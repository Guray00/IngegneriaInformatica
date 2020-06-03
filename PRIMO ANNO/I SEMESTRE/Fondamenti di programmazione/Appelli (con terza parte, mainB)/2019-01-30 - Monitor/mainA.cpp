#include "compito.h"

int main()
{
    cout << "--- PRIMA PARTE --- " << endl;

    cout << "Test del costruttore:" << endl;
    Monitor m(4);
    cout << m << endl;

    cout << "Test di inserisci:" << endl;
    m.inserisci("pippo");
    m.inserisci("pluto");
    m.inserisci("paperino");
    cout << m << endl;
    
    cout << "Altro test di inserisci:" << endl;
    m.inserisci("paperone");
    m.inserisci("nonnapapera");
    m.inserisci("rockerduck");
    cout << m << endl;

//     // --- SECONDA PARTE --- //
//     cout << "--- SECONDA PARTE --- " << endl;
//     
//     cout << "Test del costruttore di copia:" << endl;
//     Monitor m1(m);
//     cout << m1 << endl;
// 
//     Monitor m2(3);
//     m2.inserisci("topolino");
//     m2.inserisci("gambadilegno");
// 
//     {
//         cout << "Test di operator+:" << endl;
//         Monitor m3 = m1 + m2;
//         cout << m3 << endl;
// 
//         m3.inserisci("qui");
//         m3.inserisci("quo");
//         m3.inserisci("qua");
//         cout << m3 << endl;
//         
//         cout << "Test del distruttore: " << endl;
//     }
//     cout << "(m3 e' stato distrutto)" << endl;

    return 0;
}
