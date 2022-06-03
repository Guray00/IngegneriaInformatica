// io.cpp
//
#include "costanti.h"
#include "tipo.h"
//#define BOCHS
////////////////////////////////////////////////////////////////////////////////
//    COSTANTI                                                                //
////////////////////////////////////////////////////////////////////////////////


const natl PRIO = 1000;
const natl LIV = LIV_SISTEMA;


////////////////////////////////////////////////////////////////////////////////
//                        CHIAMATE DI SISTEMA USATE                           //
////////////////////////////////////////////////////////////////////////////////

extern "C" natl activate_pe(void f(int), int a, natl prio, natl liv, natb type);
extern "C" void terminate_p();
extern "C" void sem_wait(natl sem);
extern "C" void sem_signal(natl sem);
extern "C" natl sem_ini(int val);
extern "C" void wfi();	// [9.1]
extern "C" void abort_p();
extern "C" void log(log_sev sev, const char* buf, int quanti);
extern "C" addr trasforma(addr ff);
extern "C" natl pci_find(natl code, natw i);
extern "C" natl pci_read(natw l, natw regn, natl size);
extern "C" natl pci_write(natw l, natw regn, natl res, natl size);

////////////////////////////////////////////////////////////////////////////////
//                      FUNZIONI GENERICHE DI SUPPORTO                        //
////////////////////////////////////////////////////////////////////////////////

// ingresso di un byte da una porta di IO
extern "C" void inputb(ioaddr reg, natb &a);

// uscita di un byte su una porta di IO
extern "C" void outputb(natb a, ioaddr reg);

// ingresso di una word da una porta di IO
extern "C" void inputw(ioaddr reg, natw &a);

// uscita di una word su una porta di IO
extern "C" void outputw(natw a, ioaddr reg);

extern "C" void flog(log_sev sev, const char* fmt, ...);
void *memset(void *dest, int c, unsigned int n);
void *memcpy(void *dest, const void *src, unsigned int n);

////////////////////////////////////////////////////////////////////////////////
//                    GESTIONE DELLE INTERFACCE SERIALI [9.2]                 //
////////////////////////////////////////////////////////////////////////////////

enum funz { input_n, input_ln, output_n, output_0 };  // [9.2]

struct interfse_reg {	// [9.2]
	ioaddr iRBR, iTHR, iLSR, iIER, iIIR;
};

struct des_se {		// [9.2]
	interfse_reg indreg;
	natl mutex;
	natl sincr;
	natl cont;
	addr punt;
	funz funzione;
	natb stato;
};

const natl S = 2;
extern "C" des_se com[S];	// [9.2]

void input_com(des_se* p_des);	// [9.2]
void output_com(des_se* p_des);	// [9.2]
void estern_com(int i) // [9.2]
{
	natb r;
	des_se *p_des;
	p_des = &com[i];
	for(;;) {
		inputb(p_des->indreg.iIIR, r);
		if ((r&0x06) == 0x04) 
			input_com(p_des);
		else if ((r&0x06) == 0x02)
			output_com(p_des);
		wfi(); 
	}
}

void startse_in(des_se *p_des, natb vetti[], natl quanti, funz op); // [9.2.1]
extern "C" void c_readse_n(natl serial, natb vetti[], natl quanti, natb& errore) // [9.2.1]
{
	des_se *p_des;

	// (* le primitive non devono mai fidarsi dei parametri
	if (serial >= S) {
		flog(LOG_WARN, "readse_n con serial=%d", serial);
		abort_p();
	}
	// *)

	p_des = &com[serial];
	sem_wait(p_des->mutex);
	startse_in(p_des, vetti, quanti, input_n);
	sem_wait(p_des->sincr);
	errore = p_des->stato;
	sem_signal(p_des->mutex);
}

extern "C" void c_readse_ln(natl serial, natb vetti[], int& quanti, natb& errore)
{
	des_se *p_des;

	// (* le primitive non devono mai fidarsi dei parametri
	if (serial >= S) {
		flog(LOG_WARN, "readse_ln con serial=%d", serial);
		abort_p();
	}
	// *)

	p_des = &com[serial];
	sem_wait(p_des->mutex);
	startse_in(p_des, vetti, 80, input_ln);
	sem_wait(p_des->sincr);
	quanti = p_des->cont;
	errore = p_des->stato;
	sem_signal(p_des->mutex);
}

extern "C" void go_inputse(ioaddr i_ctr);
void startse_in(des_se *p_des, natb vetti[], natl quanti, funz op) // [9.2.1]
{
	p_des->cont = quanti;
	p_des->punt = vetti;
	p_des->funzione = op;
	go_inputse(p_des->indreg.iIER);
}

extern "C" void halt_inputse(ioaddr i_ctr);
void input_com(des_se *p_des) // [9.2.1]
{
	natb c; bool fine;
	fine = false;

	halt_inputse(p_des->indreg.iIER);

	inputb(p_des->indreg.iLSR, c);

	p_des->stato = c & 0x1e;
	if (p_des->stato != 0)
		fine = true;
	else {
		inputb(p_des->indreg.iRBR, c);
		if (p_des->funzione == input_n) {
			*static_cast<natb*>(p_des->punt) = c; // memorizzazione
			p_des->punt = static_cast<natb*>(p_des->punt) + 1;
			p_des->cont--;
			if(p_des->cont == 0)
				fine = true;
		} else {
			if ( (p_des->funzione == input_ln) ) {
				if(c == '\r' || c == '\n') {
					fine = true;
					p_des->cont = 80 - p_des->cont;
				} else {
					*static_cast<natb*>(p_des->punt) = c; // memorizzazione
					p_des->punt = static_cast<natb*>(p_des->punt) + 1;
					p_des->cont--;
					if (p_des->cont == 0) {
						fine = true;
						p_des->cont = 80;
					}
				}
			}
		}
	}

	if(fine == true) {
		*static_cast<natb*>(p_des->punt) = 0;	// carattere nullo
		sem_signal(p_des->sincr);
	} else
		go_inputse(p_des->indreg.iIER);
}

void startse_out(des_se *p_des, natb vetto[], natl quanti, funz op);
extern "C" void c_writese_n(natl serial, natb vetto[], natl quanti)	// [9.2.2]
{
	des_se *p_des;

	// (* le primitive non devono mai fidarsi dei parametri
	if (serial >= S) {
		flog(LOG_WARN, "writese_n con serial=%d", serial);
		abort_p();
	}
	// *)

	p_des = &com[serial];
	sem_wait(p_des->mutex);
	startse_out(p_des, vetto, quanti, output_n);
	sem_wait(p_des->sincr);
	sem_signal(p_des->mutex);
}

extern "C" void c_writese_0(natl serial, natb vetto[], natl &quanti)
{
	des_se *p_des;

	// (* le primitive non devono mai fidarsi dei parametri
	if (serial >= S) {
		flog(LOG_WARN, "writese_0 con serial=%d", serial);
		abort_p();
	}
	// *)

	p_des = &com[serial];
	sem_wait(p_des->mutex);
	startse_out(p_des, vetto, 0, output_0);
	sem_wait(p_des->sincr);
	quanti = p_des->cont;
	sem_signal(p_des->mutex);
}

extern "C" void go_outputse(ioaddr i_ctr);
void startse_out(des_se *p_des, natb vetto[], natl quanti, funz op) // [9.2.2]
{
	p_des->cont = quanti;
	p_des->punt = vetto;
	p_des->funzione = op;
	go_outputse(p_des->indreg.iIER);
	output_com(p_des); 
}

extern "C" void halt_outputse(ioaddr i_ctr);
void output_com(des_se *p_des)	// [9.2.2]
{
	natb c; bool fine;
        fine = false;

	if (p_des->funzione == output_n) {
		p_des->cont--;
		if(p_des->cont == 0) {
			fine = true;
			halt_outputse(p_des->indreg.iIER);
		}
		c = *static_cast<natb*>(p_des->punt); //prelievo
		outputb(c, p_des->indreg.iTHR);
		p_des->punt = static_cast<natb*>(p_des->punt) + 1; 
	} else if (p_des->funzione == output_0) {
		c = *static_cast<natb*>(p_des->punt); //prelievo
		if (c == 0) {
			fine = true;
			halt_outputse(p_des->indreg.iIER);
		} else {
			outputb(c, p_des->indreg.iTHR);
			p_des->cont++;
			p_des->punt = static_cast<natb*>(p_des->punt) + 1; 
		}
	}

	if (fine == true)
		sem_signal(p_des->sincr);

}

// ( inizializzazione delle interfacce seriali
extern "C" void com_setup(void);	// vedi "io.S"
// interruzioni hardware delle interfacce seriali
int com_irq[S] = { 4, 3 };

bool com_init()
{
	des_se *p_des;
	natl id;
	natl i, com_base_prio = PRIO;

	com_setup();

	for(i = 0; i < S; ++i) {
		p_des = &com[i];

		if ( (p_des->mutex = sem_ini(1)) == 0xFFFFFFFF) {
			flog(LOG_ERR, "com: impossibile creare mutex");
			return false;
		}
		if ( (p_des->sincr = sem_ini(0)) == 0xFFFFFFFF) {
			flog(LOG_ERR, "com: impossibile creare sincr");
			return false;
		}

		id = activate_pe(estern_com, i, com_base_prio - i, LIV, com_irq[i]);
		if (id == 0xFFFFFFFF) {
			flog(LOG_ERR, "com: impossibile creare proc. esterno");
			return false;
		}

	}
	flog(LOG_INFO, "com: inizializzate %d seriali", S);
	return true;
}
// )

////////////////////////////////////////////////////////////////////////////////
//                         GESTIONE DELLA CONSOLE [9.5]                       //
////////////////////////////////////////////////////////////////////////////////

const natl COLS = 80; 	// [9.5]
const natl ROWS = 25;	// [9.5]
const natl VIDEO_SIZE = COLS * ROWS;	// [9.5]

struct interfvid_reg {	// [9.5]
	ioaddr iIND, iDAT;
};

struct des_vid {	// [9.5]
	interfvid_reg indreg;
	natw* video;
	natl x, y;
	natw attr;
};

const natl MAX_CODE = 30; // [9.5]
struct interfkbd_reg {	// [9.5]
	ioaddr iRBR, iTBR, iCMR, iSTR;
};

struct des_kbd { // [9.5]
	interfkbd_reg indreg;
	addr punt;
	natl cont;
	bool shift;
	natb tab[MAX_CODE];
	natb tabmin[MAX_CODE];
	natb tabmai[MAX_CODE];
};

struct des_console { // [9.5]
	natl mutex;
	natl sincr;
	des_kbd kbd;
	des_vid vid;
};

extern "C" des_console console; // [9.5]

extern "C" void cursore(ioaddr iIND, ioaddr iDAT, int x, int y); // [9.5]

void scroll(des_vid *p_des)	// [9.5]
{
	for (natl i = 0; i < VIDEO_SIZE - COLS; i++) 
		p_des->video[i] = p_des->video[i + COLS];
	for (natl i = 0; i < COLS; i++)
		p_des->video[VIDEO_SIZE - COLS + i] = p_des->attr | ' ';
	p_des->y--;
}

void writeelem(natb c) {	// [9.5]
	des_vid* p_des = &console.vid;
	switch (c) {
	case 0:
		break;
	case '\r':
		p_des->x = 0;
		break;
	case '\n':
		p_des->x = 0;
		p_des->y++;
		if (p_des->y >= ROWS)
			scroll(p_des);
		break;
	case '\b':
		if (p_des->x > 0 || p_des->y > 0) {
			if (p_des->x == 0) {
				p_des->x = COLS - 1;
				p_des->y--;
			} else
				p_des->x--;
		}
		break;
	default:
		p_des->video[p_des->y * COLS + p_des->x] = p_des->attr | c;
		p_des->x++;
		if (p_des->x >= COLS) {
			p_des->x = 0;
			p_des->y++;
		}
		if (p_des->y >= ROWS) 
			scroll(p_des);
		break;
	}
	cursore(p_des->indreg.iIND, p_des->indreg.iDAT,
		p_des->x, p_des->y);
}

void writeseq(cstr seq)	// [9.5]
{
	const natb* pn = static_cast<const natb*>(seq);
	while (*pn != 0) {
		writeelem(*pn);
		pn++;
	}
}

extern "C" void c_writeconsole(cstr buff) // [9.5]
{
	des_console *p_des = &console;
	sem_wait(p_des->mutex);
#ifndef AUTOCORR
	writeseq(buff);
	writeelem('\n');
#else /* AUTOCORR */
	flog(LOG_USR, "%s", buff);
#endif /* AUTOCORR */
	sem_signal(p_des->mutex);
}

extern "C" void go_inputkbd(interfkbd_reg indreg); // [9.5]
extern "C" void halt_inputkbd(interfkbd_reg indreg); // [9.5]

void startkbd_in(des_kbd* p_des, str buff) // [9.5]
{
	p_des->punt = buff;
	p_des->cont = 80;
	go_inputkbd(p_des->indreg);
}

extern "C" void c_readconsole(str buff, natl& quanti) // [9.5]
{
	des_console *p_des;

	p_des = &console;
	sem_wait(p_des->mutex);
	startkbd_in(&p_des->kbd, buff);
	sem_wait(p_des->sincr);
	quanti = p_des->kbd.cont;
	sem_signal(p_des->mutex);
}

natb converti(des_kbd* p_des, natb c) { // [9.5]
	natb cc;
	natl pos = 0;
	while (pos < MAX_CODE && p_des->tab[pos] != c)
		pos++;
	if (pos == MAX_CODE)
		return 0;
	if (p_des->shift)
		cc = p_des->tabmai[pos];
	else
		cc = p_des->tabmin[pos];
	return cc;
}

void estern_kbd(int h) // [9.5]
{
	des_console *p_des = &console;
	natb a, c;
	bool fine;

	for(;;) {
		halt_inputkbd(p_des->kbd.indreg);

		inputb(p_des->kbd.indreg.iRBR, c);
		
		fine = false;
		switch (c) {
		case 0x2a: // left shift make code
			p_des->kbd.shift = true;
			break;
		case 0xaa: // left shift break code
			p_des->kbd.shift = false;
			break;
		default:
			if (c < 0x80) {
				a = converti(&p_des->kbd, c);
				if (a == 0)
					break;
				if (a == '\b') {
					if (p_des->kbd.cont < 80) {
						p_des->kbd.punt = static_cast<natb*>(p_des->kbd.punt) - 1;
						p_des->kbd.cont++;
						writeseq("\b \b");
					}
				} else if (a == '\r' || a == '\n') {
					fine = true;
					p_des->kbd.cont = 80 - p_des->kbd.cont;
					*static_cast<natb*>(p_des->kbd.punt) = 0;
					writeseq("\r\n");
				} else {
					*static_cast<natb*>(p_des->kbd.punt) = a;
					p_des->kbd.punt = static_cast<natb*>(p_des->kbd.punt) + 1;
					p_des->kbd.cont--;
					writeelem(a);
					if (p_des->kbd.cont == 0) {
						fine = true;
						p_des->kbd.cont = 80;
					}
				}
			}
			break;
		}
		if (fine == true) 
			sem_signal(p_des->sincr);
		else
			go_inputkbd(p_des->kbd.indreg);
		wfi();
	}
}

// (* inizializzazioni
extern "C" void abilita_tastiera(void);
bool vid_init();

extern "C" void c_iniconsole(natb cc)
{
	des_vid *p_des = &console.vid;
	p_des->attr = static_cast<natw>(cc) << 8;
	vid_init();
}

// Interruzione hardware della tastiera
const int KBD_IRQ = 1;

bool kbd_init()
{
	if (activate_pe(estern_kbd, 0, PRIO, LIV, KBD_IRQ) == 0xFFFFFFFF) {
		flog(LOG_ERR, "kbd: impossibile creare estern_kbd");
		return false;
	}
	return true;
}

extern "C" des_vid vid;

bool vid_init()
{
	des_vid *p_des = &console.vid;
	for (natl i = 0; i < VIDEO_SIZE; i++) 
		p_des->video[i] = p_des->attr | ' ';
	cursore(p_des->indreg.iIND, p_des->indreg.iDAT,
		p_des->x, p_des->y);
	flog(LOG_INFO, "vid: video inizializzato");
	return true;
}

bool console_init() {
	des_console *p_des = &console;

	if ( (p_des->mutex = sem_ini(1)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "kbd: impossibile creare mutex");
		return false;
	}
	if ( (p_des->sincr = sem_ini(0)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "kbd: impossibile creare sincr");
		return false;
	}
	return kbd_init() && vid_init();
}

// *)

// inerfacce ATA

enum hd_cmd { WRITE_SECT = 0x30, READ_SECT = 0x20, WRITE_DMA = 0xCA, READ_DMA = 0xC8 };
struct interfata_reg 
{	ioaddr iBR;
	ioaddr iCNL, iCNH, iSNR, iHND, iSCR, iERR,
	       iCMD, iSTS, iDCR, iASR;
}; 
struct pci_ata
{	ioaddr iBMCMD, iBMSTR, iBMDTPR;
};
struct des_ata
{	interfata_reg indreg;
	pci_ata bus_master;
	natl prd[2];
	hd_cmd comando;
	natb errore;
	natl mutex;
	natl sincr;
	natb cont;
	addr punt;
};
extern "C" des_ata hd;

const natb HD_IRQ = 15;

extern "C" void hd_write_address(des_ata* p_des, natl primo);
// scrive primo nei registri di indirizzo CNL, CNH, SNR e HND
extern "C" void hd_write_command(hd_cmd cmd, ioaddr iCMD);
// scrive cmd nel registro iCMD e aspetta che BSY torni a 0

extern "C" bool hd_wait_data(ioaddr iSTS) // [9.3.1]
{
	natb stato;

	do {
		inputb(iSTS, stato);
	} while (stato & 0x80);

	return ( (stato & 0x08) && !(stato & 0x01) );
}
// attende che BSY passi a zero e DRQ a 1. Restituisce false se ERR vale 1
extern "C" void hd_go_inout(ioaddr iSTS);
// abilita l'interfaccia a generare interruzioni
extern "C" void hd_halt_inout(ioaddr iSTS);
// disabilita l'interfaccia a generare interruzioni
extern "C" void outputbw(natw vetto[], int quanti, ioaddr reg);
// { for (int i = 0; i < quanti; i++) *reg = vetto[i]; }
extern "C" void inputbw(ioaddr reg, natw vetti[], int quanti);
// { for (int i = 0; i < quanti; i++) vetti[i] = *reg; }
extern "C" void inputb(ioaddr reg, natb& a) ;
// { 	a = *reg	;   }
extern "C" void outputb(natb a, ioaddr reg) ;
// {	*reg = a;    }
extern "C" void outputl(natl a, ioaddr reg) ;
// {	*reg = a;    }

void hd_componi_prd(des_ata* p_dmades, addr iff, natw quanti)
{	p_dmades->prd[0] = reinterpret_cast<natl>(iff);
	p_dmades->prd[1] = 0x80000000 | quanti;					// EOT posto a 1
}
extern "C" void hd_select_device(short ms, ioaddr iHND);
void hd_sel_drv(des_ata* p_des) // [9.3]
{
	natb stato;

	hd_select_device(0, p_des->indreg.iHND);

	do {
		inputb(p_des->indreg.iSTS, stato);
	} while ( (stato & 0x80) || (stato & 0x08) );
}
void starthd_in(des_ata *p_des, natw vetti[], natl primo, natb quanti);
extern "C" void c_readhd_n(natw vetti[], natl primo, 
		natb quanti, natb &errore)
{	des_ata *p_des;
	p_des = &hd;
	sem_wait(p_des->mutex);
	starthd_in(p_des, vetti, primo, quanti);
	sem_wait(p_des->sincr);
	errore = p_des->errore;
	sem_signal(p_des->mutex);
}
void starthd_out(des_ata *p_des, natw vetto[], natl primo, natb quanti);
extern "C" void c_writehd_n(natw vetto[], natl primo,
		natb quanti, natb &errore)
{	des_ata *p_des;
	p_des = &hd;
	sem_wait(p_des->mutex);
	starthd_out(p_des, vetto, primo, quanti);
	sem_wait(p_des->sincr);
	errore = p_des->errore;
	sem_signal(p_des->mutex);
}
void starthd_in(des_ata *p_des, natw vetti[], natl primo, natb quanti)
{	p_des->cont = quanti;
	p_des->punt = vetti;
	p_des->comando = READ_SECT;
	hd_sel_drv(p_des);
	hd_write_address(p_des, primo);
	outputb(quanti, p_des->indreg.iSCR);
	hd_go_inout(p_des->indreg.iDCR);
	hd_write_command(READ_SECT, p_des->indreg.iCMD); 
}
void starthd_out(des_ata *p_des, natw vetto[], natl primo, natb quanti)
{	p_des->cont = quanti;
	p_des->punt = vetto + DIM_BLOCK / 2;
	p_des->comando = WRITE_SECT;
	hd_sel_drv(p_des);
	hd_write_address(p_des, primo);
	outputb(quanti, p_des->indreg.iSCR);
	hd_go_inout(p_des->indreg.iDCR);
	hd_write_command(WRITE_SECT, p_des->indreg.iCMD);
	hd_wait_data(p_des->indreg.iSTS);
	outputbw(vetto, DIM_BLOCK/2, p_des->indreg.iBR);
}
void dmastarthd_in(des_ata *p_des, natw vetti[], natl primo, natb quanti);
extern "C" void c_dmareadhd_n(natw vetti[], natl primo, natb quanti,
		natb &errore)
{	des_ata *p_des;
	p_des = &hd;
	sem_wait(p_des->mutex);
	dmastarthd_in(p_des, vetti, primo, quanti);
	sem_wait(p_des->sincr);
	errore = p_des->errore;
	sem_signal(p_des->mutex);
}
void dmastarthd_out(des_ata *p_des, natw vetto[], natl primo, natb quanti);
extern "C" void c_dmawritehd_n(natw vetto[], natl primo, natb quanti, 
		natb& errore)
{	des_ata *p_des;
	p_des = &hd;
	sem_wait(p_des->mutex);
	dmastarthd_out(p_des, vetto, primo, quanti);
	sem_wait(p_des->sincr);
	errore = p_des->errore;
	sem_signal(p_des->mutex);
}
void dmastarthd_in(des_ata *p_des, natw vetti[], natl primo, natb quanti)
{	// la scrittura ini iBMDTPR di &prd[0] avviene in fase di inizializzazione
	natb work; addr iff;
	p_des->comando = READ_DMA;
	p_des->cont = 1;					// informazione per il driver
	iff = trasforma(vetti);
	hd_componi_prd(p_des, iff, quanti * DIM_BLOCK);
	inputb(p_des->bus_master.iBMCMD, work);
	work |= 0x08;							// lettura da PCI
	outputb(work, p_des->bus_master.iBMCMD);
	inputb(p_des->bus_master.iBMSTR, work);
	work &= 0xF9;						// bit interruzione ed errore a 0
	outputb(work, p_des->bus_master.iBMSTR);
	hd_sel_drv(p_des);
	hd_write_address(p_des, primo);
	outputb(quanti, p_des->indreg.iSCR);
	hd_go_inout(p_des->indreg.iDCR);
	hd_write_command(READ_DMA, p_des->indreg.iCMD);
	inputb(p_des->bus_master.iBMCMD, work);
	work |= 0x01; 							// avvio dell’operazione
	outputb(work, p_des->bus_master.iBMCMD); 
}
void dmastarthd_out(des_ata *p_des, natw vetto[], natl primo, natb quanti)
{	// la scrittura in iBMDTPR di &prd[0] avviene in fase di inizializzazione
	natb work; addr iff;
	p_des->comando = WRITE_DMA;
	p_des->cont = 1; 				// informazione per il driver
	iff = trasforma(vetto);
	hd_componi_prd(p_des, iff, quanti * DIM_BLOCK);
	inputb(p_des->bus_master.iBMCMD, work);
	work &= 0xF7; 					// scrittura verso PCI
	outputb(work, p_des->bus_master.iBMCMD);
	inputb(p_des->bus_master.iBMSTR, work);
	work &= 0xF9;					// bit interruzione ed errore a 0
	outputb(work, p_des->bus_master.iBMSTR);
	hd_sel_drv(p_des);
	hd_write_address(p_des, primo);
	outputb(quanti, p_des->indreg.iSCR);
	hd_go_inout(p_des->indreg.iDCR);
	hd_write_command(WRITE_DMA, p_des->indreg.iCMD);
	inputb(p_des->bus_master.iBMCMD, work);
	work |= 1;								// avvio dell’operazione
	outputb(work, p_des->bus_master.iBMCMD); 
}

void esternAta(int h)			// codice commune ai 2 processi esterni ATA
{
	des_ata* p_des = &hd;
	natb stato, work;
	for(;;)
	{	p_des->cont--;
		if (p_des->cont == 0) 
			hd_halt_inout(p_des->indreg.iDCR);
		p_des->errore = 0;
		inputb(p_des->indreg.iSTS, stato); 				// ack dell'interrupt
		switch (p_des->comando) 
		{	case READ_SECT:
			if (!hd_wait_data(p_des->indreg.iSTS))
				inputb(p_des->indreg.iERR, p_des->errore);
			else
				inputbw(p_des->indreg.iBR, static_cast<natw*>(p_des->punt),
						DIM_BLOCK / 2);
			p_des->punt = static_cast<natw*>(p_des->punt) + DIM_BLOCK / 2;
			break;
			case WRITE_SECT:
			if (p_des->cont != 0)
			{	if (!hd_wait_data(p_des->indreg.iSTS))
				inputb(p_des->indreg.iERR, p_des->errore);
				else
					outputbw(static_cast<natw*>(p_des->punt),
							DIM_BLOCK / 2, p_des->indreg.iBR);
				p_des->punt = static_cast<natw*>(p_des->punt) + 
					DIM_BLOCK / 2;
			}
			break;
			case READ_DMA:
			case WRITE_DMA:
			inputb(p_des->bus_master.iBMCMD, work);
			work &= 0xFE;				// azzeramento del bit n. 0 (start/stop)
			outputb(work, p_des->bus_master.iBMCMD);
			inputb(p_des->bus_master.iBMSTR, stato);	// ack  interrupt in DMA
			if ((stato & 0x05) == 0)
				inputb(p_des->indreg.iERR, p_des->errore);
		}
		if (p_des->cont == 0) sem_signal(p_des->sincr);
		wfi();
	}
}

bool hd_init()
{
	natl id;
	natl bm;
	des_ata* p_des;

	p_des = &hd;

	if ( (p_des->mutex = sem_ini(1)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "hd: impossibile creare mutex");
		return false;
	}
	if ( (p_des->sincr = sem_ini(0)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "hd: impossibile creare sincr");
		return false;
	}

	if ( (bm = pci_find(0x000101FF, 0)) == 0xFFFFFFFF) {
		flog(LOG_WARN, "hd: bus master non trovato");
	} else {
		natb prog_if = pci_read(bm, 0x9, 1);
		if (prog_if & 0x80) {
			natl base = pci_read(bm, 0x20, 4);
			base &= ~0x1;
			hd.bus_master.iBMCMD  = (ioaddr)(base + 0x08);
			hd.bus_master.iBMSTR  = (ioaddr)(base + 0x0a);
			hd.bus_master.iBMDTPR = (ioaddr)(base + 0x0c);
			addr iff = trasforma(&hd.prd[0]);
			outputl(reinterpret_cast<natl>(iff),
					hd.bus_master.iBMDTPR);
		}
	}

	id = activate_pe(esternAta, 0, PRIO, LIV, HD_IRQ);
	if (id == 0xFFFFFFFF) {
		flog(LOG_ERR, "com: impossibile creare proc. esterno");
		return false;
	}
	return true;
}

/////////////////////////////////////////////////////////////////////////////////
//                  FUNZIONI DI LIBRERIA                                       //
/////////////////////////////////////////////////////////////////////////////////
typedef char *va_list;

// Versione semplificata delle macro per manipolare le liste di parametri
//  di lunghezza variabile; funziona solo se gli argomenti sono di
//  dimensione multipla di 4, ma e' sufficiente per le esigenze di printk.
//
#define va_start(ap, last_req) (ap = (char *)&(last_req) + sizeof(last_req))
#define va_arg(ap, type) ((ap) += sizeof(type), *(type *)((ap) - sizeof(type)))
#define va_end(ap)

natl strlen(const char *s)
{
	natl l = 0;

	while(*s++)
		++l;

	return l;
}

char *strncpy(char *dest, const char *src, unsigned long l)
{
	unsigned long i;

	for(i = 0; i < l && src[i]; ++i)
		dest[i] = src[i];

	return dest;
}

static const char hex_map[16] = { '0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

static void htostr(char *buf, unsigned long l)
{
	int i;

	buf[0] = '0';
	buf[1] = 'x';

	for(i = 9; i > 1; --i) {
		buf[i] = hex_map[l % 16];
		l /= 16;
	}
}

static void itostr(char *buf, unsigned int len, long l)
{
	natl i, div = 1000000000, v, w = 0;

	if(l == (-2147483647 - 1)) {
		strncpy(buf, "-2147483648", 12);
		return;
	} else if(l < 0) {
		buf[0] = '-';
		l = -l;
		i = 1;
	} else if(l == 0) {
		buf[0] = '0';
		buf[1] = 0;
		return;
	} else
		i = 0;

	while(i < len - 1 && div != 0) {
		if((v = l / div) || w) {
			buf[i++] = '0' + (char)v;
			w = 1;
		}

		l %= div;
		div /= 10;
	}

	buf[i] = 0;
}

#define DEC_BUFSIZE 12

int vsnprintf(char *str, natl size, const char *fmt, va_list ap)
{
	natl in = 0, out = 0, tmp;
	char *aux, buf[DEC_BUFSIZE];

	while(out < size - 1 && fmt[in]) {
		switch(fmt[in]) {
			case '%':
				switch(fmt[++in]) {
					case 'd':
						tmp = va_arg(ap, int);
						itostr(buf, DEC_BUFSIZE, tmp);
						if(strlen(buf) >
								size - out - 1)
							goto end;
						for(aux = buf; *aux; ++aux)
							str[out++] = *aux;
						break;
					case 'x':
						tmp = va_arg(ap, int);
						if(out > size - 11)
							goto end;
						htostr(&str[out], tmp);
						out += 10;
						break;
					case 's':
						aux = va_arg(ap, char *);
						while(out < size - 1 && *aux)
							str[out++] = *aux++;
						break;	
				}
				++in;
				break;
			default:
				str[out++] = fmt[in++];
		}
	}
end:
	str[out++] = 0;

	return out;
}

int snprintf(char *buf, unsigned long n, const char *fmt, ...)
{
	va_list ap;
	int l;

	va_start(ap, fmt);
	l = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return l;
}

// copia n byte da src a dest
void *memcpy(void *dest, const void *src, unsigned int n)
{
	char       *dest_ptr = static_cast<char*>(dest);
	const char *src_ptr  = static_cast<const char*>(src);

	if (src_ptr < dest_ptr && src_ptr + n > dest_ptr)
		for (int i = n - 1; i >= 0; i--)
			dest_ptr[i] = src_ptr[i];
	else
		for (natl i = 0; i < n; i++)
			dest_ptr[i] = src_ptr[i];

	return dest;
}

// scrive n byte pari a c, a partire da dest
void *memset(void *dest, int c, unsigned int n)
{
	char *dest_ptr = static_cast<char*>(dest);

        for (natl i = 0; i < n; i++)
              dest_ptr[i] = static_cast<char>(c);

        return dest;
}

// log formattato
void flog(log_sev sev, const char *fmt, ...)
{
	va_list ap;
	const natl LOG_MSG_SIZE = 128;
	char buf[LOG_MSG_SIZE];

	va_start(ap, fmt);
	int l = vsnprintf(buf, LOG_MSG_SIZE, fmt, ap);
	va_end(ap);

	if (l > 1)
		log(sev, buf, l - 1);
}

////////////////////////////////////////////////////////////////////////////////
//                 INIZIALIZZAZIONE DEL SOTTOSISTEMA DI I/O                   //
////////////////////////////////////////////////////////////////////////////////

// inizializza i gate usati per le chiamate di IO
//
extern "C" void fill_io_gates(void);

// eseguita in fase di inizializzazione
//
extern "C" void cmain(int sem_io)
{

	fill_io_gates();
	if (!console_init())
		abort_p();
	if (!com_init())
		abort_p();
	if (!hd_init())
		abort_p();
	sem_signal(sem_io);
	terminate_p();
}
