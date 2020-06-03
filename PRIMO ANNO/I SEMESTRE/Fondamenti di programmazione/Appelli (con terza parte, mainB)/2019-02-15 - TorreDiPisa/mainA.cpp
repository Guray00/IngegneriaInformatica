#include "compito.h"

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

/*
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
*/
    return 0;
}
