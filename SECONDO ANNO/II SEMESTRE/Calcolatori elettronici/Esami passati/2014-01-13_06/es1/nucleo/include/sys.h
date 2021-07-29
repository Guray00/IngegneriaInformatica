extern "C" natl activate_p(void f(natq), natq a, natl prio, natl liv);
extern "C" void terminate_p();
extern "C" natl sem_ini(int val);
extern "C" void sem_wait(natl sem);
extern "C" void sem_signal(natl sem);
extern "C" void delay(natl n);

extern "C" void do_log(log_sev sev, const char* buf, natl quanti);

// informazioni a puro scopo di debug/correzione compiti
struct meminfo {
	natl heap_libero;
	natl num_frame_liberi;
	natl pid;
};

extern "C" meminfo getmeminfo();

// ( ESAME 2014-01-13
extern "C" void sem_multiwait(natl sem1, natl sem2);
//   ESAME 2014-01-13 )
