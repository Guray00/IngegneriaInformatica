#include "costanti.h"

	.text
.global _start, start
_start:
start:
	// chiamiamo eventuali costruttori di oggetti globali
	movabs $__init_array_start, %rbx
	movabs $__init_array_end, %r12
1:	cmpq %r12, %rbx
	je 2f
	call *(%rbx)
	addq $8, %rbx
	jmp 1b
	// il resto dell'inizializzazione e' scritto in C++
2:	jmp main

////////////////////////////////////////////////////////////////////////////////
//                       CHIAMATE DI SISTEMA GENERICHE                        //
////////////////////////////////////////////////////////////////////////////////

	.global getmeminfo
getmeminfo:
	.cfi_startproc
	int $TIPO_GMI
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

	.global sem_signal
sem_signal:
	.cfi_startproc
	int $TIPO_S
	ret
	.cfi_endproc

	.global delay
delay:
	.cfi_startproc
	int $TIPO_D
	ret
	.cfi_endproc

	.global do_log
do_log:
	.cfi_startproc
	int $TIPO_L
	ret
	.cfi_endproc

////////////////////////////////////////////////////////////////////////////////
//               CHIAMATE DI SISTEMA SPECIFICHE PER IL MODULO I/O             //
////////////////////////////////////////////////////////////////////////////////

	.global activate_pe
activate_pe:
	.cfi_startproc
	int $TIPO_APE
	ret
	.cfi_endproc

	.global wfi
wfi:
	.cfi_startproc
	int $TIPO_WFI
	ret
	.cfi_endproc

	.global abort_p
abort_p:
	.cfi_startproc
	int $TIPO_AB
	ret
	.cfi_endproc

	.global io_panic
io_panic:
	.cfi_startproc
	int $TIPO_IOP
	ret
	.cfi_endproc

	.global fill_gate
fill_gate:
	.cfi_startproc
	int $TIPO_FG
	ret
	.cfi_endproc

	.global trasforma
trasforma:
	.cfi_startproc
	int $TIPO_TRA
	ret
	.cfi_endproc

	.global access
access:
	.cfi_startproc
	int $TIPO_ACC
	ret
	.cfi_endproc

// Chiama fill_gate con i parametri specificati
.macro fill_io_gate gate off
	movq $\gate, %rdi
	movabs $\off, %rax
	movq %rax, %rsi
	movq $LIV_UTENTE, %rdx
	call fill_gate
.endm

// Inizializzazione dei gate per le primitive di IO
	.global fill_io_gates
fill_io_gates:
	pushq %rbp
	movq %rsp, %rbp

	fill_io_gate	IO_TIPO_RCON	a_readconsole
	fill_io_gate	IO_TIPO_WCON	a_writeconsole
	fill_io_gate	IO_TIPO_INIC	a_iniconsole
	fill_io_gate	IO_TIPO_HDR	a_readhd_n
	fill_io_gate	IO_TIPO_HDW	a_writehd_n
	fill_io_gate	IO_TIPO_DMAHDR	a_dmareadhd_n
	fill_io_gate	IO_TIPO_DMAHDW	a_dmawritehd_n
	fill_io_gate	IO_TIPO_GMI	a_getiomeminfo

	leave
	ret

////////////////////////////////////////////////////////////////////////////////
//                              PRIMITIVE DI IO                               //
////////////////////////////////////////////////////////////////////////////////

	.extern c_readconsole
a_readconsole:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_readconsole
	iretq
	.cfi_endproc

	.extern c_writeconsole
a_writeconsole:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_writeconsole
	iretq
	.cfi_endproc

	.extern c_iniconsole
a_iniconsole:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_iniconsole
	iretq
	.cfi_endproc

	.extern	c_readhd_n
a_readhd_n:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_readhd_n
	iretq
	.cfi_endproc

	.extern	c_writehd_n
a_writehd_n:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_writehd_n
	iretq
	.cfi_endproc

	.extern	c_dmareadhd_n
a_dmareadhd_n:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_dmareadhd_n
	iretq
	.cfi_endproc

	.extern	c_dmawritehd_n
a_dmawritehd_n:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_dmawritehd_n
	iretq
	.cfi_endproc

	.extern	c_getiomeminfo
a_getiomeminfo:
	.cfi_startproc
	.cfi_def_cfa_offset 40
	.cfi_offset rip, -40
	.cfi_offset rsp, -16
	call c_getiomeminfo
	iretq
	.cfi_endproc

.bss
	.global hd_prd
.balign 0x10000
hd_prd:
	.fill MAX_PRD, 8, 0
