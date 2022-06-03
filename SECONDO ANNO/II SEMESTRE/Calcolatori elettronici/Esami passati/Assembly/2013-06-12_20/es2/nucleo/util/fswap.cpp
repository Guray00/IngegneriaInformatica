#if __GNUC__ >= 3 && !defined(WIN)
	#include <cstdio>
	#include <cstdlib>

	using namespace std;
#else
	#include <stdio.h>
	#include <stdlib.h>
#endif
#include "swap.h"

class TipoFileSwap: public TipoSwap
{
public:
	TipoFileSwap() {}
	~TipoFileSwap() {}
	Swap *apri(const char *nome);
};


class FileSwap: public Swap {
	FILE* img;
public:
	FileSwap(FILE* img): img(img) {}
	~FileSwap();
	unsigned int dimensione() const;
protected:
	virtual bool leggi(unsigned int off, void* buff, unsigned int size);
	virtual bool scrivi(unsigned int off, const void* buff, unsigned int size);
};

Swap* TipoFileSwap::apri(const char *nome)
{
	FILE *img;

	if ( !(img = fopen(nome, "rb+")) || 
	      (fseek(img, 0L, SEEK_END) != 0) )
	{
		return NULL;
	}

	return new FileSwap(img);
}
	

FileSwap::~FileSwap()
{
	fclose(img);
}

unsigned int FileSwap::dimensione() const
{
	return ftell(img);
}

bool FileSwap::scrivi(unsigned int off, const void* buf, unsigned int size)
{
	return (fseek(img, off, SEEK_SET) == 0 && fwrite(buf, size, 1, img) == 1);
}

bool FileSwap::leggi(unsigned int off, void* buf, unsigned int size)
{
	return (fseek(img, off, SEEK_SET) == 0 && fread(buf, size, 1, img) == 1);
}

TipoFileSwap tipoFileSwap;
