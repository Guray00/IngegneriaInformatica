#include <lib.h>
#include <sys.h>

typedef char *va_list;

// Macro per funzioni variadiche: versione semplificata che funziona
//  solo se in pila ci sono oggetti di dimensione multipla di 4.
// Basta per interi e puntatori, tutto quello di cui c' e' bisogno in
//  questo sistema; se ci fosse bisogno di usare tipi di lunghezza diversa
//  e' necessario sostituire i sizeof con una macro o una funzione che
//  resitituisca la dimensione in pila del tipo specificato.
//
#define va_start(ap, last_req) (ap = (char *)&(last_req) + sizeof(last_req))
#define va_arg(ap, type) ((ap) += sizeof(type), *(type *)((ap) - sizeof(type)))
#define va_end(ap)

int vsnprintf(char *str, natl size, const char *fmt, va_list ap);
extern "C" void log(log_sev sev, cstr msg, natl quanti);

char* copy(const char* src, char* dst) {
	while (*src)
		*dst++ = *src++;
	*dst = '\0';
	return dst;
}

char* convint(int n, char* out)
{
	char buf[12];
	int i = 11;
	bool neg = false;

	if (n == 0) 
		return copy("0", out);

	buf[i--] = '\0';

	if (n < 0) {
		n = -n;
		neg = true;
	}
	while (n > 0) {
		buf[i--] = n % 10 + '0';
		n = n / 10;
	}
	if (neg)
		buf[i--] = '-';
	return copy(buf + i + 1, out);
}

natl strlen(const char *s)
{
	natl l = 0;

	while(*s++)
		++l;

	return l;
}

char *strncpy(char *dest, const char *src, size_t l)
{
	size_t i;

	for(i = 0; i < l && src[i]; ++i)
		dest[i] = src[i];

	return dest;
}

static const char hex_map[16] = { '0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

static void htostr(char *buf, unsigned long l)
{
	int i;

	buf[0] = '0';
	buf[1] = 'x';

	for(i = 9; i > 1; --i) {
		buf[i] = hex_map[l % 16];
		l /= 16;
	}
}

static void itostr(char *buf, unsigned int len, long l)
{
	natl i, div = 1000000000, v, w = 0;

	if(l == (-2147483647 - 1)) {
		strncpy(buf, "-2147483648", 12);
		return;
	} else if(l < 0) {
		buf[0] = '-';
		l = -l;
		i = 1;
	} else if(l == 0) {
		buf[0] = '0';
		buf[1] = 0;
		return;
	} else
		i = 0;

	while(i < len - 1 && div != 0) {
		if((v = l / div) || w) {
			buf[i++] = '0' + (char)v;
			w = 1;
		}

		l %= div;
		div /= 10;
	}

	buf[i] = 0;
}

#define DEC_BUFSIZE 12

int vsnprintf(char *str, natl size, const char *fmt, va_list ap)
{
	natl in = 0, out = 0, tmp;
	char *aux, buf[DEC_BUFSIZE];

	while(out < size - 1 && fmt[in]) {
		switch(fmt[in]) {
			case '%':
				switch(fmt[++in]) {
					case 'd':
						tmp = va_arg(ap, int);
						itostr(buf, DEC_BUFSIZE, tmp);
						if(strlen(buf) >
								size - out - 1)
							goto end;
						for(aux = buf; *aux; ++aux)
							str[out++] = *aux;
						break;
					case 'x':
						tmp = va_arg(ap, int);
						if(out > size - 11)
							goto end;
						htostr(&str[out], tmp);
						out += 10;
						break;
					case 's':
						aux = va_arg(ap, char *);
						while(out < size - 1 && *aux) 
							str[out++] = *aux++;
						break;	
				}
				++in;
				break;
			default:
				str[out++] = fmt[in++];
		}
	}
end:
	str[out] = 0;

	return out;
}

int snprintf(char *buf, size_t n, const char *fmt, ...)
{
	va_list ap;
	int l;

	va_start(ap, fmt);
	l = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return l;
}

int printf(const char *fmt, ...)
{
	va_list ap;
	char buf[1024];
	int l;

	va_start(ap, fmt);
	l = vsnprintf(buf, 1024, fmt, ap);
	va_end(ap);

	writeconsole(buf);

	return l;
}

char pause_buf[1];
natl pause_len = 1;
void pause()
{
#ifndef AUTOCORR
	writeconsole("Premere INVIO per continuare");
	readconsole(pause_buf, pause_len);
#endif
}


// copia n byte da src a dest
void *memcpy(void *dest, const void *src, unsigned int n)
{
	char       *dest_ptr = static_cast<char*>(dest);
	const char *src_ptr  = static_cast<const char*>(src);

	for (natl i = 0; i < n; i++)
		dest_ptr[i] = src_ptr[i];

	return dest;
}

// scrive n byte pari a c, a partire da dest
void *memset(void *dest, int c, unsigned int n)
{
	char *dest_ptr = static_cast<char*>(dest);

        for (natl i = 0; i < n; i++)
              dest_ptr[i] = static_cast<char>(c);

        return dest;
}

// log formattato
void flog(log_sev sev, const char *fmt, ...)
{
        va_list ap;
	const natl LOG_MSG_SIZE = 128;
        char buf[LOG_MSG_SIZE];

        va_start(ap, fmt);
        int l = vsnprintf(buf, LOG_MSG_SIZE, fmt, ap);
        va_end(ap);

        log(sev, buf, l);
}


struct des_mem {
	natl dimensione;
	des_mem* next;
};

des_mem* memlibera = 0;
natl mem_mutex;

void* mem_alloc(natl dim)
{
	natl quanti = (dim % sizeof(int) == 0) ? dim : ((dim + sizeof(int) - 1) / sizeof(int)) * sizeof(int);

	sem_wait(mem_mutex);
	
	des_mem *prec = 0, *scorri = memlibera;
	while (scorri != 0 && scorri->dimensione < quanti) {
		prec = scorri;
		scorri = scorri->next;
	}

	addr p = 0;
	if (scorri != 0) {
		p = scorri + 1; // puntatore al primo byte dopo il descrittore

		if (scorri->dimensione - quanti >= sizeof(des_mem) + sizeof(int)) {

			addr pnuovo = static_cast<natb*>(p) + quanti;
			des_mem* nuovo = static_cast<des_mem*>(pnuovo);

			nuovo->dimensione = scorri->dimensione - quanti - sizeof(des_mem);
			scorri->dimensione = quanti;

			nuovo->next = scorri->next;
			if (prec != 0) 
				prec->next = nuovo;
			else
				memlibera = nuovo;

		} else {

			if (prec != 0)
				prec->next = scorri->next;
			else
				memlibera = scorri->next;
		}
		
		scorri->next = reinterpret_cast<des_mem*>(0xdeadbeef);
		
	}

	sem_signal(mem_mutex);

	return p;
}

void free_interna(addr indirizzo, natl quanti);

void mem_free(void* p)
{
	if (p == 0) return;
	des_mem* des = reinterpret_cast<des_mem*>(p) - 1;
	sem_wait(mem_mutex);
	free_interna(des, des->dimensione + sizeof(des_mem));
	sem_signal(mem_mutex);
}

void free_interna(addr indirizzo, natl quanti)
{
	if (quanti == 0) return;
	des_mem *prec = 0, *scorri = memlibera;
	while (scorri != 0 && scorri < indirizzo) {
		prec = scorri;
		scorri = scorri->next;
	}
	if (prec != 0 && (natb*)(prec + 1) + prec->dimensione == indirizzo) {
		if (scorri != 0 && static_cast<natb*>(indirizzo) + quanti == (addr)scorri) {
			
			prec->dimensione += quanti + sizeof(des_mem) + scorri->dimensione;
			prec->next = scorri->next;

		} else {

			prec->dimensione += quanti;
		}
	} else if (scorri != 0 && static_cast<natb*>(indirizzo) + quanti == (addr)scorri) {
		des_mem salva = *scorri; 
		des_mem* nuovo = reinterpret_cast<des_mem*>(indirizzo);
		*nuovo = salva;
		nuovo->dimensione += quanti;
		if (prec != 0) 
			prec->next = nuovo;
		else
			memlibera = nuovo;
	} else if (quanti >= sizeof(des_mem)) {
		des_mem* nuovo = reinterpret_cast<des_mem*>(indirizzo);
		nuovo->dimensione = quanti - sizeof(des_mem);
		nuovo->next = scorri;
		if (prec != 0)
			prec->next = nuovo;
		else
			memlibera = nuovo;
	}
}

extern "C" natl end;

extern "C" void lib_init()
{
	mem_mutex = sem_ini(1);
	free_interna(&end, DIM_USR_HEAP);
}
