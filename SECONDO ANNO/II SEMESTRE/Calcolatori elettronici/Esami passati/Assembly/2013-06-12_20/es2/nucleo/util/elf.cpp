#include <stdint.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>

using namespace std;

#include "costanti.h"
#include "interp.h"
#include "elf.h"

typedef unsigned int uint32_t;

// interprete per formato elf
class InterpreteElf32: public Interprete {
public:
	InterpreteElf32();
	~InterpreteElf32() {}
	virtual Eseguibile* interpreta(FILE* pexe);
};

InterpreteElf32::InterpreteElf32()
{}

class EseguibileElf32: public Eseguibile {
	FILE *pexe;
	Elf32_Ehdr h;
	char *seg_buf;
	char *sec_buf;
	int curr_seg;

	class SegmentoElf32: public Segmento {
		EseguibileElf32 *padre;
		Elf32_Phdr* ph;
		uint32_t curr_offset;
		uint32_t curr;
		uint32_t da_leggere;
		uint32_t ancora;
	public:
		SegmentoElf32(EseguibileElf32 *padre_, Elf32_Phdr* ph_);
		virtual bool scrivibile() const;
		virtual uint32_t ind_virtuale() const;
		virtual uint32_t dimensione() const;
		virtual bool finito() const;
		virtual bool copia_pagina(void* dest);
		virtual bool prossima_pagina();
		virtual bool pagina_di_zeri() const;
		~SegmentoElf32() {}
	};

	friend class SegmentoElf32;
public:
	EseguibileElf32(FILE* pexe_);
	bool init();
	virtual Segmento* prossimo_segmento();
	virtual uint32_t entry_point() const;
	~EseguibileElf32();
};

EseguibileElf32::EseguibileElf32(FILE* pexe_)
	: pexe(pexe_), curr_seg(0),
	  seg_buf(NULL), sec_buf(NULL) 
{}

	

bool EseguibileElf32::init()
{
	if (fseek(pexe, 0, SEEK_SET) != 0) 
		return false;

	if (fread(&h, sizeof(Elf32_Ehdr), 1, pexe) < 1)
		return false;

	// i primi 4 byte devono contenere un valore prestabilito
	if (!(h.e_ident[EI_MAG0] == ELFMAG0 &&
	      h.e_ident[EI_MAG1] == ELFMAG1 &&
	      h.e_ident[EI_MAG2] == ELFMAG2 &&
	      h.e_ident[EI_MAG2] == ELFMAG2))
		return false;

	if (!(h.e_ident[EI_CLASS] == ELFCLASS32  &&  // 32 bit
	      h.e_ident[EI_DATA]  == ELFDATA2LSB &&  // little endian
	      h.e_type            == ET_EXEC     &&  // eseguibile
	      h.e_machine         == EM_386))        // per Intel x86
		return false;

	// leggiamo la tabella dei segmenti
	seg_buf = new char[h.e_phnum * h.e_phentsize];
	if ( fseek(pexe, h.e_phoff, SEEK_SET) != 0 ||
	     fread(seg_buf, h.e_phentsize, h.e_phnum, pexe) < h.e_phnum)
	{
		fprintf(stderr, "Fine prematura del file ELF\n");
		exit(EXIT_FAILURE);
	}
	
	// dall'intestazione, calcoliamo l'inizio della tabella delle sezioni
	sec_buf = new char[h.e_shnum * h.e_shentsize];
	if ( fseek(pexe, h.e_shoff, SEEK_SET) != 0 ||
	     fread(sec_buf, h.e_shentsize, h.e_shnum, pexe) < h.e_shnum)
	{
		fprintf(stderr, "Fine prematura del file ELF\n");
		exit(EXIT_FAILURE);
	}

	return true;
}

Segmento* EseguibileElf32::prossimo_segmento()
{
	while (curr_seg < h.e_phnum) {
		Elf32_Phdr* ph = (Elf32_Phdr*)(seg_buf + h.e_phentsize * curr_seg);
		curr_seg++;
		
		if (ph->p_type != PT_LOAD)
			continue;

		return new SegmentoElf32(this, ph);
	}
	return NULL;
}

uint32_t EseguibileElf32::entry_point() const
{
	return h.e_entry;
}

EseguibileElf32::~EseguibileElf32()
{
	delete[] seg_buf;
	delete[] sec_buf;
}

EseguibileElf32::SegmentoElf32::SegmentoElf32(EseguibileElf32* padre_, Elf32_Phdr* ph_)
	: padre(padre_), ph(ph_),
	  curr_offset(ph->p_offset & ~(DIM_PAGINA - 1)),
	  da_leggere(ph->p_filesz + (ph->p_offset - curr_offset)),
	  ancora(ph->p_memsz)
{
	curr = (da_leggere > DIM_PAGINA ? DIM_PAGINA : da_leggere);
}

bool EseguibileElf32::SegmentoElf32::scrivibile() const
{
	return (ph->p_flags & PF_W);
}

uint32_t EseguibileElf32::SegmentoElf32::ind_virtuale() const
{
	return ph->p_vaddr;
}

uint32_t EseguibileElf32::SegmentoElf32::dimensione() const
{
	return ph->p_memsz;
}

bool EseguibileElf32::SegmentoElf32::finito() const
{
	return (ancora <= 0);
}

bool EseguibileElf32::SegmentoElf32::prossima_pagina()
{
	if (finito())
		return false;
	da_leggere -= curr;
	curr_offset += curr;
	curr = (da_leggere > DIM_PAGINA ? DIM_PAGINA : da_leggere);
	return true;
}

bool EseguibileElf32::SegmentoElf32::pagina_di_zeri() const {
	return (da_leggere <= 0);
}

bool EseguibileElf32::SegmentoElf32::copia_pagina(void* dest)
{
	if (curr == 0)
		return true;

	if (fseek(padre->pexe, curr_offset, SEEK_SET) != 0) {
		fprintf(stderr, "errore nel file ELF\n");
		exit(EXIT_FAILURE);
	}

	if (curr < DIM_PAGINA) memset(dest, 0, DIM_PAGINA);
	if (fread(dest, 1, curr, padre->pexe) < curr) {
		fprintf(stderr, "errore nella lettura dal file ELF\n");
		exit(EXIT_FAILURE);
	}
	return true;
}

Eseguibile* InterpreteElf32::interpreta(FILE* pexe)
{
	EseguibileElf32 *pe = new EseguibileElf32(pexe);

	if (pe->init())
		return pe;

	delete pe;
	return NULL;
}

InterpreteElf32		int_elf32;
