#ifndef COMPITO_H_INCLUDED
#define COMPITO_H_INCLUDED

#include <iostream>
using namespace std;

enum DISCO { GIALLO=1, VERDE=2, ROSSO=3, NERO=4 };

class Rastrelliera 
{
    
    int dischi[4];
  
    friend ostream& operator<<(ostream&, const Rastrelliera&);
public:
    Rastrelliera(int ng = 10, int nv = 10, int nr = 10, int nn = 10);
    Rastrelliera(const Rastrelliera&);
    int* carica(int, int, int, int);
    void scarica(int* b);
    Rastrelliera& operator=(const Rastrelliera&);
    static int calcolaPeso(int*);
    static int* unisci(int*, int*);
};

#endif // COMPITO_H_INCLUDED
