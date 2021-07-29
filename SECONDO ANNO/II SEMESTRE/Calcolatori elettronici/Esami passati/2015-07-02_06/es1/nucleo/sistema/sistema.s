// sistema.s

#include "costanti.h"

//////////////////////////////////////////////////////////////////////////
// AVVIO                                                                //
//////////////////////////////////////////////////////////////////////////

.globl  _start, start
_start:				// entry point
start:
	// il boot loader ci ha passato in %rdi il puntatore alla struttura
	// multiboot_info. Questa, tra le altre cose, contiene l'indirizzo
	// dei moduli io e utente copiati in memoria dal bootloader stesso.
	// Salviamo temporaeamente l'indirizzo in pila per poi passarlo a
	// main.
	pushq %rdi
	// inizializziamo la IDT
	call init_idt
	// Il C++ prevede che si possa eseguire del codice prima di main (per
	// es. nei costruttori degli oggetti globali). gcc organizza questo
	// codice in una serie di funzioni di cui raccoglie i puntatori
	// nell'array __init_array_start. Il C++ run time deve poi chiamare
	// tutte queste funzioni prima di saltare a main.  Poiche' abbiamo
	// compilato il modulo con -nostdlib dobbiamo provvedere da soli a
	// chiamare queste funzioni, altrimenti gli oggetti globali non saranno
	// inizializzati correttamente.
	movabs $__init_array_start, %rbx
1:	cmpq $__init_array_end, %rbx
	je 2f
	call *(%rbx)
	addq $8, %rbx
	jmp 1b
	// il resto dell'inizializzazione e' scritto in C++
2:	popq %rdi
	call main
	// se arrivamo qui c'e' stato un errore, fermiamo la macchina
	hlt

//////////////////////////////////////////////////////////////////////////
// SALVATAGGIO/CARICAMENTO STATO PROCESSI                               //
//////////////////////////////////////////////////////////////////////////

// offset dei vari registri all'interno di des_proc
.set PUNT_NUCLEO, 8
.set CTX, 16
.set RAX, CTX+0
.set RCX, CTX+8
.set RDX, CTX+16
.set RBX, CTX+24
.set RSP, CTX+32
.set RBP, CTX+40
.set RSI, CTX+48
.set RDI, CTX+56
.set R8,  CTX+64
.set R9,  CTX+72
.set R10, CTX+80
.set R11, CTX+88
.set R12, CTX+96
.set R13, CTX+104
.set R14, CTX+112
.set R15, CTX+120
.set CR3, CTX+128

// copia lo stato dei registri generali nel des_proc del processo puntato da
// esecuzione.  Nessun registro viene sporcato.
salva_stato:
	// salviamo lo stato di un paio di registri in modo da poterli
	// temporaneamente riutilizzare. In particolare, useremo %rax come
	// registro di lavoro e %rbx come puntatore al des_proc.
	.cfi_startproc
	.cfi_def_cfa_offset 8
	pushq %rbx
	.cfi_adjust_cfa_offset 8
	.cfi_offset rbx, -16
	pushq %rax
	.cfi_adjust_cfa_offset 8
	.cfi_offset rax, -24

	movq esecuzione, %rbx

	// copiamo per primo il vecchio valore di %rax
	movq (%rsp), %rax
	movq %rax, RAX(%rbx)
	// usiamo %rax come appoggio per copiare il vecchio %rbx
	movq 8(%rsp), %rax
	movq %rax, RBX(%rbx)
	// copiamo gli altri registri
	movq %rcx, RCX(%rbx)
	movq %rdx, RDX(%rbx)
	// salviamo il valore che %rsp aveva prima della chiamata a salva stato
	// (valore corrente meno gli 8 byte che contengono l'indirizzo di
	// ritorno e i 16 byte dovuti alle due push che abbiamo fatto
	// all'inizio)
	movq %rsp, %rax
	addq $24, %rax
	movq %rax, RSP(%rbx)
	movq %rbp, RBP(%rbx)
	movq %rsi, RSI(%rbx)
	movq %rdi, RDI(%rbx)
	movq %r8,  R8 (%rbx)
	movq %r9,  R9 (%rbx)
	movq %r10, R10(%rbx)
	movq %r11, R11(%rbx)
	movq %r12, R12(%rbx)
	movq %r13, R13(%rbx)
	movq %r14, R14(%rbx)
	movq %r15, R15(%rbx)

	popq %rax
	.cfi_adjust_cfa_offset -8
	.cfi_restore rax
	popq %rbx
	.cfi_adjust_cfa_offset -8
	.cfi_restore rbx

	ret
	.cfi_endproc


// carica nei registri del processore lo stato contenuto nel des_proc del
// processo puntato da esecuzione.  Questa funzione sporca tutti i registri.
carica_stato:
	.cfi_startproc
	.cfi_def_cfa_offset 8
	movq esecuzione, %rbx

	popq %rcx   //ind di ritorno, va messo nella nuova pila
	.cfi_adjust_cfa_offset -8
	.cfi_register rip, rcx

	// nuovo valore per cr3
	movq CR3(%rbx), %r10
	movq %cr3, %rax
	cmpq %rax, %r10
	je 1f			// evitiamo di invalidare il TLB
				// se cr3 non cambia
	movq %r10, %rax
	movq %rax, %cr3		// il TLB viene invalidato
1:

	// anche se abbiamo cambiato cr3 siamo sicuri che l'esecuzione prosegue
	// da qui, perché ci troviamo dentro la finestra FM che è comune a
	// tutti i processi
	movq RSP(%rbx), %rsp    //cambiamo pila
	pushq %rcx              //rimettiamo l'indirizzo di ritorno
	.cfi_adjust_cfa_offset 8
	.cfi_offset rip, -8

	// se il processo precedente era terminato o abortito la sua pila
	// sistema non era stata distrutta, in modo da permettere a noi di
	// continuare ad usarla. Ora che abbiamo cambiato pila possiamo
	// disfarci della precedente.
	cmpq $0, ultimo_terminato
	je 1f
	call distruggi_pila_precedente
1:

	// aggiorniamo il puntatore alla pila sistema usata dal meccanismo
	// delle interruzioni
	movq PUNT_NUCLEO(%rbx), %rcx
	movq %rcx, tss_punt_nucleo

	movq RCX(%rbx), %rcx
	movq RDI(%rbx), %rdi
	movq RSI(%rbx), %rsi
	movq RBP(%rbx), %rbp
	movq RDX(%rbx), %rdx
	movq RAX(%rbx), %rax
	movq R8(%rbx), %r8
	movq R9(%rbx), %r9
	movq R10(%rbx), %r10
	movq R11(%rbx), %r11
	movq R12(%rbx), %r12
	movq R13(%rbx), %r13
	movq R14(%rbx), %r14
	movq R15(%rbx), %r15
	movq RBX(%rbx), %rbx


	retq
	.cfi_endproc

////////////////////////////////////////////////////////////////////////
//                 INIZIALIZZAZIONE IDT e GDT                         //
////////////////////////////////////////////////////////////////////////

// Carica un gate della IDT
// num: indice (a partire da 0) in IDT del gate da caricare
// routine: indirizzo della routine da associare al gate
// dpl: dpl del gate (LIV_SISTEMA o LIV_UTENTE)
// NOTA: la macro si limita a chiamare la routine init_gate
//       con gli stessi parametri. Verrà utilizzata per
//       motivi puramente estetici
.macro carica_gate num routine dpl

	movq $\num, %rdi
	movq $\routine, %rsi
	movq $\dpl, %rdx
	xorq %rcx, %rcx
	call init_gate
.endm


// carica la idt
// le prime 32 entrate sono definite dall'Intel e corrispondono
// alle possibili eccezioni.
.global init_idt
init_idt:
	//		indice		routine			dpl
	// gestori eccezioni:
	carica_gate	0 		divide_error 	LIV_SISTEMA
	carica_gate	1 		debug 		LIV_SISTEMA
	carica_gate	2 		nmi 		LIV_SISTEMA
	carica_gate	3 		breakpoint 	LIV_SISTEMA
	carica_gate	4 		overflow 	LIV_SISTEMA
	carica_gate	5 		bound_re 	LIV_SISTEMA
	carica_gate	6 		invalid_opcode	LIV_SISTEMA
	carica_gate	7 		dev_na 		LIV_SISTEMA
	carica_gate	8 		double_fault 	LIV_SISTEMA
	carica_gate	9 		coproc_so 	LIV_SISTEMA
	carica_gate	10 		invalid_tss 	LIV_SISTEMA
	carica_gate	11 		segm_fault 	LIV_SISTEMA
	carica_gate	12 		stack_fault 	LIV_SISTEMA
	carica_gate	13 		prot_fault 	LIV_SISTEMA
	carica_gate	14 		page_fault 	LIV_SISTEMA
	// il tipo 15 è riservato
	carica_gate	16 		fp_exc 		LIV_SISTEMA
	carica_gate	17 		ac_exc 		LIV_SISTEMA
	carica_gate	18 		mc_exc 		LIV_SISTEMA
	carica_gate	19 		simd_exc 	LIV_SISTEMA
	carica_gate	20		virt_exc	LIV_SISTEMA
	// tipi 21-29 riservati
	carica_gate	30		sec_exc		LIV_SISTEMA
	// tipo 31 riservato

	//primitive comuni (tipi 0x2-)
	carica_gate	TIPO_A		a_activate_p	LIV_UTENTE
	carica_gate	TIPO_T		a_terminate_p	LIV_UTENTE
	carica_gate	TIPO_SI		a_sem_ini	LIV_UTENTE
	carica_gate	TIPO_W		a_sem_wait	LIV_UTENTE
	carica_gate	TIPO_S		a_sem_signal	LIV_UTENTE
	carica_gate	TIPO_D		a_delay		LIV_UTENTE
	carica_gate	TIPO_L		a_log		LIV_UTENTE
	carica_gate	TIPO_GMI	a_getmeminfo	LIV_UTENTE
// ( ESAME 2015-07-02
	carica_gate	TIPO_SC		a_shmem_create	LIV_UTENTE
//   ESAME 2015-07-02 )
// ( SOLUZIONE 2015-07-02
	carica_gate	TIPO_SA		a_shmem_attach	LIV_UTENTE
//   SOLUZIONE 2015-07-02 )

	// primitive per il livello I/O (tipi 0x3-) 
	carica_gate	TIPO_APE	a_activate_pe	LIV_SISTEMA
	carica_gate	TIPO_WFI	a_wfi		LIV_SISTEMA
	carica_gate	TIPO_FG		a_fill_gate	LIV_SISTEMA
	carica_gate	TIPO_AB		a_abort_p	LIV_SISTEMA
	carica_gate	TIPO_IOP	a_io_panic	LIV_SISTEMA
	carica_gate	TIPO_TRA	a_trasforma	LIV_SISTEMA
	carica_gate	TIPO_ACC	a_access	LIV_SISTEMA

	// i tipi 0x4- verranno usati per le primitive fornite dal modulo I/O
	// (si veda fill_io_gates() in io.s)

	// i tipi da 0x50 a 0xFE verrano usati per gli handler
	// (si veda load_handler() più avanti)

	// la priorità massima è riservata al driver del timer di sistema
	carica_gate	TIPO_TIMER	driver_td	LIV_SISTEMA

	lidt idt_pointer
	ret

// carica un gate nella IDT
// parametri: (vedere la macro carica_gate)
init_gate: //rdi = indice nella idt; rsi = offset della routine; rdx = dpl, rcx = trap se non zero
	movq $idt, %r11
	movq %rsi, %rax			// offset della routine

	shlq $4, %rdi			//indice moltiplicato la grandezza del gate (16)

	// verifichiamo che il gate non sia già in uso
	cmpw $0, 2(%r11, %rdi)
	je 1f
	xorq %rax, %rax
	ret

1:	movw %ax, (%r11, %rdi)  	// primi 16 bit dell'offset
	movw $SEL_CODICE_SISTEMA, 2(%r11, %rdi)

	movw $0, %ax
	movb $0b10001110, %ah 	        // byte di accesso (presente, 32bit)
	cmpq $0, %rcx
	je 2f
	orb  $0b00000001, %ah		// trap
2:	movb %dl, %al			// DPL
	shlb $5, %al			// posizione del DPL nel byte di accesso
	orb  %al, %ah			// byte di accesso con DPL in %ah
	movb $0, %al			// la parte bassa deve essere 0
	movl %eax, 4(%r11, %rdi)	// 16 bit piu' sign. dell'offset
					// e byte di accesso
	shrq $32, %rax			// estensione a 64 bit dell'offset
	movl %eax, 8(%r11,%rdi)
	movl $0, 12(%r11,%rdi) 		// riservato

	movq $1, %rax
	ret

// inizializza la GDT.
// Lo scopo princiale è quello di eseguire l'istruzione lgdt con l' indirizzo
// della gdt, in modo da caricare il registro gdtr.  Dobbiamo però anche
// inizializzare l'entrata tss_seg della GDT, che non è possibile inizializzare
// staticamente per via delle complesse operazioni che dobbiamo eseguire sul
// puntatore tss.
	.global init_gdt
init_gdt:
	.cfi_startproc

	// inizializziamo il tss_seg
	movq $tss_seg, %rdx
	movw $(tss_end - tss - 1), (%rdx) 	//[15:0] = limit[15:0]
	movq $tss, %rax
	movw %ax, 2(%rdx)	//[31:16] = base[15:0]
	shrq $16,%rax
	movb %al, 4(%rdx)	//[39:32] = base[24:16]
	movb $0b10001001, 5(%rdx)	//[47:40] = p_dpl_type
	movb $0, 6(%rdx)	//[55:48] = 0
	movb %ah, 7(%rdx)	//[63:56] = base[31:24]
	shrq $16, %rax
	movl %eax, 8(%rdx) 	//[95:64] = base[63:32]
	movl $0, 12(%rdx)	//[127:96] = 0

	lgdt gdt_pointer
	movw $(tss_seg - gdt), %cx
	ltr %cx

	retq
	.cfi_endproc

////////////////////////////////////////////////////////
// a_primitive                                        //
////////////////////////////////////////////////////////
        .extern c_activate_p
a_activate_p:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
        call c_activate_p
	call carica_stato
        iretq
	.cfi_endproc

        .extern c_terminate_p
a_terminate_p:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
        call c_terminate_p
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_sem_ini
a_sem_ini:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_sem_ini
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_sem_wait
a_sem_wait:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_sem_wait
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_sem_signal
a_sem_signal:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_sem_signal
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_delay
a_delay:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_delay
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_log
a_log:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_log
	call carica_stato
	iretq
	.cfi_endproc

a_getmeminfo:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_getmeminfo
	iretq
	.cfi_endproc
// ( ESAME 2015-07-02

a_shmem_create:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_shmem_create
	call carica_stato
	iretq
	.cfi_endproc
//   ESAME 2015-07-02 )
// ( SOLUZIONE 2015-07-02
a_shmem_attach:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_shmem_attach
	call carica_stato
	iretq
	.cfi_endproc
//   SOLUZIONE 2015-07-02 )

//
// Interfaccia offerta al modulo di IO, inaccessibile dal livello utente
//

	.extern c_activate_pe
a_activate_pe:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
        call c_activate_pe
	iretq
	.cfi_endproc

a_wfi:	
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call apic_send_EOI
	call schedulatore
	call carica_stato
	iretq
	.cfi_endproc

a_fill_gate:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	// controlliamo che il tipo sia 0x4-
	movq %rdi, %rax
	andq $0xF0, %rax
	cmpq $0x40, %rax
	je 1f
	xorq %rax, %rax
	jmp 2f
1:	movq $1, %rcx	// forza tipo trap
	call init_gate
2:	iretq
	.cfi_endproc

	.extern c_abort_p
a_abort_p:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
        call c_abort_p
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_io_panic
a_io_panic:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
        call c_io_panic
	call carica_stato
	iretq
	.cfi_endproc

	.extern c_trasforma
a_trasforma:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_trasforma
	iretq
	.cfi_endproc

	.extern c_access
a_access:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_access
	iretq
	.cfi_endproc

////////////////////////////////////////////////////////////////
// gestori delle eccezioni				      //
////////////////////////////////////////////////////////////////
// Gestiamo tutte le eccezioni (tranne nmi) nello stesso modo: inviamo un
// messaggio al log e terminiamo forzatamente il processo che ha causato
// l'eccezione. Per questo motivo, ogni gestore chiama la funzione
// gestore_eccezioni() (definita in sistema.cpp), passandole il numero
// corrispondente al suo tipo di eccezione (primo argomento) e il %rip che si
// trova in cima alla pila (terzo argomento). Quest'ultimo da indicazioni sul
// punto del programma che ha causato l'eccezione.
//
// Il secondo parametro passato a gestore_eccezioni richiede qualche
// spiegazione in più.  Alcune eccezioni lasciano in pila un'ulteriore parola
// quadrupla, il cui significato dipende dal tipo di eccezione.  Per avere la
// pila sistema in uno stato uniforme prima di chiamare salva_stato, estraiamo
// questa ulteriore parola quadrupla copiandola nella variable global
// exc_error. Il contenuto di exc_error viene poi passato come secondo
// parametro di gestore_eccezioni.  Le eccezioni che non prevedono questa
// ulteriore parola quadrupla si limitano a passare 0. L'uso della variabile
// global exc_error non causa problemi, perché le eccezioni sono disabilitate.
//
divide_error:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $0, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

debug:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $1, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

nmi:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	// gestiamo nmi (non-maskable-interrupt) in modo speciale.  La funzione
	// c_nmi chiamerà panic(), la quale stampa un po' di informazioni sullo
	// stato del sistema e spegne la macchina.
	call c_nmi
	call carica_stato
	iretq
	.cfi_endproc

breakpoint:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $3, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

overflow:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $4, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

bound_re:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $5, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

invalid_opcode:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $6, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

dev_na:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $7, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

double_fault:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	popq exc_error
	call salva_stato
	movq $8, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

coproc_so:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $9, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

invalid_tss:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	pop exc_error
	.cfi_adjust_cfa_offset -8
	call salva_stato
	movq $10, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

segm_fault:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	pop exc_error
	.cfi_adjust_cfa_offset -8
	call salva_stato
	movq $11, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

stack_fault:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	pop exc_error
	.cfi_adjust_cfa_offset -8
	call salva_stato
	movq $12, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

prot_fault:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	pop exc_error
	.cfi_adjust_cfa_offset -8
	call salva_stato
	movq $13, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

page_fault:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	pop exc_error
	.cfi_adjust_cfa_offset -8
	call salva_stato
	movq $14, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

fp_exc:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $16, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

ac_exc:
	.cfi_startproc
	.cfi_def_cfa_offset 48
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	pop exc_error
	.cfi_adjust_cfa_offset -8
	call salva_stato
	movq $13, %rdi
	movq exc_error, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

mc_exc:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $18, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

simd_exc:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $19, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

virt_exc:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $20, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

sec_exc:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	movq $31, %rdi
	movq $0, %rsi
	movq (%rsp), %rdx
	call gestore_eccezioni
	call carica_stato
	iretq
	.cfi_endproc

////////////////////////////////////////////////////////
// handler/driver                                     //
////////////////////////////////////////////////////////

// driver del timer
	.extern c_driver_td
driver_td:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call c_driver_td
	call apic_send_EOI
	call carica_stato

	iretq
	.cfi_endproc

// predisponioamo tutti i possibili handler, ma non li inseriamo ancora nella
// IDT perché non sappiamo la priorità.  Sarà la activate_pe() a predisporre
// opportunamente i gate della IDT invocando la funzione load_handler()
// definita più avanti.

handler_0:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $0, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_1:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $1, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_2:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $2, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_3:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $3, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_4:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $4, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_5:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $5, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_6:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $6, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_7:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $7, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_8:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $8, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_9:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $9, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_10:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $10, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_11:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $11, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_12:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $12, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_13:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $13, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_14:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $14, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_15:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $15, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_16:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $16, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_17:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $17, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_18:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $18, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_19:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $19, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_20:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $20, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_21:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $21, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_22:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $22, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_23:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $23, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

handler_24:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call salva_stato
	call inspronti

	movq $24, %rcx
	movq a_p(, %rcx, 8), %rax
	movq %rax, esecuzione

	call carica_stato
	iretq
	.cfi_endproc

	.global load_handler
	// La funzione si aspetta un <tipo> in %rdi e un <irq> in %rsi.
	// Provvede quindi a caricare il gate <tipo> della ITD in modo che
	// punti a handler_<irq>.
load_handler:
	.cfi_startproc
	movq %rsi, %rax
	// visto che gli handler sono tutti della stessa dimensione,
	// calcoliamo l'indirizzo dell'handler che ci interessa usando
	// la formula
	//
	//	handler_0 + <dim_handler> * <irq>
	//
	// dove <dim_handler> si può ottenere sottraendo gli indirizzi
	// di due handler consecutivi qualunque.
	movq $(handler_1 - handler_0), %rcx
	mulq %rcx
	movq $handler_0, %rsi
	addq %rax, %rsi
	// ora %rsi contiene l'indirizzo dell'handler, mentre %rdi
	// contiene ancora il tipo
	movq $LIV_SISTEMA, %rdx
	xorq %rcx, %rcx	// tipo interrupt
	call init_gate
	ret
	.cfi_endproc

//////////////////////////////////////////////////////////
// primitive richiamate dal nucleo stesso	        //
//////////////////////////////////////////////////////////
	.global sem_ini
sem_ini:
	.cfi_startproc
	int $TIPO_SI
	ret
	.cfi_endproc

	.global sem_wait
sem_wait:
	.cfi_startproc
	int $TIPO_W
	ret
	.cfi_endproc

	.global activate_p
activate_p:
	.cfi_startproc
	int $TIPO_A
	ret
	.cfi_endproc

	.global terminate_p
terminate_p:
	.cfi_startproc
	int $TIPO_T
	ret
	.cfi_endproc

	.global salta_a_main
salta_a_main:
	.cfi_startproc
	call carica_stato		// carichiamo, in particolare, tss_punt_nucleo
	iretq				// torniamo al chiamante "trasformati" in processo
	.cfi_endproc

// setup_self_dump: chiamata da panic.  Il backtrace parte normalmente
// dall'ultimo stato salvato di ogni processo, ma per il processo corrente
// vorremmo farla partire dallo stato attuale del processore, in modo da
// conoscere il motivo per cui è stata invocata panic(). La funzione self_dump
// modifica la pila sistema in modo che si trovi in uno stato simile a quello
// successivo ad una interruzione e chiama salva stato per aggiornare il
// descrittore di processo con lo stato attuale del processore. In questo modo
// il bactrace del processo corrente partirà dalla funzione panic() stessa,
// passando poi al suo chiamante e così via.
	.global setup_self_dump
setup_self_dump:
	.cfi_startproc
	// otteniamo il %rip e l'%rsp che vogliamo var apparire nelle 5 parole
	// lunghe che simulano quelle salvata da una interruzione
	popq %rax		// %rip salvato
	.cfi_def_cfa_offset 0
	.cfi_register rip, rax
	movq %rsp, %rcx		// %rsp del chiamante
	.cfi_def_cfa_register rcx
	// ora li copiamo in pila nelle rispettive posizioni
	// (le altre 3 parole lunghe non ci interessano)
	subq $8, %rsp
	pushq %rcx		// salviamo %rsp
	subq $16, %rsp
	pushq %rax		// salviamo %rip
	// per completare l'interruzione simulata, chiamiamo salva_stato
	// (importante soprattutto per salvare il valore corrente di %rbp)
	call salva_stato
	// salva_stato non modifica nessun registro, quindi %rax contiene
	// ancora il %rip salvato. Lo rimettiamo in pila e torniamo al
	// chiamante
	pushq %rax
	ret
	.cfi_endproc

// cleanup_self_dump: ripulisce la pila da quando vi aveva inserito
// la setup_self_dump, in modo che sia possibile proseguire con la
// normale esecuzione, nel caso process_dump() fosse stata chiamata
// da c_abort_p() e non da panic().
	.global cleanup_self_dump
cleanup_self_dump:
	popq %rax
	addq $40, %rsp
	pushq %rax
	ret

	.global end_program
end_program:
       lidt triple_fault_idt
       int $1

////////////////////////////////////////////////////////////////
// sezione dati: tabelle e stack			      //
////////////////////////////////////////////////////////////////
.data
	// puntatori alle tabelle GDT e IDT
	// nel formato richiesto dalle istruzioni LGDT e LIDT
gdt_pointer:
	.word end_gdt-gdt		// limite della GDT
	.quad gdt			// base della GDT
idt_pointer:
	.word 0xFFF			// limite della IDT (256 entrate)
	.quad idt			// base della IDT
triple_fault_idt:
	.word 0
	.quad 0

.balign 8
.global gdt
gdt:
	.quad 0		    //segmento nullo
code_sys_seg:
	.word 0b0           //limit[15:0]   not used
	.word 0b0           //base[15:0]    not used
	.byte 0b0           //base[23:16]   not used
	.byte 0b10011010    //P|DPL|1|1|C|R|A|  DPL=00=sistema
	.byte 0b00100000    //G|D|L|-|-------|  L=1 long mode
	.byte 0b0           //base[31:24]   not used
code_usr_seg:
	.word 0b0           //limit[15:0]   not used
	.word 0b0           //base[15:0]    not used
	.byte 0b0           //base[23:16]   not used
	.byte 0b11111010    //P|DPL|1|1|C|R|A|  DPL=11=utente
	.byte 0b00100000    //G|D|L|-|-------|  L=1 long mode
	.byte 0b0           //base[31:24]   not used
data_usr_seg:
	.word 0b0           //limit[15:0]   not used
	.word 0b0           //base[15:0]    not used
	.byte 0b0           //base[23:16]   not used
	.byte 0b11110010    //P|DPL|1|0|E|W|A|  DPL=11=utente
	.byte 0b00000000    //G|D|-|-|-------|
	.byte 0b0           //base[31:24]   not used
tss_seg:
	.space 16, 0	    // riempito da init_gdt
end_gdt:

tss:
	.long 0
	.global tss_punt_nucleo
tss_punt_nucleo:
	.quad 0
	.space 11 * 8, 0
	.word 0
	.word tss_end - tss - 1
tss_end:

.bss
.balign 16
idt:
	// spazio per 256 gate
	// verra' riempita a tempo di esecuzione
	.space 16 * 256, 0
end_idt:

exc_error:
	.space 8, 0
