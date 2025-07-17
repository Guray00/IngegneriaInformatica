#ifndef COMPITO_H
#define COMPITO_H

#include <iostream>
using namespace std;


const int MAXCHAR_TITOLO = 50;
const int MAXCHAR_DESCR  = 100;


class Calendario; // dichiarazione incompleta


class Evento{
public:
    char titolo[MAXCHAR_TITOLO+1];
    char descrizione[MAXCHAR_DESCR+1];
    int giorno, mese, anno;


    Evento(const char* t = "", const char* d = "", int dd = 1, int mm = 1, int aaaa = 2025);
    friend ostream& operator<<(ostream&, const Evento&);
    bool controllaPrimaDi(const Evento&) const;
    bool controllaDataEsatta(int, int, int) const;
    bool controllaParolachiave(const char* keyword) const;


    friend class Calendario;
};


struct elem{
    Evento evento;
    elem* succ;
};


class Calendario {
    elem* testa;
    char* titoloCalendario;


    // Mappa i mesi al numero di giorni nel mese corrispondente
    static const int giorniMese[12];


    static bool controllaDataValida(int, int, int);
    static bool controllaStringaValida(const char*);
    elem* ottieniUltimoEvento() const;

    // mascheramento operatore di assegnamento
    Calendario& operator=(const Calendario&);

public:
    // --- PRIMA PARTE ---
    Calendario(const char*);
    bool aggiungiEvento(const char*, const char*, int, int, int);
    friend ostream& operator<<(ostream&, const Calendario&);
    bool rimuoviEvento(int, int, int);

    // --- SECONDA PARTE ---
    ~Calendario();
    Calendario(const Calendario&);
    int rimuoviEventiSuccessiviA(int, int, int);
    Calendario cercaEventi(const char* keyword) const;
};

#endif //COMPITO_H