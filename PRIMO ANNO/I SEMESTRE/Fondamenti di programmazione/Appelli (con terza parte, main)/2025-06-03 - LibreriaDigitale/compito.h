#ifndef COMPITO_H
#define COMPITO_H

#include <iostream>
using namespace std;

const int MAX_NOME_SCAFFALE = 20;
const int MAX_TITOLO_LIBRO = 30;

struct Libro {
    char titolo[MAX_TITOLO_LIBRO+1];
    bool usato;
    Libro* next;
};

struct Scaffale {
    char nome[MAX_NOME_SCAFFALE+1];
    int capacita;
    int numLibri;
    Libro* libri;
    Scaffale* next;
};

class LibreriaDigitale {

    Scaffale* head;

public:
    //prima parte
    LibreriaDigitale();
    friend ostream& operator<<(ostream&, const LibreriaDigitale&);
    void aggiungiScaffale(const char* nome, int capacita);
    bool aggiungiLibro(const char* nomeScaffale, const char* titolo, bool condizione);

    //seconda parte
    LibreriaDigitale(const LibreriaDigitale&);
    ~LibreriaDigitale();
    void rimuoviLibro(const char* nomeScaffale, const char* titolo);
    LibreriaDigitale operator~() const;
    LibreriaDigitale& operator!();
};

#endif