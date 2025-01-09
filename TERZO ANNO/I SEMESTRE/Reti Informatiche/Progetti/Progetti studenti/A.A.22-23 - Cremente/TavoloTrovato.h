//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef TAVOLITROVATI_H
#define TAVOLITROVATI_H

struct TavoloTrovato{
    int id;
    struct TavoloTrovato* next;
};

struct TavoloTrovato* new_tavolo_trovato(int);
void del_tavolo_trovato(struct TavoloTrovato*);
void ins_tavolo_trovato(struct TavoloTrovato**, struct TavoloTrovato*);
void svuota_lista_tavoli_trovati(struct TavoloTrovato**);

#endif