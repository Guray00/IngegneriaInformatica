#ifndef COMPITO_H_INCLUDED
#define COMPITO_H_INCLUDED

#include <iostream>
using namespace std;

const int MAXCHAR = 20;
enum Priorita {ROSSO, GIALLO, VERDE, BIANCO};

struct elem {
    char nome[MAXCHAR+1];
    elem* pun;
};
typedef elem* Lista;

class ProntoSoccorso
{
    Lista p[4];         // una lista di pazienti per ogni livello
    int numPazienti;    // numero totale di pazienti

    // funzioni di utilita'
    void inserisci(Lista&, const char*);
    int estrai(Lista&, char*);
    void copia(Lista, Lista&);
    void distruggi(Lista&);
public:
    ProntoSoccorso();
    void ricovero(const char*, Priorita);
    int prossimo(char*);
    friend ostream& operator<< (ostream&, const ProntoSoccorso&);
    ProntoSoccorso(const ProntoSoccorso&);
    ProntoSoccorso& operator=(const ProntoSoccorso&);
    ~ProntoSoccorso();
};


#endif // COMPITO_H_INCLUDED
