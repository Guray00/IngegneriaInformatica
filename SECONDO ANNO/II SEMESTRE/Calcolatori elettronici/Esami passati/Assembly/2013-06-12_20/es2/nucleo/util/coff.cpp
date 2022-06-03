#include <stdint.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

using namespace std;

#include "costanti.h"
#include "interp.h"
#include "coff.h"
#include "dos.h"

typedef unsigned int uint;

// interprete per formato coff-go32-exe
class InterpreteCoff_go32: public Interprete {
public:
	InterpreteCoff_go32();
	~InterpreteCoff_go32() {}
	virtual Eseguibile* interpreta(FILE* pexe);
};

InterpreteCoff_go32::InterpreteCoff_go32()
{}

class EseguibileCoff_go32: public Eseguibile {
	FILE *pexe;
	FILHDR h;
	AOUTHDR ah;
	unsigned int soff;
	char *seg_buf;
	int curr_seg;

	class SegmentoCoff_go32: public Segmento {
		EseguibileCoff_go32 *padre;
		SCNHDR* ph;
		uint curr_offset;
		uint curr_vaddr;
		uint da_leggere;
		uint line;
		size_t curr;
	public:
		SegmentoCoff_go32(EseguibileCoff_go32 *padre_, SCNHDR* ph_);
		virtual bool scrivibile() const;
		virtual uint ind_virtuale() const;
		virtual uint dimensione() const;
		virtual bool finito() const;
		virtual bool prossima_pagina();
		virtual bool pagina_di_zeri() const;
		virtual bool copia_pagina(void* dest);
		~SegmentoCoff_go32() {}
	};

	friend class SegmentoCoff_go32;
public:
	EseguibileCoff_go32(FILE* pexe_);
	bool init();
	virtual Segmento* prossimo_segmento();
	virtual uint32_t entry_point() const;
	~EseguibileCoff_go32();
};

EseguibileCoff_go32::EseguibileCoff_go32(FILE* pexe_)
	: pexe(pexe_), curr_seg(0), seg_buf(NULL)
{}

	

bool EseguibileCoff_go32::init()
{
	DOS_EXE dos;

	if (fseek(pexe, 0, SEEK_SET) != 0)
		return false;

	if (fread(&dos, sizeof(DOS_EXE), 1, pexe) < 1)
		return false;

	if (dos.signature != DOS_MAGIC)
		return false;

	soff = dos.blocks_in_file * 512L;
	if (dos.bytes_in_last_block)
		  soff -= (512 - dos.bytes_in_last_block);

	if (fseek(pexe, soff, SEEK_SET) != 0) 
		return false;

	if (fread(&h, FILHSZ, 1, pexe) < 1)
		return false;

	// i primi 2 byte devono contenere un valore prestabilito
	if (h.f_magic != I386MAGIC)
		return false;

	if (!(h.f_flags & F_EXEC)) 
		return false;

	// leggiamo l'a.out header
	if (fread(&ah, 1, h.f_opthdr, pexe) < h.f_opthdr)
	{
		fprintf(stderr, "Fine prematura del file COFF-go32\n");
		exit(EXIT_FAILURE);
	}

	// controlliamo che sia consistente
	if (ah.magic != ZMAGIC)
		return false;

	// leggiamo la tabella delle sezioni
	seg_buf = new char[h.f_nscns * SCNHSZ];
	if (fread(seg_buf, SCNHSZ, h.f_nscns, pexe) < h.f_nscns)
	{
		fprintf(stderr, "Fine prematura del file COFF-go32\n");
		exit(EXIT_FAILURE);
	}
	
	return true;
}

Segmento* EseguibileCoff_go32::prossimo_segmento()
{
	while (curr_seg < h.f_nscns) {
		SCNHDR* ph = (SCNHDR*)(seg_buf + SCNHSZ * curr_seg);
		curr_seg++;

		if (ph->s_vaddr == 0 ||
		   ph->s_flags != STYP_TEXT && ph->s_flags != STYP_DATA && ph->s_flags != STYP_BSS)
			continue;
		
		return new SegmentoCoff_go32(this, ph);
	}
	return NULL;
}

uint32_t EseguibileCoff_go32::entry_point() const
{
	return ah.entry;
}


EseguibileCoff_go32::~EseguibileCoff_go32()
{
	delete[] seg_buf;
}

EseguibileCoff_go32::SegmentoCoff_go32::SegmentoCoff_go32(EseguibileCoff_go32* padre_, SCNHDR* ph_)
	: padre(padre_), ph(ph_),
	  curr_offset(ph->s_scnptr),
	  curr_vaddr(ph->s_vaddr),
	  da_leggere(ph->s_size),
	  line(curr_vaddr & (DIM_PAGINA - 1)),
	  curr(da_leggere > DIM_PAGINA - line ? DIM_PAGINA - line: da_leggere)
{
}

bool EseguibileCoff_go32::SegmentoCoff_go32::scrivibile() const
{
	return (ph->s_flags & (STYP_DATA | STYP_BSS));
}

uint EseguibileCoff_go32::SegmentoCoff_go32::ind_virtuale() const
{
	return (ph->s_vaddr);
}

uint EseguibileCoff_go32::SegmentoCoff_go32::dimensione() const
{
	return ph->s_size;
}

bool EseguibileCoff_go32::SegmentoCoff_go32::finito() const
{
	return (da_leggere <= 0);
}


bool EseguibileCoff_go32::SegmentoCoff_go32::copia_pagina(void* dest)
{
	if (finito())
		return false;

	if (fseek(padre->pexe, padre->soff + curr_offset, SEEK_SET) != 0) {
		fprintf(stderr, "errore nel file COFF-go32\n");
		exit(EXIT_FAILURE);
	}

	if (ph->s_flags & STYP_BSS) {
		memset((char*)dest + line, 0, curr);
	} else {
		if (fread((char*)dest + line, 1, curr, padre->pexe) < curr) {
			fprintf(stderr, "errore nella lettura dal file COFF-go32\n");
			exit(EXIT_FAILURE);
		}
	}
	return true;
}

bool EseguibileCoff_go32::SegmentoCoff_go32::prossima_pagina()
{
	if (finito())
		return false;

	da_leggere -= curr;
	curr_offset += curr;
	curr_vaddr += curr;
	line = curr_vaddr & (DIM_PAGINA - 1);
	curr = (da_leggere > DIM_PAGINA - line ? DIM_PAGINA - line: da_leggere);
	return true;
}

bool EseguibileCoff_go32::SegmentoCoff_go32::pagina_di_zeri() const
{
	return (ph->s_flags & STYP_BSS && line == 0 && curr == DIM_PAGINA);
}

Eseguibile* InterpreteCoff_go32::interpreta(FILE* pexe)
{
	EseguibileCoff_go32 *pe = new EseguibileCoff_go32(pexe);

	if (pe->init())
		return pe;

	delete pe;
	return NULL;
}

InterpreteCoff_go32	int_coff_go32;
