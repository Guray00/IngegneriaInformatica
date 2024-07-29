#include "head.h"
#include "utility.h"
#include "Comanda.h"
#include "Ordine.h"

//alloca la memoria per una nuova comanda e assegna i relativi parametri
struct Comanda* new_comanda(struct Ordine* p_head, char* p_stato, int p_id_tavolo, int p_num_comanda){
    struct Comanda* ret = malloc(sizeof(struct Comanda));
    ret->ordini = p_head;
    strcpy(ret->stato, p_stato);
    ret->id_tavolo = p_id_tavolo;
    ret->num_comanda = p_num_comanda;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a una comanda
void del_comanda(struct Comanda* p_comanda){
    free(p_comanda);
}

//inserisce una comanda in fondo alla lista delle comande
void ins_comanda(struct Comanda** p_head, struct Comanda* p_comanda){
    if(*p_head == NULL){
        *p_head = p_comanda;
        return;
    }
    
    struct Comanda* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_comanda;
    return;
}

void svuota_lista_comande(struct Comanda** p_head){
    struct Comanda* tmp = NULL;
    struct Ordine* tmp_ordine = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        tmp_ordine = tmp->ordini;
        svuota_lista_ordini(&tmp_ordine);
        *p_head = (*p_head)->next;
        del_comanda(tmp);
    }
    return;
}