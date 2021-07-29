#line 1 "utente/prog/pintr.in"
/*
 * Prova interrupt/interrupted
 */

#include <all.h>

const int NPROC = 3;


#line 10 "utente/prog/pintr.in"
extern natl m1;
#line 10 "utente/prog/pintr.in"
natl p1, p2, p3, p4, p5, p6;
natl finish[NPROC];


void pm1(natq a)
{
	printf("%d: %d\n", a, delay2(10));
	sem_signal(finish[a]);
	terminate_p();
}

void pm3(natq a)
{
	if (interrupt(p1)) printf("3: interrupt OK\n");
	else 		   printf("3: interrupt failed\n");
	sem_signal(finish[a]);
	terminate_p();
}

void mio_main(natq a)
#line 30 "utente/prog/pintr.in"
{
	for (int i = 0; i < NPROC; i++)
		finish[i] = sem_ini(0);
	p1 = activate_p(pm1, 0, 40, LIV_UTENTE);
	p2 = activate_p(pm1, 1, 35, LIV_UTENTE);
	p3 = activate_p(pm3, 2, 30, LIV_UTENTE);
	for (int i = 0; i < NPROC; i++)
		sem_wait(finish[i]);
	pause();

	terminate_p();
}
natl m1;
#line 49 "utente/utente.cpp"

void main()
{
	m1 = activate_p(mio_main, 0, 100, LIV_UTENTE);

	terminate_p();}
