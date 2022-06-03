// ( costanti usate in sistema.cpp e sistema.S
//   SEL = selettori (segmentazione con modello flat)
//   LIV = livelli di privilegio
#define SEL_CODICE_SISTEMA	8
#define SEL_DATI_SISTEMA 	16
#define SEL_CODICE_UTENTE	27
#define SEL_DATI_UTENTE 	35
#define LIV_UTENTE		3
#define LIV_SISTEMA		0
// )

// ( varie dimensioni
#define KiB			1024U
#define MiB			(1024*KiB)
#define MEM_TOT			(16*MiB)
#define DIM_M1			(2*MiB)
#define DIM_M2			(MEM_TOT - DIM_M1)
#define MAX_SEM			4096
#define DIM_PAGINA		4096U
#define DIM_MACROPAGINA		(DIM_PAGINA * 1024U)
#define DIM_DESP		216 	// descrittore di processo
#define DIM_DESS		8	// descrittore di semaforo
#define BYTE_SEM		(DIM_DESS * MAX_SEM)
#define MAX_PRD			16
#define N_DPF			(DIM_M2 / DIM_PAGINA)
#define DIM_USR_HEAP		(256*KiB)
#define DIM_USR_STACK		(64*KiB)
#define DIM_SYS_STACK		(4*KiB)
#define DIM_BLOCK		512
// ( ESAME 2013-06-12
#define MAX_PHM			16
//   ESAME 2013-06-12 )
// )

// ( tipi interruzioni esterne
#define VETT_0			0xF0
#define VETT_1                  0xD0
#define VETT_2                  0xC0
#define VETT_3                  0xB0
#define VETT_4                  0xA0
#define VETT_5                  0x90
#define VETT_6                  0x80
#define VETT_7                  0x70
#define VETT_8                  0x60
#define VETT_9                  0x50
#define VETT_10                 0x40
#define VETT_11                 0x30
#define VETT_12                 0x20
#define VETT_13                 0xD1
#define VETT_14                 0xE0
#define VETT_15                 0xE1
#define VETT_16                 0xC1
#define VETT_17                 0xB1
#define VETT_18                 0xA1
#define VETT_19                 0x91
#define VETT_20                 0x81
#define VETT_21                 0x71
#define VETT_22                 0x61
#define VETT_23                 0x51
#define VETT_S			0x4F
// )
// ( tipi delle primitive
#define TIPO_A			0x42	// activate_p
#define TIPO_T			0x43	// terminate_p
#define TIPO_SI			0x44	// sem_ini
#define TIPO_W			0x45	// sem_wait
#define TIPO_S			0x46	// sem_signal
#define TIPO_D			0x49	// delay
#define TIPO_RE			0x4b	// resident
#define TIPO_EP			0x4c	// end_program
#define TIPO_APE		0x52	// activate_pe
#define TIPO_WFI		0x53	// wfi
#define TIPO_FG			0x54	// *fill_gate
#define TIPO_P			0x55	// *panic
#define TIPO_AB			0x56	// *abort_p
#define TIPO_L			0x57	// *log
#define TIPO_TRA		0x58	// trasforma
#define TIPO_PCIF		0x59	// pci_find
#define TIPO_PCIR		0x5a	// pci_read
#define TIPO_PCIW		0x5b	// pci_write
// ( ESAME 2013-06-12
#define TIPO_PHI		0x82	// pimutex_init
#define TIPO_PHW		0x83	// pimutex_wait
#define TIPO_PHS		0x84	// pimutex_signal
//   ESAME 2013-06-12 )

#define IO_TIPO_HDR		0x62	// readhd_n
#define IO_TIPO_HDW		0x63	// writehd_n
#define IO_TIPO_DMAHDR		0x64	// dmareadhd_n
#define IO_TIPO_DMAHDW		0x65	// dmawritehd_n
#define IO_TIPO_RSEN		0x72	// readse_n
#define IO_TIPO_RSELN		0x73	// readse_ln
#define IO_TIPO_WSEN		0x74	// writese_n
#define IO_TIPO_WSE0		0x75	// writese_0
#define IO_TIPO_RCON		0x76	// readconsole
#define IO_TIPO_WCON		0x77	// writeconsole
#define IO_TIPO_INIC		0x78	// iniconsole
// * in piu' rispetto al libro
// )

// ( suddivisione della memoria virtuale
//   NTAB = Numero di Tabelle delle pagine
//   SIS  = SIStema
//   MIO  = Modulo IO
//   USR  = utente (USeR)
//   C    = condiviso
//   P    = privato
#define NTAB_SIS_C		256	// 1GiB
#define NTAB_SIS_P		1	// 4MiB
#define NTAB_MIO_C		250	// 1GiB - 4MiB - 20MiB
#define NTAB_PCI_C		5	// 20MiB
#define NTAB_USR_C		256	// 1GiB
#define NTAB_USR_P		256	// 1GiB
// )
#define INIT_SECTION_ASM_OP	".section\t.myinit,\"ax\"\n"
