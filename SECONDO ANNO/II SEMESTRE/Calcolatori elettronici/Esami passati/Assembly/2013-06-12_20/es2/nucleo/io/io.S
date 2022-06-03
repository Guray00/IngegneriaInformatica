#define ASM 1
#include "costanti.h"

////////////////////////////////////////////////////////////////////////////////
//                                 COSTANTI                                   //
////////////////////////////////////////////////////////////////////////////////

// Tipi delle interruzioni delle chiamate di sistema usate
// Devono coincidere con quelli usati in sistema.s e utente.s
//
.set tipo_a,  TIPO_A
.set tipo_t,  TIPO_T
.set tipo_si, TIPO_SI
.set tipo_w,  TIPO_W
.set tipo_s,  TIPO_S
.set tipo_nd, TIPO_ND
.set tipo_d,  TIPO_D
.set tipo_l,  TIPO_L

// Tipi delle interruzioni usate per interfacciarsi al modulo
//  sistema
// Devono coincidere con quelli usati in sistema.s
//
.set tipo_ape,  TIPO_APE
.set tipo_wfi, TIPO_WFI
.set tipo_va,   TIPO_VA
.set tipo_p,    TIPO_P
.set tipo_ab,   TIPO_AB
.set tipo_fg,   TIPO_FG
.set tipo_rl,   TIPO_RL
.set tipo_tra,  TIPO_TRA
.set tipo_pcif, TIPO_PCIF
.set tipo_pcir, TIPO_PCIR
.set tipo_pciw, TIPO_PCIW


// Tipi delle interruzioni usate dalle primitive di IO
// Devono coincidere con quelli usati in utente.s
//
.set io_tipo_rsen,   IO_TIPO_RSEN
.set io_tipo_rseln,  IO_TIPO_RSELN
.set io_tipo_wsen,   IO_TIPO_WSEN
.set io_tipo_wse0,   IO_TIPO_WSE0
.set io_tipo_rcon,   IO_TIPO_RCON		
.set io_tipo_wcon,   IO_TIPO_WCON		
.set io_tipo_inic,   IO_TIPO_INIC
.set io_tipo_hdr,    IO_TIPO_HDR
.set io_tipo_hdw,    IO_TIPO_HDW
.set io_tipo_dmahdr, IO_TIPO_DMAHDR
.set io_tipo_dmahdw, IO_TIPO_DMAHDW


////////////////////////////////////////////////////////////////////////////////
//                  MACRO PER LA MANIPOLAZIONE DEI PARAMETRI                  //
////////////////////////////////////////////////////////////////////////////////

// Copia dei parametri di una chiamata di sistema dalla pila utente
//  alla pila sistema
.macro copia_param n_long offset
        movl $\offset, %ecx
        movl 4(%esp, %ecx, 4), %eax     // cs in eax
        testl $3, %eax			// verifica del livello di privilegio
					//  del chiamante
        jz 1f                           // copia da pila sistema

        movl 12(%esp, %ecx, 4), %eax    // vecchio esp (della pila utente)
					//  in eax
        leal 4(%eax), %esi		// indirizzo del primo parametro in
					//  esi
        jmp 2f
1:
        leal 16(%esp, %ecx, 4), %esi	// indirizzo del primo parametro in esi
2:
        movl $\n_long, %eax		// creazione in pila dello spazio per
        shll $2, %eax			//  la copia dei parametri
        subl %eax, %esp
        leal (%esp), %edi		// indirizzo della destinazione del
					//  primo parametro in edi

        movl $\n_long, %ecx
        cld
        rep
           movsl			// copia dei parametri
.endm

// Salvataggio dei registri in pila
.macro salva_registri
	pushl %eax
	pushl %ecx
	pushl %edx
	pushl %ebx
	pushl %esi
	pushl %edi
	pushl %ebp
.endm

// Caricamento dei registri dalla pila (duale rispetto a salva_registri)
.macro carica_registri
	popl %ebp
	popl %edi
	popl %esi
	popl %ebx
	popl %edx
	popl %ecx
	popl %eax
.endm

// salvataggio dei registri in pila per chiamate di sistema che ritornano
//  un valore in eax, che non viene salvato
.macro salva_reg_rit

	pushl %ecx
	pushl %edx
	pushl %ebx
	pushl %esi
	pushl %edi
	pushl %ebp

.endm


// ripristino dei registri (tutti meno eax) dalla pila (duale rispetto a
//  salva_reg_rit)
.macro carica_reg_rit

	popl %ebp
	popl %edi
	popl %esi
	popl %ebx
	popl %edx
	popl %ecx

.endm

// Chiama fill_gate con i parametri specificati
.macro fill_io_gate gate off
	pushl $LIV_UTENTE
	pushl $\off
	pushl $\gate
	call fill_gate
	addl $12, %esp
.endm

.macro check_cavallo
	testl $0x80000000, %eax
	jnz 1f
	pushl %eax
	pushl $param_err
	pushl $2
	call flog
	addl $12, %esp
	int $tipo_ab
1:

.endm

.macro cavallo_di_troia offset

	movl (\offset * 4) (%esp), %eax
	check_cavallo
.endm

.macro cavallo_di_troia2 offset1 offset2

	movl (\offset1 * 4) (%esp), %eax
	addl (\offset2 * 4) (%esp), %eax
	decl %eax
	check_cavallo
.endm

.macro cavallo_di_troia3 offset1 offset2

	movl (\offset1 * 4) (%esp), %eax
	movl (\offset2 * 4) (%esp), %ebx
	addl (%ebx), %eax
	decl %eax
	check_cavallo
.endm

.global _start, start
_start:
start:	jmp cmain

////////////////////////////////////////////////////////////////////////////////
//                             SEZIONE DATI                                   //
////////////////////////////////////////////////////////////////////////////////

	.data

param_err:
	.asciz "parametro errato %x"

// Descrittori delle interfacce seriali
	.global com		// non comi, como
com:	.word	0x03f8		// com[0].indreg.iRBR
	.word	0x03f8		// com[0].indreg.iTHR
	.word	0x03fd		// com[0].indreg.iLSR
	.word	0x03f9		// com[0].indreg.iIER
	.word	0x03fa		// com[0].indreg.iIIR
	.word   0		// padding
	.long	0		// com[0].mutex
	.long	0		// com[0].sincr
	.long	0		// com[0].cont
	.long	0		// com[0].punt
	.long	0		// com[0].funzione
	.long	0		// com[0].stato
	.word	0x02f8		// com[1].indreg.iRBR
	.word	0x02f8		// com[1].indreg.iTHR
	.word	0x03fd		// com[1].indreg.iLSR
	.word	0x02f9		// com[1].indreg.iIER
	.word	0x02fa		// com[1].indreg.iIIR
	.word   0		// padding
	.long	0		// com[1].mutex
	.long	0		// com[1].sincr
	.long	0		// com[1].cont
	.long	0		// com[1].punt
	.long	0		// com[1].funzione
	.long	0		// com[1].stato

// descrittore console
	.global console	// [9.5]
console:
	.long	0		// mutex
	.long	0		// sincr
	// descrittore tastiera
	.word	0x60		// kbd.indreg.iRBR
	.word	0x60		// kbd.indreg.iTBR
	.word	0x64		// kbd.indreg.iCMR
	.word	0x64		// kbd.indreg.iSTR
	.long	0		// kbd.punt
	.long   0		// kbd.cont
	.byte	0		// kbd.shift
	// tab
	.byte	0x10, 0x11, 0x12
	.byte   0x13, 0x14, 0x15, 0x16
	.byte   0x17, 0x18, 0x19, 0x1E 
	.byte   0x1F, 0x20, 0x21, 0x22
	.byte   0x23, 0x24, 0x25, 0x26
	.byte	0x2C, 0x2D, 0x2E, 0x2F
	.byte   0x30, 0x31, 0x32, 0x39
	.byte   0x1C, 0x0e, 0x01
	// tabmin
        .byte  'q'
	.byte  'w', 'e', 'r', 't'
	.byte  'y', 'u', 'i', 'o'
	.byte  'p', 'a', 's', 'd'
	.byte  'f', 'g', 'h', 'j'
	.byte  'k', 'l', 'z', 'x'
	.byte  'c', 'v', 'b', 'n'
	.byte  'm', ' ', '\n', '\b'
	.byte  0x1B
	// tabmai
        .byte  'Q', 'W', 'E'
	.byte  'R', 'T', 'Y', 'U'
	.byte  'I', 'O', 'P', 'A'
	.byte  'S', 'D', 'F', 'G'
	.byte  'H', 'J', 'K', 'L'
        .byte  'Z', 'X', 'C', 'V'
	.byte  'B', 'N', 'M', ' '
	.byte  '\r', '\b', 0x1B
	.byte  0	// allineamento
	// Descrittore del video
	.word	0x03D4		// vid.indreg.iIND
	.word	0x03D5		// vid.indreg.iDAT
	.long	0xB8000 	// vid.video
	.long	0		// vid.x
	.long   0		// vid.y
	.word   0x4B00		// vid.attr
	.word	0		// allineamento

	.global hd
hd:
	.word	0x0170		//hd.indreg.iBR
	.word	0x0174		//hd.indreg.iCNL
	.word	0x0175		//hd.indreg.iCNH
	.word	0x0173		//hd.indreg.iSNR
	.word	0x0176		//hd.indreg.iHND
	.word 	0x0172		//hd.indreg.iSCR
	.word	0x0171		//hd.indreg.iERR
	.word	0x0177		//hd.indreg.iCMD
	.word	0x0177		//hd.indreg.iSTS
	.word	0x0376		//hd.indreg.iDCR
	.word	0x0376		//hd.indreg.iASR
	.word	0		//hd.bus_master.iCMD
	.word	0		//hd.bus_master.iSTATUS
	.word	0		//hd.bus_master.iDPTR
	.space  8*2, 0		//hd.prd
	.long	0		//hd.comando
	.byte	0		//hd.errore
	.space  3, 0		//padding
	.long	0		//hd.mutex
	.long	0		//hd.sincr
	.byte	0		//hd.cont
	.space	3, 0		//padding
	.long	0		//hd.punt


////////////////////////////////////////////////////////////////////////////////
//                          CHIAMATE DI SISTEMA                               //
////////////////////////////////////////////////////////////////////////////////

	.text
	.global activate_p
activate_p:
	int $tipo_a
	ret

	.global terminate_p // [7.1]
terminate_p:
	int $tipo_t
	ret

	.global sem_ini
sem_ini:
	int $tipo_si
	ret

	.global sem_wait	// [7.1]
sem_wait:
	int $tipo_w
	ret

	.global sem_signal	// [7.1]
sem_signal:
	int $tipo_s
	ret

	.global trasforma
trasforma:
	int $tipo_tra
	ret

////////////////////////////////////////////////////////////////////////////////
//                     INTERFACCIA VERSO IL MODULO SISTEMA                    //
////////////////////////////////////////////////////////////////////////////////

	.global activate_pe
activate_pe:	// [7.1]
	int $tipo_ape
	ret

	.global wfi	// [9.1]
wfi:
	int $tipo_wfi
	ret

	.global panic
panic:
	int $tipo_p
	ret

	.global abort_p
abort_p:
	int $tipo_ab
	ret

	.global fill_gate
fill_gate:
	int $tipo_fg
	ret

	.global delay
delay:
	int $tipo_d
	ret

	.global log
log:
	int $tipo_l
	ret

	.global pci_find
pci_find:
	int $tipo_pcif
	ret

	.global pci_read
pci_read:
	int $tipo_pcir
	ret

	.global pci_write
pci_write:
	int $tipo_pciw
	ret

	.global writevid
writevid:
	int $io_tipo_wcon
	ret

////////////////////////////////////////////////////////////////////////////////
//                         FUNZIONI DI SUPPORTO                               //
////////////////////////////////////////////////////////////////////////////////

// Ingresso di un byte da una porta di IO
	.global inputb
inputb:
	pushl %eax
	pushl %edx
	movl 12(%esp), %edx
	inb %dx, %al
	movl 16(%esp), %edx
	movb %al, (%edx)
	popl %edx
	popl %eax
	ret

// Uscita di un byte su una porta di IO
	.global outputb
outputb:
	pushl %eax
	pushl %edx
	movb 12(%esp), %al
	movl 16(%esp), %edx
	outb %al, %dx
	popl %edx
	popl %eax
	ret

// Ingresso di una word da una porta di IO
	.global inputw
inputw:
	pushl %eax
	pushl %edx
	movl 12(%esp), %edx
	inw %dx, %ax
	movl 16(%esp), %edx
	movw %ax, (%edx)
	popl %edx
	popl %eax
	ret

// Uscita di una word su una porta di IO
	.global outputw
outputw:
	pushl %eax
	pushl %edx
	movw 12(%esp), %ax
	movl 16(%esp), %edx
	outw %ax, %dx
	popl %edx
	popl %eax
	ret

// Ingresso di una parola lunga da una porta di IO
	.global inputl
inputl:
	pushl %eax
	pushl %edx
	movl 12(%esp), %edx
	inl %dx, %eax
	movl 16(%esp), %edx
	movl %eax, (%edx)
	popl %edx
	popl %eax
	ret

// Uscita di una word su una porta di IO
	.global outputl
outputl:
	pushl %eax
	pushl %edx
	movl 12(%esp), %eax
	movl 16(%esp), %edx
	outl %eax, %dx
	popl %edx
	popl %eax
	ret

// Ingresso di un buffer continuo da un buffer di IO di word
	.global inputbw
inputbw:
	pushl %eax
	pushl %edx
	pushl %edi
	pushl %ecx
	
	movl 20(%esp), %edx
	movl 24(%esp), %edi
	movl 28(%esp),%ecx
	cld
	rep
	insw
	
	popl %ecx
	popl %edi
	popl %edx
	popl %eax
	ret

// Uscita di un buffer continuo su una buffer di IO di word
	.global outputbw
outputbw:
	pushl %eax
	pushl %edx
	pushl %esi
	pushl %ecx
	
	movl 28(%esp), %edx
	movl 20(%esp), %esi
	movl 24(%esp),%ecx
	cld
	rep
	outsw
	
	popl %ecx
	popl %esi
	popl %edx
	popl %eax
	ret

// Inizio dell' ingresso da una interfaccia seriale
	.global go_inputse
go_inputse:
	pushl %eax
	pushl %edx

	movl 12(%esp), %edx		// ind. di IER in edx
	inb %dx, %al
	orb $0x01, %al			// abilitazione dell' interfaccia a
					//  generare interruzioni in ingresso
	outb %al, %dx

	popl %edx
	popl %eax
	ret

// Fine dell' ingresso da un' interfaccia seriale
	.global halt_inputse
halt_inputse:
	pushl %eax
	pushl %edx

	movl 12(%esp), %edx		// ind. di IER in edx
	inb %dx, %al
	and $0xfe, %al
	outb %al, %dx			// disabilitazione della generazione
					//  di interruzioni
	popl %edx
	popl %eax
	ret

// Inizio dell' uscita su interfaccia seriale
	.global go_outputse
go_outputse:
	pushl %eax
	pushl %edx

	movl 12(%esp), %edx		// ind. di IER in edx
	inb %dx, %al
	orb $0x02, %al
	outb %al, %dx

	popl %edx
	popl %eax
	ret

// Fine dell' uscita su interfaccia seriale
	.global halt_outputse
halt_outputse:
	pushl %eax
	pushl %edx

	movl 12(%esp), %edx		// ind. di IER in edx
	inb %dx, %al
	and $0xfd, %al
	outb %al, %dx

	popl %edx
	popl %eax
	ret

// Indirizzi delle porte delle interfacce seriali
.set LCR1, 0x03fb
.set LCR2, 0x02fb
.set DLR_LSB1, 0x03f8
.set DLR_LSB2, 0x02f8
.set DLR_MSB1, 0x03f9
.set DLR_MSB2, 0x02f9
.set IER1, 0x03f9
.set IER2, 0x02f9
.set RBR1, 0x03f8
.set RBR2, 0x02f8
.set MCR1, 0x03fc
.set MCR2, 0x02fc


// Inizializzazione delle interfacce seriali
	.global com_setup
com_setup:
	pushl %eax
	pushl %edx

	movb $0x80, %al
	movw $LCR1, %dx
	outb %al, %dx
	movw $0x000c, %ax
	movw $DLR_LSB1, %dx
	outb %al, %dx
	movb %ah, %al
	movw $DLR_MSB1, %dx
	outb %al, %dx
	movb $0x03, %al
	movw $LCR1, %dx
	outb %al, %dx
	movb $0x00, %al
	movw $IER1, %dx
	outb %al, %dx
	movw $RBR1, %dx
	movw $MCR1, %dx			// abilitazione porta 3-state
	movb $0b00001000, %al
	outb %al, %dx
	inb %dx, %al

	movb $0x80, %al
	movw $LCR2, %dx
	outb %al, %dx
	movw $0x000c, %ax
	movw $DLR_LSB2, %dx
	outb %al, %dx
	movb %ah, %al
	movw $DLR_MSB2, %dx
	outb %al, %dx
	movb $0x03, %al
	movw $LCR2, %dx
	outb %al, %dx
	movb $0x00, %al
	movw $IER2, %dx
	outb %al, %dx
	movw $RBR2, %dx
	movw $MCR2, %dx
	movb $0b00001000, %al
	outb %al, %dx

	inb %dx, %al

	popl %edx
	popl %eax

	ret

.set KBD_WCB,	0x60
.set KBD_RCB,	0x20

.macro wait_kbd_out
1:	inb $0x64, %al	  // leggi stato
	testb $0x02, %al  // busy?
	jnz 1b
.endm

	.global go_inputkbd
go_inputkbd:
	pushl %ebp
	movl %esp, %ebp
	pushl %eax

	movw 12(%ebp), %dx
	movb $KBD_WCB, %al
	outb %al, %dx
	movw 8(%ebp), %dx
	movb $0x61, %al
	outb %al, %dx
	movw 12(%ebp), %dx
1:	inb %dx, %al	
	testb $0x02, %al
	jnz 1b

	popl %eax
	leave
	ret
	
	
	ret

	.global halt_inputkbd
halt_inputkbd:
	pushl %ebp
	movl %esp, %ebp
	pushl %eax

	movw 12(%ebp), %dx
	movb $KBD_WCB, %al
	outb %al, %dx
	movw 8(%ebp), %dx
	movb $0x60, %al
	outb %al, %dx
	movw 12(%ebp), %dx
1:	inb %dx, %al	 
	testb $0x02, %al 
	jnz 1b

	popl %eax
	leave
	ret
	ret

// indirizzi delle porte relative alla gestione del cursore, nel controllore 
// della scheda video
.set CUR_HIGH, 0x0e
.set CUR_LOW, 0x0f
.set DAT, 0x03d5


// visualizza il cursore nella posizione passata come parametro
	.global cursore
cursore:
	pushl %ebp
	movl %esp, %ebp
	pushl %eax
	pushl %ebx
	pushl %edx
	movb  $80, %al
	mulb  20(%ebp)
	addb  16(%ebp), %al
	adcb  $0, %ah
	movw  %ax, %bx 	
	movw  8(%ebp), %dx
	movb  $CUR_HIGH, %al
	outb  %al, %dx
	movw  12(%ebp), %dx
	movb  %bh, %al
	outb  %al, %dx
	movw  8(%ebp), %dx
	movb  $CUR_LOW, %al
	outb  %al, %dx
	movw  12(%ebp), %dx
	movb  %bl, %al
	outb  %al, %dx
	popl  %edx
	popl  %ebx
	popl  %eax
	leave
	ret

// Inizializzazione dei gate per le primitive di IO
	.global fill_io_gates
fill_io_gates:
	pushl %ebp
	movl %esp, %ebp

	fill_io_gate	io_tipo_rsen	a_readse_n
	fill_io_gate	io_tipo_rseln	a_readse_ln
	fill_io_gate	io_tipo_wsen	a_writese_n
	fill_io_gate	io_tipo_wse0	a_writese_0
	fill_io_gate	io_tipo_rcon	a_readconsole
	fill_io_gate	io_tipo_wcon	a_writeconsole
	fill_io_gate	io_tipo_inic	a_iniconsole
	fill_io_gate	io_tipo_hdr	a_readhd_n
	fill_io_gate	io_tipo_hdw	a_writehd_n
	fill_io_gate	io_tipo_dmahdr	a_dmareadhd_n
	fill_io_gate	io_tipo_dmahdw	a_dmawritehd_n
	leave
	ret

////////////////////////////////////////////////////////////////////////////////
//                              PRIMITIVE DI IO                               //
////////////////////////////////////////////////////////////////////////////////

	.extern c_readse_n
a_readse_n:
	salva_registri
	copia_param 4 7
	cavallo_di_troia 1
	cavallo_di_troia2 1 2
	cavallo_di_troia 3
	call c_readse_n
	addl $16, %esp
	carica_registri
	iret

	.extern c_readse_ln
a_readse_ln:
	salva_registri
	copia_param 4 7
	cavallo_di_troia 1
	cavallo_di_troia 2
	cavallo_di_troia3 1 2
	cavallo_di_troia 3
	call c_readse_ln
	addl $16, %esp
	carica_registri
	iret

	.extern c_writese_n
a_writese_n:
	salva_registri
	copia_param 3 7
	cavallo_di_troia 1
	cavallo_di_troia2 1 2
	call c_writese_n
	addl $12, %esp
	carica_registri
	iret

	.extern c_writese_0	// non c_writese_ln, che va lo stesso
a_writese_0:
	salva_registri
	copia_param 3 7
	cavallo_di_troia 1
	cavallo_di_troia 2
	cavallo_di_troia3 1 2
	call c_writese_0
	addl $12, %esp
	carica_registri
	iret

	.extern c_readconsole
a_readconsole:
	salva_registri
	copia_param 2 7
	cavallo_di_troia 0
	cavallo_di_troia 1
	cavallo_di_troia3 0 1
	call c_readconsole
	addl $8, %esp
	carica_registri
	iret

	.extern c_writeconsole
a_writeconsole:
	salva_registri
	copia_param 1 7
	cavallo_di_troia 0
	call c_writeconsole
	addl $4, %esp
	carica_registri
	iret

	.extern c_iniconsole
a_iniconsole:
	salva_registri
	copia_param 1 7
	call c_iniconsole
	addl $4, %esp
	carica_registri
	iret


# interface ATA

.global			hd_write_address
hd_write_address:	
	pushl %ebp
	movl %esp, %ebp
	pushl %eax
	pushl %edx
	pushl %edi
	
	movl 12(%ebp),%eax
	movl 8(%ebp),%edi	// accede al descrittore per comodita`
	movw 6(%edi),%dx
	outb %al,%dx		// caricato SNR
	movw 2(%edi),%dx
	movb %ah,%al
	outb %al,%dx		// caricato CNL
	shrl $16,%eax
	movw 4(%edi),%dx
	outb %al,%dx		// caricato CNH
	movw 8(%edi),%dx
	inb %dx,%al		// HND in %al
	andb $0xf0,%al		// maschera per l'indirizzo in HND
	andb $0x0f,%ah		// maschera per i 4 bit +sign di primo
	orb  $0xe0,%ah		// seleziona LBA
	orb %ah,%al
	outb %al,%dx		// caricato HND
	
	popl %edi
	popl %edx
	popl %eax
	leave
	ret

.global			hd_write_command
hd_write_command: 
	pushl %ebp
	movl %esp, %ebp
	pushl %edx
	pushl %eax

	movb 8(%ebp), %al
	movw 12(%ebp), %dx
	outb %al, %dx

	popl %eax
	popl %edx
	leave
	ret


.global		hd_go_inout
hd_go_inout:		#...
	pushl %eax
	pushl %edx

	movl 12(%esp), %edx		// ind. di DEV_CTL in edx
	movb $0x08,%al
	outb %al, %dx			// abilitazione dell' interfaccia a
					// generare interruzioni
	popl %edx
	popl %eax
	ret
.global			hd_halt_inout
hd_halt_inout:	
	pushl %eax
	pushl %edx

	movl 12(%esp), %edx		// ind. di DEV_CTL in edx
	movb $0x0A,%al
	outb %al, %dx			// disabilitazione della generazione
					// di interruzioni
	popl %edx
	popl %eax
	ret

// Seleziona uno dei due drive di un canale ATA
	.global hd_select_device
hd_select_device:
	pushl %ebp
	movl %esp, %ebp
	pushl %eax
	pushl %edx

	movl 8(%ebp),%eax
	cmpl $0,%eax
	je shd_ms
shd_sl:	movb $0xf0,%al
	jmp ms_out
shd_ms:	movb $0xe0,%al
ms_out:	movl 12(%ebp),%edx
	outb %al,%dx

	popl %edx
	popl %eax
	leave
	ret

.global		readhd_n
readhd_n:	int		$io_tipo_hdr
		ret
.global		writehd_n
writehd_n:	int		$io_tipo_hdw
		ret
.global		dmareadhd_n
dmareadhd_n:	int		$io_tipo_dmahdr
		ret
.global		dmawritehd_n
dmawritehd_n:	int		$io_tipo_dmahdw
		ret
.extern		c_readhd_n
a_readhd_n:	# routine INT $io_tipo_hdr
		salva_registri
		copia_param 4 7
		cavallo_di_troia 0
		cavallo_di_troia2 0 2
		cavallo_di_troia 3
		call	c_readhd_n
		addl $16, %esp
		carica_registri
		iret

.EXTERN		c_writehd_n
a_writehd_n:	# routine INT $io_tipo_hdw
		salva_registri
		copia_param 4 7
		cavallo_di_troia 0
		cavallo_di_troia2 0 2
		cavallo_di_troia 3
		call	c_writehd_n
		addl $16, %esp
		carica_registri
		iret

.EXTERN		c_dmareadhd_n
a_dmareadhd_n: 	# routine INT $dma_tipob_r
		salva_registri
		copia_param 4 7
		cavallo_di_troia 0
		cavallo_di_troia2 0 2
		cavallo_di_troia 3
		call	c_dmareadhd_n
		addl $16, %esp
		carica_registri
		iret

.EXTERN		c_dmawritehd_n
a_dmawritehd_n:	# routine INT $dma_tipob_w
		salva_registri
		copia_param 4 7
		cavallo_di_troia 0
		cavallo_di_troia2 0 2
		cavallo_di_troia 3
		call	c_dmawritehd_n
		addl $16, %esp
		carica_registri
		iret

