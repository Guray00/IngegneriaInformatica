#include "head.h"
#include "utility.h"
#include "ComInPrep.h"
#include "Ordine.h"
#include "funz_kd.h"

void guida_comandi_kd(){
    printf("Questi sono i comandi che puoi digitare:\n");
    printf("- take: accetta una comanda.\n");
    printf("- show: mostra le comande accettate (in preparazione). \n");
    printf("- set: imposta lo stato della comanda.\n");
    return;
}

//funzione che stampa a schermo uno * per ogni comanda in attesa di essere accettata
void gestisci_comando_notifica(char* p_buffer){
    char messaggio[RIGA_TESTO_SIZE];
    char comando[COMANDO_SIZE];
    if(sscanf(p_buffer, "%s %s", comando, messaggio) == 2){;
        printf("Comande aggiornate: %s\n", messaggio);
        return;
    }
    printf("Tutte le comande sono state prese in carico.\n");
}

//funzione che accetta la prima comanda tra quelle in attesa. Inserisce la comanda nella struttura ComInPrep. Lo stato della
//comanda passa a "In Preparazione" lato server.
void gestisci_comando_take(int p_socket, char* p_comandointero, struct ComInPrep** comande){
    char comando[COMANDO_SIZE];
    char buffer[BUFFER_SIZE];
    int num_comanda;
    int id_tavolo;
    char cod_piatto[COD_PIATTO_SIZE];
    int quantita;

    struct ComInPrep* tmp = NULL;
    struct Ordine* ordini = NULL;
    struct Ordine* tmp_ordine = NULL;

    if(sscanf(p_comandointero, "%s", comando) == 1){
        if(!invia_messaggio(p_socket, p_comandointero, "Errore in fase di invio comando take.")) return;
        if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione comanda (comando take).")) return;
        if(strcmp(buffer, "NO") == 0){
            printf("Non ci sono comande accettabili al momento, riprovare dopo la notifica.\n");
            return;
        }
        sscanf(buffer, "com%d T%d", &num_comanda, &id_tavolo);
        while(1){
            if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione comanda (comando take while).")) return;
            if(strcmp(buffer, "FINE") == 0) break;
            sscanf(buffer, "%s %d", cod_piatto, &quantita);
            tmp_ordine = new_ordine(cod_piatto, quantita);
            ins_ordine(&ordini, tmp_ordine);
        }


        tmp = new_cominprep(id_tavolo, num_comanda, ordini);
        ins_cominprep(comande, tmp);
        printf("com%d T%d\n", tmp->num_comanda, tmp->id_tavolo);
        tmp_ordine = tmp->ordini;
        while(tmp_ordine != NULL){
            printf("%s %d\n", tmp_ordine->cod_piatto, tmp_ordine->quantita);
            tmp_ordine = tmp_ordine->next;
        }
    }
    else{
        printf("Comando take inserito in modo non valido. Riprovare.\n");
    }
    return;
}

//stampa a schermo tutte le comande in preparazione del kitchen device specifico che l'ha chiamata
void gestisci_comando_show(char* p_comandointero, struct ComInPrep* p_comande){
    char comando[COMANDO_SIZE] = ""; //conterra' la parola show, da ignorare
    struct ComInPrep* tmp = p_comande;
    struct Ordine* tmp_ordine = NULL;

    if(sscanf(p_comandointero, "%s", comando) == 1){
        if(tmp == NULL){
            printf("Non ci sono comande attualmente in preparazione.\n");
            return;
        }
        while(tmp != NULL){
            tmp_ordine = tmp->ordini;
            printf("com%d T%d\n", tmp->num_comanda, tmp->id_tavolo);
            while(tmp_ordine != NULL){
                printf("%s %d\n", tmp_ordine->cod_piatto, tmp_ordine->quantita);
                tmp_ordine = tmp_ordine->next;
            }
            tmp = tmp->next;
        }
    }
    else{
        printf("Comando show inserito in modo non valido. Riprovare.\n");
    }
    return;
}

void gestisci_comando_set(int p_socket, char* p_comandointero, struct ComInPrep** p_head){
    char comando[COMANDO_SIZE] = ""; //conterra' la parola set, da ignorare
    int num_comanda;
    int id_tavolo;
    char buffer[BUFFER_SIZE];

    if(sscanf(p_comandointero, "%s com%d-T%d", comando, &num_comanda, &id_tavolo) == 3){
        if(!rem_cominprep(p_head, id_tavolo, num_comanda)){
            printf("La comanda inserita non e' stata trovata, riprovare.\n");
            return;
        }
        if(!invia_messaggio(p_socket, p_comandointero, "Errore in fase di invio comando set.")) return;
        if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione risposta comando set.")) return;
        printf("%s\n", buffer);
    }
    else{
        printf("Comando set inserito in modo non valido. Riprovare.\n");
    }
    return;
}

void gestisci_comando_stop_kd(int p_socket){
    printf("Ricevuto comando \"stop\" dal server, arresto il device.\n");
    fflush(stdout);
    close(p_socket);
    exit(0);
}