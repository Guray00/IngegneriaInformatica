// main.cpp
#include "compito.h"
using namespace std;

int main()
{
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test del costruttore:" << endl;
    AlberoDiNatale a(4);
    cout << a << endl;
    
    cout << "Test della aggiungiPallina:" << endl;
    a.aggiungiPallina('V', 1, 2);
    a.aggiungiPallina('R', 3, 0);
    a.aggiungiPallina('B', 0, 1);
    a.aggiungiPallina('V', 0, 2);
    a.aggiungiPallina('V', 1, 1);   // fallisce
    a.aggiungiPallina('V', 1, 2);   // fallisce
    a.aggiungiPallina('G', 0, 0);   // fallisce
    a.aggiungiPallina('R', 4, 0);   // fallisce
    a.aggiungiPallina('R', 1, 5);   // fallisce
    a.aggiungiPallina('B', -1, 2);  // fallisce
    a.aggiungiPallina('B', 2, -2);  // fallisce
    cout << a << endl;
    
    // --- SECONDA PARTE --- //
    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test operator+=: " << endl;
    cout << (a+=2) << endl;
    
    a.aggiungiPallina('B', 0, 2);
    a.aggiungiPallina('R', 1, 3);
    a.aggiungiPallina('R', 3, 0);
    cout << a << endl;
    
    cout << "Test della coloreMassimo: " << endl;
    cout << a.coloreMassimo() << endl << endl;
    
    cout << "Test del distruttore: " << endl;
    {
        AlberoDiNatale a1(3);
        a1.aggiungiPallina('R', 0, 1);
    }
    cout << "(a1 e' stato distrutto)" << endl;

    // --- TERZA PARTE --- //
    cout << endl << "--- TERZA PARTE ---" << endl;
    cout << "Test aggiuntivi operator+=:" << endl;
    cout << (a+=0) << endl;  // test += con argomento nullo
    cout << (a+=-3) << endl; // test += con argomento negativo
    cout << (a+=10) << endl; 
    
    // test coloreMassimo
    cout << "Test aggiuntivi coloreMassimo:" << endl;
    a.aggiungiPallina('V', 4, 0);
    a.aggiungiPallina('V', 0, 12);
    cout << a << endl;
    cout << a.coloreMassimo() << endl << endl;
    
    // test coloreMassimo con parita'
    a.aggiungiPallina('R', 2, 1);
    cout << a << endl;
    cout << a.coloreMassimo() << endl << endl;
    
    // test attributo const di coloreMassimo
    cout << "Test attributo const di coloreMassimo:" << endl;
    const AlberoDiNatale a2(3);
    cout << a2 << endl;
    cout << a2.coloreMassimo() << endl << endl;

    return 0;
}
