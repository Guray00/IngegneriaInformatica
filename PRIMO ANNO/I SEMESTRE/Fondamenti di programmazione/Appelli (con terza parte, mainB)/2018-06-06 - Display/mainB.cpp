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
    
    // --- SECONDA PARTE --- //
    cout << "--- SECONDA PARTE ---" << endl;

    cout << "Test di writeW:" << endl;
    d1.writeW("EmiliaRomagna");
    d1.writeW("Marche");
    cout << d1 << endl;

    {
        cout << "Test dell'op. di assegnamento:" << endl;
        Display d2(2,7);
        d2 = d1;
        cout << d2 << endl;
        
        cout << "Test del distruttore:" << endl;
    }
    cout << "(d2 e' stato distrutto)" << endl << endl;
    
    // --- TERZA PARTE --- //
    cout << "--- TERZA PARTE ---" << endl;
    
    cout << "Test aggiuntivi del costruttore:" << endl;
    Display d3(0,0);     // non valido, crea un display 5x8
    cout << d3 << endl;
    
    Display d4(-7,2);    // non valido, crea un display 5x8
    cout << d4 << endl;
    
    cout << "Test aggiuntivi di writeW:" << endl;
    d4.writeW(NULL);
    d4.writeW("");
    d4.writeW("TrentinoAltoAdige");
    cout << d4 << endl;
    
    cout << "Test aggiuntivi dell'op. di assegnamento:" << endl;
    d4 = d4;             // ERRORE
    cout << d4 << endl;
    
    d4 = d1;  
    d4.writeW("Molise");
    cout << d4 << endl;
    
    d1.writeW("Campania");
    cout << d1 << endl;
        
    return 0;
}
