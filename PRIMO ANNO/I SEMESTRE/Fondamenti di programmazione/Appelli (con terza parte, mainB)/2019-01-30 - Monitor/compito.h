#ifndef COMPITO_H_INCLUDED
#define COMPITO_H_INCLUDED

#include <iostream>
#include <cstring>

using namespace std;
const int MAXLEN = 10;

class Monitor
{
    // il monitor e' implementato come un coda (array circolare) di stringhe dinamiche
    char** mntr;
    int dim;
    int front, back;
    
    // mascheramento operatore di assegnamento (impedisce la chiamata m1=m1+m2; )
    Monitor& operator=(const Monitor&);
    
public:
    Monitor(int);
    void inserisci (const char*);
    friend  ostream& operator <<(ostream&, const Monitor&);
    
    // SECONDA PARTE
    Monitor(const Monitor&);
    friend  Monitor operator+(const Monitor&, const Monitor&);
    ~Monitor();
};

#endif // COMPITO_H_INCLUDED
