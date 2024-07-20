#include "head.h"
#include "utility.h"
#include "ComInPrep.h"

//alloca la memoria per una nuova comanda in preparazione e assegna i relativi parametri
struct ComInPrep* new_cominprep(int p_id_tavolo, int p_num_comanda, struct Ordine* p_ordini){
    struct ComInPrep* ret = malloc(sizeof(struct ComInPrep));
    ret->id_tavolo = p_id_tavolo;
    ret->num_comanda = p_num_comanda;
    ret->ordini = p_ordini;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a una comanda in preparazione
void del_cominprep(struct ComInPrep* p_cominprep){
    free(p_cominprep);
}

//inserisce una comanda in preparazione in fondo alla lista delle comande in preparazione
void ins_cominprep(struct ComInPrep** p_head, struct ComInPrep* p_cominprep){
    if(*p_head == NULL){
        *p_head = p_cominprep;
        return;
    }
    
    struct ComInPrep* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_cominprep;
    return;
}

void svuota_lista_comande(struct ComInPrep** p_head){
    struct ComInPrep* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_cominprep(tmp);
    }
    return;
}

//rimuove una comanda in preparazione (relativa all'id del tavolo e al numero comanda) dalla lista delle comande in preparazione
bool rem_cominprep(struct ComInPrep** p_head, int p_id, int p_num){
    if(*p_head == NULL) return false;

    struct ComInPrep* tmp = *p_head;
    if((*p_head)->id_tavolo == p_id && (*p_head)->num_comanda == p_num){
        *p_head = (*p_head)->next;
        del_cominprep(tmp);
        return true;
    }

    while(tmp->next != NULL && (tmp->next->id_tavolo != p_id || tmp->next->num_comanda != p_num)){
        tmp = tmp->next;
    }

    if(tmp->next == NULL) return false;

    struct ComInPrep* todelete = tmp->next;
    tmp->next = todelete->next;
    del_cominprep(todelete);
    return true;
}