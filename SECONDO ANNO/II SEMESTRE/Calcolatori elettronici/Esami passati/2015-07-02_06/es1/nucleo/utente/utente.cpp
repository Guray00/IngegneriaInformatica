#line 1 "utente/prog/pshmem.in"
#include <all.h>


#line 5 "utente/prog/pshmem.in"
extern natl init;
#line 5 "utente/prog/pshmem.in"
const int NSHMEM = 2;
const natl shmem_size[NSHMEM] = { 500, 1000 };
natl shmem[NSHMEM];

void shw(natq a)
{
	natl *shm = static_cast<natl*>(shmem_attach(shmem[a]));

	natl *ptr = shm;
	printf("shw: begin writing shmem %d\n", shmem[a]);
	for (natl i = 0; i < shmem_size[a]; i++) {
		*ptr += i + a;
		ptr += 1024;
	}
	printf("shw: end writing shmem %d\n", shmem[a]);
	terminate_p();
}

void shr(natq a)
{
	for (natl i = 0; i < NSHMEM; i++) {
		natl *shm = static_cast<natl*>(shmem_attach(shmem[i]));

		natl *ptr = shm;
		for (natl j = 0; j < shmem_size[i]; j++) {
			natl b = *ptr;
			if (b % 200 == i)
				printf("shr%d: read %d from shmem %d+%x\n", a, b, shmem[i], (ptr-shm)*4);
			(*ptr)++;
			ptr += 1024;
		}
	}
	terminate_p();
}

void last(natq a)
{
	pause();
	terminate_p();
}

void init_body(natq a)
#line 47 "utente/prog/pshmem.in"
{
	for (int i = 0; i < NSHMEM; i++)
		shmem[i] = shmem_create(shmem_size[i]);

	activate_p(shw, 0, 50, LIV_UTENTE);
	activate_p(shr, 1, 40, LIV_UTENTE);
	activate_p(shw, 1, 30, LIV_UTENTE);
	activate_p(shr, 2, 20, LIV_UTENTE);
	activate_p(last, 3, 10, LIV_UTENTE);

	terminate_p();
}
natl init;
#line 65 "utente/utente.cpp"

void main()
{
	init = activate_p(init_body, 0, 60, LIV_UTENTE);

	terminate_p();}
