#line 1 "utente/prog/pmw.in"
#include <all.h>


#line 5 "utente/prog/pmw.in"
extern natl m1;
#line 5 "utente/prog/pmw.in"
extern natl chain1;
#line 6 "utente/prog/pmw.in"
extern natl chain2;
#line 7 "utente/prog/pmw.in"
extern natl chain3;
#line 8 "utente/prog/pmw.in"
extern natl chain4;
#line 10 "utente/prog/pmw.in"
extern natl sem1;
#line 11 "utente/prog/pmw.in"
extern natl sem2;
#line 13 "utente/prog/pmw.in"
void p_multi1(natq a)
{
	//printf("multi1 start\n");
	sem_wait(chain1);
	//printf("multi1 calling mw\n");
	sem_multiwait(sem1, sem2);
	printf("%d: sezione critica %d-%d\n", a, sem1, sem2);
	sem_signal(sem1);
	//printf("multi1 second signal\n");
	sem_signal(sem2);
	terminate_p();
}

void p_single1(natq a)
{
	//printf("single1 start\n");
	sem_wait(sem1);
	//printf("signal mult1\n");
	sem_signal(chain1);
	//printf("signal mult2\n");
	sem_signal(chain2);
	//printf("waiting single2\n");
	sem_wait(chain3);
	printf("%d: sezione critica %d\n", a, sem1);
	sem_signal(sem1);
	terminate_p();
}

void p_multi2(natq a)
{
	//printf("multi2 start\n");
	sem_wait(chain2);
	//printf("multi2 calling mw\n");
	sem_multiwait(sem2, sem1);
	sem_wait(chain4);
	printf("%d: sezione critica %d-%d\n", a, sem2, sem1);
	//printf("multi2 restart\n");
	sem_signal(sem2);
	//printf("multi2 second signal\n");
	sem_signal(sem1);
	terminate_p();
}

void p_single2(natq a)
{
	//printf("single2 start\n");
	sem_wait(sem2);
	//printf("single2 signal single1\n");
	sem_signal(chain3);
	printf("%d: sezione critica %d\n", a, sem2);
	sem_signal(sem2);
	terminate_p();
}

void p_single3(natq a)
{
	//printf("single3 start\n");
	sem_wait(sem2);
	printf("%d: sezione critica %d\n", a, sem1);
	sem_signal(sem2);
	terminate_p();
}

void p_single4(natq a)
{
	//printf("single4 start\n");
	sem_signal(chain4);
	pause();
	terminate_p();
}


void mio_main(natq a)
#line 86 "utente/prog/pmw.in"
{
	(void) activate_p(p_multi1, 3, 50, LIV_UTENTE);
	(void) activate_p(p_multi2, 3, 45, LIV_UTENTE);
	(void) activate_p(p_single1, 1, 40, LIV_UTENTE);
	(void) activate_p(p_single2, 2, 35, LIV_UTENTE);
	(void) activate_p(p_single3, 4, 30, LIV_UTENTE);
	(void) activate_p(p_single4, 5, 25, LIV_UTENTE);

	terminate_p();
}
natl m1;
natl chain1;
natl chain2;
natl chain3;
natl chain4;
natl sem1;
natl sem2;
#line 112 "utente/utente.cpp"

void main()
{
	m1 = activate_p(mio_main, 0, 100, LIV_UTENTE);
	chain1 = sem_ini(0);
	chain2 = sem_ini(0);
	chain3 = sem_ini(0);
	chain4 = sem_ini(0);
	sem1 = sem_ini(1);
	sem2 = sem_ini(1);

	terminate_p();}
