//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef KITCHEN_DEVICE_H
#define KITCHEN_DEVICE_H

struct KitchenDevice{
    int socket;
    struct KitchenDevice* next;
};

struct KitchenDevice* new_kd(int);
void del_kd(struct KitchenDevice*);
void ins_kd(struct KitchenDevice**, struct KitchenDevice*);
void svuota_lista_kd(struct KitchenDevice**);

#endif