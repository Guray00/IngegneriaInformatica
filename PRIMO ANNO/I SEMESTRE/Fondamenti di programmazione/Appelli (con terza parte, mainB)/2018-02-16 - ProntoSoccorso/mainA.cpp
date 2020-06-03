#include <iostream>
#include "compito.h"
using namespace std;

int main()
{
    // --- PRIMA PARTE --- //
    cout << "---PRIMA PARTE---" << endl;
    
    cout << "Test del costruttore di default:" << endl;
    ProntoSoccorso ps;
    cout << ps << endl;

    cout << "Test di ricovero:" << endl;
    ps.ricovero("Mario Rossi", ROSSO);
    ps.ricovero("Maria Neri", BIANCO);
    ps.ricovero("Paolo Verdi", VERDE);
    ps.ricovero("Giuseppe Gialli", ROSSO);
    cout << ps << endl;

    cout << "Test di prossimo:" << endl;
    char prossimo[21];
    ps.prossimo(prossimo);
    cout << "Prossimo: " << prossimo << endl;
    ps.prossimo(prossimo);
    cout << "Prossimo: " << prossimo << endl;
    ps.prossimo(prossimo);
    cout << "Prossimo: " << prossimo << endl << endl;
    cout << ps << endl;

//     // --- SECONDA PARTE --- //
//     cout << "---SECONDA PARTE---" << endl;
//     
//     cout << "Test dell'operatore =:" << endl;
//     ProntoSoccorso ps1;
//     ps1 = ps;
//     cout << ps1 << endl;
//     
//     {
//         ps1.ricovero("Carlo Bianchi", BIANCO);
//         ps1.ricovero("Luigi Viola", VERDE);
//         
//         cout << "Test del costruttore di copia:" << endl;
//         ProntoSoccorso ps2(ps1);
//         cout << ps2 << endl;
//    
//         cout << "Test del distruttore:" << endl;
//     }
//     cout << "(ps2 e' stato distrutto)" << endl << endl;
    
    return 0;
}
