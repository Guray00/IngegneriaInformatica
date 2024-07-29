//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef TAVOLO_H
#define TAVOLO_H

#include "utility.h"

#define MAX_TAVOLI 9

struct Prenotazione;

struct Tavolo{
    struct Prenotazione* prenotazioni; //utile per controllare rapidamente la disponibilita'
    int num_prenotazioni;
    int id;
    int sala;
    char posizionesala[COMANDO_SIZE];
    int numposti;
    struct Tavolo* next;
};

struct Tavolo* new_tavolo(int, int, char*, int);
void del_tavolo(struct Tavolo*);
void ins_tavolo(struct Tavolo**, struct Tavolo*);
bool rem_tavolo(struct Tavolo**, int);
struct Tavolo* dup_tavolo(struct Tavolo*);
void svuota_lista_tavoli(struct Tavolo**);
void svuota_array_tavoli(struct Tavolo*);
void recupera_tavoli(struct Tavolo*);
struct Tavolo* verifica_tavoli_disponibili(struct Tavolo*, int, int, int, int, int);

#endif