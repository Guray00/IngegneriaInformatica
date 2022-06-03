#include "costanti.h"
#include "interp.h"

ListaInterpreti* ListaInterpreti::instance()
{
	if (!instance_) {
		instance_ = new ListaInterpreti();
	}
	return instance_;
}

Interprete* ListaInterpreti::prossimo()
{
	Interprete *in = NULL;
	if (curr) {
		in = curr->in;
		curr = curr->next;
	}
	return in;
}

Interprete::Interprete()
{
	ListaInterpreti::instance()->aggiungi(this);
}

ListaInterpreti* ListaInterpreti::instance_ = NULL;
