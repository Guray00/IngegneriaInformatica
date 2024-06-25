#include <iostream>
using namespace std;

class Wordle {

    struct tentativo{
        char* sequenza;
        char* risultato;
        tentativo* prossimo;
    };

    static const int lunghezza_default = 5;
    static const int tentativi_default = 6;

    int lunghezza;
    int tentativi_rimanenti;

    char* sequenza_segreta;

    bool gioco_avviato;

    tentativo* storico;

    bool corretta_formattazione(const char *sequenza) const;
    bool inizializza_risultato(const char *sequenza_tentata, char * risultato) const;
    tentativo* inizializza_tentativo(const char *sequenza_tentata) const;
    void inserisci_tentativo(tentativo* nuovo_tentativo);
    static void distruggi_tentativo(tentativo* t);
    void distruggi_storico();
    void copia_tentativo(tentativo* t, const tentativo *t1) const;
    void stampa_tentativo(ostream& os, const tentativo* t, bool stampa_storico, unsigned posizione_storico) const;

    Wordle(const Wordle&);

public:

    Wordle(int n, int max_t);
    ~Wordle();
    bool avvia_gioco(const char *sequenza);
    void indovina(const char *sequenza_tentata);
    friend ostream& operator<<(ostream& os, const Wordle& w);
    void stampa_storico(ostream& os) const;
    Wordle& operator-=(const char* s);
    Wordle& operator=(const Wordle& w);
};

