//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef PIATTO_H
#define PIATTO_H

#include "utility.h"

struct Piatto{
    char cod_piatto[COD_PIATTO_SIZE];
    char nome_piatto[RIGA_TESTO_SIZE];
    int prezzo;
    struct Piatto* next;
};

struct Piatto* new_piatto(char*, char*, int);
void del_piatto(struct Piatto*);
void ins_piatto(struct Piatto**, struct Piatto*);
void svuota_lista_piatti(struct Piatto**);
struct Piatto* recupera_piatti();
bool controlla_piatti(char*, struct Piatto*);
bool codicepiatto_valido(char*, struct Piatto*);

#endif