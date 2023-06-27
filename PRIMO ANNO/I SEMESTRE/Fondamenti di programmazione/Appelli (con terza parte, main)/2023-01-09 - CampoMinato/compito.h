#ifndef CAMPOMINATO_COMPITO_H
#define CAMPOMINATO_COMPITO_H

#include <iostream>
using namespace std;

class CampoMinato {

    enum stato_gioco{NON_AVVIABILE, AVVIABILE, AVVIATO, SCONFITTA, VITTORIA};

    stato_gioco stato;

    int dimensione;
    int num_mine;
    char* tabellone;

    bool coordinate_scorrette(int r, int c) const;
    static bool cella_scoperta(char cella);

public:

    CampoMinato(int n);
    ~CampoMinato();
    bool aggiungi_mina(int r, int c);
    void scopri(int r, int c);
    friend ostream& operator<<(ostream& os, const CampoMinato& c);
    CampoMinato(const CampoMinato& c);
    CampoMinato operator+(const CampoMinato& c) const;
};


#endif //CAMPOMINATO_COMPITO_H