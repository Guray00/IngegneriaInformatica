#include "account.h"
#include "sessione.h"
#include "tuttigli.h"

unsigned static int contatore = 0; // Usato per l'id

/* Funzione che alloca dinamicamente una struct Account e e ritorna
il puntatore a tale struttura */
struct Account* new_account(char* email, char* passw){
    struct Account* save_ptr = malloc(sizeof(struct Account));
    strcpy(save_ptr->email, email);
    strcpy(save_ptr->passw, passw);
    save_ptr->id = ++contatore;
    save_ptr->next = NULL;
    save_ptr->status = offline;
    return save_ptr;
}

/* Toglie ACCOUNT dalla lista e libera la memoria occupata da una struttura account*/
void del_account(struct Account** lista, struct Account* account){

    struct Account* corrente = *lista;
    struct Account* precedente = NULL;

    // Cerca l'account nella lista e quando lo trova è su CORRENTE
    while (corrente != NULL && corrente != account) {
        precedente = corrente;
        corrente = corrente->next;
    }

    // Se l'account è stato trovato, rimuovilo dalla lista
    if (corrente != NULL) {
        // Se l'account è in testa alla lista aggiorno LISTA
        if (precedente == NULL) {
            *lista = corrente->next;
        } else {
            precedente->next = corrente->next;
        }

        // Libera la memoria dell'ACCOUNT rimosso
        free(corrente);
    } else {
        printf("Account non trovato nella lista.\n");
    }
}
/* Inserisce ACCOUNT in cima alla lista*/
void ins_account(struct Account** lista, struct Account* account){

    // lista vuota
    if(*lista == NULL){
        *lista = account;
    } else { // lista non vuota
        account->next = *lista;
        *lista = account;
    }
}

/* Data una lista di strutture ACCOUNT, controlla se è
 presente un account specifico dati email e password, se non trova nulla ritorna NULL*/
struct Account* check_account(struct Account** lista, char *email, char *password){
    if(*lista == NULL){
        printf("Account non presente nella lista.\n");
        return NULL;
    }
    struct Account* corrente = *lista;

    // Cerca l'account nella lista
    while (corrente != NULL) {
        if (strcmp(corrente->email, email) == 0 && strcmp(corrente->passw, password) == 0) {
            printf("Account trovato nella lista.\n");
            return corrente;
        }
        corrente = corrente->next;
    }

    // Account non trovato nella lista
    printf("Account non trovato nella lista.\n");
    return NULL;

}

/* Data una lista di strutture ACCOUNT, controlla se è
 presente un account specifico data l'email, se non trova nulla ritorna NULL*/
struct Account* check_account_solo_email(struct Account** lista, char* email){
    if(*lista == NULL){
        printf("Account non presente nella lista.\n");
        return NULL;
    }
    struct Account* corrente = *lista;

    // Cerca l'account nella lista
    while (corrente != NULL) {
        if (strcmp(corrente->email, email) == 0) {
            printf("Account trovato nella lista.\n");
            return corrente;
        }
        corrente = corrente->next;
    }

    // Account non trovato nella lista
    printf("Account non trovato nella lista.\n");
    return NULL;

}
/* Mette l'account offline*/
void offline_account_by_id(struct Account **lista, int id){
    struct Account* corrente = *lista;


    // Cerca l'account nella lista
    while (corrente != NULL) {
        if (corrente->id == id) {
            corrente->status = offline;
            printf("L'utente %d è andato offline\n", id);
            client_online--;
        }
        corrente = corrente->next;
    }

}