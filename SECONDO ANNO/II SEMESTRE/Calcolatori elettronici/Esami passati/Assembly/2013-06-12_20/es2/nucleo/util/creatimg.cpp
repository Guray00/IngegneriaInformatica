#include <stdint.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

using namespace std;

#include "costanti.h"
#include "interp.h"
#include "swap.h"

const uint32_t UPB = DIM_PAGINA / sizeof(uint32_t);
const uint32_t BPU = sizeof(uint32_t) * 8;

const uint32_t fine_utente_condiviso = (NTAB_SIS_C + NTAB_SIS_P + NTAB_MIO_C + NTAB_USR_C) * DIM_MACROPAGINA;

union descrittore_pagina {
	// caso di pagina presente
	struct {
		// byte di accesso
		unsigned int P:		1;	// bit di presenza
		unsigned int RW:	1;	// Read/Write
		unsigned int US:	1;	// User/Supervisor
		unsigned int PWT:	1;	// Page Write Through
		unsigned int PCD:	1;	// Page Cache Disable
		unsigned int A:		1;	// Accessed
		unsigned int D:		1;	// Dirty
		unsigned int pgsz:	1;	// non visto a lezione
		// fine byte di accesso
		
		unsigned int global:	1;	// non visto a lezione
		unsigned int avail:	3;	// non usati

		unsigned int address:	20;	// indirizzo fisico
	} p;
	// caso di pagina assente
	struct {
		// informazioni sul tipo di pagina
		unsigned int P:		1;
		unsigned int RW:	1;
		unsigned int US:	1;
		unsigned int PWT:	1;
		unsigned int PCD:	1;

		unsigned int block:	27;
	} a;	
};

typedef descrittore_pagina descrittore_tabella;

struct direttorio {
	descrittore_tabella entrate[1024];
}; 

struct tabella_pagine {
	descrittore_pagina  entrate[1024];
};

struct pagina {
	union {
		unsigned char byte[DIM_PAGINA];
		unsigned int  parole_lunghe[DIM_PAGINA / sizeof(unsigned int)];
	};
};

short indice_direttorio(uint32_t indirizzo) {
	return (indirizzo & 0xffc00000) >> 22;
}

short indice_tabella(uint32_t indirizzo) {
	return (indirizzo & 0x003ff000) >> 12;
}

tabella_pagine* tabella_puntata(descrittore_tabella* pdes_tab) {
	return reinterpret_cast<tabella_pagine*>(pdes_tab->p.address << 12);
}

pagina* pagina_puntata(descrittore_pagina* pdes_pag) {
	return reinterpret_cast<pagina*>(pdes_pag->p.address << 12);
}

struct bm_t {
	unsigned int *vect;
	unsigned int size;
};

inline unsigned int bm_isset(bm_t *bm, unsigned int pos)
{
	return !(bm->vect[pos / 32] & (1UL << (pos % 32)));
}

inline void bm_set(bm_t *bm, unsigned int pos)
{
	bm->vect[pos / 32] &= ~(1UL << (pos % 32));
}

inline void bm_clear(bm_t *bm, unsigned int pos)
{
	bm->vect[pos / 32] |= (1UL << (pos % 32));
}

void bm_create(bm_t *bm, unsigned int *buffer, unsigned int size)
{
	bm->vect = buffer;
	bm->size = size;
	unsigned int vecsize = size / BPU + (size % BPU ? 1 : 0);

	for(int i = 0; i < vecsize; ++i)
		bm->vect[i] = 0;
}


bool bm_alloc(bm_t *bm, unsigned int& pos)
{
	int i, l;

	i = 0;
	while(i < bm->size && bm_isset(bm, i)) i++;

	if (i == bm->size)
		return false;

	bm_set(bm, i);
	pos = i;
	return true;
}

void bm_free(bm_t *bm, unsigned int pos)
{
	bm_clear(bm, pos);
}

#define CHECKSW(f, b, d)	do { if (!swap->f(b, d)) { fprintf(stderr, "blocco %d: " #f " fallita\n", b); exit(EXIT_FAILURE); } } while(0)

superblock_t superblock;
direttorio main_dir;
bm_t blocks;
pagina pag;
pagina zero_pag;
tabella_pagine tab;
Swap* swap = NULL;

class TabCache {
	bool dirty;
	bool valid;
	block_t block;
public:
	
	TabCache() {
		valid = false;
	}

	~TabCache() {
		if (valid && dirty) {
			CHECKSW(scrivi_blocco, block, &tab);
		}
	}

	block_t nuova() {
		block_t b;

		if (valid && dirty) {
			CHECKSW(scrivi_blocco, block, &tab);
		}
		memset(&tab, 0, sizeof(tabella_pagine));
	
		if (! bm_alloc(&blocks, b) ) {
			fprintf(stderr, "spazio insufficiente nello swap\n");
			exit(EXIT_FAILURE);
		}
		valid = true;
		dirty = true;
		block = b;
		return b;
	}

	void leggi(block_t blocco) {
		if (valid) {
			if (blocco == block)
				return;
			if (dirty)
				CHECKSW(scrivi_blocco, block, &tab);
		}
		CHECKSW(leggi_blocco, blocco, &tab);
		block = blocco;
		valid = true;
		dirty = false;
	}
	void scrivi() {
		dirty = true;
	}
};


void do_map(char* fname, int liv, uint32_t& entry_point, uint32_t& last_address)
{
	FILE* exe;
	TabCache tabc;

	if ( !(exe = fopen(fname, "rb")) ) {
		perror(fname);
		exit(EXIT_FAILURE);
	}


	descrittore_tabella* pdes_tab;
	tabella_pagine* ptabella;
	descrittore_pagina* pdes_pag;

	Eseguibile *e = NULL;
	ListaInterpreti* interpreti = ListaInterpreti::instance();
	interpreti->rewind();
	while (interpreti->ancora()) {
		e = interpreti->prossimo()->interpreta(exe);
		if (e) break;
	}
	if (!e) {
		fprintf(stderr, "Formato del file '%s' non riconosciuto\n", fname);
		exit(EXIT_FAILURE);
	}

	entry_point = e->entry_point();

	
	// dall'intestazione, calcoliamo l'inizio della tabella dei segmenti di programma
	last_address = 0;
	Segmento *s = NULL;
	while (s = e->prossimo_segmento()) {
		uint32_t ind_virtuale = s->ind_virtuale();
		uint32_t dimensione = s->dimensione();
		uint32_t end_addr = ind_virtuale + dimensione;

		if (end_addr > last_address) 
			last_address = end_addr;

		ind_virtuale &= 0xfffff000;
		end_addr = (end_addr + 0x00000fff) & 0xfffff000;
		for (; ind_virtuale < end_addr; ind_virtuale += sizeof(pagina))
		{
			block_t b;
			pdes_tab = &main_dir.entrate[indice_direttorio(ind_virtuale)];
			if (pdes_tab->a.block == 0) {
				b = tabc.nuova();
				pdes_tab->a.block = b;
				pdes_tab->a.PWT   = 0;
				pdes_tab->a.PCD   = 0;
				pdes_tab->a.RW	  = 1;
				pdes_tab->a.US	  = liv;
				pdes_tab->a.P	  = 0;
			} else {
				tabc.leggi(pdes_tab->a.block);
			}

			pdes_pag = &tab.entrate[indice_tabella(ind_virtuale)];
			if (pdes_pag->a.block == 0) {
				if (! bm_alloc(&blocks, b) ) {
					fprintf(stderr, "%s: spazio insufficiente nello swap\n", fname);
					exit(EXIT_FAILURE);
				}
				pdes_pag->a.block = b;
			} else {
				CHECKSW(leggi_blocco, pdes_pag->a.block, &pag);
			}
			if (s->pagina_di_zeri()) {
				CHECKSW(scrivi_blocco, pdes_pag->a.block, &zero_pag);
			} else {
				s->copia_pagina(&pag);
				CHECKSW(scrivi_blocco, pdes_pag->a.block, &pag);
			}
			pdes_pag->a.PWT = 0;
			pdes_pag->a.PCD = 0;
			pdes_pag->a.RW |= s->scrivibile();
			pdes_pag->a.US |= liv;
			tabc.scrivi();
			s->prossima_pagina();
		}

	}
	fclose(exe);
}




int main(int argc, char* argv[])
{
	if (argc < 3) {
		fprintf(stderr, "Utilizzo: %s <swap> <modulo io> <modulo utente>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	ListaTipiSwap* tipiswap = ListaTipiSwap::instance();
	tipiswap->rewind();
	while (tipiswap->ancora()) {
		swap = tipiswap->prossimo()->apri(argv[1]);
		if (swap) break;
	}
	if (!swap) {
		fprintf(stderr, "Dispositivo swap '%s' non riconosciuto\n", argv[1]);
		exit(EXIT_FAILURE);
	}

	long dim = swap->dimensione() / DIM_PAGINA;
	int nlong = dim / BPU + (dim % BPU ? 1 : 0);
	int nbmblocks = nlong / UPB + (nlong % UPB ? 1 : 0);
	
	bm_create(&blocks, new uint32_t[nbmblocks * UPB], dim);

	for (int i = 0; i < dim; i++)
		bm_free(&blocks, i);

	for (int i = 0; i <= nbmblocks + 1; i++)
		bm_set(&blocks, i);

	superblock.bm_start = 1;
	superblock.blocks = dim;
	superblock.directory = nbmblocks + 1;

	memset(&main_dir, 0, sizeof(direttorio));

	uint32_t last_address;
	do_map(argv[2], 0, superblock.io_entry, last_address);
	superblock.io_end = last_address;

	do_map(argv[3], 1, superblock.user_entry, last_address);
	superblock.user_end = last_address;

	// le tabelle condivise per lo heap:
	TabCache tabc;
	for (uint32_t addr = last_address; addr < last_address + DIM_USR_HEAP; addr += sizeof(pagina)) {
		descrittore_tabella *pdes_tab = &main_dir.entrate[indice_direttorio(addr)];
		block_t b;
		if (pdes_tab->a.block == 0) {
			b = tabc.nuova();
			pdes_tab->a.block = b;
			pdes_tab->a.PWT   = 0;
			pdes_tab->a.PCD   = 0;
			pdes_tab->a.RW	  = 1;
			pdes_tab->a.US	  = 1;
			pdes_tab->a.P	  = 1;
		} else {
			tabc.leggi(pdes_tab->a.block);
		}

		descrittore_pagina* pdes_pag = &tab.entrate[indice_tabella(addr)];
		if (pdes_pag->a.block == 0) {
			if (! bm_alloc(&blocks, b) ) {
				fprintf(stderr, "user heap: spazio insufficiente nello swap\n");
				exit(EXIT_FAILURE);
			}
			pdes_pag->a.block = b;
			CHECKSW(scrivi_blocco, pdes_pag->a.block, &zero_pag);
		} 
		pdes_pag->a.PWT = 0;
		pdes_pag->a.PCD = 0;
		pdes_pag->a.RW |= 1;
		pdes_pag->a.US |= 1;
		tabc.scrivi();
	}
		
	superblock.magic[0] = 'C';
	superblock.magic[1] = 'E';
	superblock.magic[2] = 'S';
	superblock.magic[3] = 'W';

	int *w = (int*)&superblock, sum = 0;
	for (int i = 0; i < sizeof(superblock) / sizeof(int) - 1; i++)
		sum += w[i];
	superblock.checksum = -sum;

	if ( !swap->scrivi_superblocco(superblock) ||
	     !swap->scrivi_bitmap(blocks.vect, nbmblocks) ||
	     !swap->scrivi_blocco(superblock.directory, &main_dir))
	{
		fprintf(stderr, "errore nella creazione dello swap\n");
		exit(EXIT_FAILURE);
	}
	return EXIT_SUCCESS;
}


	
	
