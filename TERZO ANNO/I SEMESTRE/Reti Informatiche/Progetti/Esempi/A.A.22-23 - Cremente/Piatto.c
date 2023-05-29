#include "head.h"
#include "utility.h"
#include "Piatto.h"

//alloca la memoria per un nuovo piatto e assegna i relativi parametri
struct Piatto* new_piatto(char* p_cod_piatto, char* p_nome_piatto, int p_prezzo){
    struct Piatto* ret = malloc(sizeof(struct Piatto));
    strcpy(ret->cod_piatto, p_cod_piatto);
    strcpy(ret->nome_piatto, p_nome_piatto);
    ret->prezzo = p_prezzo;
    ret->next = NULL;
    return ret;
}

//libera la memoria relativa a un piatto
void del_piatto(struct Piatto* p_piatto){
    free(p_piatto);
}

//inserisce un piatto in fondo alla lista dei piatti
void ins_piatto(struct Piatto** p_head, struct Piatto* p_piatto){
    if(*p_head == NULL){
        *p_head = p_piatto;
        return;
    }
    
    struct Piatto* tmp = *p_head;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }

    tmp->next = p_piatto;
    return;
}

void svuota_lista_piatti(struct Piatto** p_head){
    struct Piatto* tmp = NULL;
    while(*p_head != NULL){
        tmp = *p_head;
        *p_head = (*p_head)->next;
        del_piatto(tmp);
    }
    return;
}

//riempie l'array struct Piatto* elencoPiatti con i piatti presenti in Menu.txt
struct Piatto* recupera_piatti(){
    FILE *fptr;
    char riga[RIGA_TESTO_SIZE]; //riga del file

    char l_cod_piatto[COD_PIATTO_SIZE];
    char l_nome_piatto[RIGA_TESTO_SIZE];
    int l_prezzo;

    struct Piatto* headPiatti = NULL;
    struct Piatto* tmp = NULL;

    fptr = fopen("Menu.txt", "r");
    if(fptr == NULL){
        perror("Errore nell'apertura in lettura file Tavoli.txt.\n");
        fflush(stdout);
        exit(1);
    }

    //Dopo aver aperto il file, lo leggiamo riga per riga
    while(fgets(riga, sizeof(riga), fptr) != NULL){
        //per ogni riga, prendiamo i valori che ci servono e li assegniamo alla posizione giusta dell'array
        sscanf(riga, "%s - %d - %[^\n]", l_cod_piatto, &l_prezzo, l_nome_piatto);

        //aggiungo la prenotazione alla lista generica delle prenotazioni
        tmp = new_piatto(l_cod_piatto, l_nome_piatto, l_prezzo);
        ins_piatto(&headPiatti, tmp);
    }

    fclose(fptr);
    return headPiatti;
}

//funzione chamata da funz_serv.c, serve per controllare che una comanda ricevuta da un table device contenga
//dei piatti e che quei piatti abbiano un codice valido
bool controlla_piatti(char* p_comandointero, struct Piatto* p_elencoPiatti){
    char comandotoken[COMANDO_SIZE];
    char* token = NULL;
    char codicepiatto[COD_PIATTO_SIZE];
    char letterapiatto;
    char numeropiatto;
    int quantita;

    //copio il comando in un'altra stringa per poter usare la strtok
    //senza modificare il comando originale
    strcpy(comandotoken, p_comandointero);

    //tokenizzo il comando cosi' sono gia' pronto a controllare
    //se oltre al semplice comando ci sono eventuali parametri
    token = strtok(comandotoken, " \n");

    //so che la prima parola sara' "comanda", quindi salto direttamente alla successiva
    token = strtok(NULL, " \n");

    //se l'utente non ha specificato parametri dopo "comanda" il comando non e' valido
    if(token == NULL) return false;

    while(token != NULL){
        if(sscanf(token, "%c%c-%d", &letterapiatto, &numeropiatto, &quantita) == 3){
            sprintf(codicepiatto, "%c%c", letterapiatto, numeropiatto);
            if(!codicepiatto_valido(codicepiatto, p_elencoPiatti)) return false;
            token = strtok(NULL, " \n");
        }
        else return false;
    }

    return true;
}

//funzione che, data una stringa che dovrebbe contenere il codice di un piatto, controlla se 
//questo codice e' davvero esistente
bool codicepiatto_valido(char* p_codicepiatto, struct Piatto* p_elencoPiatti){
    struct Piatto* tmp = p_elencoPiatti;
    if(tmp == NULL) return false;
    while(tmp != NULL){
        if(strcmp(p_codicepiatto, tmp->cod_piatto) == 0) return true;
        tmp = tmp->next;
    }
    return false;
}