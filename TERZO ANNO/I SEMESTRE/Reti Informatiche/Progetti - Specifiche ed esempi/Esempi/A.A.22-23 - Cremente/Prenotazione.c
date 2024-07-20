#include "head.h"
#include "utility.h"
#include "Prenotazione.h"
#include "Tavolo.h"

//alloca la memoria per una nuova prenotazione e assegna i relativi parametri
struct Prenotazione* new_prenotazione(int p_cod_prenotazione, char* p_cliente, int p_num_persone, int p_giorno, int p_mese, int p_anno, int p_ora){
    struct Prenotazione* ret = malloc(sizeof(struct Prenotazione));
    ret->cod_prenotazione = p_cod_prenotazione;
    strcpy(ret->cliente, p_cliente);
    ret->num_persone = p_num_persone;
    ret->giorno = p_giorno;
    ret->mese = p_mese;
    ret->anno = p_anno;
    ret->ora = p_ora;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a una prenotazione
void del_prenotazione(struct Prenotazione* p_prenotazione){
    free(p_prenotazione);
}

//inserisce una prenotazione in fondo alla lista di prenotazioni
void ins_prenotazione(struct Prenotazione** p_head, struct Prenotazione* p_prenotazione){
    if(*p_head == NULL){
        *p_head = p_prenotazione;
        return;
    }
    
    struct Prenotazione* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_prenotazione;
    return;
}

//rimuove una prenotazione (relativa al codice cod_prenotazione) dalla lista delle prenotazioni
bool rem_prenotazione(struct Prenotazione** p_head, int p_cod_prenotazione){
    if(*p_head == NULL) return false;

    struct Prenotazione* tmp = *p_head;
    if((*p_head)->cod_prenotazione == p_cod_prenotazione){
        *p_head = (*p_head)->next;
        del_prenotazione(tmp);
        return true;
    }

    while(tmp->next != NULL && tmp->next->cod_prenotazione != p_cod_prenotazione){
        tmp = tmp->next;
    }

    if(tmp->next == NULL) return false;

    struct Prenotazione* todelete = tmp->next;
    tmp->next = todelete->next;
    del_prenotazione(todelete);
    return true;
}

void svuota_lista_prenotazioni(struct Prenotazione** p_head){
    struct Prenotazione* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_prenotazione(tmp);
    }
    return;
}

//duplica una prenotazione per poterla inserire contemporaneamente sia nella lista
//generica delle prenotazioni, sia nella lista delle prenotazioni del tavolo
struct Prenotazione* dup_prenotazione(struct Prenotazione* p_prenotazione){
    struct Prenotazione* ret = new_prenotazione(p_prenotazione->cod_prenotazione,
                                                p_prenotazione->cliente,
                                                p_prenotazione->num_persone,
                                                p_prenotazione->giorno,
                                                p_prenotazione->mese,
                                                p_prenotazione->anno,
                                                p_prenotazione->ora);
    return ret;
}

//riempie l'array struct Prenotazione* elencoPrenotazioni con le prenotazioni presenti in Prenotazioni.txt
//e assegna le varie prenotazioni ai tavoli
struct Prenotazione* recupera_prenotazioni(struct Tavolo* p_elencoTavoli){
    FILE *fptr;
    char riga[RIGA_TESTO_SIZE]; //riga del file
    int indiceTavolo;

    int l_cod_prenotazione;
    char l_cliente[CLIENTE_SIZE];
    int l_num_persone;
    int l_giorno;
    int l_mese;
    int l_anno;
    int l_ora;

    struct Prenotazione* headPrenotazioni = NULL;
    struct Prenotazione* tmp = NULL;
    struct Prenotazione* tmp_dup = NULL;

    fptr = fopen("Prenotazioni.txt", "r");
    if(fptr == NULL){
        perror("Errore nell'apertura in lettura file Prenotazioni.txt.\n");
        fflush(stdout);
        exit(1);
    }

    //Dopo aver aperto il file, lo leggiamo riga per riga
    while(fgets(riga, sizeof(riga), fptr) != NULL){
        //per ogni riga, prendiamo i valori che ci servono e li assegniamo alla posizione giusta dell'array
        sscanf(riga, "%d %s %d %d-%d-%d %d", &l_cod_prenotazione, l_cliente, &l_num_persone, &l_giorno, &l_mese, &l_anno, &l_ora);

        //aggiungo la prenotazione alla lista generica delle prenotazioni
        tmp = new_prenotazione(l_cod_prenotazione, l_cliente, l_num_persone, l_giorno, l_mese, l_anno, l_ora);
        ins_prenotazione(&headPrenotazioni, tmp);

        //aggiungo la prenotazione al tavolo corrispondente
        indiceTavolo = (l_cod_prenotazione % 10) - 1;
        tmp_dup = dup_prenotazione(tmp);
        ins_prenotazione(&(p_elencoTavoli[indiceTavolo].prenotazioni), tmp_dup);
        p_elencoTavoli[indiceTavolo].num_prenotazioni++; 
    }

    fclose(fptr);
    return headPrenotazioni;
}

void crea_file_prenotazioni(struct Prenotazione* p_elencoPrenotazioni){
    struct Prenotazione* tmp = p_elencoPrenotazioni;    
    FILE *fptr;

    remove("Prenotazioni.txt");

    fptr = fopen("Prenotazioni.txt", "w");
    if(fptr == NULL){
        perror("Errore nell'apertura in scrittura file Prenotazioni.txt.\n");
        fflush(stdout);
        exit(1);
    }

    while(tmp != NULL){
        fprintf(fptr, "%d %s %d %d-%d-%d %d\n", tmp->cod_prenotazione, tmp->cliente, tmp->num_persone, tmp->giorno, tmp->mese, tmp->anno, tmp->ora);
        tmp = tmp->next;
    }

    fclose(fptr);
    return;
}

int genera_id_prenotazione(struct Prenotazione* p_elencoPrenotazioni, int p_id_tavolo){
    struct Prenotazione* tmp = p_elencoPrenotazioni;
    char ret[COD_PRENOTAZIONE_SIZE];
    int nuovo_id;

    if(tmp == NULL){
        sprintf(ret, "%d%d", 1, p_id_tavolo);
        return atoi(ret);
    }
    while(tmp->next != NULL){
        tmp = tmp->next;
    }
    nuovo_id = (tmp->cod_prenotazione / 10) + 1;
    sprintf(ret, "%d%d", nuovo_id, p_id_tavolo);
    return atoi(ret);
}

//riceve un codice prenotazione e controlla se e' effettivamente un codice appartenente a una prenotazione nella lista delle prenotazioni
bool prenotazione_valida(int p_cod_prenotazione, struct Prenotazione* p_elencoPrenotazioni){
    struct Prenotazione* tmp = p_elencoPrenotazioni;
    while(tmp != NULL){
        if(tmp->cod_prenotazione == p_cod_prenotazione) return true;
        tmp = tmp->next;
    }
    return false;
}