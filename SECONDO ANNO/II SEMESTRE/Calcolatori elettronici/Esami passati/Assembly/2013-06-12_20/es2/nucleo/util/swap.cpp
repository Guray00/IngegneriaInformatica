#include "costanti.h"
#include "swap.h"

ListaTipiSwap* ListaTipiSwap::instance()
{
	if (!instance_) {
		instance_ = new ListaTipiSwap();
	}
	return instance_;
}

TipoSwap* ListaTipiSwap::prossimo()
{
	TipoSwap *in = NULL;
	if (curr) {
		in = curr->in;
		curr = curr->next;
	}
	return in;
}

TipoSwap::TipoSwap()
{
	ListaTipiSwap::instance()->aggiungi(this);
}

bool Swap::scrivi_superblocco(const superblock_t& sb)
{
	return scrivi(512, &sb, sizeof(sb));
}

bool Swap::scrivi_bitmap(const void* vec, int nb)
{
	 return scrivi(DIM_PAGINA, vec, DIM_PAGINA * nb);
}

bool Swap::scrivi_blocco(block_t b, const void* buf)
{
	return scrivi(b * DIM_PAGINA, buf, DIM_PAGINA);
}

bool Swap::leggi_blocco(block_t b, void* buf)
{
	return leggi(b * DIM_PAGINA, buf, DIM_PAGINA);
}

ListaTipiSwap* ListaTipiSwap::instance_ = NULL;
