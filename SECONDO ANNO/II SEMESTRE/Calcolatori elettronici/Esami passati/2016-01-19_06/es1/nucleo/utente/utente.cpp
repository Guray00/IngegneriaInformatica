#line 1 "utente/prog/ppipe.in"
#include <all.h>


#line 5 "utente/prog/ppipe.in"
extern natl init;
#line 5 "utente/prog/ppipe.in"
const int DIMBUF = 10;
char src[DIMBUF];
char dst[DIMBUF];

void writer(natq p)
{
	for (int i = 0; i < DIMBUF; i += 5) {
		printf("writer: invio %d byte\n", 5);
		writepipe(p, src + i, 5);
	}
	printf("writer: termino\n");
	terminate_p();
}

void reader(natq p)
{
	for (int i = 0; i < DIMBUF; i += 2) {
		printf("reader: ricevo %d byte\n", 2);
		readpipe(p, dst + i, 2);
	}
	printf("reader: termino\n");
	terminate_p();

}

void last(natq a)
{
	pause();
	terminate_p();
}

void init_body(natq a)
#line 37 "utente/prog/ppipe.in"
{
	natl p = inipipe();
	activate_p(writer, p, 50, LIV_UTENTE);
	activate_p(reader, p, 20, LIV_UTENTE);
	activate_p(last, 3, 10, LIV_UTENTE);

	terminate_p();
}
natl init;
#line 51 "utente/utente.cpp"

void main()
{
	init = activate_p(init_body, 0, 60, LIV_UTENTE);

	terminate_p();}
