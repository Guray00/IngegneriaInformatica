#include <iostream>
#include "compito.h"
using namespace std;

int main() {
    cout <<"--- PRIMA PARTE ---" << endl;

    cout << "Test del costruttore e dell'operatore di uscita" << endl;
    Occorrenze o("CHE FAI TU LUNA IN CIEL DIMMI CHE FAI SILENZIOSA LUNA");
    cout << o << endl;

    cout << "Test dell'operatore di modulo: (deve stampare 3)" << endl;
    cout << o % 2 << endl << endl;


    cout <<"--- SECONDA PARTE ---" << endl;

    cout << "Test dell'operatore di somma ed assegnamento: (LUNA:3, DAMMI:1)" << endl;
    o += "LUNA";
    o += "DAMMI";
    cout << o << endl;

    cout << "Test dell'operatore parentesi quadra:" << endl;
    cout << "-> numero di occorrenze della parola LUNA (deve stampare 3): " << o["LUNA"] << endl;
    cout << "-> numero di occorrenze della parola CHE  (deve stampare 2): " << o["CHE"] << endl <<endl;

    cout << "Test dell'operatore di sottrazione e assegnamento (rimuove DAMMI e DIMMI):" << endl;
    o -= 'D';
    cout << o << endl;

    cout << "Test del distruttore ('o' sta per essere distrutto)" << endl;
}
