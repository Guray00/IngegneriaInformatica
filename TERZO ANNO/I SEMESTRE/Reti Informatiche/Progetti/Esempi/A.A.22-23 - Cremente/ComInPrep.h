//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef COMINPREP_H
#define COMINPREP_H

struct Ordine;

//Comanda In Preparazione
struct ComInPrep{
    int id_tavolo;
    int num_comanda;
    struct Ordine* ordini;
    struct ComInPrep* next;
};

struct ComInPrep* new_cominprep(int, int, struct Ordine*);
void del_cominprep(struct ComInPrep*);
void ins_cominprep(struct ComInPrep**, struct ComInPrep*);
void svuota_lista_cominprep(struct ComInPrep**);
bool rem_cominprep(struct ComInPrep**, int, int);

#endif