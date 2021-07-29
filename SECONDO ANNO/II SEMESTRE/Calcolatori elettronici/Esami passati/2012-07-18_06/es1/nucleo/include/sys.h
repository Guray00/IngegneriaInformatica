extern "C" natl activate_p(void f(natq), natq a, natl prio, natl liv);
extern "C" void terminate_p();
extern "C" natl sem_ini(int val);
extern "C" void sem_wait(natl sem);
extern "C" void sem_signal(natl sem);
extern "C" void delay(natl n);
// ( ESAME 2012-07-18
extern "C" natl channel_init(natl dim);
extern "C" void channel_send(natl id, natl msg);
extern "C" natl channel_receive(natl id);
//   ESAME 2012-07-18 )

extern "C" void do_log(log_sev sev, const char* buf, natl quanti);

// informazioni a puro scopo di debug/correzione compiti
struct meminfo {
	natl heap_libero;
	natl num_frame_liberi;
	natl pid;
};

extern "C" meminfo getmeminfo();

