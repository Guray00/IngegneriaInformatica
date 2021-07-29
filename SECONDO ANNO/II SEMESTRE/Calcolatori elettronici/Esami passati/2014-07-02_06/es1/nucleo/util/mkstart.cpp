#include <fstream>
#include <iomanip>
#include <costanti.h>
#include <tipo.h>
#include <vm.h>

using namespace std;

typedef unsigned long natq;

int main()
{
	natq start_io = norm(((natq)I_MIO_C << 39UL));
	natq start_utente = norm(((natq)I_UTN_C << 39UL));

	ofstream startmk("util/start.mk");
	startmk << "MEM=" << MEM_TOT/MiB << endl;
	startmk << hex;
	startmk << "START_IO=0x"      << start_io << endl;
	startmk << "START_UTENTE=0x"  << start_utente << endl;
	startmk.close();

	//ofstream startgdb("util/start.gdb");
	//startgdb << "set $START_IO="      << start_io + 0x120 << endl;
	//startgdb << "set $START_UTENTE="  << start_utente + 0x120 << endl;
	//startgdb.close();

	ofstream startpl("util/start.pl");
	startpl << hex;
	startpl << "$START_IO='"      << setw(16) << setfill('0') << start_io << "';" << endl;
	startpl << "$START_UTENTE='"  << setw(16) << setfill('0') << start_utente << "';" << endl;
	startpl << "1;" << endl;
	startpl.close();

	return 0;
}
