# utente.s
#
#include <costanti.h>

	.global _start, start
_start:
start:
	.cfi_startproc
	// chiamiamo eventuali costruttori di oggetti globali
	movabs $__init_array_start, %rbx
	movabs $__init_array_end, %r12
1:	cmpq %r12, %rbx
	je 2f
	call *(%rbx)
	addq $8, %rbx
	jmp 1b
2:	jmp main
	.cfi_endproc

# Tipi di interruzione per le chiamate di sistema e per le primitive di IO
#

	.text
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

	.global getmeminfo
getmeminfo:
	.cfi_startproc
	int $TIPO_GMI
	ret
	.cfi_endproc

	.global readconsole
readconsole:
	.cfi_startproc
	int $IO_TIPO_RCON
	ret
	.cfi_endproc

	.global writeconsole
writeconsole:
	.cfi_startproc
	int $IO_TIPO_WCON
	ret
	.cfi_endproc

	.global iniconsole
iniconsole:
	.cfi_startproc
	int $IO_TIPO_INIC
	ret
	.cfi_endproc

	.global readhd_n
readhd_n:
	.cfi_startproc
	int $IO_TIPO_HDR
	ret
	.cfi_endproc

	.global writehd_n
writehd_n:
	.cfi_startproc
	int $IO_TIPO_HDW
	ret
	.cfi_endproc

	.global dmareadhd_n
dmareadhd_n:
	.cfi_startproc
	int $IO_TIPO_DMAHDR
	ret
	.cfi_endproc

	.global dmawritehd_n
dmawritehd_n:
	.cfi_startproc
	int $IO_TIPO_DMAHDW
	ret
	.cfi_endproc

	.global getiomeminfo
getiomeminfo:
	.cfi_startproc
	int $IO_TIPO_GMI
	ret
	.cfi_endproc

// ( ESAME 2015-07-02
	.global shmem_create
shmem_create:
	.cfi_startproc
	int $TIPO_SC
	ret
	.cfi_endproc

	.global shmem_attach
shmem_attach:
	.cfi_startproc
	int $TIPO_SA
	ret
	.cfi_endproc
//   ESAME 2015-07-02 )
