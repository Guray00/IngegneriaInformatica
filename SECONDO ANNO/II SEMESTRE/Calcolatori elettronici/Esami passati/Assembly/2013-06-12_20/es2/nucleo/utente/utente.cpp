#line 1 "utente/prog/phm.in"
#include <sys.h>
#include <lib.h>


#line 6 "utente/prog/phm.in"
extern int s1;
#line 7 "utente/prog/phm.in"
extern int s2;
#line 9 "utente/prog/phm.in"
natl pim;

void p1(int a)
{
	sem_wait(s1);
	sem_signal(s2);
	pim_wait(pim);
	printf("sezione critica %d", a);
	pim_signal(pim);
	printf("fine processo %d", a);
	terminate_p();
}

void p2(int a)
{
	sem_wait(s2);
	printf("fine processo %d", a);
	terminate_p();
}

void p3(int a)
{
	pim_wait(pim);
	printf("inizio sezione critica %d", a);
	sem_signal(s1);
	printf("fine sezione critica %d", a);
	pim_signal(pim);
	printf("fine processo %d", a);
	pause();
	terminate_p();
}

void mio_main(int a)
#line 42 "utente/prog/phm.in"
{
	pim = pim_init();
	(void) activate_p(p1, 1, 90, LIV_UTENTE);
	(void) activate_p(p2, 2, 89, LIV_UTENTE);
	(void) activate_p(p3, 3, 88, LIV_UTENTE);

	terminate_p();
}
short m1;
int s1;
int s2;

int main()
{
	m1 = activate_p(mio_main, 0, 100, LIV_UTENTE);
	s1 = sem_ini(0);
	s2 = sem_ini(0);

	terminate_p();
}
