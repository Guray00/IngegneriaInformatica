#include "compito.h"
#include <iostream>

using namespace std;

int main() {
    
    cout << "--- PRIMA PARTE ---" << endl;
    // test costruttore
    Barriera b1;
    cout <<  b1 << endl;
    
    // test nuovoVeicolo
    b1.nuovoVeicolo("AAABBB");
    b1.nuovoVeicolo("CCCDDD");
    b1.nuovoVeicolo("EEEFFF");
    b1.nuovoVeicolo("GGGHHH");
    b1.nuovoVeicolo("ab159Z"); // fallisce!
    b1.nuovoVeicolo("IIIJJJ");
    cout << b1 << endl;
    
    // test serviVeicolo
    b1.serviVeicolo(1);
    b1.serviVeicolo(1);
	b1.serviVeicolo(3);
    b1.serviVeicolo(4);   // non fa niente
    cout << b1 << endl;
    
    cout << "--- SECONDA PARTE ---" << endl;

    // test apriOppureChiudi
    int ret = b1.apriOppureChiudi(1.0);
    cout << "apriOppureChiudi: " << ret << " caselli aperti" << endl;
    cout << b1 << endl;
    
    b1.nuovoVeicolo("KKKLLL");
    b1.nuovoVeicolo("MMMNNN");
    b1.nuovoVeicolo("OOOPPP");    
    cout << b1 << endl;
    
    ret = b1.apriOppureChiudi(2.0);
    cout << "apriOppureChiudi: " << ret << " caselli aperti" << endl;	
    cout << b1 << endl;
    
    // test operator int
    cout << "Sono presenti " << int(b1) << " veicoli alla barriera" << endl;
    
    // test distruttore
    {
		cout<<endl<<"Test del distruttore sull'oggetto b2"<<endl;
        Barriera b2;
        b2.nuovoVeicolo("QQQRRR");
        cout << b2 << endl;
    }
    cout << "(b2 e' stato distrutto)" << endl;
	
	// TERZA PARTE
	cout << "--- TERZA PARTE ---" << endl;
	b1.nuovoVeicolo("SSSTTT");
	cout << b1 << endl;

	cout << "Altro test apriOppureChiudi:" << ret << " caselli aperti" << endl;
	ret = b1.apriOppureChiudi(1.0);
	cout << b1 << endl;

    return 0;
}
