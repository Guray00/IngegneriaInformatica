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
}

