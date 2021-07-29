#line 1 "utente/prog/prr.in"
#include <all.h>

const int NPROC = 4;


#line 6 "utente/prog/prr.in"
extern natl m1;
#line 6 "utente/prog/prr.in"
natl finish[NPROC];
natl flag[NPROC - 1];


void p0(natq a)
{
	printf("Processo %d: inizio\n", a);
	while (!flag[a])
		;
	printf("Processo %d: termino\n", a);
	sem_signal(finish[a]);
	terminate_p();
}

void pi(natq a)
{
	printf("Processo %d: inizio\n", a);
	while (!flag[a])
		;
	flag[a-1] = 1;
	printf("Processo %d: termino\n", a);
	sem_signal(finish[a]);
	terminate_p();
}

void pn(natq a)
{
	printf("Processo %d: inizio\n", a);
	flag[a-1] = 1;
	printf("Processo %d: termino\n", a);
	sem_signal(finish[a]);
	terminate_p();
}


void mio_main(natq a)
#line 42 "utente/prog/prr.in"
{
	for (int i = 0; i < NPROC; i++)
		finish[i] = sem_ini(0);
	abilita_rr();
	activate_p(p0, 0, 40, LIV_UTENTE);
	for (int i = 1; i < NPROC - 1; i++)
		activate_p(pi, i, 40, LIV_UTENTE);
	activate_p(pn, NPROC-1, 40, LIV_UTENTE);
	for (int i = 0; i < NPROC; i++)
		sem_wait(finish[i]);
	disabilita_rr();
	pause();

	terminate_p();
}
natl m1;
#line 64 "utente/utente.cpp"

void main()
{
	m1 = activate_p(mio_main, 0, 100, LIV_UTENTE);

	terminate_p();}
