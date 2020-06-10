#include "compito.h"

Polinomio::Polinomio(int gr, const int *vett) {
    if ( ( gr < 0 ) || ( vett == nullptr ) || (vett[0] == 0) )
        exit(1);

    grado = gr;
    coef = new int[grado + 1];
    for (int i = 0; i <= grado; i++)
        coef[i] = vett[i];
}


ostream& operator<<(ostream& os, const Polinomio& p){
    int i;
    for ( i = p.grado; i > 0; i-- )
        if (p.coef[p.grado-i] >= 0)
            os<<'+'<<p.coef[p.grado - i]<<"x^"<< i <<' ';  // in alternativa: os<<showpos;
        else
            os << p.coef[p.grado - i] << "x^" << i << ' ';
    if ( p.coef[p.grado - i] >= 0)
        os<<'+'<<p.coef[p.grado - i];
    else
        os<<p.coef[p.grado - i];

    return os;
}

int Polinomio::valuta(int x)const {
    int tot = coef[grado];
    int pot = x;
    for (int i = 1; i <= grado; i++) {
        tot += coef[grado - i] * pot;
        pot = pot * x;
    }
    return tot;
}

// Seconda parte
Polinomio::operator bool()const{
    // il primo coefficiente e' positivo o negativo (non puo' essere zero), 
    // quindi i segni del polinomio sono coerenti se gli altri coefficienti 
    // sono zero o hanno stesso segno del primo
    int aux = coef[0];
    for (int i = 1; i <= grado; i++){
        if ( coef[i] != 0 ) {
            if (aux * coef[i] < 0)
                return false; // il polinomio non ha coefficienti coerenti
            aux = coef[i];
        }
    }
    return true; // il pononomio è a coefficienti coerenti
}

Polinomio Polinomio::operator*(const Polinomio &p) const{

    int grado_prod = grado + p.grado;
    int *coef_prod = new int[ grado_prod + 1 ];

    // calcolo i prodotti dei singoli monomi, e poi sommo i monomi risultanti di grado uguale
    // il monomio coef[i] ha grado (grado-i) e il monomio p.coef[j] ha grado (p.grado-j), 
    // quindi il loro prodotto ha grado (grado+p.grado-i-j), che va in coef_prod[i+j].
    for (int i = 0; i <= grado_prod; i++)
        coef_prod[i] = 0;
    for (int i=0; i <= grado; i++)
        for (int j=0; j <= p.grado; j++)
            coef_prod[i+j] += coef[i]*p.coef[j];

    Polinomio Prod(grado_prod, coef_prod);
    delete [] coef_prod;

    return Prod;
}

Polinomio& Polinomio::operator=(const Polinomio &p){
    if ( this == &p )
        return *this;

    // se i polinomi hanno un numero diverso di coefficienti, 
    // rialloco il vettore dei coefficienti della dimensione giusta
    if ( grado != p.grado ){
        delete [] coef;
        coef = new int[p.grado + 1];
        grado = p.grado;
    }

    for (int i = 0; i <= grado; i++)
        coef[i] = p.coef[i];

    return *this;
}