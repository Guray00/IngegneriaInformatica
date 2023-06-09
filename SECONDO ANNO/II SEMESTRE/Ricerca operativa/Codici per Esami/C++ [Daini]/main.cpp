#include <iostream>
#include "grafo2.h"
using namespace std;
int main() {

    int dim;
    bool soddisfatto = false;
    while(!soddisfatto) {
        cout << "Scrivere il numero di nodi del grafo(da 0 a n-1): ";
        cin >> dim;
        cout << "Sicuro? Digitare 1 per confermare, 0, per ricominciare";
        cin >> soddisfatto;
        if(!soddisfatto)
            continue;
        // test
        grafo2 g(dim);
        g.stampa_grafo();
        cout << "Sei soddisfatto? Se si, digitare 1, altrimenti 0" << endl;
        cin >> soddisfatto;
        if(!soddisfatto)
            continue;

        while(true) {
            cout << endl;
            cout << "Digitare la partenza e la destinazione(da 0 a n-1): ";
            int partenza, arrivo;
            soddisfatto = false;
            while (!soddisfatto) {
                cin >> partenza;
                cin >> arrivo;
                cout << "Digitare 1 per confermare la scelta; 0, per ricominciare" << endl;
                cin >> soddisfatto;
            }
            bool errato = false;
            g.Cammini_Minimi(partenza, arrivo,errato);
            g.Ford_Furkersord(partenza, arrivo,errato);
            if(!errato) break;
        }
    }
    return 0;
}
