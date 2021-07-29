// io.cpp
//
#include <costanti.h>
#include <libce.h>
#include <sys.h>
#include <sysio.h>
#include <io.h>

const natl LIV = LIV_SISTEMA;

extern "C" void panic(const char *msg)
{
	flog(LOG_ERR, "modulo I/O: %s", msg);
	io_panic();
}

////////////////////////////////////////////////////////////////////////////////
//                        MEMORIA DINAMICA                                    //
////////////////////////////////////////////////////////////////////////////////

natl mem_mutex;

void* operator new(size_t s)
{
	void *p;

	sem_wait(mem_mutex);
	p = alloca(s);
	sem_signal(mem_mutex);

	return p;
}

void operator delete(void* p)
{
	sem_wait(mem_mutex);
	dealloca(p);
	sem_signal(mem_mutex);
}

extern "C" natq c_getiomeminfo()
{
	natq rv;
	sem_wait(mem_mutex);
	rv = disponibile();
	sem_signal(mem_mutex);
	return rv;
}

void* operator new(size_t s, align_val_t a)
{
	void *p;

	sem_wait(mem_mutex);
	p = alloc_aligned(s, a);
	sem_signal(mem_mutex);
	return p;
}

////////////////////////////////////////////////////////////////////////////////
//                         GESTIONE DELLA CONSOLE                             //
////////////////////////////////////////////////////////////////////////////////

struct des_console {
	natl mutex;
	natl sincr;
	char* punt;
	natq cont;
	natq dim;
} console;

extern "C" void c_writeconsole(const char* buff, natq quanti) //
{
	des_console *p_des = &console;

	if (!access(buff, quanti, false)) {
		flog(LOG_WARN, "writeconsole: parametri non validi: %p, %d:", buff, quanti);
		abort_p();
	}

	sem_wait(p_des->mutex);
#ifndef AUTOCORR
	for (natq i = 0; i < quanti; i++)
		char_write(buff[i]);
#else /* AUTOCORR */
	if (buff[quanti - 2] == '\n')
		quanti -= 2;
	flog(LOG_USR, "%.*s", quanti, buff);
#endif /* AUTOCORR */
	sem_signal(p_des->mutex);
}

void startkbd_in(des_console* d, char* buff, natq dim)
{
	d->punt = buff;
	d->cont = dim;
	d->dim  = dim;
	enable_intr_kbd();
}

extern "C" natq c_readconsole(char* buff, natq quanti) //
{
	des_console *d = &console;
	natq rv;

	if (!access(buff, quanti, true)) {
		flog(LOG_WARN, "readconsole: parametri non validi: %p, %d:", buff, quanti);
		abort_p();
	}

#ifdef AUTOCORR
	return 0;
#endif

	if (!quanti)
		return 0;

	sem_wait(d->mutex);
	startkbd_in(d, buff, quanti);
	sem_wait(d->sincr);
	rv = d->dim - d->cont;
	sem_signal(d->mutex);
	return rv;
}

void estern_kbd(int h) //
{
	des_console *d = &console;
	char a;
	bool fine;

	for(;;) {
		disable_intr_kbd();

		a = char_read();

		fine = false;
		switch (a) {
		case 0:
			break;
		case '\b':
			if (d->cont < d->dim) {
				d->punt--;
				d->cont++;
				str_write("\b \b");
			}
			break;
		case '\r':
		case '\n':
			fine = true;
			*d->punt = '\0';
			str_write("\r\n");
			break;
		default:
			*d->punt = a;
			d->punt++;
			d->cont--;
			char_write(a);
			if (d->cont == 0) {
				fine = true;
			}
			break;
		}
		if (fine)
			sem_signal(d->sincr);
		else
			enable_intr_kbd();
		wfi();
	}
}

extern "C" void c_iniconsole(natb cc)
{
	clear_screen(cc);
}

// Interruzione hardware della tastiera
const int KBD_IRQ = 1;
const int KBD_PRIO = MIN_EXT_PRIO + 0x50;

bool kbd_init()
{
	// blocchiamo subito le interruzioni generabili dalla tastiera
	disable_intr_kbd();

	// svuotiamo il buffer interno della tastiera
	drain_kbd();

	if (activate_pe(estern_kbd, 0, KBD_PRIO, LIV, KBD_IRQ) == 0xFFFFFFFF) {
		flog(LOG_ERR, "kbd: impossibile creare estern_kbd");
		return false;
	}
	flog(LOG_INFO, "kbd: tastiera inizializzata");
	return true;
}

bool vid_init()
{
	clear_screen(0x07);
	flog(LOG_INFO, "vid: video inizializzato");
	return true;
}

bool console_init()
{
	des_console *d = &console;

	if ( (d->mutex = sem_ini(1)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "console: impossibile creare mutex");
		return false;
	}
	if ( (d->sincr = sem_ini(0)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "console: impossibile creare sincr");
		return false;
	}
	return kbd_init() && vid_init();
}

////////////////////////////////////////////////////////////////////////////////
//                         INTERFACCE ATA                                     //
////////////////////////////////////////////////////////////////////////////////

struct des_ata {
	natb comando;
	natl mutex;
	natl sincr;
	natb cont;
	natb* punt;
} hd;

extern "C" natl hd_prd[];

const natb HD_IRQ = 14;
const natl HD_PRIO = MIN_EXT_PRIO + 0x60;

void hd_prepare_prd(natb* vett, natb quanti)
{
	natq n = quanti * DIM_BLOCK;
	int i = 0;

	while (n && i < MAX_PRD) {
		paddr p = trasforma(vett);
		natq  r = DIM_PAGINA - (p % DIM_PAGINA);
		if (r < n)
			r = n;
		hd_prd[i] = p;
		hd_prd[i + 1] = r;

		n -= r;
		vett += r;
		i += 2;
	}
	hd_prd[i - 1] |= 0x80000000;
}

void starthd_in(des_ata *d, natb vetti[], natl primo, natb quanti)
{
	d->cont = quanti;
	d->punt = vetti;
	d->comando = READ_SECT;
	hd_start_cmd(primo, quanti, READ_SECT);
}

extern "C" void c_readhd_n(natb vetti[], natl primo, natb quanti)
{
	des_ata *d = &hd;

	if (!access(vetti, quanti * DIM_BLOCK, true)) {
		flog(LOG_WARN, "readhd_n: parametri non validi: %p, %d", vetti, quanti);
		abort_p();
	}

	sem_wait(d->mutex);
	starthd_in(d, vetti, primo, quanti);
	sem_wait(d->sincr);
	sem_signal(d->mutex);
}

void starthd_out(des_ata *d, natb vetto[], natl primo, natb quanti)
{
	d->cont = quanti;
	d->punt = vetto + DIM_BLOCK;
	d->comando = WRITE_SECT;
	hd_start_cmd(primo, quanti, WRITE_SECT);
	hd_output_sect(vetto);
}

extern "C" void c_writehd_n(natb vetto[], natl primo, natb quanti)
{
	des_ata *d = &hd;

	if (!access(vetto, quanti * DIM_BLOCK, false)) {
		flog(LOG_WARN, "writehd_n: parametri non validi: %p, %d", vetto, quanti);
		abort_p();
	}

	sem_wait(d->mutex);
	starthd_out(d, vetto, primo, quanti);
	sem_wait(d->sincr);
	sem_signal(d->mutex);
}

void dmastarthd_in(des_ata *d, natb vetti[], natl primo, natb quanti)
{
	// la scrittura in iBMDTPR di &hd_prd[0] avviene in fase di inizializzazione
	d->comando = READ_DMA;
	d->cont = 1;					// informazione per il driver
	hd_prepare_prd(vetti, quanti);
	paddr prd = trasforma(hd_prd);
	bm_prepare(prd, false);
	hd_start_cmd(primo, quanti, READ_DMA);
	bm_start();
}

extern "C" void c_dmareadhd_n(natb vetti[], natl primo, natb quanti,
		natb &errore)
{
	des_ata *d = &hd;

	if (!access(vetti, quanti * DIM_BLOCK, true)) {
		flog(LOG_WARN, "dmareadhd_n: parametri non validi: %p, %d", vetti, quanti);
		abort_p();
	}

	sem_wait(d->mutex);
	dmastarthd_in(d, vetti, primo, quanti);
	sem_wait(d->sincr);
	sem_signal(d->mutex);
}

void dmastarthd_out(des_ata *d, natb vetto[], natl primo, natb quanti)
{
	d->comando = WRITE_DMA;
	d->cont = 1; 				// informazione per il driver
	hd_prepare_prd(vetto, quanti);
	paddr prd = trasforma(hd_prd);
	bm_prepare(prd, true);
	hd_start_cmd(primo, quanti, WRITE_DMA);
	bm_start();
}

extern "C" void c_dmawritehd_n(natb vetto[], natl primo, natb quanti)
{
	des_ata *d = &hd;

	if (!access(vetto, quanti * DIM_BLOCK, false)) {
		flog(LOG_WARN, "dmawritehd_n: parametri non validi: %p, %d", vetto, quanti);
		abort_p();
	}

	sem_wait(d->mutex);
	dmastarthd_out(d, vetto, primo, quanti);
	sem_wait(d->sincr);
	sem_signal(d->mutex);
}


void esternAta(int h)			// codice commune ai 2 processi esterni ATA
{
	des_ata* d = &hd;
	for(;;) {
		d->cont--;
		hd_ack_intr();
		switch (d->comando) {
		case READ_SECT:
			hd_input_sect(d->punt);
			d->punt += DIM_BLOCK;
			break;
		case WRITE_SECT:
			if (d->cont != 0) {
				hd_output_sect(d->punt);
				d->punt += DIM_BLOCK;
			}
			break;
		case READ_DMA:
		case WRITE_DMA:
			bm_ack();
			break;
		}
		if (d->cont == 0)
			sem_signal(d->sincr);
		wfi();
	}
}

bool hd_init()
{
	natl id;
	natb bus = 0, dev = 0, fun = 0;
	des_ata* d;

	d = &hd;

	if ( (d->mutex = sem_ini(1)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "hd: impossibile creare mutex");
		return false;
	}
	if ( (d->sincr = sem_ini(0)) == 0xFFFFFFFF) {
		flog(LOG_ERR, "hd: impossibile creare sincr");
		return false;
	}

	if (!bm_find(bus, dev, fun)) {
		flog(LOG_WARN, "hd: bus master non trovato");
		return false;
	}

	flog(LOG_INFO, "bm: %2x:%2x:%2x", bus, dev, fun);
	bm_init(bus, dev, fun);

	id = activate_pe(esternAta, 0, HD_PRIO, LIV, HD_IRQ);
	if (id == 0xFFFFFFFF) {
		flog(LOG_ERR, "com: impossibile creare proc. esterno");
		return false;
	}

	hd_enable_intr();

	return true;
}


////////////////////////////////////////////////////////////////////////////////
//                 INIZIALIZZAZIONE DEL SOTTOSISTEMA DI I/O                   //
////////////////////////////////////////////////////////////////////////////////

extern "C" natq end;
extern "C" void fill_io_gates();
// eseguita in fase di inizializzazione
extern "C" void main(int sem_io)
{

	fill_io_gates();
	mem_mutex = sem_ini(1);
	if (mem_mutex == 0xFFFFFFFF) {
		panic("impossible creare semaforo mem_mutex");
	}
	vaddr end_ = reinterpret_cast<vaddr>(&end);
	end_ = (end_ + DIM_PAGINA - 1) & ~(DIM_PAGINA - 1);
	heap_init((void *)end_, DIM_IO_HEAP);
	if (!console_init())
		panic("inizializzazione console fallita");
	if (!hd_init())
		panic("inizializzazione hard disk fallita");
	sem_signal(sem_io);
	terminate_p();
}
