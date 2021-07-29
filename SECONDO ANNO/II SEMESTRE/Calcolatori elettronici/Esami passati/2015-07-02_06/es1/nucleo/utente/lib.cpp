#include <costanti.h>
#include <libce.h>
#include <sys.h>
#include <io.h>
#include "lib.h"

static const natq PRINTF_BUF = 1024;

int printf(const char *fmt, ...)
{
	va_list ap;
	char buf[PRINTF_BUF];
	int l;

	va_start(ap, fmt);
	l = vsnprintf(buf, PRINTF_BUF, fmt, ap);
	va_end(ap);

	writeconsole(buf, l);

	return l;
}

char pause_buf[1];
void pause()
{
#ifndef AUTOCORR
	printf("Premere un tasto per continuare");
	readconsole(pause_buf, 1);
#endif
}

natl getpid()
{
	return getmeminfo().pid;
}


extern "C" void panic(const char* msg)
{
	flog(LOG_WARN, "%s", msg);
	terminate_p();
}


natl mem_mutex;

void* operator new(size_t s)
{
	void *p;

	sem_wait(mem_mutex);
	p = alloca(s);
	sem_signal(mem_mutex);

	return p;
}


void operator delete(void* p)
{
	sem_wait(mem_mutex);
	dealloca(p);
	sem_signal(mem_mutex);
}

extern "C" natl end;

void lib_init() __attribute__((constructor));
void lib_init()
{
	mem_mutex = sem_ini(1);
	heap_init(allinea(&end, DIM_PAGINA), DIM_USR_HEAP);
}
