// sistema.cpp
//
#include "mboot.h"		// *****
#include "costanti.h"		// *****

/////////////////////////////////////////////////////////////////////////////////
//                     PROCESSI [4]                                            //
/////////////////////////////////////////////////////////////////////////////////
#include "tipo.h"		// [4.4]

const int N_REG = 45;	// [4.6]

// descrittore di processo [4.6]
struct des_proc {	
	natl id;
	addr punt_nucleo;
	natl riservato;	
	// quattro parole lunghe a disposizione
	natl disp[4];				// (*)
	addr cr3;
	natl contesto[N_REG];
	natl cpl;
};

// (*) le quattro parole lunghe "a disposizione" 
//   servono a contenere gli indirizzi logici delle pile
//   per gli altri due livelli previsti nella segmentazione

// ( indici dei vari registri all'interno dell'array "contesto"
//   Nota: in fondo all'array c'e' lo spazio sufficiente
//   a contenere i 10 registri, da 10 byte ciascuno, della FPU
enum { I_EIP = 0, I_EFLAGS, I_EAX, I_ECX, I_EDX, I_EBX,
       I_ESP, I_EBP, I_ESI, I_EDI, I_ES, I_CS, I_SS,
       I_DS, I_FS, I_GS, I_LDT,  I_IOMAP,
       I_FPU_CR, I_FPU_SR, I_FPU_TR, I_FPU_IP,
       I_FPU_IS, I_FPU_OP, I_FPU_OS };
// )

// elemento di una coda di processi [4.6]
struct proc_elem {
	natl id;
	natl precedenza;
	proc_elem *puntatore;
};
extern proc_elem *esecuzione;	// [4.6]
extern proc_elem *pronti;	// [4.6]

extern "C" natl activate_p(void f(int), int a, natl prio, natl liv); // [4.6]
extern "C" void terminate_p();	// [4.6]
// - per la crezione/terminazione di un processo, si veda [P_PROCESS] piu' avanti
// - per la creazione del processo start_utente, si veda "main_sistema" avanti
extern "C" des_proc* des_p(natl id);

extern volatile natl processi;		// [4.7]
extern "C" void end_program();	// [4.7]
// corpo del processo dummy	// [4.7]
void dd(int i)
{
	while (processi != 1)
		;
	end_program();
}

// - per salva_stato/carica_stato, si veda il file "sistema.S"

// [4.8]
void inserimento_lista(proc_elem *&p_lista, proc_elem *p_elem)
{
// ( inserimento in una lista semplice ordinata
//   (tecnica dei due puntatori)
	proc_elem *pp, *prevp;

	pp = p_lista;
	prevp = 0;
	while (pp != 0 && pp->precedenza >= p_elem->precedenza) {
		prevp = pp;
		pp = pp->puntatore;
	}

	p_elem->puntatore = pp;

	if (prevp == 0)
		p_lista = p_elem;
	else
		prevp->puntatore = p_elem;

// )
}

// [4.8]
void rimozione_lista(proc_elem *&p_lista, proc_elem *&p_elem)
{
// ( ESAME 2013-06-12
	proc_elem *scan, *prec, **max;
	max = &p_lista;
	for (prec = 0, scan = p_lista; scan; prec = scan, scan = scan->puntatore) {
		if (scan->precedenza > (*max)->precedenza)
			max = &prec->puntatore;
	}
	p_elem = *max;
	*max = (*max)->puntatore;
//   ESAME 2013-06-12 )
}

extern "C" void inspronti()
{
// (
	inserimento_lista(pronti, esecuzione);
// )
}

// [4.8]
extern "C" void schedulatore(void)
{
// ( poiche' la lista e' gia' ordinata in base alla priorita',
//   e' sufficiente estrarre l'elemento in testa
	rimozione_lista(pronti, esecuzione);
// )
}

/////////////////////////////////////////////////////////////////////////////////
//                     SEMAFORI [4]                                            //
/////////////////////////////////////////////////////////////////////////////////

// descrittore di semaforo [4.11]
struct des_sem {
	int counter;
	proc_elem *pointer;
};

// vettore dei descrittori di semaforo [4.11]
extern des_sem array_dess[MAX_SEM];

// - per sem_ini, si veda [P_SEM_ALLOC] avanti

// ( per la gestione degli errori/debugging, useremo le seguenti funzioni:
//   flog: invia un messaggio formatto al log (si veda [P_LOG] per l'implementazione)
extern "C" void flog(log_sev, cstr fmt, ...);
//   abort_p: termina forzatamente un processo (vedi [P_PROCESS] avanti)
extern "C" void abort_p() __attribute__ (( noreturn ));
//   sem_valido: restituisce true se sem e' un semaforo effettivamente allocato
bool sem_valido(natl sem);
// )


// [4.11]
extern "C" void c_sem_wait(natl sem)
{
	des_sem *s;

// (* una primitiva non deve mai fidarsi dei parametri
	if (!sem_valido(sem)) {
		flog(LOG_WARN, "semaforo errato: %d", sem);
		abort_p();
	}
// *)

	s = &array_dess[sem];
	(s->counter)--;

	if ((s->counter) < 0) {
		inserimento_lista(s->pointer, esecuzione);
		schedulatore();
	}
}

// [4.11]
extern "C" void c_sem_signal(natl sem)
{
	des_sem *s;
	proc_elem *lavoro;

// (* una primitiva non deve mai fidarsi dei parametri
	if (!sem_valido(sem)) {
		flog(LOG_WARN, "semaforo errato: %d", sem);
		abort_p();
	}
// *)

	s = &array_dess[sem];
	(s->counter)++;

	if ((s->counter) <= 0) {
		rimozione_lista(s->pointer, lavoro);
		inserimento_lista(pronti, lavoro);
		inspronti();	// preemption
		schedulatore();	// preemption
	}
}

extern "C" natl sem_ini(int);		// [4.11]
extern "C" void sem_wait(natl);		// [4.11]
extern "C" void sem_signal(natl);	// [4.11]


// ( ESAME 2013-06-12
struct des_pim {
	natl orig_prio;
	proc_elem *owner;
	proc_elem *waiting;
};

struct des_pim array_despim[MAX_PHM];

natl next_pim = 0;
bool pim_valido(natl pim)
{
	return pim < next_pim;
}

extern "C" natl c_pim_init()
{
	if (next_pim >= MAX_PHM)
		return 0xFFFFFFFF;
	return next_pim++;
}
//  ESAME 2013-06-12 )


// ( SOLUZIONE 2013-06-12
//   SOLUZIONE 2013-06-12 )

/////////////////////////////////////////////////////////////////////////////////
//               MEMORIA DINAMICA [4]                                          //
/////////////////////////////////////////////////////////////////////////////////

void *alloca(natl dim);			// [4.14]
void dealloca(void* p);			// [4.14]
// (per l'implementazione, si veda [P_SYS_HEAP] avanti)

/////////////////////////////////////////////////////////////////////////////////
//                         TIMER [4][9]                                        //
/////////////////////////////////////////////////////////////////////////////////

// richiesta al timer [4.16]
struct richiesta {
	natl d_attesa;
	richiesta *p_rich;
	proc_elem *pp;
};

richiesta *p_sospesi; // [4.16]

void inserimento_lista_attesa(richiesta *p); // [4.16]
// parte "C++" della primitiva delay [4.16]
extern "C" void c_delay(natl n)
{
	richiesta *p;

	p = static_cast<richiesta*>(alloca(sizeof(richiesta)));
	p->d_attesa = n;	
	p->pp = esecuzione;

	inserimento_lista_attesa(p);
	schedulatore();
}

// inserisce P nella coda delle richieste al timer [4.16]
void inserimento_lista_attesa(richiesta *p)
{
	richiesta *r, *precedente;
	bool ins;

	r = p_sospesi;
	precedente = 0;
	ins = false;

	while (r != 0 && !ins)
		if (p->d_attesa > r->d_attesa) {
			p->d_attesa -= r->d_attesa;
			precedente = r;
			r = r->p_rich;
		} else
			ins = true;

	p->p_rich = r;
	if (precedente != 0)
		precedente->p_rich = p;
	else
		p_sospesi = p;

	if (r != 0)
		r->d_attesa -= p->d_attesa;
}

// driver del timer [4.16][9.6]
extern "C" void c_driver_td(void)
{
	richiesta *p;

	if(p_sospesi != 0)
		p_sospesi->d_attesa--;

	while(p_sospesi != 0 && p_sospesi->d_attesa == 0) {
		inserimento_lista(pronti, p_sospesi->pp);
		p = p_sospesi;
		p_sospesi = p_sospesi->p_rich;
		dealloca(p);
	}

	inspronti();
	schedulatore();
}


/////////////////////////////////////////////////////////////////////////////////
//                         PAGINE FISICHE [6]                                  //
/////////////////////////////////////////////////////////////////////////////////


enum tt { LIBERA, DIRETTORIO, TABELLA_CONDIVISA, TABELLA_PRIVATA,
	PAGINA_CONDIVISA, PAGINA_PRIVATA }; // [6.3]
struct des_pf {			// [6.3]
	tt contenuto;	// uno dei valori precedenti
	union {
		struct { 
			bool	residente;	// pagina residente o meno
			natl	processo;	// identificatore di processo
			natl	ind_massa;	// indirizzo della pagina in memoria di massa
			addr	ind_virtuale;
			// indirizzo virtuale della pagina (ultimi 12 bit a 0)
			// o della prima pagina indirizzata da una tabella (ultimi 22 bit uguali a 0)
			natl	contatore;	// contatore per le statistiche
		} pt; 	// rilevante se "contenuto" non vale LIBERA
		struct  { // informazioni relative a una pagina libera
			des_pf*	prossima_libera;// indice del descrittore della prossima pagina libera
		} avl;	// rilevante se "contenuto" vale LIBERA
	};
};

des_pf dpf[N_DPF];	// vettore di descrittori di pagine fisiche [9.3]
addr prima_pf_utile;	// indirizzo fisico della prima pagina fisica di M2 [9.3]
des_pf* pagine_libere;	// indice del descrittore della prima pagina libera [9.3]

// [9.3]
des_pf* descrittore_pf(addr indirizzo_pf)
{
	natl indice = ((natl)indirizzo_pf - (natl)prima_pf_utile) / DIM_PAGINA;
	return &dpf[indice];
}

// [9.3]
addr indirizzo_pf(des_pf* ppf)
{
	natl indice = ppf - &dpf[0];
	return (addr)((natl)prima_pf_utile + indice * DIM_PAGINA);
}

// ( inizializza i descrittori di pagina fisica (vedi [P_MEM_PHYS])
bool init_dpf();
// )

/////////////////////////////////////////////////////////////////////////////////
//                         PAGINAZIONE [6]                                     //
/////////////////////////////////////////////////////////////////////////////////

//   ( definiamo alcune costanti utili per la manipolazione dei descrittori
//     di pagina e di tabella. Assegneremo a tali descrittori il tipo "natl"
//     e li manipoleremo tramite maschere e operazioni sui bit.
const natl BIT_P    = 1U << 0; // il bit di presenza
const natl BIT_RW   = 1U << 1; // il bit di lettura/scrittura
const natl BIT_US   = 1U << 2; // il bit utente/sistema(*)
const natl BIT_PWT  = 1U << 3; // il bit Page Wright Through
const natl BIT_PCD  = 1U << 4; // il bit Page Cache Disable
const natl BIT_A    = 1U << 5; // il bit di accesso
const natl BIT_D    = 1U << 6; // il bit "dirty"

// (*) attenzione, la convenzione Intel e' diversa da quella
// illustrata nel libro: 0 = sistema, 1 = utente.

const natl ACCB_MASK  = 0x000000FF; // maschera per il byte di accesso
const natl ADDR_MASK  = 0xFFFFF000; // maschera per l'indirizzo
const natl INDMASS_MASK = 0xFFFFFFE0; // maschera per l'indirizzo in mem. di massa
const natl INDMASS_SHIFT = 5;	    // primo bit che contiene l'ind. in mem. di massa
// )

// per le implementazioni mancanti, vedi [P_PAGING] avanti
natl& get_destab(natl processo, addr ind_virt); // [6.3]
natl& get_despag(natl processo, addr ind_virt); // [6.3]
natl& singolo_des(addr iff, natl index);		// [6.3]
natl& get_des(natl processo, tt tipo, addr ind_virt); // [6.3]
bool  extr_P(natl descrittore)			// [6.3]
{ // (
	return (descrittore & BIT_P); // )
} 
bool extr_D(natl descrittore)			// [6.3]
{ // (
	return (descrittore & BIT_D); // )
}
bool extr_A(natl descrittore)			// [6.3]
{ // (
	return (descrittore & BIT_A); // )
}
addr extr_IND_FISICO(natl descrittore)		// [6.3]
{ // (
	return (addr)(descrittore & ADDR_MASK); // )
}
natl extr_IND_MASSA(natl descrittore)		// [6.3]
{ // (
	return (descrittore & INDMASS_MASK) >> INDMASS_SHIFT; // )
}
void set_P(natl& descrittore, bool bitP)	// [6.3]
{ // (
	if (bitP)
		descrittore |= BIT_P;
	else
		descrittore &= ~BIT_P; // )
}
void set_A(natl& descrittore, bool bitA)	// [6.3]
{ // (
	if (bitA)
		descrittore |= BIT_A;
	else
		descrittore &= ~BIT_A; // )
}
// (* definiamo anche la seguente funzione:
//    clear_IND_M: azzera il campo M (indirizzo in memoria di massa)
void clear_IND_MASSA(natl& descrittore)
{
	descrittore &= ~INDMASS_MASK;
}
// *)
void  set_IND_FISICO(natl& descrittore, addr ind_fisico) // [6.3]
{ // (
	clear_IND_MASSA(descrittore);
	descrittore |= ((natl)(ind_fisico) & ADDR_MASK); // )
}
void set_IND_MASSA(natl& descrittore, natl ind_massa) // [6.3]
{ // (
	clear_IND_MASSA(descrittore);
	descrittore |= (ind_massa << INDMASS_SHIFT); // )
}

void set_D(natl& descrittore, bool bitD) // [6.3]
{ // (
	if (bitD)
		descrittore |= BIT_D;
	else
		descrittore &= ~BIT_D; // )
}

// (* useremo anche le seguenti funzioni (implementazioni mancanti in [P_PAGING])
// mset_des: copia "descrittore" nelle "n" entrate della tabella/direttorio puntata
//  da "dest" partendo dalla "i"-esima
void mset_des(addr dest, natl i, natl n, natl descrittore);
// copy_dir: funzione che copia (parte di) una/o tabella/direttorio
// ("src") in un altra/o ("dst"). Vengono copiati
// "n" descrittori a partire dall' "i"-esimo
void copy_des(addr src, addr dst, natl i, natl n);
// *)

// carica un nuovo valore in cr3 [vedi sistema.S]
extern "C" void loadCR3(addr dir);

// restituisce il valore corrente di cr3 [vedi sistema.S]
extern "C" addr readCR3();

// attiva la paginazione [vedi sistema.S]
extern "C" void attiva_paginazione();

/////////////////////////////////////////////////////////////////////////////////
//                    MEMORIA VIRTUALE [6][10]                                 //
/////////////////////////////////////////////////////////////////////////////////

// ( definiamo delle costanti per le varie parti in cui dividiamo la memoria virtuale
//   (vedi [6.1][10.1]).
//   Per semplicita' ragioniamo sempre in termini di intere "tabelle delle pagine". 
//   Ricordiamo che ogni tabella delle pagine mappa una porzione contigua dello spazio
//   di indirizzamento virtuale, grande 4MiB e allineata ai 4MiB ("macropagina").
//   Le costanti che iniziano con "ntab_" indicano il numero di tabelle delle pagine
//   dedicate alla parte di memoria virtuale corrispondente (si veda "include/costanti.h" per i valori)
const natl ntab_sistema_condiviso = NTAB_SIS_C;
const natl ntab_sistema_privato   = NTAB_SIS_P;
const natl ntab_io_condiviso	  = NTAB_MIO_C;
const natl ntab_pci_condiviso     = NTAB_PCI_C;
const natl ntab_utente_condiviso  = NTAB_USR_C;
const natl ntab_utente_privato    = NTAB_USR_P;

//   Le costanti che iniziano con "i_" contengono l'indice (all'interno dei direttori
//   di tutti i processi) della prima tabella corrispondente alla zona di memoria virtuale nominata
const natl i_sistema_condiviso = 0;
const natl i_sistema_privato   = i_sistema_condiviso + ntab_sistema_condiviso;
const natl i_io_condiviso      = i_sistema_privato   + ntab_sistema_privato;
const natl i_pci_condiviso     = i_io_condiviso      + ntab_io_condiviso;
const natl i_utente_condiviso  = i_pci_condiviso     + ntab_pci_condiviso;
const natl i_utente_privato    = i_utente_condiviso  + ntab_utente_condiviso;

//   Le costanti che iniziano con "dim_" contengono la dimensione della corrispondente
//   zona, in byte
const natl dim_sistema_condiviso = ntab_sistema_condiviso * DIM_MACROPAGINA;
const natl dim_sistema_privato   = ntab_sistema_privato   * DIM_MACROPAGINA;
const natl dim_io_condiviso	 = ntab_io_condiviso	  * DIM_MACROPAGINA;
const natl dim_utente_condiviso  = ntab_utente_condiviso  * DIM_MACROPAGINA;
const natl dim_utente_privato    = ntab_utente_privato    * DIM_MACROPAGINA;
const natl dim_pci_condiviso     = ntab_pci_condiviso     * DIM_MACROPAGINA;

//   Le costanti "inizio_" ("fine_") contengono l'indirizzo del primo byte che fa parte
//   (del primo byte che non fa piu' parte) della zona corrispondente
natb* const inizio_sistema_condiviso = 0x00000000;
natb* const fine_sistema_condiviso   = inizio_sistema_condiviso + dim_sistema_condiviso;
natb* const inizio_sistema_privato   = fine_sistema_condiviso;
natb* const fine_sistema_privato     = inizio_sistema_privato   + dim_sistema_privato;
natb* const inizio_io_condiviso      = fine_sistema_privato;
natb* const fine_io_condiviso	     = inizio_io_condiviso      + dim_io_condiviso;
natb* const inizio_pci_condiviso     = fine_io_condiviso;
natb* const fine_pci_condiviso       = inizio_pci_condiviso     + dim_pci_condiviso;
natb* const inizio_utente_condiviso  = fine_pci_condiviso;
natb* const fine_utente_condiviso    = inizio_utente_condiviso  + dim_utente_condiviso;
natb* const inizio_utente_privato    = fine_utente_condiviso;
natb* const fine_utente_privato      = inizio_utente_privato    + dim_utente_privato;
// )

// per l'inizializzazione, si veda [P_INIT] avanti

// (* in caso di errori fatali, useremo la segunte funzione, che blocca il sistema:
extern "C" void panic(cstr msg) __attribute__ (( noreturn ));
// implementazione in [P_PANIC]
// *)


extern "C" addr readCR2();
void swap(tt tipo, addr ind_virt); // [6.4]
void c_routine_pf()	// [6.4][10.2]
{
	addr ind_virt = readCR2();
	// carica sia la tabella delle pagine che la pagina, o solo la pagina
	bool bitP; natl dt;
	dt = get_des(esecuzione->id, TABELLA_PRIVATA, ind_virt);
	bitP = extr_P(dt);
	if (!bitP)
		swap(TABELLA_PRIVATA, ind_virt);
	swap(PAGINA_PRIVATA, ind_virt);
}

bool extr_D(natl descrittore);
bool extr_A(natl descrittore);
addr extr_IND_FISICO(natl descrittore);
natl extr_IND_MASSA(natl descrittore);
void set_P(natl& decrittore, bool bitP);
void set_A(natl& decrittore, bool bitP);
void set_D(natl& decrittore, bool bitP);
void set_IND_FISICO(natl& descrittore, addr ind_fisico);
void set_IND_MASSA(natl& descrittore, natl ind_massa);
des_pf* alloca_pagina_fisica_libera();	// [6.4]
des_pf* scegli_vittima(tt tipo, addr ind_virt);	// [6.4]
bool scollega(des_pf* ppf);		// [6.4]
void scarica(des_pf* ppf);		// [6.4]
void carica(des_pf* ppf);		// [6.4]
void collega(des_pf* ppf);		// [6.4]

// [6.4]
void rilascia_pagina_fisica(des_pf* ppf);
void swap(tt tipo, addr ind_virt)
{
	// "ind_virt" e' l'indirizzo virtuale non tradotto
	// carica una tabella delle pagine o una pagina
	des_pf* nuovo_dpf = alloca_pagina_fisica_libera();
	if (nuovo_dpf == 0) {
		des_pf* dpf_vittima = scegli_vittima(tipo, ind_virt);
		bool occorre_salvare = scollega(dpf_vittima);
		if (occorre_salvare)
			scarica(dpf_vittima);
		nuovo_dpf = dpf_vittima;
	}
	natl des = get_des(esecuzione->id, tipo, ind_virt);
	natl IM = extr_IND_MASSA(des);
	// (* non tutto lo spazio virtuale e' disponibile
	if (!IM) {
		flog(LOG_WARN, "indirizzo %x fuori dallo spazio virtuale allocato",
				ind_virt);
		rilascia_pagina_fisica(nuovo_dpf);
		abort_p();
	}
	// *)
	nuovo_dpf->contenuto = tipo;
	nuovo_dpf->pt.residente = false;
	nuovo_dpf->pt.processo = esecuzione->id;
	nuovo_dpf->pt.ind_virtuale = ind_virt;
	nuovo_dpf->pt.ind_massa = IM;
	nuovo_dpf->pt.contatore  = 0;
	carica(nuovo_dpf);
	collega(nuovo_dpf);
}

des_pf* alloca_pagina_fisica_libera()	// [6.4]
{
	des_pf* p = pagine_libere;
	if (pagine_libere != 0)
		pagine_libere = pagine_libere->avl.prossima_libera;
	return p;
}

// (* rende di nuovo libera la pagina fisica il cui descrittore di pagina fisica
//    ha per indice "i"
void rilascia_pagina_fisica(des_pf* ppf)
{
	ppf->contenuto = LIBERA;
	ppf->avl.prossima_libera = pagine_libere;
	pagine_libere = ppf;
}
// *)


void collega(des_pf *ppf)	// [6.4]
{
	natl& des = get_des(ppf->pt.processo, ppf->contenuto, ppf->pt.ind_virtuale);
	set_IND_FISICO(des, indirizzo_pf(ppf));
	set_P(des, true);
	set_D(des, false);
	set_A(des, false);
}

extern "C" void invalida_entrata_TLB(addr ind_virtuale); // [6.4]
natl alloca_blocco();	// [10.5]
bool scollega(des_pf* ppf)	// [6.4][10.5]
{
	bool bitD;
	natl &des = get_des(ppf->pt.processo, ppf->contenuto, ppf->pt.ind_virtuale);
	bitD = extr_D(des);
	bool occorre_salvare = bitD || ppf->contenuto == TABELLA_PRIVATA;
	set_IND_MASSA(des, ppf->pt.ind_massa);
	set_P(des, false);
	invalida_entrata_TLB(ppf->pt.ind_virtuale);
	return occorre_salvare;	// [10.5]
}

// (* oltre ad allocare, vogliamo anche deallocare blocchi
//    (quando un processo termina, possiamo deallocare tutti blocchi che
//    contengono le sue pagine private)
void dealloca_blocco(natl blocco);
// *)
void leggi_speciale(addr dest, natl primo);
void scrivi_speciale(addr src, natl primo);

void carica(des_pf* ppf) // [6.4][10.5]
{
	leggi_speciale(indirizzo_pf(ppf), ppf->pt.ind_massa);
}

void scarica(des_pf* ppf) // [6.4]
{
	scrivi_speciale(indirizzo_pf(ppf), ppf->pt.ind_massa);
}

bool vietato(des_pf* ppf, natl proc, tt tipo, addr ind_virt)
{
	if (tipo == PAGINA_PRIVATA && ppf->contenuto == TABELLA_PRIVATA &&
	    ppf->pt.processo == proc &&
	    ((natl)ppf->pt.ind_virtuale & 0xffc00000) == ((natl)ind_virt & 0xffc00000))
		return true;
	return false;
}

void stat();		// [6.6]
des_pf* scegli_vittima2(natl proc, tt tipo, addr ind_virtuale) // [6.4]
{
	des_pf *ppf, *dpf_vittima;
	ppf = &dpf[0];
	while ( (ppf < &dpf[N_DPF] && ppf->pt.residente) ||
			vietato(ppf, proc, tipo, ind_virtuale))
		ppf++;
	if (ppf == &dpf[N_DPF]) return 0;
	dpf_vittima = ppf;
	stat();
	for (ppf++; ppf < &dpf[N_DPF]; ppf++) {
		if (ppf->pt.residente || vietato(ppf, proc, tipo, ind_virtuale))
			continue;
		switch (ppf->contenuto) {
		case PAGINA_PRIVATA:
			if (ppf->pt.contatore < dpf_vittima->pt.contatore ||
			    (ppf->pt.contatore == dpf_vittima->pt.contatore &&
			    		dpf_vittima->contenuto == TABELLA_PRIVATA))
				dpf_vittima = ppf;
			break;
		case TABELLA_PRIVATA:
			if (ppf->pt.contatore < dpf_vittima->pt.contatore) 
				dpf_vittima = ppf;
			break;
		default:
			break;
		}
	}
	return dpf_vittima;
}

des_pf* scegli_vittima(tt tipo, addr ind_virtuale)
{
	return scegli_vittima2(esecuzione->id, tipo, ind_virtuale);
}

extern "C" void invalida_TLB(); // [6.6]
extern "C" void delay(natl t);

void stat()
{
	des_pf *ppf1, *ppf2;
	addr ff1, ff2;
	bool bitA;

	for (natl i = 0; i < N_DPF; i++) {
		ppf1 = &dpf[i];
		switch (ppf1->contenuto) {
		case DIRETTORIO:
		case TABELLA_PRIVATA:
			ff1 = indirizzo_pf(ppf1);
			for (int j = 0; j < 1024; j++) {
				natl& des = singolo_des(ff1, j);
				if (extr_P(des)) {
					bitA = extr_A(des);
					set_A(des, false);
					ff2 = extr_IND_FISICO(des);
					ppf2 = descrittore_pf(ff2);
					if (!ppf2->pt.residente) {
						ppf2->pt.contatore >>= 1;
						if (bitA)
							ppf2->pt.contatore |= 0x80000000;
					}
				}
			}
			break;
		default:
			break;
		}
	}
	invalida_TLB();
}


natl proc_corrente()
{
	return esecuzione->id;
}


/////////////////////////////////////////////////////////////////////////////////
//                    PROCESSI ESTERNI [7]                                     //
/////////////////////////////////////////////////////////////////////////////////

// (
const natl MAX_IRQ  = 24;
// )
proc_elem *a_p[MAX_IRQ];  // [7.1]

// per la parte "C++" della activate_pe, si veda [P_EXTERN_PROC] avanti


/////////////////////////////////////////////////////////////////////////////////
//                    SUPPORTO PCI                                             //
/////////////////////////////////////////////////////////////////////////////////
const ioaddr PCI_CAP = 0x0CF8;
const ioaddr PCI_CDP = 0x0CFC;
const addr PCI_startmem = reinterpret_cast<addr>(0x00000000 - dim_pci_condiviso);

extern "C" void inputb(ioaddr reg, natb &a);	// [9.3.1]
extern "C" void outputb(natb a, ioaddr reg);	// [9.3.1]
// (*
extern "C" void inputw(ioaddr reg, natw &a);	
extern "C" void outputw(natw a, ioaddr reg);
extern "C" void inputl(ioaddr reg, natl &a);	
extern "C" void outputl(natl a, ioaddr reg);
// *)

natl make_CAP(natw w, natb off)
{
	return 0x80000000 | (w << 8) | (off & 0xFC);
}

natb pci_read_confb(natw w, natb off)
{
	natl l = make_CAP(w, off);
	outputl(l, PCI_CAP);
	natb ret;
	inputb(PCI_CDP + (off & 0x03), ret);
	return ret;
}

natw pci_read_confw(natw w, natb off)
{
	natl l = make_CAP(w, off);
	outputl(l, PCI_CAP);
	natw ret;
	inputw(PCI_CDP + (off & 0x03), ret);
	return ret;
}

natl pci_read_confl(natw w, natb off)
{
	natl l = make_CAP(w, off);
	outputl(l, PCI_CAP);
	natl ret;
	inputl(PCI_CDP, ret);
	return ret;
}

void pci_write_confb(natw w, natb off, natb data)
{
	natl l = make_CAP(w, off);
	outputl(l, PCI_CAP);
	outputb(data, PCI_CDP + (off & 0x03));
}

void pci_write_confw(natw w, natb off, natw data)
{
	natl l = make_CAP(w, off);
	outputl(l, PCI_CAP);
	outputw(data, PCI_CDP + (off & 0x03));
}

void pci_write_confl(natw w, natb off, natl data)
{
	natl l = make_CAP(w, off);
	outputl(l, PCI_CAP);
	outputl(data, PCI_CDP);
}

bool pci_find_dev(natw& w, natw devID, natw vendID)
{
	for( ; w != 0xFFFF; w++) {
		natw work;

		if ( (work = pci_read_confw(w, 0)) == 0xFFFF ) 
			continue;
		if ( work == vendID && pci_read_confw(w, 2) == devID) 
			return true;
	}
	return false;
}

bool pci_find_class(natw& w, natb code[])
{
	for ( ; w != 0xFFFF; w++) {
		if (pci_read_confw(w, 0) == 0xFFFF)
			continue;
		natb work[3];
		natl i;
		for (i = 0; i < 3; i++) {
			work[i] = pci_read_confb(w, 2 * 4 + i + 1);
			if (code[i] != 0xFF && code[i] != work[i])
				break;
		}
		if (i == 3) {
			for (i = 0; i < 3; i++)
				code[i] = work[i];
			return true;
		}
	} 
	return false;
}

extern "C" natl c_pci_find(natl code, natw i)
{
	natb* pcode = (natb*)&code;
	natw w, j = 0;
	for(w = 0; w != 0xFFFF; w++) {
		if (! pci_find_class(w, pcode)) 
			return 0xFFFFFFFF;
		if (j == i)
			return w;
		j++;
	} 
	return 0xFFFFFFFF;
}

extern "C" natl c_pci_read(natw l, natw regn, natl size)
{
	natl res;
	switch (size) {
	case 1:
		res = pci_read_confb(l, regn);
		break;
	case 2:
		res = pci_read_confw(l, regn);
		break;
	case 4:
		res = pci_read_confl(l, regn);
		break;
	default:
		flog(LOG_WARN, "pci_read(%x, %d, %d): parametro errato", l, regn, size);
		abort_p();
	}
	return res;
}

extern "C" void c_pci_write(natw l, natw regn, natl res, natl size)
{
	switch (size) {
	case 1:
		pci_write_confb(l, regn, res);
		break;
	case 2:
		pci_write_confw(l, regn, res);
		break;
	case 4:
		pci_write_confl(l, regn, res);
		break;
	default:
		flog(LOG_WARN, "pci_write(%x, %d, %d, %d): parametro errato", l, regn, res, size);
		abort_p();
	}
}

///////////////////////////////////////////////////////////////////////////////////
//                   INIZIALIZZAZIONE [10]                                       //
///////////////////////////////////////////////////////////////////////////////////
const natl MAX_PRIORITY	= 0xfffffff;
const natl MIN_PRIORITY	= 0x0000001;
const natl DUMMY_PRIORITY = 0x0000000;
const natl HEAP_SIZE = 640*4096U - 4096U;
const natl DELAY = 59659;

extern "C" void *memset(void* dest, int c, natl n);
// restituisce true se le due stringe first e second sono uguali
extern addr max_mem_lower;
extern addr max_mem_upper;
extern addr mem_upper;
extern proc_elem init;
int salta_a(addr indirizzo);
addr occupa(natl quanti);
bool ioapic_init();
bool crea_finestra_FM(addr direttorio);
bool crea_finestra_PCI(addr direttorio);
natl crea_dummy();
bool init_pe();
bool crea_main_sistema(natl dummy_proc);
extern "C" void salta_a_main();
extern "C" void c_panic(cstr msg, natl eip1, natw cs, natl eflags, natl eip2);
// timer
extern natl ticks;
extern natl clocks_per_usec;
extern "C" void attiva_timer(natl count);
void ini_COM1();
void init_heap();
// super blocco (vedi [10.5] e [P_SWAP] avanti)
struct superblock_t {
	char	magic[4];
	natl	bm_start;
	natl	blocks;
	natl	directory;
	void	(*user_entry)(int);
	addr	user_end;
	void	(*io_entry)(int);
	addr	io_end;
	int	checksum;
};

// descrittore di swap (vedi [P_SWAP] avanti)
struct des_swap {
	natl *free;		// bitmap dei blocchi liberi
	superblock_t sb;	// contenuto del superblocco 
} swap_dev; 	// c'e' un unico oggetto swap
bool swap_init();
extern "C" void cmain (natl magic, multiboot_info_t* mbi)
{
	des_pf* ppf;
	addr direttorio;
	natl dummy_proc;
	
	// (* anche se il primo processo non e' completamente inizializzato,
	//    gli diamo un identificatore, in modo che compaia nei log
	init.id = 0;
	init.precedenza = MAX_PRIORITY;
	esecuzione = &init;
	// *)
	
	ini_COM1();

	flog(LOG_INFO, "Nucleo di Calcolatori Elettronici, v4.09");

	// (* controlliamo di essere stati caricati
	//    da un bootloader che rispetti lo standard multiboot
	if (magic != MULTIBOOT_BOOTLOADER_MAGIC) {
		flog(LOG_ERR, "Numero magico non valido: 0x%x", magic);
		goto error;
	}
	// *)

	// (* Assegna allo heap di sistema HEAP_SIZE byte nel primo MiB
	init_heap();
	flog(LOG_INFO, "Heap di sistema: %d B", HEAP_SIZE);
	// *)

	// ( il resto della memoria e' per le pagine fisiche (parte M2, vedi [1.10])
	init_dpf();
	flog(LOG_INFO, "Pagine fisiche: %d", N_DPF);
	// )

	// ( creiamo il direttorio "D" (vedi [10.4])
	ppf = alloca_pagina_fisica_libera();
	if (ppf == 0) {
		flog(LOG_ERR, "Impossibile allocare il direttorio principale");
		goto error;
	}
	direttorio = indirizzo_pf(ppf);
	ppf->contenuto = DIRETTORIO;
	ppf->pt.residente = true;
	// azzeriamo il direttorio appena creato
	memset(direttorio, 0, DIM_PAGINA);
	// )

	// ( memoria fisica in memoria virtuale (vedi [1.8] e [10.4])
	if (!crea_finestra_FM(direttorio))
		goto error;
	flog(LOG_INFO, "Mappata memoria fisica in memoria virtuale");
	// )

	if (!crea_finestra_PCI(direttorio))
		goto error;
	flog(LOG_INFO, "Mappata memoria PCI in memoria virtuale");
	// ( inizializziamo il registro CR3 con l'indirizzo del direttorio ([10.4])
	loadCR3(direttorio);
	// )
	// ( attiviamo la paginazione ([10.4])
	attiva_paginazione();
	flog(LOG_INFO, "Paginazione attivata");
	// )

	// ( stampa informativa
	flog(LOG_INFO, "Semafori: %d", MAX_SEM);
	// )

	// (* inizializziamo il controllore delle interruzioni [vedi sistema.S]
	ioapic_init();
	flog(LOG_INFO, "Controllore delle interruzioni inizializzato");
	// *)
	//
	// ( inizializzazione dello swap, che comprende la lettura
	//   degli entry point di start_io e start_utente (vedi [10.4])
	if (!swap_init())
			goto error;
	flog(LOG_INFO, "sb: blocks=%d user=%x/%x io=%x/%x", 
			swap_dev.sb.blocks,
			swap_dev.sb.user_entry,
			swap_dev.sb.user_end,
			swap_dev.sb.io_entry,
			swap_dev.sb.io_end);
	// )
	
	// ( creazione del processo dummy [10.4]
	dummy_proc = crea_dummy();
	if (dummy_proc == 0xFFFFFFFF)
		goto error;
	flog(LOG_INFO, "Creato il processo dummy");
	// )

	// (* processi esterni generici
	if (!init_pe())
		goto error;
	flog(LOG_INFO, "Creati i processi esterni generici");
	// *)

	// ( creazione del processo main_sistema [10.4]
	if (!crea_main_sistema(dummy_proc))
		goto error;
	flog(LOG_INFO, "Creato il processo main_sistema");
	// )

	// (* selezioniamo main_sistema
	schedulatore();
	// *)
	// ( esegue CALL carica_stato; IRET ([10.4], vedi "sistema.S")
	salta_a_main(); 
	// )
	return;

error:
	c_panic("Errore di inizializzazione", 0, 0, 0, 0);
}

bool aggiungi_pe(proc_elem *p, natb irq);
bool crea_spazio_condiviso(natl dummy_proc, addr& last_address);


//
// (* restituisce il minimo naturale maggiore o uguale a v/q
natl ceild(natl v, natl q)
{
	return v / q + (v % q != 0 ? 1 : 0);
}
// *)

addr last_address;
void main_sistema(int n)
{
	natl sync_io;
	natl dummy_proc = (natl)n; 


	// ( caricamento delle tabelle e pagine residenti degli spazi condivisi ([10.4])
	flog(LOG_INFO, "creazione o lettura delle tabelle e pagine residenti condivise...");
	if (!crea_spazio_condiviso(dummy_proc, last_address))
		goto error;
 	// )

	// ( inizializzazione del modulo di io [7.1][10.4]
	flog(LOG_INFO, "creazione del processo main I/O...");
	sync_io = sem_ini(0);
	if (sync_io == 0xFFFFFFFF) {
		flog(LOG_ERR, "Impossibile allocare il semaforo di sincr per l'IO");
		goto error;
	}
	if (activate_p(swap_dev.sb.io_entry, sync_io, MAX_PRIORITY, LIV_SISTEMA) == 0xFFFFFFFF) {
		flog(LOG_ERR, "impossibile creare il processo main I/O");
		goto error;
	}
	sem_wait(sync_io);
	// )

	// ( creazione del processo start_utente
	flog(LOG_INFO, "creazione del processo start_utente...");
	if (activate_p(swap_dev.sb.user_entry, 0, MAX_PRIORITY, LIV_UTENTE) == 0xFFFFFFFF) {
		flog(LOG_ERR, "impossibile creare il processo main utente");
		goto error;
	}
	// )
	// (* attiviamo il timer
	attiva_timer(DELAY);
	// *)
	// ( terminazione [10.4]
	terminate_p();
	// )
error:
	panic("Errore di inizializzazione");
}


/////////////////////////////////////////////////////////////////////////////////////
//                 Implementazioni                                                 //
/////////////////////////////////////////////////////////////////////////////////////
// ( [P_LIB]
// non possiamo usare l'implementazione della libreria del C/C++ fornita con DJGPP o gcc,
// perche' queste sono state scritte utilizzando le primitive del sistema
// operativo Windows o Unix. Tali primitive non
// saranno disponibili quando il nostro nucleo andra' in esecuzione.
// Per ragioni di convenienza, ridefiniamo delle funzioni analoghe a quelle
// fornite dalla libreria del C.
//
// copia n byte da src a dest
extern "C" void *memcpy(str dest, cstr src, natl n)
{
	char       *dest_ptr = static_cast<char*>(dest);
	const char *src_ptr  = static_cast<const char*>(src);

	for (natl i = 0; i < n; i++)
		dest_ptr[i] = src_ptr[i];

	return dest;
}

// scrive n byte pari a c, a partire da dest
extern "C" void *memset(str dest, int c, natl n)
{
	char *dest_ptr = static_cast<char*>(dest);

        for (natl i = 0; i < n; i++)
              dest_ptr[i] = static_cast<char>(c);

        return dest;
}


// Versione semplificata delle macro per manipolare le liste di parametri
//  di lunghezza variabile; funziona solo se gli argomenti sono di
//  dimensione multipla di 4, ma e' sufficiente per le esigenze di printk.
//
typedef char *va_list;
#define va_start(ap, last_req) (ap = (char *)&(last_req) + sizeof(last_req))
#define va_arg(ap, type) ((ap) += sizeof(type), *(type *)((ap) - sizeof(type)))
#define va_end(ap)


// restituisce la lunghezza della stringa s (che deve essere terminata da 0)
natl strlen(cstr s)
{
	natl l = 0;
	const natb* ss = static_cast<const natb*>(s);

	while (*ss++)
		++l;

	return l;
}

// copia al piu' l caratteri dalla stringa src alla stringa dest
natb *strncpy(str dest, cstr src, natl l)
{
	natb* bdest = static_cast<natb*>(dest);
	const natb* bsrc = static_cast<const natb*>(src);

	for (natl i = 0; i < l && bsrc[i]; ++i)
		bdest[i] = bsrc[i];

	return bdest;
}

static const char hex_map[16] = { '0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

// converte l in stringa (notazione esadecimale)
static void htostr(str vbuf, natl l, natl cifre)
{
	char *buf = static_cast<char*>(vbuf);
	for (int i = cifre - 1; i >= 0; --i) {
		buf[i] = hex_map[l % 16];
		l /= 16;
	}
}

// converte l in stringa (notazione decimale)
static void itostr(str vbuf, natl len, long l)
{
	natl i, div = 1000000000, v, w = 0;
	char *buf = static_cast<char*>(vbuf);

	if (l == (-2147483647 - 1)) {
 		strncpy(buf, "-2147483648", 12);
 		return;
   	} else if (l < 0) {
		buf[0] = '-';
		l = -l;
		i = 1;
	} else if (l == 0) {
		buf[0] = '0';
		buf[1] = 0;
		return;
	} else
		i = 0;

	while (i < len - 1 && div != 0) {
		if ((v = l / div) || w) {
			buf[i++] = '0' + (char)v;
			w = 1;
		}

		l %= div;
		div /= 10;
	}

	buf[i] = 0;
}

// converte la stringa buf in intero
int strtoi(char* buf)
{
	int v = 0;
	while (*buf >= '0' && *buf <= '9') {
		v *= 10;
		v += *buf - '0';
		buf++;
	}
	return v;
}

#define DEC_BUFSIZE 12

// stampa formattata su stringa
int vsnprintf(str vstr, natl size, cstr vfmt, va_list ap)
{
	natl in = 0, out = 0, tmp;
	char *aux, buf[DEC_BUFSIZE];
	char *str = static_cast<char*>(vstr);
	const char* fmt = static_cast<const char*>(vfmt);
	natl cifre;

	while (out < size - 1 && fmt[in]) {
		switch(fmt[in]) {
			case '%':
				cifre = 8;
			again:
				switch(fmt[++in]) {
					case '1':
					case '2':
					case '4':
					case '8':
						cifre = fmt[in] - '0';
						goto again;
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
						if(out > size - (cifre + 1))
							goto end;
						htostr(&str[out], tmp, cifre);
						out += cifre;
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

// stampa formattata su stringa (variadica)
extern "C" int snprintf(str buf, natl n, cstr fmt, ...)
{
	va_list ap;
	int l;
	va_start(ap, fmt);
	l = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return l;
}

// restituisce il valore di "v" allineato a un multiplo di "a"
natl allinea(natl v, natl a)
{
	return (v % a == 0 ? v : ((v + a - 1) / a) * a);
}
addr allineav(addr v, natl a)
{
	return (addr)allinea((natl)v, a);
}
// )

// ( [P_SEM_ALLOC] (vedi [4.11])
// I semafori non vengono mai deallocati, quindi e' possibile allocarli
// sequenzialmente. Per far questo, e' sufficiente ricordare quanti ne
// abbiamo allocati 
natl sem_allocati = 0;
natl alloca_sem()
{
	natl i;

	if (sem_allocati >= MAX_SEM)
		return 0xFFFFFFFF;

	i = sem_allocati;
	sem_allocati++;
	return i;
}

// dal momento che i semafori non vengono mai deallocati,
// un semaforo e' valido se e solo se il suo indice e' inferiore
// al numero dei semafori allocati
bool sem_valido(natl sem)
{
	return sem < sem_allocati;
}

// parte "C++" della primitiva sem_ini [4.11]
extern "C" natl c_sem_ini(int val)
{
	natl i = alloca_sem();

	if (i != 0xFFFFFFFF)
		array_dess[i].counter = val;

	return i;
}
// )

// ( [P_SYS_HEAP] (vedi [4.14])
//
// Il nucleo ha bisogno di una zona di memoria gestita ad heap, per realizzare
// la funzione "alloca".
// Lo heap e' composto da zone di memoria libere e occupate. Ogni zona di memoria
// e' identificata dal suo indirizzo di partenza e dalla sua dimensione.
// Ogni zona di memoria contiene, nei primi byte, un descrittore di zona di
// memoria (di tipo des_mem), con un campo "dimensione" (dimensione in byte
// della zona, escluso il descrittore stesso) e un campo "next", significativo
// solo se la zona e' libera, nel qual caso il campo punta alla prossima zona
// libera. Si viene quindi a creare una lista delle zone libere, la cui testa
// e' puntata dalla variabile "memlibera" (allocata staticamente). La lista e'
// mantenuta ordinata in base agli indirizzi di partenza delle zone libere.

// descrittore di zona di memoria: descrive una zona di memoria nello heap di
// sistema
struct des_mem {
	natl dimensione;
	des_mem* next;
};

// testa della lista di descrittori di memoria fisica libera
des_mem* memlibera = 0;

// funzione di allocazione: cerca la prima zona di memoria libera di dimensione
// almeno pari a "quanti" byte, e ne restituisce l'indirizzo di partenza.
// Se la zona trovata e' sufficientemente piu' grande di "quanti" byte, divide la zona
// in due: una, grande "quanti" byte, viene occupata, mentre i rimanenti byte vanno
// a formare una nuova zona (con un nuovo descrittore) libera.
void* alloca(natl dim)
{
	// per motivi di efficienza, conviene allocare sempre multipli di 4 
	// byte (in modo che le strutture dati restino allineate alla linea)
	natl quanti = allinea(dim, sizeof(int));
	// allochiamo "quanti" byte, invece dei "dim" richiesti
	
	// per prima cosa, cerchiamo una zona di dimensione sufficiente
	des_mem *prec = 0, *scorri = memlibera;
	while (scorri != 0 && scorri->dimensione < quanti) {
		prec = scorri;
		scorri = scorri->next;
	}
	// assert(scorri == 0 || scorri->dimensione >= quanti);

	addr p = 0;
	if (scorri != 0) {
		p = scorri + 1; // puntatore al primo byte dopo il descrittore
				// (coincide con l'indirizzo iniziale delle zona
				// di memoria)

		// per poter dividere in due la zona trovata, la parte
		// rimanente, dopo aver occupato "quanti" byte, deve poter contenere
		// almeno il descrittore piu' 4 byte (minima dimensione
		// allocabile)
		if (scorri->dimensione - quanti >= sizeof(des_mem) + sizeof(int)) {

			// il nuovo descrittore verra' scritto nei primi byte 
			// della zona da creare (quindi, "quanti" byte dopo "p")
			addr pnuovo = static_cast<natb*>(p) + quanti;
			des_mem* nuovo = static_cast<des_mem*>(pnuovo);

			// aggiustiamo le dimensioni della vecchia e della nuova zona
			nuovo->dimensione = scorri->dimensione - quanti - sizeof(des_mem);
			scorri->dimensione = quanti;

			// infine, inseriamo "nuovo" nella lista delle zone libere,
			// al posto precedentemente occupato da "scorri"
			nuovo->next = scorri->next;
			if (prec != 0) 
				prec->next = nuovo;
			else
				memlibera = nuovo;

		} else {

			// se la zona non e' sufficientemente grande per essere
			// divisa in due, la occupiamo tutta, rimuovendola
			// dalla lista delle zone libere
			if (prec != 0)
				prec->next = scorri->next;
			else
				memlibera = scorri->next;
		}
		
		// a scopo di debug, inseriamo un valore particolare nel campo
		// next (altimenti inutilizzato) del descrittore. Se tutto
		// funziona correttamente, ci aspettiamo di ritrovare lo stesso
		// valore quando quando la zona verra' successivamente
		// deallocata. (Notare che il valore non e' allineato a 4 byte,
		// quindi un valido indirizzo di descrittore non puo' assumere
		// per caso questo valore).
		scorri->next = reinterpret_cast<des_mem*>(0xdeadbeef);
		
	}

	// restituiamo l'indirizzo della zona allocata (0 se non e' stato
	// possibile allocare).  NOTA: il descrittore della zona si trova nei
	// byte immediatamente precedenti l'indirizzo "p".  Questo e'
	// importante, perche' ci permette di recuperare il descrittore dato
	// "p" e, tramite il descrittore, la dimensione della zona occupata
	// (tale dimensione puo' essere diversa da quella richiesta, quindi
	// e' ignota al chiamante della funzione).
	return p;
}

void free_interna(addr indirizzo, natl quanti);

// "dealloca" deve essere usata solo con puntatori restituiti da "alloca", e rende
// nuovamente libera la zona di memoria di indirizzo iniziale "p".
void dealloca(void* p)
{

	// e' normalmente ammesso invocare "dealloca" su un puntatore nullo.
	// In questo caso, la funzione non deve fare niente.
	if (p == 0) return;
	
	// recuperiamo l'indirizzo del descrittore della zona
	des_mem* des = reinterpret_cast<des_mem*>(p) - 1;

	// se non troviamo questo valore, vuol dire che un qualche errore grave
	// e' stato commesso (free su un puntatore non restituito da malloc,
	// doppio free di un puntatore, sovrascrittura del valore per accesso
	// al di fuori di un array, ...)
	if (des->next != reinterpret_cast<des_mem*>(0xdeadbeef))
		panic("free() errata");
	
	// la zona viene liberata tramite la funzione "free_interna", che ha
	// bisogno dell'indirizzo di partenza e della dimensione della zona
	// comprensiva del suo descrittore
	free_interna(des, des->dimensione + sizeof(des_mem));
}

// rende libera la zona di memoria puntata da "indirizzo" e grande "quanti"
// byte, preoccupandosi di creare il descrittore della zona e, se possibile, di
// unificare la zona con eventuali zone libere contigue in memoria.  La
// riunificazione e' importante per evitare il problema della "falsa
// frammentazione", in cui si vengono a creare tante zone libere, contigue, ma
// non utilizzabili per allocazioni piu' grandi della dimensione di ciascuna di
// esse.
// "free_interna" puo' essere usata anche in fase di inizializzazione, per
// definire le zone di memoria fisica che verranno utilizzate dall'allocatore
void free_interna(addr indirizzo, natl quanti)
{

	// non e' un errore invocare free_interna con "quanti" uguale a 0
	if (quanti == 0) return;

	// il caso "indirizzo == 0", invece, va escluso, in quanto l'indirizzo
	// 0 viene usato per codificare il puntatore nullo
	if (indirizzo == 0) panic("free_interna(0)");

	// la zona va inserita nella lista delle zone libere, ordinata per
	// indirizzo di partenza (tale ordinamento serve a semplificare la
	// successiva operazione di riunificazione)
	des_mem *prec = 0, *scorri = memlibera;
	while (scorri != 0 && scorri < indirizzo) {
		prec = scorri;
		scorri = scorri->next;
	}
	// assert(scorri == 0 || scorri >= indirizzo)

	// in alcuni casi, siamo in grado di riconoscere l'errore di doppia
	// free: "indirizzo" non deve essere l'indirizzo di partenza di una
	// zona gia' libera
	if (scorri == indirizzo) {
		flog(LOG_ERR, "indirizzo = 0x%x", indirizzo);
		panic("double free\n");
	}
	// assert(scorri == 0 || scorri > indirizzo)

	// verifichiamo che la zona possa essere unificata alla zona che la
	// precede.  Cio' e' possibile se tale zona esiste e il suo ultimo byte
	// e' contiguo al primo byte della nuova zona
	if (prec != 0 && (natb*)(prec + 1) + prec->dimensione == indirizzo) {

		// controlliamo se la zona e' unificabile anche alla eventuale
		// zona che la segue
		if (scorri != 0 && static_cast<natb*>(indirizzo) + quanti == (addr)scorri) {
			
			// in questo caso le tre zone diventano una sola, di
			// dimensione pari alla somma delle tre, piu' il
			// descrittore della zona puntata da scorri (che ormai
			// non serve piu')
			prec->dimensione += quanti + sizeof(des_mem) + scorri->dimensione;
			prec->next = scorri->next;

		} else {

			// unificazione con la zona precedente: non creiamo una
			// nuova zona, ma ci limitiamo ad aumentare la
			// dimensione di quella precedente
			prec->dimensione += quanti;
		}

	} else if (scorri != 0 && static_cast<natb*>(indirizzo) + quanti == (addr)scorri) {

		// la zona non e' unificabile con quella che la precede, ma e'
		// unificabile con quella che la segue. L'unificazione deve
		// essere eseguita con cautela, per evitare di sovrascrivere il
		// descrittore della zona che segue prima di averne letto il
		// contenuto
		
		// salviamo il descrittore della zona seguente in un posto
		// sicuro
		des_mem salva = *scorri; 
		
		// allochiamo il nuovo descrittore all'inizio della nuova zona
		// (se quanti < sizeof(des_mem), tale descrittore va a
		// sovrapporsi parzialmente al descrittore puntato da scorri)
		des_mem* nuovo = reinterpret_cast<des_mem*>(indirizzo);

		// quindi copiamo il descrittore della zona seguente nel nuovo
		// descrittore. Il campo next del nuovo descrittore e'
		// automaticamente corretto, mentre il campo dimensione va
		// aumentato di "quanti"
		*nuovo = salva;
		nuovo->dimensione += quanti;

		// infine, inseriamo "nuovo" in lista al posto di "scorri"
		if (prec != 0) 
			prec->next = nuovo;
		else
			memlibera = nuovo;

	} else if (quanti >= sizeof(des_mem)) {

		// la zona non puo' essere unificata con nessun'altra.  Non
		// possiamo, pero', inserirla nella lista se la sua dimensione
		// non e' tale da contenere il descrittore (nel qual caso, la
		// zona viene ignorata)

		des_mem* nuovo = reinterpret_cast<des_mem*>(indirizzo);
		nuovo->dimensione = quanti - sizeof(des_mem);

		// inseriamo "nuovo" in lista, tra "prec" e "scorri"
		nuovo->next = scorri;
		if (prec != 0)
			prec->next = nuovo;
		else
			memlibera = nuovo;
	}
}

void init_heap()
{
	free_interna((addr)4096U, HEAP_SIZE);
}
// )

// ( [P_MEM_PHYS]
// init_dpf viene chiamata in fase di inizalizzazione.  Tutta la
// memoria non ancora occupata viene usata per le pagine fisiche.  La funzione
// si preoccupa anche di allocare lo spazio per i descrittori di pagina fisica,
// e di inizializzarli in modo che tutte le pagine fisiche risultino libere
bool init_dpf()
{

	prima_pf_utile = (addr)DIM_M1;

	pagine_libere = &dpf[0];
	for (natl i = 0; i < N_DPF - 1; i++) {
		dpf[i].contenuto = LIBERA;
		dpf[i].avl.prossima_libera = &dpf[i + 1];
	}
	dpf[N_DPF - 1].avl.prossima_libera = 0;

	return true;
}
// )

// ( [P_PROCESS] (si veda [4.6][4.7])
// funzioni usate da crea_processo
void rilascia_tutto(addr direttorio, natl i, natl n);
extern "C" int alloca_tss(des_proc* p);
extern "C" void rilascia_tss(int indice);

// elemento di coda e descrittore del primo processo (quello che esegue il 
// codice di inizializzazione e la funzione main)
proc_elem init;
des_proc des_main;

natl& get_des2(natl proc, tt tipo, addr ind_virt);
des_pf *swap2(natl proc, tt tipo, addr ind_virt, bool residente);

bool crea(natl proc, addr ind_virt, tt tipo, natl liv)
{
	natl& dt = get_des(proc, tipo, ind_virt);
	bool bitP = extr_P(dt);
	if (!bitP) {
		natl blocco = extr_IND_MASSA(dt);
		if (!blocco) {
			if (! (blocco = alloca_blocco()) ) {
				panic("spazio nello swap esaurito");
			}
			set_IND_MASSA(dt, blocco);
			dt = dt | BIT_RW;
			if (liv == LIV_UTENTE) dt = dt | BIT_US;
		}
	}
	return bitP;
}

void crea_pagina(natl proc, addr ind_virt, natl liv)
{
	bool pres;

	pres = crea(proc, ind_virt, TABELLA_PRIVATA, liv);
	if (!pres)
		swap2(proc, TABELLA_PRIVATA, ind_virt, (liv == LIV_SISTEMA));
	crea(proc, ind_virt, PAGINA_PRIVATA, liv);
}

natl crea_pila(natl proc, natb *bottom, natl size, natl liv)
{
	size = (size + (DIM_PAGINA - 1)) & ~(DIM_PAGINA - 1);

	for (natb* ind = bottom - size; ind != bottom; ind += DIM_PAGINA)
		crea_pagina(proc, (addr)ind, liv);
	return size;
}

addr carica_pila(natl proc, addr bottom, natl size, bool residente)
{
	natl base = (natl)bottom;
	des_pf *ppf;

	for (natl ind = base - size; ind != base; ind += DIM_PAGINA) {
		bool bitP; natl dt;
		dt = get_des(proc,  TABELLA_PRIVATA, (addr)ind);
		bitP = extr_P(dt);
		if (!bitP)
			swap2(proc, TABELLA_PRIVATA, (addr)ind, residente);
		ppf = swap2(proc, PAGINA_PRIVATA, (addr)ind, residente);
		if (ppf == 0) {
			panic("impossibile caricare pila");
		}
	}
	return indirizzo_pf(ppf);
}

void crea_direttorio(addr dest)
{
	addr pdir = readCR3();

	memset(dest, 0, DIM_PAGINA);

	copy_des(pdir, dest, i_sistema_condiviso, ntab_sistema_condiviso);
	copy_des(pdir, dest, i_io_condiviso,      ntab_io_condiviso);
	copy_des(pdir, dest, i_pci_condiviso,     ntab_pci_condiviso);
	copy_des(pdir, dest, i_utente_condiviso,  ntab_utente_condiviso);
}

des_pf* alloca_pagina_fisica(natl proc, tt tipo, addr ind_virt)
{
	des_pf *ppf = alloca_pagina_fisica_libera();
	if (ppf == 0) {
		if ( (ppf = scegli_vittima2(proc, tipo, ind_virt)) && scollega(ppf) )
			scarica(ppf);
	}
	return ppf;
}

des_pf* swap2(natl proc, tt tipo, addr ind_virt, bool residente)
{
	des_pf* ppf = alloca_pagina_fisica(proc, tipo, ind_virt);
	if (!ppf)
		return 0;
	natl des = get_des(proc, tipo, ind_virt);
	natl IM = extr_IND_MASSA(des);
	ppf->contenuto = tipo;
	ppf->pt.residente = residente;
	ppf->pt.processo = proc;
	ppf->pt.ind_virtuale = ind_virt;
	ppf->pt.ind_massa = IM;
	ppf->pt.contatore = 0;
	carica(ppf);
	collega(ppf);
	return ppf;
}

const natl BIT_IF = 1L << 9;
proc_elem* crea_processo(void f(int), int a, int prio, char liv, bool IF)
{
	proc_elem	*p;			// proc_elem per il nuovo processo
	natl		identifier;		// indice del tss nella gdt 
	des_proc	*pdes_proc;		// descrittore di processo
	des_pf*		dpf_direttorio;		// direttorio del processo
	addr		pila_sistema;
	natl		size;
	

	// ( allocazione (e azzeramento preventivo) di un des_proc 
	//   (parte del punto 3 in [4.6])
	pdes_proc = static_cast<des_proc*>(alloca(sizeof(des_proc)));
	if (pdes_proc == 0) goto errore1;
	memset(pdes_proc, 0, sizeof(des_proc));
	// )

	// ( selezione di un identificatore (punto 1 in [4.6])
	identifier = alloca_tss(pdes_proc);
	if (identifier == 0) goto errore2;
	// )
	
	// ( allocazione e inizializzazione di un proc_elem
	//   (punto 3 in [4.6])
	p = static_cast<proc_elem*>(alloca(sizeof(proc_elem)));
        if (p == 0) goto errore3;
        p->id = identifier << 3U;
        p->precedenza = prio;
	p->puntatore = 0;
	// )

	// ( creazione del direttorio del processo (vedi [10.3]
	//   e la funzione "carica()")
	dpf_direttorio = alloca_pagina_fisica(p->id, DIRETTORIO, 0);
	if (dpf_direttorio == 0) goto errore4;
	dpf_direttorio->contenuto = DIRETTORIO;
	dpf_direttorio->pt.residente = true;
	pdes_proc->cr3 = indirizzo_pf(dpf_direttorio);
	crea_direttorio(pdes_proc->cr3);
	// )

	// ( creazione della pila sistema (vedi [10.3]).
	size = crea_pila(p->id, fine_sistema_privato, DIM_SYS_STACK, LIV_SISTEMA);
	//   carichiamo tutta la pila sistema e la rendiamo residente
	pila_sistema = carica_pila(p->id, fine_sistema_privato, size, true);
	// )

	if (liv == LIV_UTENTE) {
		// ( inizializziamo la pila sistema.
		natl* pl = static_cast<natl*>(pila_sistema);

		pl[1019] = (natl)f;		// EIP (codice utente)
		pl[1020] = SEL_CODICE_UTENTE;	// CS (codice utente)
		pl[1021] = (IF? BIT_IF : 0);	// EFLAG
		pl[1022] = (natl)(fine_utente_privato - 2 * sizeof(int)); // ESP (pila utente)
		pl[1023] = SEL_DATI_UTENTE;	// SS (pila utente)
		//   eseguendo una IRET da questa situazione, il processo
		//   passera' ad eseguire la prima istruzione della funzione f,
		//   usando come pila la pila utente (al suo indirizzo virtuale)
		// )

		// ( creazione e inizializzazione della pila utente
		crea_pila(p->id, fine_utente_privato, DIM_USR_STACK, LIV_UTENTE);
		//   carichiamo la prima pagina (dal fondo) della pila utente
		addr pila_utente = carica_pila(p->id, fine_utente_privato, DIM_PAGINA, false);

		//   dobbiamo ora fare in modo che la pila utente si trovi nella
		//   situazione in cui si troverebbe dopo una CALL alla funzione
		//   f, con parametro a:
		pl = static_cast<natl*>(pila_utente);
		pl[1022] = 0xffffffff;	// ind. di ritorno non significativo
		pl[1023] = a;		// parametro del processo

		// dobbiamo settare manualmente il bit D, perche' abbiamo
		// scritto nella pila tramite la finestra FM, non tramite
		// il suo indirizzo virtuale.
		natl& dp = get_despag(p->id, fine_utente_privato - DIM_PAGINA);
		set_D(dp, true);
		// )

		// ( infine, inizializziamo il descrittore di processo
		//   (punto 3 in [4.6])
		//   indirizzo del bottom della pila sistema, che verra' usato
		//   dal meccanismo delle interruzioni
		pdes_proc->punt_nucleo = fine_sistema_privato;
		pdes_proc->riservato  = SEL_DATI_SISTEMA;

		//   inizialmente, il processo si trova a livello sistema, come
		//   se avesse eseguito una istruzione INT, con la pila sistema
		//   che contiene le 5 parole lunghe preparate precedentemente
		pdes_proc->contesto[I_ESP] = (natl)(fine_sistema_privato - 5 * sizeof(int));
		pdes_proc->contesto[I_SS]  = SEL_DATI_SISTEMA;

		pdes_proc->contesto[I_DS]  = SEL_DATI_UTENTE;
		pdes_proc->contesto[I_ES]  = SEL_DATI_UTENTE;

		pdes_proc->contesto[I_FPU_CR] = 0x037f;
		pdes_proc->contesto[I_FPU_TR] = 0xffff;
		pdes_proc->cpl = LIV_UTENTE;
		//   tutti gli altri campi valgono 0
		// )
	} else {
		// ( inizializzazione delle pila sistema
		natl* pl = static_cast<natl*>(pila_sistema);
		pl[1019] = (natl)f;	  	// EIP (codice sistema)
		pl[1020] = SEL_CODICE_SISTEMA;  // CS (codice sistema)
		pl[1021] = (IF? BIT_IF : 0);  	// EFLAG
		pl[1022] = 0xffffffff;		// indirizzo ritorno?
		pl[1023] = a;			// parametro
		//   i processi esterni lavorano esclusivamente a livello
		//   sistema. Per questo motivo, prepariamo una sola pila (la
		//   pila sistema)
		// )

		// ( inizializziamo il descrittore di processo
		//   (punto 3 in [4.6])
		pdes_proc->contesto[I_ESP] = (natl)(fine_sistema_privato - 5 * sizeof(int));
		pdes_proc->contesto[I_SS]  = SEL_DATI_SISTEMA;

		pdes_proc->contesto[I_DS]  = SEL_DATI_SISTEMA;
		pdes_proc->contesto[I_ES]  = SEL_DATI_SISTEMA;
		pdes_proc->contesto[I_FPU_CR] = 0x037f;
		pdes_proc->contesto[I_FPU_TR] = 0xffff;
		pdes_proc->cpl = LIV_SISTEMA;
		//   tutti gli altri campi valgono 0
		// )
	}

	return p;

#if 0
errore6:	rilascia_tutto(indirizzo_pf(dpf_direttorio), i_sistema_privato, ntab_sistema_privato);
errore5:	rilascia_pagina_fisica(dpf_direttorio);
#endif
errore4:	dealloca(p);
errore3:	rilascia_tss(identifier);
errore2:	dealloca(pdes_proc);
errore1:	return 0;
}

// parte "C++" della activate_p, descritta in [4.6]
extern "C" natl
c_activate_p(void f(int), int a, natl prio, natl liv)
{
	proc_elem *p;			// proc_elem per il nuovo processo
	natl id = 0xFFFFFFFF;		// id da restituire in caso di fallimento

	// (* non possiamo accettare una priorita' minore di quella di dummy
	//    o maggiore di quella del processo chiamante
	if (prio < MIN_PRIORITY || prio > esecuzione->precedenza) {
		flog(LOG_WARN, "priorita' non valida: %d", prio);
		abort_p();
	}
	// *)
	
	// (* controlliamo che 'liv' contenga un valore ammesso 
	//    [segnalazione di E. D'Urso]
	if (liv != LIV_UTENTE && liv != LIV_SISTEMA) {
		flog(LOG_WARN, "livello non valido: %d", liv);
		abort_p();
	}
	// *)

	if (liv == LIV_SISTEMA && des_p(esecuzione->id)->cpl == LIV_UTENTE) {
		flog(LOG_WARN, "errore di protezione");
		abort_p();
	}

	// (* accorpiamo le parti comuni tra c_activate_p e c_activate_pe
	// nella funzione ausiliare crea_processo
	// (questa svolge, tra l'altro, i punti 1-3 in [4.6])
	p = crea_processo(f, a, prio, liv, true);
	// *)

	if (p != 0) {
		inserimento_lista(pronti, p);	// punto 4 in [4.6]
		processi++;			// [4.7]
		id = p->id;			// id del processo creato
						// (allocato da crea_processo)
		flog(LOG_INFO, "proc=%d entry=%x(%d) prio=%d liv=%d", id, f, a, prio, liv);
	}

	return id;
}


void rilascia_tutto(addr direttorio, natl i, natl n);
// rilascia tutte le strutture dati private associate al processo puntato da 
// "p" (tranne il proc_elem puntato da "p" stesso)
void distruggi_processo(proc_elem* p)
{
	des_proc* pdes_proc = des_p(p->id);

	addr direttorio = pdes_proc->cr3;
	rilascia_tutto(direttorio, i_sistema_privato, ntab_sistema_privato);
	rilascia_tutto(direttorio, i_utente_privato,  ntab_utente_privato);
	rilascia_pagina_fisica(descrittore_pf(direttorio));
	rilascia_tss(p->id >> 3);
	dealloca(pdes_proc);
}

// rilascia ntab tabelle (con tutte le pagine da esse puntate) a partire da 
// quella puntata dal descrittore i-esimo di direttorio.
void rilascia_tutto(addr direttorio, natl i, natl n)
{
	for (natl j = i; j < i + n && j < 1024; j++)
	{
		natl dt = singolo_des(direttorio, j);
		if (extr_P(dt)) {
			addr tabella = extr_IND_FISICO(dt);
			for (int k = 0; k < 1024; k++) {
				natl dp = singolo_des(tabella, k);
				if (extr_P(dp)) {
					addr pagina = extr_IND_FISICO(dp);
					rilascia_pagina_fisica(descrittore_pf(pagina));
				} else {
					natl blocco = extr_IND_MASSA(dp);
					dealloca_blocco(blocco);
				}
			}
			rilascia_pagina_fisica(descrittore_pf(tabella));
		} else {
			natl blocco = extr_IND_MASSA(dt);
			dealloca_blocco(blocco);
		}
	}
}

// parte "C++" della terminate_p, descritta in [4.6]
extern "C" void c_terminate_p()
{
	// il processo che deve terminare e' quello che ha invocato
	// la terminate_p, quindi e' in esecuzione
	proc_elem *p = esecuzione;
	distruggi_processo(p);
	processi--;			// [4.7]
	flog(LOG_INFO, "Processo %d terminato", p->id);
	dealloca(p);
	schedulatore();			// [4.6]
}

// come la terminate_p, ma invia anche un warning al log (da invocare quando si 
// vuole terminare un processo segnalando che c'e' stato un errore)
extern "C" void c_abort_p()
{
	proc_elem *p = esecuzione;
	distruggi_processo(p);
	processi--;
	flog(LOG_WARN, "Processo %d abortito", p->id);
	dealloca(p);
	schedulatore();
}
// )


// ( [P_PAGING] 

// (*il microprogramma di gestione delle eccezioni di page fault lascia in cima 
//   alla pila (oltre ai valori consueti) una doppia parola, i cui 4 bit meno 
//   significativi specificano piu' precisamente il motivo per cui si e' 
//   verificato un page fault. Il significato dei bit e' il seguente:
//   - prot: se questo bit vale 1, il page fault si e' verificato per un errore 
//   di protezione: il processore si trovava a livello utente e la pagina (o la 
//   tabella) era di livello sistema (bit US = 0). Se prot = 0, la pagina o la 
//   tabella erano assenti (bit P = 0)
//   - write: l'accesso che ha causato il page fault era in scrittura (non 
//   implica che la pagina non fosse scrivibile)
//   - user: l'accesso e' avvenuto mentre il processore si trovava a livello 
//   utente (non implica che la pagina fosse invece di livello sistema)
//   - res: uno dei bit riservati nel descrittore di pagina o di tabella non 
//   avevano il valore richiesto (il bit D deve essere 0 per i descrittori di 
//   tabella, e il bit pgsz deve essere 0 per i descrittori di pagina)
struct pf_error {
	natl prot  : 1;
	natl write : 1;
	natl user  : 1;
	natl res   : 1;
	natl pad   : 28; // bit non significativi
};
// *)

// (* indirizzo del primo byte che non contiene codice di sistema (vedi "sistema.S")
extern "C" addr fine_codice_sistema; 
// *)

natl pf_mutex;			// [6.4]
extern "C" addr readCR2();	// [6.4]
natl swap(natl processo, addr ind_virt);  // [6.4]
// (* punti in cui possiamo accettare un page fault dal modulo sistema (vedi "sistema.S")
extern "C" addr* possibili_pf;
bool possibile_pf(addr eip)
{
	for (addr *p = possibili_pf; *p; p++) {
		if (*p == eip)
			return true;
	}
	return false;
}
// *)
extern "C" void c_pre_routine_pf(	// [6.4]
	// (* prevediamo dei parametri aggiuntivi:
		pf_error errore,	/* vedi sopra */
		addr eip		/* ind. dell'istruzione che ha causato il fault */
	// *)
	)
{
	// (* il sistema non e' progettato per gestire page fault causati 
	//   dalle primitie di nucleo (vedi [6.5]), quindi, se cio' si e' verificato, 
	//   si tratta di un bug
	if ((eip < fine_codice_sistema && !possibile_pf(eip)) || errore.res == 1) {
		flog(LOG_ERR, "eip: %x, page fault a %x: %s, %s, %s, %s", eip, readCR2(),
			errore.prot  ? "protezione"	: "pag/tab assente",
			errore.write ? "scrittura"	: "lettura",
			errore.user  ? "da utente"	: "da sistema",
			errore.res   ? "bit riservato"	: "");
		panic("page fault dal modulo sistema");
	}
	// *)
	
	// (* l'errore di protezione non puo' essere risolto: il processo ha 
	//    tentato di accedere ad indirizzi proibiti (cioe', allo spazio 
	//    sistema)
	if (errore.prot == 1) {
		flog(LOG_WARN, "errore di protezione: eip=%x, ind=%x, %s, %s", eip, readCR2(),
			errore.write ? "scrittura"	: "lettura",
			errore.user  ? "da utente"	: "da sistema");
		abort_p();
	}
	// *)
	

	c_routine_pf();
}

// funzione che restituisce i 10 bit piu' significativi di "ind_virt"
// (indice nel direttorio)
int i_dir(addr ind_virt)
{
	return ((natl)ind_virt & 0xFFC00000) >> 22;
}

// funzione che restituisce i bit 22-12 di "ind_virt"
// (indice nella tabella delle pagine)
int i_tab(addr ind_virt)
{
	return ((natl)ind_virt & 0x003FF000) >> 12;
}

natl& singolo_des(addr iff, natl index) // [6.3]
{
	natl *pd = static_cast<natl*>(iff);
	return pd[index];
}

natl& get_destab(addr dir, addr ind_virt) // [6.3]
{
	return singolo_des(dir, i_dir(ind_virt));
}

natl& get_despag(addr tab, addr ind_virt) // [6.3]
{
	return singolo_des(tab, i_tab(ind_virt));
}

addr get_dir(natl proc);
addr get_tab(natl proc, addr ind_virt);

natl& get_destab(natl processo, addr ind_virt) // [6.3]
{
	return get_destab(get_dir(processo), ind_virt);
}

natl& get_despag(natl processo, addr ind_virt) // [6.3]
{
	natl dt = get_destab(processo, ind_virt);
	return get_despag(extr_IND_FISICO(dt), ind_virt);
}

// restituisce l'indirizzo fisico del direttorio del processo proc
addr get_dir(natl proc)
{
	des_proc *p = des_p(proc);
	return p->cr3;
}

addr get_tab(natl proc, addr ind_virt)
{
	natl dt = get_destab(proc, ind_virt);
	return extr_IND_FISICO(dt);
}

// ( si veda "case DIRETTORIO:" sotto
natl dummy_des;
// )
natl& get_des(natl processo, tt tipo, addr ind_virt)
{
	switch (tipo) {
	case PAGINA_PRIVATA:
	case PAGINA_CONDIVISA:
		return get_despag(processo, ind_virt);
	case TABELLA_PRIVATA:
	case TABELLA_CONDIVISA:
		return get_destab(processo, ind_virt);
	// ( per poter usare swap anche per caricare direttori prevediamo
	//   questo ulteriore caso (restituiamo un descrittore fasullo,
	//   perché il direttorio non e' puntato da un descrittore)
	case DIRETTORIO:
		dummy_des = 0;
		return dummy_des;
	// )
	default:
		flog(LOG_ERR, "get_des(%d, %d, %x)", processo, tipo, ind_virt);
		panic("Errore di sistema");  // ****
	}
}


void set_des(addr dirtab, int index, natl des)
{
	natl *pd = static_cast<natl*>(dirtab);
	pd[index] = des;
}

void set_destab(addr dir, addr ind_virt, natl destab)
{
	set_des(dir, i_dir(ind_virt), destab);
}
void set_despag(addr tab, addr ind_virt, natl despag)
{
	set_des(tab, i_tab(ind_virt), despag);
}

void mset_des(addr dirtab, natl i, natl n, natl des)
{
	natl *pd = static_cast<natl*>(dirtab);
	for (natl j = i; j < i + n && j < 1024; j++)
		pd[j] = des;
}

void copy_des(addr src, addr dst, natl i, natl n)
{
	natl *pdsrc = static_cast<natl*>(src),
	     *pddst = static_cast<natl*>(dst);
	for (natl j = i; j < i + n && j < 1024; j++)
		pddst[j] = pdsrc[j];
}

extern "C" addr c_trasforma(addr ind_virt)
{
	natl dp = get_despag(esecuzione->id, ind_virt);
	natl ind_fis_pag = (natl)extr_IND_FISICO(dp);
	return (addr)(ind_fis_pag | ((natl)ind_virt & 0x00000FFF));

}



// )

// ( [P_MEM_VIRT]
//
// mappa le ntab pagine virtuali a partire dall'indirizzo virt_start agli 
// indirizzi fisici
// che partono da phys_start, in sequenza.
bool sequential_map(addr direttorio, addr phys_start, addr virt_start, natl npag, natl flags)
{
	natb *indv = static_cast<natb*>(virt_start),
	     *indf = static_cast<natb*>(phys_start);
	for (natl i = 0; i < npag; i++, indv += DIM_PAGINA, indf += DIM_PAGINA) {
		natl dt = get_destab(direttorio, indv);
		addr tabella;
		if (! extr_P(dt)) {
			des_pf* ppf = alloca_pagina_fisica_libera();
			if (ppf == 0) {
				flog(LOG_ERR, "Impossibile allocare le tabelle condivise");
				return false;
			}
			ppf->contenuto = TABELLA_CONDIVISA;
			ppf->pt.residente = true;
			tabella = indirizzo_pf(ppf);

			dt = ((natl)tabella & ADDR_MASK) | flags | BIT_P;
			set_destab(direttorio, indv, dt);
		} else {
			tabella = extr_IND_FISICO(dt);
		}
		natl dp = ((natl)indf & ADDR_MASK) | flags | BIT_P;
		set_despag(tabella, indv, dp);
	}
	return true;
}
// mappa tutti gli indirizzi a partire da start (incluso) fino ad end (escluso)
// in modo che l'indirizzo virtuale coincida con l'indirizzo fisico.
// start e end devono essere allineati alla pagina.
bool identity_map(addr direttorio, addr start, addr end, natl flags)
{
	natl npag = (static_cast<natb*>(end) - static_cast<natb*>(start)) / DIM_PAGINA;
	return sequential_map(direttorio, start, start, npag, flags);
}
// mappa la memoria fisica, dall'indirizzo 0 all'indirizzo max_mem, nella 
// memoria virtuale gestita dal direttorio pdir
// (la funzione viene usata in fase di inizializzazione)
bool crea_finestra_FM(addr direttorio)
{
	return identity_map(direttorio, (addr)DIM_PAGINA, (addr)MEM_TOT, BIT_RW);
}

// ( [P_PCI]

// mappa in memoria virtuale la porzione di spazio fisico dedicata all'I/O (PCI e altro)
bool crea_finestra_PCI(addr direttorio)
{
	return sequential_map(direttorio,
			PCI_startmem,
			inizio_pci_condiviso,
			ntab_pci_condiviso * 1024,
			BIT_RW | BIT_PCD);
}

natb pci_getbus(natw l)
{
	return l >> 8;
}

natb pci_getdev(natw l)
{
	return (l & 0x00FF) >> 3;
}

natb pci_getfun(natw l)
{
	return l & 0x0007;
}
// )

// ( [P_IOAPIC]

// parte piu' significativa di una redirection table entry
const natl IOAPIC_DEST_MSK = 0xFF000000; // destination field mask
const natl IOAPIC_DEST_SHF = 24;	 // destination field shift
// parte meno significativa di una redirection table entry
const natl IOAPIC_MIRQ_BIT = (1U << 16); // mask irq bit
const natl IOAPIC_TRGM_BIT = (1U << 15); // trigger mode (1=level, 0=edge)
const natl IOAPIC_IPOL_BIT = (1U << 13); // interrupt polarity (0=high, 1=low)
const natl IOAPIC_DSTM_BIT = (1U << 11); // destination mode (0=physical, 1=logical)
const natl IOAPIC_DELM_MSK = 0x00000700; // delivery mode field mask (000=fixed)
const natl IOAPIC_DELM_SHF = 8;		 // delivery mode field shift
const natl IOAPIC_VECT_MSK = 0x000000FF; // vector field mask
const natl IOAPIC_VECT_SHF = 0;		 // vector field shift

struct ioapic_des {
	natl* IOREGSEL;
	natl* IOWIN;
	natl* EOI;
	natb  RTO;	// Redirection Table Offset
};

extern "C" ioapic_des ioapic;

natl ioapic_in(natb off)
{
	*ioapic.IOREGSEL = off;
	return *ioapic.IOWIN;
}

void ioapic_out(natb off, natl v)
{
	*ioapic.IOREGSEL = off;
	*ioapic.IOWIN = v;
}

natl ioapic_read_rth(natb irq)
{
	return ioapic_in(ioapic.RTO + irq * 2 + 1);
}

void ioapic_write_rth(natb irq, natl w)
{
	ioapic_out(ioapic.RTO + irq * 2 + 1, w);
}

natl ioapic_read_rtl(natb irq)
{
	return ioapic_in(ioapic.RTO + irq * 2);
}

void ioapic_write_rtl(natb irq, natl w)
{
	ioapic_out(ioapic.RTO + irq * 2, w);
}

void ioapic_set_VECT(natl irq, natb vec)
{
	natl work = ioapic_read_rtl(irq);
	work = (work & ~IOAPIC_VECT_MSK) | (vec << IOAPIC_VECT_SHF);
	ioapic_write_rtl(irq, work);
}

void ioapic_set_MIRQ(natl irq, bool v)
{
	natl work = ioapic_read_rtl(irq);
	if (v)
		work |= IOAPIC_MIRQ_BIT;
	else
		work &= ~IOAPIC_MIRQ_BIT;
	ioapic_write_rtl(irq, work);
}

extern "C" void ioapic_mask(natl irq)
{
	ioapic_set_MIRQ(irq, true);
}

extern "C" void ioapic_unmask(natl irq)
{
	ioapic_set_MIRQ(irq, false);
}

void ioapic_set_TRGM(natl irq, bool v)
{
	natl work = ioapic_read_rtl(irq);
	if (v)
		work |= IOAPIC_TRGM_BIT;
	else
		work &= ~IOAPIC_TRGM_BIT;
	ioapic_write_rtl(irq, work);
}


const natw PIIX3_VENDOR_ID = 0x8086;
const natw PIIX3_DEVICE_ID = 0x7000;
const natb PIIX3_APICBASE = 0x80;
const natb PIIX3_XBCS = 0x4e;
const natl PIIX3_XBCS_ENABLE = (1U << 8);

natl apicbase_getxy(natl apicbase)
{
	return (apicbase & 0x01F) << 10U;
}

extern "C" void disable_8259();
bool ioapic_init()
{
	natw l = 0;
	// trovare il PIIX3 e
	if (!pci_find_dev(l, PIIX3_DEVICE_ID, PIIX3_VENDOR_ID)) {
		flog(LOG_WARN, "PIIX3 non trovato");
		return false;
	}
	flog(LOG_DEBUG, "PIIX3: trovato a %2x.%2x.%2x",
			pci_getbus(l), pci_getdev(l), pci_getfun(l));
	// 	inizializzare IOREGSEL e IOWIN
	natb apicbase;
	apicbase = pci_read_confb(l, PIIX3_APICBASE);
	natl tmp_IOREGSEL = (natl)ioapic.IOREGSEL | apicbase_getxy(apicbase);
	natl tmp_IOWIN    = (natl)ioapic.IOWIN    | apicbase_getxy(apicbase);
	// 	trasformiamo gli indirizzi fisici in virtuali
	ioapic.IOREGSEL = (natl*)(tmp_IOREGSEL - (natl)PCI_startmem + (natl)inizio_pci_condiviso);
	ioapic.IOWIN    = (natl*)(tmp_IOWIN    - (natl)PCI_startmem + (natl)inizio_pci_condiviso);
	ioapic.EOI	= (natl*)((natl)ioapic.EOI - (natl)PCI_startmem + (natl)inizio_pci_condiviso);
	flog(LOG_DEBUG, "IOAPIC: ioregsel %8x, iowin %8x", ioapic.IOREGSEL, ioapic.IOWIN);
	// 	abilitare il /CS per l'IOAPIC
	natl xbcs;
	xbcs = pci_read_confl(l, PIIX3_XBCS);
	xbcs |= PIIX3_XBCS_ENABLE;
	pci_write_confl(l, PIIX3_XBCS, xbcs);
	disable_8259();
	// riempire la redirection table
	for (natb i = 0; i < MAX_IRQ; i++) {
		ioapic_write_rth(i, 0);
		ioapic_write_rtl(i, IOAPIC_MIRQ_BIT | IOAPIC_TRGM_BIT);
	}
	ioapic_set_VECT(0, VETT_0);	ioapic_set_TRGM(0, false);
	ioapic_set_VECT(1, VETT_1);
	ioapic_set_VECT(2, VETT_2);	ioapic_set_TRGM(2, false);
	ioapic_set_VECT(3, VETT_3);
	ioapic_set_VECT(4, VETT_4);
	ioapic_set_VECT(5, VETT_5);
	ioapic_set_VECT(6, VETT_6);
	ioapic_set_VECT(7, VETT_7);
	ioapic_set_VECT(8, VETT_8);
	ioapic_set_VECT(9, VETT_9);
	ioapic_set_VECT(10, VETT_10);
	ioapic_set_VECT(11, VETT_11);
	ioapic_set_VECT(12, VETT_12);
	ioapic_set_VECT(13, VETT_13);
	ioapic_set_VECT(14, VETT_14);
	ioapic_set_VECT(15, VETT_15);
	ioapic_set_VECT(16, VETT_16);
	ioapic_set_VECT(17, VETT_17);
	ioapic_set_VECT(18, VETT_18);
	ioapic_set_VECT(19, VETT_19);
	ioapic_set_VECT(20, VETT_20);
	ioapic_set_VECT(21, VETT_21);
	ioapic_set_VECT(22, VETT_22);
	ioapic_set_VECT(23, VETT_23);
	return true;
}

extern "C" void ioapic_reset()
{
	for (natb i = 0; i < MAX_IRQ; i++) {
		ioapic_write_rth(i, 0);
		ioapic_write_rtl(i, IOAPIC_MIRQ_BIT | IOAPIC_TRGM_BIT);
	}
	natw l = 0;
	pci_find_dev(l, PIIX3_DEVICE_ID, PIIX3_VENDOR_ID);
	natl xbcs;
	xbcs = pci_read_confl(l, PIIX3_XBCS);
	xbcs &= ~PIIX3_XBCS_ENABLE;
	pci_write_confl(l, PIIX3_XBCS, xbcs);
}

// )


// ( [P_EXTERN_PROC]
// Registrazione processi esterni
proc_elem* const ESTERN_BUSY = (proc_elem*)1;
proc_elem *a_p_save[MAX_IRQ];
// primitiva di nucleo usata dal nucleo stesso
extern "C" void wfi();

// inizialmente, tutti gli interrupt esterni sono associati ad una istanza di 
// questo processo esterno generico, che si limita ad inviare un messaggio al 
// log ogni volta che viene attivato. Successivamente, la routine di 
// inizializzazione del modulo di I/O provvedera' a sostituire i processi 
// esterni generici con i processi esterni effettivi, per quelle periferiche 
// che il modulo di I/O e' in grado di gestire.
void estern_generico(int h)
{
	for (;;) {
		flog(LOG_WARN, "Interrupt %d non gestito", h);

		wfi();
	}
}

// associa il processo esterno puntato da "p" all'interrupt "irq".
// Fallisce se un processo esterno (non generico) era gia' stato associato a 
// quello stesso interrupt
extern "C" void unmask_irq(natb irq);
bool aggiungi_pe(proc_elem *p, natb irq)
{
	if (irq >= MAX_IRQ || a_p_save[irq] == 0)
		return false;

	a_p[irq] = p;
	distruggi_processo(a_p_save[irq]);
	dealloca(a_p_save[irq]);
	a_p_save[irq] = 0;
	ioapic_unmask(irq);
	return true;

}


extern "C" natl c_activate_pe(void f(int), int a, natl prio, natl liv, natb type)
{
	proc_elem	*p;			// proc_elem per il nuovo processo

	if (prio < MIN_PRIORITY) {
		flog(LOG_WARN, "priorita' non valida: %d", prio);
		abort_p();
	}

	p = crea_processo(f, a, prio, liv, true);
	if (p == 0)
		goto error1;
		
	if (!aggiungi_pe(p, type) ) 
		goto error2;

	flog(LOG_INFO, "estern=%d entry=%x(%d) prio=%d liv=%d type=%d", p->id, f, a, prio, liv, type);

	return p->id;

error2:	distruggi_processo(p);
error1:	
	return 0xFFFFFFFF;
}

// init_pe viene chiamata in fase di inizializzazione, ed associa una istanza 
// di processo esterno generico ad ogni interrupt
bool init_pe()
{
	for (natl i = 0; i < MAX_IRQ; i++) {
		proc_elem* p = crea_processo(estern_generico, i, 1, LIV_SISTEMA, true);
		if (p == 0) {
			flog(LOG_ERR, "Impossibile creare i processi esterni generici");
			return false;
		}
		a_p_save[i] = a_p[i] = p;
	}
	aggiungi_pe(ESTERN_BUSY, 2);
	return true;
}
// )

// ( [P_HARDDISK]

const ioaddr iBR = 0x01F0;
const ioaddr iCNL = 0x01F4;
const ioaddr iCNH = 0x01F5;
const ioaddr iSNR = 0x01F3;
const ioaddr iHND = 0x01F6;
const ioaddr iSCR = 0x01F2;
const ioaddr iERR = 0x01F1;
const ioaddr iCMD = 0x01F7;
const ioaddr iSTS = 0x01F7;
const ioaddr iDCR = 0x03F6;

void leggisett(natl lba, natb quanti, natw vetti[])
{	
	natb lba_0 = lba,
		lba_1 = lba >> 8,
		lba_2 = lba >> 16,
		lba_3 = lba >> 24;
	natb s;
	do 
		inputb(iSTS, s);
	while (s & 0x80);

	outputb(lba_0, iSNR); 			// indirizzo del settore e selezione drive
	outputb(lba_1, iCNL);
	outputb(lba_2, iCNH);
	natb hnd = (lba_3 & 0x0F) | 0xE0;
	outputb(hnd, iHND);
	outputb(quanti, iSCR); 			// numero di settori
	outputb(0x0A, iDCR);			// disabilitazione richieste di interruzione
	outputb(0x20, iCMD);			// comando di lettura

	for (int i = 0; i < quanti; i++) {
		do 
			inputb(iSTS, s);
		while ((s & 0x88) != 0x08);
		for (int j = 0; j < 512/2; j++)
			inputw(iBR, vetti[i*512/2 + j]);
	}
}

void scrivisett(natl lba, natb quanti, natw vetto[])
{	
	natb lba_0 = lba,
		lba_1 = lba >> 8,
		lba_2 = lba >> 16,
		lba_3 = lba >> 24;
	natb s;
	do 
		inputb(iSTS, s);
	while (s & 0x80);
	outputb(lba_0, iSNR);					// indirizzo del settore e selezione drive
	outputb(lba_1, iCNL);
	outputb(lba_2, iCNH);
	natb hnd = (lba_3 & 0x0F) | 0xE0;
	outputb(hnd, iHND);
	outputb(quanti, iSCR);					// numero di settori
	outputb(0x0A, iDCR);					// disabilitazione richieste di interruzione
	outputb(0x30, iCMD);					// comando di scrittura
	for (int i = 0; i < quanti; i++) {
		do
			inputb(iSTS, s);
		while ((s & 0x88) != 0x08);
		for (int j = 0; j < 512/2; j++)
			outputw(vetto[i*512/2 + j], iBR);
	}
}


// )
// ( [P_LOG]


// gestore generico di eccezioni (chiamata da tutti i gestori di eccezioni in 
// sistema.S, tranne il gestore di page fault)
extern "C" void gestore_eccezioni(int tipo, unsigned errore,
		addr eip, unsigned cs, short eflag)
{
	if (eip < fine_codice_sistema) {
		flog(LOG_ERR, "Eccezione %d, eip = %x, errore = %x", tipo, eip, errore);
		panic("eccezione dal modulo sistema");
	}
	flog(LOG_WARN, "Eccezione %d, errore %x", tipo, errore);
	flog(LOG_WARN, "eflag = %x, eip = %x, cs = %x", eflag, eip, cs);
}

const ioaddr iRBR = 0x03F8;		// DLAB deve essere 0
const ioaddr iTHR = 0x03F8;		// DLAB deve essere 0
const ioaddr iLSR = 0x03FD;
const ioaddr iLCR = 0x03FB;
const ioaddr iDLR_LSB = 0x03F8;		// DLAB deve essere 1
const ioaddr iDLR_MSB = 0x03F9;		// DLAB deve essere 1
const ioaddr iIER = 0x03F9;		// DLAB deve essere 0
const ioaddr iMCR = 0x03FC;
const ioaddr iIIR = 0x03FA;


void ini_COM1()
{	natw CBITR = 0x000C;		// 9600 bit/sec.
	natb dummy;
	outputb(0x80, iLCR);		// DLAB 1
	outputb(CBITR, iDLR_LSB);
	outputb(CBITR >> 8, iDLR_MSB);
	outputb(0x03, iLCR);		// 1 bit STOP, 8 bit/car, parita dis, DLAB 0
	outputb(0x00, iIER);		// richieste di interruzione disabilitate
	inputb(iRBR, dummy);		// svuotamento buffer RBR
}

void serial_o(natb c)
{	natb s;
	do 
	{	inputb(iLSR, s);    }
	while (! (s & 0x20));
	outputb(c, iTHR);
}

// invia un nuovo messaggio sul log
void do_log(log_sev sev, const natb* buf, natl quanti)
{
	const char* lev[] = { "DBG", "INF", "WRN", "ERR", "USR" };
	if (sev > MAX_LOG) {
		flog(LOG_WARN, "Livello di log errato: %d", sev);
		abort_p();
	}
	const natb* l = (const natb*)lev[sev];
	while (*l)
		serial_o(*l++);
	serial_o((natb)'\t');
	natb idbuf[10];
	snprintf(idbuf, 10, "%d", esecuzione->id);
	l = idbuf;
	while (*l)
		serial_o(*l++);
	serial_o((natb)'\t');

	for (natl i = 0; i < quanti; i++)
		serial_o(buf[i]);
	serial_o((natb)'\n');
}
extern "C" void c_log(log_sev sev, const natb* buf, natl quanti)
{
	do_log(sev, buf, quanti);
}

// log formattato
extern "C" void flog(log_sev sev, cstr fmt, ...)
{
	va_list ap;
	const natl LOG_MSG_SIZE = 128;
	natb buf[LOG_MSG_SIZE];

	va_start(ap, fmt);
	int l = vsnprintf(buf, LOG_MSG_SIZE, fmt, ap);
	va_end(ap);

	if (l > 1)
		do_log(sev, buf, l - 1);
}

// )

// ( [P_SWAP]
// lo swap e' descritto dalla struttura des_swap, che specifica il canale 
// (primario o secondario) il drive (primario o master) e il numero della 
// partizione che lo contiene. Inoltre, la struttura contiene una mappa di bit, 
// utilizzata per l'allocazione dei blocchi in cui lo swap e' suddiviso, e un 
// "super blocco".  Il contenuto del super blocco e' copiato, durante 
// l'inizializzazione del sistema, dal primo settore della partizione di swap, 
// e deve contenere le seguenti informazioni:
// - magic (un valore speciale che serve a riconoscere la partizione, per 
// evitare di usare come swap una partizione utilizzata per altri scopi)
// - bm_start: il primo blocco, nella partizione, che contiene la mappa di bit 
// (lo swap, inizialmente, avra' dei blocchi gia' occupati, corrispondenti alla 
// parte utente/condivisa dello spazio di indirizzamento dei processi da 
// creare: e' necessario, quindi, che lo swap stesso memorizzi una mappa di 
// bit, che servira' come punto di partenza per le allocazioni dei blocchi 
// successive)
// - blocks: il numero di blocchi contenuti nella partizione di swap (esclusi 
// quelli iniziali, contenenti il superblocco e la mappa di bit)
// - directory: l'indice del blocco che contiene il direttorio
// - l'indirizzo virtuale dell'entry point del programma contenuto nello swap 
// (l'indirizzo di main)
// - l'indirizzo virtuale successivo all'ultima istruzione del programma 
// contenuto nello swap
// - l'indirizzo virtuale dell'entry point del modulo io contenuto nello swap
// - l'indirizzo virtuale successivo all'ultimo byte occupato dal modulo io
// - checksum: somma dei valori precedenti (serve ad essere ragionevolmente 
// sicuri che quello che abbiamo letto dall'hard disk e' effettivamente un 
// superblocco di questo sistema, e che il superblocco stesso non e' stato 
// corrotto)
//

// usa l'istruzione macchina BSF (Bit Scan Forward) per trovare in modo
// efficiente il primo bit a 1 in v
extern "C" int trova_bit(natl v);

// vedi [10.5]
natl alloca_blocco()
{
	natl i = 0;
	natl risu = 0;
	natl vecsize = ceild(swap_dev.sb.blocks, sizeof(natl) * 8);
	static natb pagina_di_zeri[DIM_PAGINA] = { 0 };

	// saltiamo le parole lunghe che contengono solo zeri (blocchi tutti occupati)
	while (i < vecsize && swap_dev.free[i] == 0) i++;
	if (i < vecsize) {
		natl pos = trova_bit(swap_dev.free[i]);
		swap_dev.free[i] &= ~(1UL << pos);
		risu = pos + sizeof(natl) * 8 * i;
	} 
	if (risu) {
		scrivi_speciale(pagina_di_zeri, risu);
	}
	return risu;
}

void dealloca_blocco(natl blocco)
{
	if (blocco == 0)
		return;
	swap_dev.free[blocco / 32] |= (1UL << (blocco % 32));
}



// legge dallo swap il blocco il cui indice e' passato come primo parametro, 
// copiandone il contenuto a partire dall'indirizzo "dest"
void leggi_speciale(addr dest, natl blocco)
{
	natl sector = blocco * 8;

	leggisett(sector, 8, static_cast<natw*>(dest));
}

void scrivi_speciale(addr src, natl blocco)
{
	natl sector = blocco * 8;

	scrivisett(sector, 8, static_cast<natw*>(src));
}

// lettura dallo swap (da utilizzare nella fase di inizializzazione)
bool leggi_swap(addr buf, natl first, natl bytes)
{
	natl nsect = ceild(bytes, 512);

	leggisett(first, nsect, static_cast<natw*>(buf));

	return true;
}

// inizializzazione del descrittore di swap
char read_buf[512];
bool swap_init()
{
	// lettura del superblocco
	flog(LOG_DEBUG, "lettura del superblocco dall'area di swap...");
	if (!leggi_swap(read_buf, 1, sizeof(superblock_t)))
		return false;

	swap_dev.sb = *reinterpret_cast<superblock_t*>(read_buf);

	// controlliamo che il superblocco contenga la firma di riconoscimento
	if (swap_dev.sb.magic[0] != 'C' ||
	    swap_dev.sb.magic[1] != 'E' ||
	    swap_dev.sb.magic[2] != 'S' ||
	    swap_dev.sb.magic[3] != 'W')
	{
		flog(LOG_ERR, "Firma errata nel superblocco");
		return false;
	}

	// controlliamo il checksum
	int *w = (int*)&swap_dev.sb, sum = 0;
	for (natl i = 0; i < sizeof(swap_dev.sb) / sizeof(int); i++)
		sum += w[i];

	if (sum != 0) {
		flog(LOG_ERR, "Checksum errato nel superblocco");
		return false;
	}

	flog(LOG_DEBUG, "lettura della bitmap dei blocchi...");

	// calcoliamo la dimensione della mappa di bit in pagine/blocchi
	natl pages = ceild(swap_dev.sb.blocks, DIM_PAGINA * 8);

	// quindi allochiamo in memoria un buffer che possa contenerla
	swap_dev.free = static_cast<natl*>(alloca((pages * DIM_PAGINA)));
	if (swap_dev.free == 0) {
		flog(LOG_ERR, "Impossibile allocare la bitmap dei blocchi");
		return false;
	}
	// infine, leggiamo la mappa di bit dalla partizione di swap
	return leggi_swap(swap_dev.free,
		swap_dev.sb.bm_start * 8, pages * DIM_PAGINA);
}
// )

// ( [P_PANIC]


// la funzione backtrace stampa su video gli indirizzi di ritorno dei record di 
// attivazione presenti sulla pila sistema
extern "C" void backtrace(int off);

// panic mostra un'insieme di informazioni di debug sul video e blocca il 
// sistema. I parametri "eip1", "cs", "eflags" e "eip2" sono in pila per 
// effetto della chiamata di sistema
extern "C" void c_panic(cstr     msg,
		        natl	 eip1,
			natw	 cs,
			natl	 eflags,
			natl 	 eip2)
{
	des_proc* p = des_p(esecuzione->id);
	flog(LOG_ERR, "PANIC");
	flog(LOG_ERR, "%s", msg);
	if (p) {
		flog(LOG_ERR, "EAX=%x  EBX=%x  ECX=%x  EDX=%x",	
			 p->contesto[I_EAX], p->contesto[I_EBX],
			 p->contesto[I_ECX], p->contesto[I_EDX]);
		flog(LOG_ERR,  "ESI=%x  EDI=%x  EBP=%x  ESP=%x",	
			 p->contesto[I_ESI], p->contesto[I_EDI], p->contesto[I_EBP], p->contesto[I_ESP]);
		flog(LOG_ERR, "CS=%4x DS=%4x ES=%4x FS=%4x GS=%4x SS=%4x",
			cs, p->contesto[I_DS], p->contesto[I_ES],
			p->contesto[I_FS], p->contesto[I_GS], p->contesto[I_SS]);
		flog(LOG_ERR, "EIP=%x  EFLAGS=%x", eip2, eflags);
		flog(LOG_ERR, "BACKTRACE:");
		backtrace(0);

		flog(LOG_ERR, "processi utente: %d", processi - 1);
		for (natl id = 4*8; id < 8192; id += 8) {
			des_proc *p = des_p(id);
			if (p && p->cpl == LIV_UTENTE) {
				addr v_eip = (addr)((natl)fine_sistema_privato - 5 * sizeof(int));
				natl dp = get_despag(id, v_eip);
				natl ind_fis_pag = (natl)extr_IND_FISICO(dp);
				addr f_eip = (addr)(ind_fis_pag | ((natl)v_eip & 0x00000FFF));
				flog(LOG_ERR, "proc=%d EIP=%x", id, *(natl*)f_eip);
			}
		}
	}
	end_program();
}

extern "C" void c_nmi(natl eip1, natw cs, natl eflags)
{
	c_panic("INTERRUZIONE FORZATA", 0, cs, eflags, eip1);
}

// )
// ( [P_INIT]
bool carica_tutto(natl proc, natl i, natl n, addr& last_addr)
{
	addr dir = get_dir(proc);
	for (natl j = i; j < i + n && j < 1024; j++)
	{
		addr ind = (addr)(j * DIM_MACROPAGINA);
		natl dt = singolo_des(dir, j);
		if (extr_IND_MASSA(dt)) {	  
			des_pf* dpf_tabella = swap2(proc, TABELLA_CONDIVISA, ind, true);
			if (dpf_tabella == 0) {
				flog(LOG_ERR, "Impossibile allocare tabella residente");
				return false;
			}
			for (int k = 0; k < 1024; k++) {
				natl dp = singolo_des(indirizzo_pf(dpf_tabella), k);
				if (extr_IND_MASSA(dp)) {
					addr ind_virt = static_cast<natb*>(ind) + k * DIM_PAGINA;
					if (!swap2(proc, PAGINA_CONDIVISA, ind_virt, true)) {
						flog(LOG_ERR, "Impossibile allocare pagina residente");
						return false;
					}
					last_addr = static_cast<natb*>(ind_virt) + DIM_PAGINA;
				}
			}
		}
	}
	return true;
}

bool crea_spazio_condiviso(natl dummy_proc, addr& last_address)
{
	
	// ( lettura del direttorio principale dallo swap
	flog(LOG_INFO, "lettura del direttorio principale...");
	addr tmp = alloca(DIM_PAGINA);
	if (tmp == 0) {
		flog(LOG_ERR, "memoria insufficiente");
		return false;
	}
	if (!leggi_swap(tmp, swap_dev.sb.directory * 8, DIM_PAGINA))
		return false;
	// )

	// (  carichiamo le parti condivise nello spazio di indirizzamento del processo
	//    dummy (vedi [10.2])
	addr dummy_dir = get_dir(dummy_proc);
	copy_des(tmp, dummy_dir, i_io_condiviso, ntab_io_condiviso);
	copy_des(tmp, dummy_dir, i_utente_condiviso, ntab_utente_condiviso);
	dealloca(tmp);
	
	if (!carica_tutto(dummy_proc, i_io_condiviso, ntab_io_condiviso, last_address))
		return false;
	if (!carica_tutto(dummy_proc, i_utente_condiviso, ntab_utente_condiviso, last_address))
		return false;
	// )

	// ( copiamo i descrittori relativi allo spazio condiviso anche nel direttorio
	//   corrente, in modo che vengano ereditati dai processi che creeremo in seguito
	addr my_dir = get_dir(proc_corrente());
	copy_des(dummy_dir, my_dir, i_io_condiviso, ntab_io_condiviso);
	copy_des(dummy_dir, my_dir, i_utente_condiviso, ntab_utente_condiviso);
	// )

	invalida_TLB();
	return true;
}

// creazione del processo dummy iniziale (usata in fase di inizializzazione del sistema)
natl crea_dummy()
{
	proc_elem* di = crea_processo(dd, 0, DUMMY_PRIORITY, LIV_SISTEMA, true);
	if (di == 0) {
		flog(LOG_ERR, "Impossibile creare il processo dummy");
		return 0xFFFFFFFF;
	}
	inserimento_lista(pronti, di);
	processi++;
	return di->id;
}
void main_sistema(int n);
bool crea_main_sistema(natl dummy_proc)
{
	proc_elem* m = crea_processo(main_sistema, (int)dummy_proc, MAX_PRIORITY, LIV_SISTEMA, false);
	if (m == 0) {
		flog(LOG_ERR, "Impossibile creare il processo main_sistema");
	}
	inserimento_lista(pronti, m);
	processi++;
	return true;
}
// )
