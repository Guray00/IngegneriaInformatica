#ifndef SWAP_H__
#define SWAP_H__

#include <stdint.h>

#include <cstdlib>

using namespace std;

typedef uint32_t block_t;

struct superblock_t {
	int8_t		magic[4];
	block_t		bm_start;
	uint32_t	blocks;
	block_t		directory;
	uint32_t	user_entry;
	uint32_t	user_end;
	uint32_t	io_entry;
	uint32_t	io_end;
	uint32_t	checksum;
};

// interfaccia generica agli swap
class Swap {
public:
	virtual unsigned int dimensione() const = 0;
	bool scrivi_superblocco(const superblock_t& sb);
	bool scrivi_bitmap(const void* vec, int nb);
	bool scrivi_blocco(block_t b, const void* blk);
	bool leggi_blocco(block_t b, void* blk);
	virtual ~Swap() {}
protected:
	virtual bool leggi(unsigned int off, void* buff, unsigned int size) = 0;
	virtual bool scrivi(unsigned int off, const void* buff, unsigned int size) = 0;
};

class ListaTipiSwap;

class TipoSwap {
public:
	TipoSwap();
	virtual Swap* apri(const char* nome) = 0;
	virtual ~TipoSwap() {};
};

class ListaTipiSwap {
	
public:
	static ListaTipiSwap* instance();
	void aggiungi(TipoSwap* in) { testa = new Elem(in, testa); }
	void rewind() { curr = testa; }
	bool ancora() { return curr != NULL; }
	TipoSwap* prossimo();
private:
	static ListaTipiSwap* instance_;
	ListaTipiSwap() : testa(NULL), curr(NULL) {}
	
	struct Elem {
		TipoSwap* in;
		Elem* next;

		Elem(TipoSwap* in_, Elem* next_ = NULL):
			in(in_), next(next_)
		{}
	} *testa, *curr;


};

#endif
