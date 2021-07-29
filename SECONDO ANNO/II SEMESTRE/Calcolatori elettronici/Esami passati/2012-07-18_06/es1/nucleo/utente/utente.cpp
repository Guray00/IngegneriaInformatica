#line 1 "utente/prog/pchan.in"
#include <all.h>

const int N_SENDERS = 4;
const int N_RECEIVERS = 1;
const int NPROC = N_SENDERS + N_RECEIVERS;


#line 8 "utente/prog/pchan.in"
extern natl m1;
#line 8 "utente/prog/pchan.in"
natl finish[NPROC];

void g(int*);


void f(int x){
	g(&x);
}



struct conf {
	natl cid;
	natl msg;
	natl n_msg;
};

struct s{
	int i[4];
};

int f(s x){
	int sum=0;
	for(int j=0; j<4; j++){
		sum += x.i[j];
	}
	return sum;
}




conf config[NPROC];

void sender(natq a)
{
	for (unsigned i = 0; i < config[a].n_msg; i++) {
		printf("%d: invio %d a %d\n", a, config[a].msg+i, config[a].cid);
		channel_send(config[a].cid, config[a].msg+i);
	}
	sem_signal(finish[a]);
	terminate_p();
}

void receiver(natq a)
{
	for (unsigned i = 0; i < config[a].n_msg; i++) {
		natl m = channel_receive(config[a].cid);
		printf("%d: ricevuto %d\n", a, m);
	}
	sem_signal(finish[a]);
	terminate_p();
}

void mio_main(natq a)
#line 39 "utente/prog/pchan.in"
{
	for (int i = 0; i < NPROC; i++)
		finish[i] = sem_ini(0);

	natl cid = channel_init(4);
	if (cid == 0xFFFFFFFF) {
		flog(LOG_WARN, "allocazione channel fallita");
		terminate_p();
	}
	natl cid2 = channel_init(4);
	if (cid2 == 0xFFFFFFFF) {
		printf("allocazione secondo channel fallita\n");
	}
	config[0].cid = cid;
	config[0].msg  = 1234;
	config[0].n_msg  = 5;
	config[1].cid = cid;
	config[1].msg  = 4321;
	config[1].n_msg = 2;
	config[2].cid = cid;
	config[2].msg  = 555;
	config[2].n_msg = 2;
	config[3].cid = cid;
	config[3].msg  = 0;
	config[3].n_msg = 9;
	(void) activate_p(sender, 0, 45, LIV_UTENTE);
	(void) activate_p(sender, 1, 30, LIV_UTENTE);
	(void) activate_p(sender, 2, 20, LIV_UTENTE);
	(void) activate_p(receiver, 3, 35, LIV_UTENTE);

	config[4].cid = 16000;
	config[4].msg  = 333;
	config[4].n_msg = 1;
	(void) activate_p(sender, 4, 42, LIV_UTENTE);

	for (int i = 0; i < NPROC - 1; i++)
		sem_wait(finish[i]);
	pause();

	terminate_p();
}
natl m1;
#line 87 "utente/utente.cpp"

void main()
{
	m1 = activate_p(mio_main, 0, 100, LIV_UTENTE);

	terminate_p();}
