#include "compito.h"

Distributore::Distributore(int N) {
    if (N<=0 || N>9)
        N = 3;
    
    numRipiani = N;
    mat = new int[numRipiani * MAX_SLOT];
    for (int i=0;i<numRipiani*MAX_SLOT; i++)
        mat[i] = 1;
}

bool Distributore::acquista(int i) {
    // ottieni coordinate
    int r = i / 10;
    int c = i % 10;
    
    // controllo ingresso
    if (r < 1 || r > numRipiani || c >= MAX_SLOT)
        return false;
    
    if (mat[(r-1)*MAX_SLOT+c] > 0) {
        mat[(r-1)*MAX_SLOT+c]--;
        return true;
        }
    return false;
}

void Distributore::aggiungi(int i, int n) {
    if (n<1)
       return;
    
    // ottieni coordinate
    int r = i / 10;
    int c = i % 10;
    
    // controllo
    if (r < 1 || r > numRipiani || c >= MAX_SLOT)
        return;

    while (mat[(r-1)*MAX_SLOT+c] < MAX_PEZZI && n > 0) {
        mat[(r-1)*MAX_SLOT+c]++;
        n--;
    }
}

ostream& operator<<(ostream& os, const Distributore& d) {
    for (int r = 0; r < d.numRipiani; r++) {
        os << r+1 << ":";
        for (int c = 0; c < MAX_SLOT; c++) {
            os << " " << d.mat[r*MAX_SLOT+c];
        }
        os << endl;
    }
    return os;
}

Distributore Distributore::operator+(int n) {
    if (n < 1)  
       n=1;     
    int quanti = numRipiani + n;
    Distributore nuovo(quanti);
    int i;
    for(i=0; i< numRipiani; i++)
      for (int j=0; j< MAX_SLOT; j++)
        nuovo.mat[i*MAX_SLOT+j] = mat[i*MAX_SLOT+j];
    
    for(; i< quanti; i++)
      for (int j=0; j< MAX_SLOT; j++)
        nuovo.mat[i*MAX_SLOT+j] = 0;
    return nuovo;    
}

Distributore::Distributore(const Distributore& d) {
    numRipiani = d.numRipiani;
    mat = new int[numRipiani*MAX_SLOT];
    for (int i=0;i<numRipiani*MAX_SLOT; i++)
        mat[i] = d.mat[i];
    
}

Distributore::~Distributore() {
    delete[] mat;
}
