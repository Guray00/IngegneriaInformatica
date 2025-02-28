#ifndef COMPITO_H
#define COMPITO_H

#include <iostream>
using namespace std;


const int NOME_UTENTE = 25;


struct utente {
    char nome_utente[NOME_UTENTE + 1];
    bool prioritario;
    utente* prossimo;
};


class UfficioPostale {
    utente** ufficio;
    int num_sportelli;
    int utenti_totali;
    int utenti_prioritari;
    int utenti_non_prioritari;


public:
    UfficioPostale(int = 2);
    friend ostream& operator<< (ostream&, const UfficioPostale&);
    void accodaUtente(const char*, int);
    bool serviUtente(int);

    // --- SECONDA PARTE ---
    ~UfficioPostale();
    void accodaPrioritario(const char*);
    void passaAvanti(const char*, int, int);
    UfficioPostale& operator!();
};

#endif //COMPITO_H