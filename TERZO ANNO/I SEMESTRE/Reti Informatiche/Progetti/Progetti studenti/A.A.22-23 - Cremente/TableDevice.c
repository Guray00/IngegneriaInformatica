#include "head.h"
#include "utility.h"
#include "TableDevice.h"

//alloca la memoria per un nuovo td e assegna i relativi parametri
struct TableDevice* new_td(int p_socket, int p_id_tavolo){
    struct TableDevice* ret = malloc(sizeof(struct TableDevice));
    ret->socket = p_socket;
    ret->id_tavolo = p_id_tavolo;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a un td
void del_td(struct TableDevice* p_td){
    free(p_td);
}

//inserisce un td in fondo alla lista dei td
void ins_td(struct TableDevice** p_head, struct TableDevice* p_td){
    if(*p_head == NULL){
        *p_head = p_td;
        return;
    }
    
    struct TableDevice* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_td;
    return;
}

void svuota_lista_td(struct TableDevice** p_head){
    struct TableDevice* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_td(tmp);
    }
    return;
}