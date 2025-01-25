#include "head.h"
#include "utility.h"
#include "KitchenDevice.h"

//alloca la memoria per un nuovo kd e assegna i relativi parametri
struct KitchenDevice* new_kd(int p_socket){
    struct KitchenDevice* ret = malloc(sizeof(struct KitchenDevice));
    ret->socket = p_socket;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a un kd
void del_kd(struct KitchenDevice* p_kd){
    free(p_kd);
}

//inserisce un kd in fondo alla lista dei kd
void ins_kd(struct KitchenDevice** p_head, struct KitchenDevice* p_kd){
    if(*p_head == NULL){
        *p_head = p_kd;
        return;
    }
    
    struct KitchenDevice* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_kd;
    return;
}

void svuota_lista_kd(struct KitchenDevice** p_head){
    struct KitchenDevice* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_kd(tmp);
    }
    return;
}