#ifndef COMPITO_H_INCLUDED
#define COMPITO_H_INCLUDED
#include <iostream>
using namespace std;

const int N = 5; // capacita' della sala eventi

enum tipo {GOLD, SILVER}; // tipo di abbonamento

struct cliente { // cliente: identificatore e tipo abbonamento
    int id;
    tipo t;
};

struct Ammessi { // elenco degli ammessi
    cliente elenco[N]; // elenco[i] specifica un cliente ammesso
    int quanti; // tra 0 e N
};

struct elem { // elemento di una lista di clienti
    cliente info;
    elem* next;
};

typedef elem* Lista;

class Prenotazione {
    friend ostream& operator<<(ostream&, const Prenotazione&);
    Lista gold;
    Lista silver;
    bool aperta;
public:
    Prenotazione();
    void prenota(int cli, tipo ti);
    void cancella(int cli, tipo ti);
    operator int()const;
    Ammessi chiudi();
    ~Prenotazione();
};


#endif // COMPITO_H_INCLUDED
