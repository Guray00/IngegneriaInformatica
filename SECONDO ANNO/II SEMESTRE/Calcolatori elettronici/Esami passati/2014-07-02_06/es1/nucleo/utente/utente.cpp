#line 1 "utente/prog/pbarrier.in"
#include <all.h>


#line 4 "utente/prog/pbarrier.in"
extern natl pbarrier;
#line 4 "utente/prog/pbarrier.in"
extern natl sync1;
#line 5 "utente/prog/pbarrier.in"
extern natl sync2;
#line 6 "utente/prog/pbarrier.in"
extern natl sync3;
#line 8 "utente/prog/pbarrier.in"
void notreg(natq a)
{
	barrier();
	printf("processo errato %d\n", a);
	terminate_p();
}

void b1(natq a)
{
	sem_wait(sync1);
	printf("processo %d: reg\n", a);
	reg();
	sem_wait(sync1);
	printf("processo %d: dereg\n", a);
	dereg();
	printf("processo %d: after dereg\n", a);
	sem_wait(sync1);
	printf("processo %d: reg\n", a);
	reg();
	sem_wait(sync1);
	printf("processo %d: barrier approach\n", a);
	barrier();
	printf("processo %d: barrier leave\n", a);
	sem_wait(sync1);
	printf("processo %d: terminate\n", a);
	terminate_p();
}

void b2(natq a)
{
	sem_wait(sync2);
	printf("processo %d: reg\n", a);
	reg();
	sem_wait(sync2);
	printf("processo %d: barrier approach\n", a);
	barrier();
	printf("processo %d: barrier leave\n", a);
	sem_wait(sync2);
	printf("processo %d: dereg\n", a);
	dereg();
	printf("processo %d: after dereg\n", a);
	sem_wait(sync2);
	printf("processo %d: reg\n", a);
	reg();
	sem_wait(sync2);
	printf("processo %d: dereg\n", a);
	dereg();
	printf("processo %d: after dereg\n", a);
	sem_wait(sync2);
	printf("processo %d: terminate\n", a);
	terminate_p();
}

void b3(natq a)
{
	sem_wait(sync3);
	printf("processo %d: reg\n", a);
	reg();
	sem_wait(sync3);
	printf("processo %d: barrier approach\n", a);
	barrier();
	printf("processo %d: barrier leave\n", a);
	sem_wait(sync3);
	printf("processo %d: barrier approach\n", a);
	barrier();
	printf("processo %d: barrier leave\n", a);
	sem_wait(sync3);
	printf("processo %d: barrier approach\n", a);
	barrier();
	printf("processo %d: barrier leave\n", a);
	sem_wait(sync3);
	printf("processo %d: terminate\n", a);
	terminate_p();
}

void conductor(natq a)
{
	sem_signal(sync1);
	sem_signal(sync2);
	sem_signal(sync3);
	sem_signal(sync2);
	sem_signal(sync3);
	sem_signal(sync1);
	sem_signal(sync2);
	sem_signal(sync3);
	sem_signal(sync2);
	sem_signal(sync1);
	sem_signal(sync1);
	sem_signal(sync2);
	sem_signal(sync3);
	sem_signal(sync1);
	sem_signal(sync2);
	sem_signal(sync3);
	pause();
	terminate_p();
}

void main_body(natq a)
#line 106 "utente/prog/pbarrier.in"
{
	activate_p(notreg, 1, 50, LIV_UTENTE);
	activate_p(b1, 1, 29, LIV_UTENTE);
	activate_p(b2, 2, 30, LIV_UTENTE);
	activate_p(b3, 3, 28, LIV_UTENTE);
	activate_p(conductor, 4, 10, LIV_UTENTE);

	terminate_p();
}
natl pbarrier;
natl sync1;
natl sync2;
natl sync3;
#line 127 "utente/utente.cpp"

void main()
{
	pbarrier = activate_p(main_body, 0, 100, LIV_UTENTE);
	sync1 = sem_ini(0);
	sync2 = sem_ini(0);
	sync3 = sem_ini(0);

	terminate_p();}
