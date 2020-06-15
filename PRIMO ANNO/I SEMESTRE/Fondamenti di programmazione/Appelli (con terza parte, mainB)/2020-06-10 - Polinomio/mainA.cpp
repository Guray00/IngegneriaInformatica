#include <iostream>
#include "compito.h"

// ATTENZIONE! Per la soluzione di questo compito e'
// vietato utilizzare la funzione pow di <cmath>

int main() {

    // PRIMA PARTE
    const int vett[] = {-3, 7, -4};
    Polinomio P(2, vett); // crea il seguente polinomio di grado 2: P(x) = -3x^2 +7x^1 -4
    cout << "P(x) = " << P << endl << endl;

    cout << "Valuto il polinomio P(x) in x=3: " << endl;
    cout << "P(3) = " << P.valuta(3) << endl << endl; // deve stampare -10
    {
        Polinomio P2(2, vett);
        cout << "Test distruttore:" << endl;
    }
    cout << "distruttore invocato." << endl;

    /*
    // SECONDA PARTE
    cout << "Test dell'operatore di conv. a bool ('caso coeff. incoerenti')" << endl << endl;
    if ( P )
        cout << "Il polinomio P(x) ha coefficienti coerenti" << endl << endl;
    else
        cout << "Il polinomio P(x) ha coefficienti incoerenti" << endl << endl; // OK

    const int vett2[] = {+2, -3, +5, -1};
    Polinomio P3(3, vett2);  // P3(x) = +2x^3 -3x^2 +5x -1
    cout << "P3(x) = " << P3 << endl << endl;

    cout << "Prodotto di P*P3 (deve stampare '-6x^5 +23x^4 -44x^3 +50x^2 -27x^1 +4')" << endl;
    cout << P * P3 << endl << endl;

    P3 = P;
    cout << "Nuovo P3(x) = " << P3 << endl;
	*/
    
}
