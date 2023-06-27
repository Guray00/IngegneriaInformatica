//
// Created by alex on 01/07/2020.
//

#ifndef ESAME1LUGLIO_COMPITO_H
#define ESAME1LUGLIO_COMPITO_H
#include <iostream>
#include <cstring>
using namespace std;

const int MAX_CHAR = 30;

struct parola {
    char c[MAX_CHAR+1];
    int o;
    parola* next;
};

class Occorrenze {
    parola* p0;
public:
    //PRIMA PARTE
    Occorrenze(const char*);
    int operator%(int)const;
    friend ostream&operator<<(ostream&, const Occorrenze&);
    //SECONDA PARTE
    Occorrenze& operator+=(const char*);
    int operator[](const char*)const;
    Occorrenze& operator-=(const char);
    ~Occorrenze();
};


#endif //ESAME1LUGLIO_COMPITO_H

// fine file
