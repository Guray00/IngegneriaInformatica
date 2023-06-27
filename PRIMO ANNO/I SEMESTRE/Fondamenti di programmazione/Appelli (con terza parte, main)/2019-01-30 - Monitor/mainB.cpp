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

    // --- SECONDA PARTE --- //
    cout << "--- SECONDA PARTE --- " << endl;
    
    cout << "Test del costruttore di copia:" << endl;
    Monitor m1(m);
    cout << m1 << endl;

    Monitor m2(3);
    m2.inserisci("topolino");
    m2.inserisci("gambadilegno");

    {
        cout << "Test di operator+:" << endl;
        Monitor m3 = m1 + m2;
        cout << m3 << endl;

        m3.inserisci("qui");
        m3.inserisci("quo");
        m3.inserisci("qua");
        cout << m3 << endl;
        
        cout << "Test del distruttore: " << endl;
    }
    cout << "(m3 e' stato distrutto)" << endl;

    
    // --- TERZA PARTE --- //
    cout << endl << "--- TERZA PARTE ---" << endl;
    
    cout << "Test aggiuntivo del costruttore (input negativo):" << endl;
    Monitor m4(-2);
    cout << m4 << endl;
    
    cout << "Test aggiuntivo del costruttore (input nullo):" << endl;
    Monitor m5(0);
    cout << m5 << endl;
    
    cout << "Test aggiuntivi di inserisci:" << endl;
    m5.inserisci("gastone");
    m5.inserisci(NULL);       // fallisce
    m5.inserisci(""); 
    m5.inserisci("minnie");
    cout << m5 << endl;
    
    cout << "Test aggiuntivi di operator+:" << endl;
    Monitor m6(5);
    Monitor m7 = m5 + m6;
    cout << m7 << endl;
    
    cout << "Test aggiuntivi del costr. di copia" << endl;
    Monitor m8(m6);
    cout << m8 << endl;
    
    return 0;
}
