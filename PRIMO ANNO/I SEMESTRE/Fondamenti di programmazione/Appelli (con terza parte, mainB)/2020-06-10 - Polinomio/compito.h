#include <iostream>
#include <cstdlib>
using namespace std;

class Polinomio{
    int *coef;
    int grado;
public:
    // PRIMA PARTE
    Polinomio(int n, const int *vett);
    int valuta(int)const;
    friend ostream& operator<<(ostream&, const Polinomio&);
    ~Polinomio(){ delete[] coef; }

    // SECONDA PARTE
    operator bool()const;
    Polinomio  operator*(const Polinomio&)const;
    Polinomio& operator=(const Polinomio&);
};