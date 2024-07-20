//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef ORDINE_H
#define ORDINE_H

#include "utility.h"

struct Ordine{
    char cod_piatto[COD_PIATTO_SIZE];
    int quantita;
    struct Ordine* next;
};

struct Ordine* new_ordine(char*, int);
void del_ordine(struct Ordine*);
void ins_ordine(struct Ordine**, struct Ordine*);
void svuota_lista_ordini(struct Ordine**);

#endif