#include <iostream>
using namespace std;
#include"zaino.h"
int main() {
    zaino z;
    cout << " scegliere le seguenti opzioni:" << endl;
    cout << "1) zaino intero, soltanto" << endl;
    cout << "2) Branch And Bound con zaino binario all'inizio" << endl;
    cout << "3) solo zaino binario" << endl;
    cout << "4) zaino intero + Branch And Bound con zaino binario all'inizio" << endl;
    cout << "altro: esci" << endl;
    int scelta;
    cin >> scelta;
    int Vs = 0, Vi = 0,pos_i = 0;
    switch(scelta) {
        case 1:     z.risolvi_zaino_intero(); break;
        case 2:     z.Branch_Bound(); break;
        case 3:     z.risolvi_zaino_binario(Vs,Vi,pos_i); break;
        case 4:     z.risolvi_zaino_intero(); cout << endl;z.Branch_Bound(); break;
    }
    return 0;
}
