#include "head.h"
#include "utility.h"
#include "Ordine.h"

//alloca la memoria per un nuovo ordine e assegna i relativi parametri
struct Ordine* new_ordine(char* p_cod_piatto, int p_quantita){
    struct Ordine* ret = malloc(sizeof(struct Ordine));
    strcpy(ret->cod_piatto, p_cod_piatto);
    ret->quantita = p_quantita;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a un ordine
void del_ordine(struct Ordine* p_ordine){
    free(p_ordine);
}

//inserisce un ordine in fondo alla lista degli ordini
void ins_ordine(struct Ordine** p_head, struct Ordine* p_ordine){
    if(*p_head == NULL){
        *p_head = p_ordine;
        return;
    }
    
    struct Ordine* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_ordine;
    return;
}

void svuota_lista_ordini(struct Ordine** p_head){
    struct Ordine* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_ordine(tmp);
    }
    return;
}