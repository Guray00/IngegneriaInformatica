#include "compito.h"

int main(){

	cout << "\n--- PRIMA PARTE ---\n";

	cout << "\nTest del costruttore\n";    
    Mappa m;
    cout<<m<<endl;

	cout << "\nTest della aggiungi()\n";    
    m.aggiungi(ROSSO, 1.2, 2);
    cout<<m<<endl;
     
    m.aggiungi(VERDE, 1, 5.2);
    m.aggiungi(ROSSO, 7.2, 3);
    cout<<m<<endl;
	
	cout << "\nTest della elimina()\n";    
    m.elimina(1,5.2);
    cout<<m<<endl;
	
    /*
	cout << "\n--- SECONDA PARTE ---\n";

	cout << "\nTest della riduci()\n" << endl;
	m.riduci(1);
	cout << m << endl;

	m.riduci(5);
	cout << m << endl;
	
	cout << "\nTest del costruttore di copia (e stampa di m1)" << endl;

	m.aggiungi(GIALLO, 4.5, 2.6);
	m.aggiungi(GIALLO, 9.2, 11.4);
	m.aggiungi(VERDE, 3.2, 1.4);	
	cout << "Mappa m:\n" << m << endl;

	Mappa m1(m);
	cout << "Mappa m1:\n" << m1 << endl;

	{
		Mappa m2(m1);
		cout << "\nTest del distruttore (m2 sta per essere distrutto)\n" << endl;
	}
	*/

    return 0;
}

