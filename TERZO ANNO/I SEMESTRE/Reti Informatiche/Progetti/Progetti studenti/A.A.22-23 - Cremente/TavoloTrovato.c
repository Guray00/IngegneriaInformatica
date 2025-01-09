#include "head.h"
#include "TavoloTrovato.h"

//alloca la memoria per un nuovo tavolo trovato e assegna i relativi parametri
struct TavoloTrovato* new_tavolo_trovato(int p_id){
    struct TavoloTrovato* ret = malloc(sizeof(struct TavoloTrovato));
    ret->id = p_id;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a un tavolo trovato
void del_tavolo_trovato(struct TavoloTrovato* p_tavolo){
    free(p_tavolo);
}

//inserisce un tavolo trovato in fondo alla lista di tavoli trovati
void ins_tavolo_trovato(struct TavoloTrovato** p_head, struct TavoloTrovato* p_tavolo){
    if(*p_head == NULL){
        *p_head = p_tavolo;
        return;
    }
    
    struct TavoloTrovato* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_tavolo;
    return;
}

void svuota_lista_tavoli_trovati(struct TavoloTrovato** p_head){
    struct TavoloTrovato* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_tavolo_trovato(tmp);
    }
    return;
}