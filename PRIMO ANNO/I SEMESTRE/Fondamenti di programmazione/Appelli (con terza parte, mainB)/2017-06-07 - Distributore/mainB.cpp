#include "compito.h"
#include <iostream>

using namespace std;

int main() {
    
    cout << endl << "--- PRIMA PARTE ---" << endl;
    // test costruttore
    cout << "Test costruttore" << endl;
    Distributore d(3);
    cout << d << endl;
    
    // test acquista
    cout << "Test acquista" << endl;
    d.acquista(12);
    d.acquista(30);
    d.acquista(1);   // fallisce
    d.acquista(26);  // fallisce
    d.acquista(24);
    cout << d << endl;
    
    // test aggiungi
    cout << "Test aggiungi" << endl;
    d.aggiungi(11,2);
    d.aggiungi(31,3);
    d.aggiungi(22,6);
    cout << d << endl;
    
    cout << "--- SECONDA PARTE ---" << endl;

    // test operator+
    cout << "Test operator+" << endl;
    cout << d + 2 << endl;
    
    // test distruttore
    {
        cout << "Test costr. di copia" << endl;
        Distributore d1(d);
        cout << d1 << endl;
    }
    cout << "(d1 e' stato distrutto)" << endl;

	cout << "--- TERZA PARTE (test aggiuntivi) ---" << endl;
	
	Distributore d2(-3);
	cout << d2 << endl;

	Distributore d3(1);
	cout << d3 << endl;
	d3.aggiungi(1,2);
	d3.acquista(12);
	d3.acquista(12);
	cout << d3 << endl;
	Distributore d4(d3 + 3);
	cout << d4 << endl;

    return 0;
}
