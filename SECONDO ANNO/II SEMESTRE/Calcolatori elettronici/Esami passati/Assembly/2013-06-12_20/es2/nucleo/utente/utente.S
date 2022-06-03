# utente.s
#
#define ASM 1
#include <costanti.h>

# Tipi di interruzione per le chiamate di sistema e per le primitive di IO
#

.set tipo_a, TIPO_A
.set tipo_t, TIPO_T
.set tipo_si, TIPO_SI
.set tipo_w, TIPO_W
.set tipo_s, TIPO_S
.set tipo_d, TIPO_D
.set tipo_rl, TIPO_RL
.set tipo_re, TIPO_RE
.set tipo_l, TIPO_L
.set tipo_ep, TIPO_EP
// ( ESAME 2013-06-12
.set tipo_phi, TIPO_PHI
.set tipo_phw, TIPO_PHW
.set tipo_phs, TIPO_PHS
//   ESAME 2013-06-12 )

.set io_tipo_rsen, IO_TIPO_RSEN
.set io_tipo_rseln, IO_TIPO_RSELN
.set io_tipo_wsen, IO_TIPO_WSEN
.set io_tipo_wse0, IO_TIPO_WSE0
.set io_tipo_rcon, IO_TIPO_RCON
.set io_tipo_inic, IO_TIPO_INIC
.set io_tipo_wcon, IO_TIPO_WCON
.set io_tipo_hdr, IO_TIPO_HDR
.set io_tipo_hdw, IO_TIPO_HDW
.set io_tipo_dmahdr, IO_TIPO_DMAHDR
.set io_tipo_dmahdw, IO_TIPO_DMAHDW

	.text
	.global activate_p
activate_p:
	int $tipo_a
	ret

	.global terminate_p
terminate_p:
	int $tipo_t
	ret


	.global end_program
end_program:
	int $tipo_ep
	ret

	.global sem_ini
sem_ini:
	int $tipo_si
	ret

	.global sem_wait
sem_wait:
	int $tipo_w
	ret

	.global sem_signal
sem_signal:
	int $tipo_s
	ret

	.global delay
delay:
	int $tipo_d
	ret

	.global readse_n
readse_n:
	int $io_tipo_rsen
	ret

	.global readse_ln
readse_ln:
	int $io_tipo_rseln
	ret

	.global writese_n
writese_n:
	int $io_tipo_wsen
	ret

	.global writese_0
writese_0:
	int $io_tipo_wse0
	ret

	.global readconsole
readconsole:
	int $io_tipo_rcon
	ret

	.global writeconsole
writeconsole:
	int $io_tipo_wcon
	ret

	.global iniconsole
iniconsole:
	int $io_tipo_inic
	ret

	.global readhd_n
readhd_n:
	int $io_tipo_hdr
	ret

	.global writehd_n
writehd_n:
	int $io_tipo_hdw
	ret

	.global dmareadhd_n
dmareadhd_n:
	int $io_tipo_dmahdr
	ret

	.global dmawritehd_n
dmawritehd_n:
	int $io_tipo_dmahdw
	ret

// ( ESAME 2013-06-12
	.global pim_init
pim_init:
	int $tipo_phi
	ret

	.global pim_wait
pim_wait:
	int $tipo_phw
	ret

	.global pim_signal
pim_signal:
	int $tipo_phs
	ret
//   ESAME 2013-06-12 )


	.global log
log:
	int $tipo_l
	ret


	.global _start, start
_start:
start:
	call lib_init
	jmp main
