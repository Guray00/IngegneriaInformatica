#ifndef INTERP_H__
#define INTERP_H__

#include <stdint.h>

#include <cstdio>
#include <cstdlib>

using namespace std;

// interfaccia generica ai tipi di file eseguibile
class Segmento {
public:
	virtual bool scrivibile() const = 0;
	virtual unsigned int ind_virtuale() const = 0;
	virtual unsigned int dimensione() const = 0;
	virtual bool finito() const = 0;
	virtual bool prossima_pagina() = 0;
	virtual bool pagina_di_zeri() const = 0;
	virtual bool copia_pagina(void * dest) = 0;
	virtual ~Segmento() {}
};

class Eseguibile {
public:
	virtual Segmento* prossimo_segmento() = 0;
	virtual uint32_t entry_point() const = 0;
	virtual ~Eseguibile() {}
};

class ListaInterpreti;

class Interprete {
public:
	Interprete();
	virtual Eseguibile* interpreta(FILE* exe) = 0;
	virtual ~Interprete() {};
};

class ListaInterpreti {
	
public:
	static ListaInterpreti* instance();
	void aggiungi(Interprete* in) { testa = new Elem(in, testa); }
	void rewind() { curr = testa; }
	bool ancora() { return curr != NULL; }
	Interprete* prossimo();
private:
	static ListaInterpreti* instance_;
	ListaInterpreti() : testa(NULL), curr(NULL) {}
	
	struct Elem {
		Interprete* in;
		Elem* next;

		Elem(Interprete* in_, Elem* next_ = NULL):
			in(in_), next(next_)
		{}
	} *testa, *curr;


};

#endif
