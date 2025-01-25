//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef TABLE_DEVICE_H
#define TABLE_DEVICE_H

struct TableDevice{
    int socket;
    int id_tavolo;
    struct TableDevice* next;
};

struct TableDevice* new_td(int, int);
void del_td(struct TableDevice*);
void ins_td(struct TableDevice**, struct TableDevice*);
void svuota_lista_td(struct TableDevice**);

#endif