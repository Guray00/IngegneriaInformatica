#include <iostream>
#include "compito.h"
using namespace std;

int main()
{
    // --- PRIMA PARTE --- //
    cout << "--- PRIMA PARTE ---" << endl;
    
    cout << "Test del costruttore:" << endl;
    Rastrelliera r;
    cout << r;

    cout << "Test di carica e di calcolaPeso:" << endl;
    int* b1 = r.carica(4, 4, 3, 0);
    if (b1 != NULL)
        cout << "il peso del bilanciere b1 e': " << Rastrelliera::calcolaPeso(b1) << endl;
    else
        cout << "il bilanciere b1 e' scarico\n";
    cout << r;

    cout << "Altro test di carica e di calcolaPeso:" << endl;
    int* b2 = r.carica(0, 0, 8, 4);
    if (b2 != NULL)
        cout << "il peso del bilanciere b2 e': " << Rastrelliera::calcolaPeso(b2) << endl;
    else
        cout << "il bilanciere b2 e' scarico\n";
    cout << r;

    cout << "Test di scarica:" << endl;
    r.scarica(b1);
    cout << r;

//     // --- SECONDA PARTE --- //
//     cout << "\n--- SECONDA PARTE ---\n";
// 
//     cout << "Test di unisci:" << endl;
// 	int* b3 = r.carica(3, 3, 1, 0);
//     int* b4 = r.carica(2, 2, 0, 0);
//     int* b5 = Rastrelliera::unisci(b3, b4);
//     if (b5 != NULL)
//         cout << "il peso del bilanciere b5 e': " << Rastrelliera::calcolaPeso(b5) << endl;
//     else
//         cout << "il bilanciere b5 e' scarico\n";
//     cout << r;
// 
//     cout << "Test dell'op. di assegnamento:" << endl;
//     Rastrelliera r2;
//     r2 = r;
//     cout << r2;
    
    return 0;
}
