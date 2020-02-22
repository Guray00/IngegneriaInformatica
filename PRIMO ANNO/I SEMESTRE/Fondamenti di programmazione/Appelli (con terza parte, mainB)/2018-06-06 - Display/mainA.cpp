#include <iostream>
#include "compito.h"
using namespace std;

int main()
{
    // --- PRIMA PARTE --- //
    cout << "--- PRIMA PARTE ---" << endl;
    
    cout << "Test del costruttore:" << endl;
    Display d(4,6);
    cout << d << endl;

    cout << "Test di writeT:" << endl;
    d.writeT("Lazio");
    d.writeT("Toscana");
    d.writeT("Umbria");
    cout << d << endl;
    
    cout << "Altro test di writeT:" << endl;
    d.writeT("");
    d.writeT(NULL);
    d.writeT("Sardegna");
    d.writeT("Sicilia");
    cout << d << endl;

    cout << "Test del costruttore di copia:" << endl;
    Display d1(d);
    cout << d1 << endl;
        
    return 0;
}
