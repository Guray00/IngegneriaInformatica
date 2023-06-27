#include "compito.h"

Tartaglia::Tartaglia(int n) {
    ord = ( n < 1 ) ? 5: n;
    T = new unsigned int*[ord+1];
    for (int i = 0; i <= ord; i++){
        T[i] = new unsigned int[i+1];
        T[i][0] = T[i][i] = 1;
        for (int j = 1; j < i; j++) {
            T[i][j] = T[i-1][j-1]+T[i-1][j];
        }
    }
}

ostream& operator<<(ostream& os, const Tartaglia& t) {
    for (int i = 0; i <= t.ord; i++) {
        for (int j = 0; j <= i; j++)
            os << setw(5)<<t.T[i][j] ; // setw(5) allinea correttamente triangoli Tart. di ordine <= 15
        cout << endl;
    }
    return os;
}


int Tartaglia::fibonacci(int n) const{
   if ( n < 0 || n > ord )
       return -1;
   int tot = 0;
   int j = 0;
   for (int i = n; i >= (n+1)/2; i--)
        tot += T[i][j++];
   return tot;
}


// SECONDA PARTE

void Tartaglia::espandi(int n) const {
    if ( n <= 0 || n > ord )
         return;

    switch (n){
        case 0:
            cout << "{1}";
            break;
        case 1:
            cout << "{a^1 + b^1}";
            break;
        default:
            int j = 0;
            cout<<"{a^"<<n<< " + " ;
            for ( j = 1; j < n; j++)
                cout<<T[n][j]<<"a^"<<n-j<<"*b^"<<j<< " + " ;
            cout<<"b^"<<j<<'}';
    }
}

void Tartaglia::dealloca(){
    for (int i = 0; i <= ord; i++)
        delete[] T[i];
    delete[] T;
}
Tartaglia& Tartaglia::operator=(const Tartaglia&t){
    if (this != &t){
        if ( ord != t.ord) {
            dealloca();
            ord = t.ord;
            T = new unsigned int *[ord + 1];
            for (int i = 0; i <= ord; i++){
                T[i] = new unsigned int[i+1];
                for (int j = 0; j <= i; j++)
                     T[i][j] = t.T[i][j];
            }
        }
    }
    return *this;
}