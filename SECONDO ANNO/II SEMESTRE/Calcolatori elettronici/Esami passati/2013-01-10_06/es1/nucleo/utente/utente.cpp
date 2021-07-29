#line 1 "utente/prog/pjoin.in"
#include <all.h>


#line 5 "utente/prog/pjoin.in"
extern natl m1;
#line 5 "utente/prog/pjoin.in"
void child(natq a)
{
	printf("figlio %d: termino\n", a);
	terminate_p();
}

void father(natq a)
{
	(void) activate_p(child, 3, 30, LIV_UTENTE);
	printf("padre %d: termino\n", a);
	terminate_p();
}

void mio_main(natq a)
#line 19 "utente/prog/pjoin.in"
{
	(void) activate_p(child, 1, 90, LIV_UTENTE);
	(void) activate_p(child, 2, 91, LIV_UTENTE);
	for (int i = 0; i < 2; i++) {
		printf("attendo terminazione figlio\n");
		join();
	}
	(void) activate_p(father, 1, 50, LIV_UTENTE);
	printf("attendo terminazione padre\n");
	join();
	pause();

	terminate_p();
}
natl m1;
#line 39 "utente/utente.cpp"

void main()
{
	m1 = activate_p(mio_main, 0, 100, LIV_UTENTE);

	terminate_p();}
