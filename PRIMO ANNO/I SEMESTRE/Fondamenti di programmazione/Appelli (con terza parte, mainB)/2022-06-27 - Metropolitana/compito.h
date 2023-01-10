#include <iostream>
using namespace std;

const int num_stazioni =  5;
const int max_utenti   = 50;
const int max_capienza = 99;

class Metropolitana {

    struct stazione{
        int utenti;
        int posti_liberi;
        int capienza;
        bool presenza_treno;
    };

    bool grafo[num_stazioni][num_stazioni];
    stazione stazioni[num_stazioni];

    //Funzioni di utilitÃ 
    void scarica_treno(int, stazione*);
    void carica_treno(stazione*);
    bool arrivo_treno(int, int, int, stazione*);

public:
    Metropolitana();
    friend ostream& operator<<(ostream&, const Metropolitana&);
    int aggiungi_utenti(int, int);
    bool aggiungi_treno(int, int);
    Metropolitana& aggiungi_connessione(int, int);
    bool rimuovi_treno(int);
    bool muovi_treno(int, int, int);    
    int operator!() const;
    Metropolitana& operator++();
};