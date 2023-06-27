#include <iostream>
#include "compito.h"

using namespace std;

int main()
{
    cout << "---PRIMA PARTE---" << endl;
    cout << "Test costruttore e operatore uscita:" << endl;
    Prenotazione p;
    cout << p << endl;

    cout << "Test funzione prenota:" << endl;
    for (int i = 1; i <= 6; i++)
        p.prenota(i, GOLD);
    for (int i = 7; i <= 13; i++)
        p.prenota(i, SILVER);
    cout << p << endl;

    cout << "Test funzione cancella:" << endl;
    p.cancella(2, GOLD);
    p.cancella(3, GOLD);
    p.cancella(4, GOLD);
    p.cancella(5, GOLD);
    p.cancella(13, GOLD);   
    p.cancella(7, SILVER);
    p.cancella(5, SILVER);  
    cout << p << endl;
   
    return 0;
}

