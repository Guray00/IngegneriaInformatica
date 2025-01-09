//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef COMANDA_H
#define COMANDA_H

#include "utility.h"

struct Ordine;

struct Comanda{
    struct Ordine* ordini;
    char stato[STATO_COMANDA_SIZE];
    int id_tavolo;
    int num_comanda;
    struct Comanda* next;
};

struct Comanda* new_comanda(struct Ordine*, char*, int, int);
void del_comanda(struct Comanda*);
void ins_comanda(struct Comanda**, struct Comanda*);
void svuota_lista_comande(struct Comanda**);

#endif