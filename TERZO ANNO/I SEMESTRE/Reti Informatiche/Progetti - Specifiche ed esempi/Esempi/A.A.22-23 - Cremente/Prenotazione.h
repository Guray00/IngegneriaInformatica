//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef PRENOTAZIONE_H
#define PRENOTAZIONE_H

#include "utility.h"

struct Tavolo;

struct Prenotazione{
    int cod_prenotazione;
    char cliente[CLIENTE_SIZE];
    int num_persone;
    int giorno;
    int mese;
    int anno;
    int ora;
    struct Prenotazione* next;
};

struct Prenotazione* new_prenotazione(int, char*, int, int, int, int, int);
void del_prenotazione(struct Prenotazione*);
void ins_prenotazione(struct Prenotazione**, struct Prenotazione*);
bool rem_prenotazione(struct Prenotazione**, int);
void svuota_lista_prenotazioni(struct Prenotazione**);
struct Prenotazione* dup_prenotazione(struct Prenotazione*);
struct Prenotazione* recupera_prenotazioni(struct Tavolo*);
int genera_id_prenotazione(struct Prenotazione*, int);
bool prenotazione_valida(int, struct Prenotazione*);

void crea_file_prenotazioni(struct Prenotazione*);

#endif