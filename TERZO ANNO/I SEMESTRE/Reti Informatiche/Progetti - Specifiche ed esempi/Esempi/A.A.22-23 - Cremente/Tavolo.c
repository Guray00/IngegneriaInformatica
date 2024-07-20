#include "head.h"
#include "Prenotazione.h"
#include "Tavolo.h"

//alloca la memoria per un nuovo tavolo e assegna i relativi parametri
struct Tavolo* new_tavolo(int p_id, int p_sala, char* p_posizionesala, int p_numposti){
    struct Tavolo* ret = malloc(sizeof(struct Tavolo));
    ret->prenotazioni = NULL;
    ret->num_prenotazioni = 0;
    ret->id = p_id;
    ret->sala = p_sala;
    strcpy(ret->posizionesala, p_posizionesala);
    ret->numposti = p_numposti;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a un tavolo
void del_tavolo(struct Tavolo* p_tavolo){
    free(p_tavolo);
}

//inserisce un tavolo in fondo alla lista di tavoli
void ins_tavolo(struct Tavolo** p_head, struct Tavolo* p_tavolo){
    if(*p_head == NULL){
        *p_head = p_tavolo;
        return;
    }
    
    struct Tavolo* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_tavolo;
    return;
}

//rimuove un tavolo (relativa all'id del tavolo) dalla lista dei tavoli
bool rem_tavolo(struct Tavolo** p_head, int p_id){
    if(*p_head == NULL) return false;

    struct Tavolo* tmp = *p_head;
    if((*p_head)->id == p_id){
        *p_head = (*p_head)->next;
        del_tavolo(tmp);
        return true;
    }

    while(tmp->next != NULL && tmp->next->id != p_id){
        tmp = tmp->next;
    }

    if(tmp->next == NULL) return false;

    struct Tavolo* todelete = tmp->next;
    tmp->next = todelete->next;
    del_tavolo(todelete);
    return true;
}

void svuota_lista_tavoli(struct Tavolo** p_head){
    struct Tavolo* tmp = NULL;
    struct Prenotazione* tmp_prenotazioni = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        tmp_prenotazioni = tmp->prenotazioni;
        svuota_lista_prenotazioni(&tmp_prenotazioni);
        *p_head = (*p_head)->next;
        del_tavolo(tmp);
    }
    return;
}

void svuota_array_tavoli(struct Tavolo* p_head){
    int i;
    for(i = 0; i < MAX_TAVOLI; i++){
        svuota_lista_prenotazioni(&p_head[i].prenotazioni);
        p_head[i].num_prenotazioni = 0;
    }
    return;
}

//duplica un tavolo dell'elencoTavoli per poterlo inserire nella lista 
//dei tavoli disponibili da restituire al client
struct Tavolo* dup_tavolo(struct Tavolo* p_tavolo){
    struct Tavolo* ret = new_tavolo(p_tavolo->id,
                                    p_tavolo->sala,
                                    p_tavolo->posizionesala,
                                    p_tavolo->numposti);
    return ret;
}

//riempie l'array struct Tavolo* elencoTavoli con i tavoli presenti in Tavoli.txt
void recupera_tavoli(struct Tavolo* elencoTavoli){
    FILE *fptr;
    char riga[RIGA_TESTO_SIZE]; //riga del file
    int indice = 0;

    fptr = fopen("Tavoli.txt", "r");
    if(fptr == NULL){
        perror("Errore nell'apertura in lettura file Tavoli.txt.\n");
        fflush(stdout);
        exit(1);
    }

    //Dopo aver aperto il file, lo leggiamo riga per riga
    while(fgets(riga, sizeof(riga), fptr) != NULL){
        //per ogni riga, prendiamo i valori che ci servono e li assegniamo alla posizione giusta dell'array
        sscanf(riga, "T%d SALA%d %s %d", &elencoTavoli[indice].id, 
                                         &elencoTavoli[indice].sala, 
                                         elencoTavoli[indice].posizionesala, 
                                         &elencoTavoli[indice].numposti);
        indice++; 
    }

    fclose(fptr);
    return;
}

//costruisce la struttura dati ret in base ai tavoli che sono disponibili per la prenotazione
struct Tavolo* verifica_tavoli_disponibili(struct Tavolo* p_elencoTavoli, int p_num_persone, int p_giorno, int p_mese, int p_anno, int p_ora){
    struct Tavolo* ret = NULL;
    struct Tavolo* tavolo_dup;
    struct Prenotazione* tmp;
    bool tavolo_disponibile = true;
    int i;

    for(i = 0; i < MAX_TAVOLI; i++){
        if(p_elencoTavoli[i].numposti < p_num_persone) continue;
        tmp = p_elencoTavoli[i].prenotazioni;
        tavolo_disponibile = true;
        while(tmp != NULL && tavolo_disponibile){
            if(tmp->giorno == p_giorno && tmp->mese == p_mese && tmp->anno == p_anno && tmp->ora == p_ora) tavolo_disponibile = false;
            tmp = tmp->next;
        }
        if(!tavolo_disponibile) continue;

        //arrivati qui, il tavolo e' disponibile e lo aggiungo alla lista
        tavolo_dup = dup_tavolo(&p_elencoTavoli[i]);
        ins_tavolo(&ret, tavolo_dup);

    }

    return ret;
}