#include "compito.h"
#include <iostream>
using namespace std;

int main() 
{
    // --- PRIMA PARTE --- //
    cout << "--- PRIMA PARTE --- " << endl;

    cout << "Test del costruttore:" << endl;
    TorreDiPisa t(10);
    cout << t << endl;

    cout << "Test di operatore +=:" << endl;
    t += 3;
    t += 4;
    t += 7;
    cout << t << endl;
    t += 12; // troppa pendenza
    t += 6;  // troppa poca
    cout << t << endl;

    cout << "Test di operatore int():" << endl;
    cout << "Pendenza media: " << int(t) << endl;

    // --- SECONDA PARTE --- //
    cout << endl << "--- SECONDA PARTE --- " << endl;

    cout << "Test di operatore ++:" << endl;
    cout << t++ << endl << t << endl;
    t++; // troppa pendenza
    cout << t << endl;

    cout << "Test di stabilizza:" << endl;
    t.stabilizza();
    cout << t << endl;

    {
        TorreDiPisa t2(5);
        cout << "Test del distruttore: " << endl;
    }
    cout << "(t2 e' stato distrutto)" << endl;

    // --- TERZA PARTE --- //
    cout << endl << "--- TERZA PARTE ---" << endl;

    cout << "Test aggiuntivo del costruttore (input negativo):" << endl;
    TorreDiPisa t3(-4);
    cout << t3 << endl;

    cout << "Test aggiuntivo di operatore += (input negativo):" << endl;
    TorreDiPisa t4(4);
    t4 += -3;
    cout << t4 << endl;

    cout << "Test aggiuntivo di operatore += (troppi loggiati):" << endl;
    t4 += 1;
    t4 += 2;
    t4 += 3;
    t4 += 4;
    t4 += 5; // troppi loggiati
    cout << t4 << endl;

    cout << "Test aggiuntivo di operatore ++ (nessun loggiato):" << endl;
    TorreDiPisa t5(3);
    t5++;
    cout << t5 << endl;

    cout << "Test aggiuntivo di stabilizza (nessun loggiato):" << endl;
    t5.stabilizza();
    cout << t5 << endl;

    cout << "Test aggiuntivo di operatore ++ (primo loggiato con pendenza relativa massima):" << endl;
    t5 += 4;
    t5++;
    cout << t5 << endl;

    return 0;
}
