#include "head.h"
#include "utility.h"
#include "funz_cli.h"
#include "TavoloTrovato.h"

// Mostra l'elenco di comandi selezionabili da terminale
void guida_comandi_cli(){
    printf("Benvenuto sulla pagina prenotazioni del ristorante 我吃饭!\n");
    printf("Questi sono i comandi che puoi digitare:\n");
    printf("- find: ricerca la disponibilita' per una prenotazione.\n");
    printf("- book: invia una prenotazione. \n");
    printf("- esc:  termina il client.\n");
    printf("Ricorda: il comando find deve essere seguito da:\n");
    printf("cognome persone data ora\n");
    return;
}

//gestisce il comando find mandando al server la prenotazione e ricevendo la lista di tavoli disponibili
bool gestisci_comando_find(int p_socket, char* p_comandointero){
    char cliente[CLIENTE_SIZE];
    int num_persone;
    int giorno;
    int mese;
    int anno;
    int ora;
    char comando[COMANDO_SIZE] = "";
    char buffer[BUFFER_SIZE] = "";
    int id_tavolo_trovato;
    struct TavoloTrovato* nuovo_tavolo = NULL;
    svuota_lista_tavoli_trovati(&gv_id_tavoli_disp_dopo_find);

    if(sscanf(p_comandointero, "%s %s %d %d-%d-%d %d", comando, cliente, &num_persone, &giorno, &mese, &anno, &ora) == 7){
        if(num_persone > MAX_NUM_PERSONE || num_persone < 1){
            printf("Numero di persone non valido (deve essere compreso tra 1 e %d).\n", MAX_NUM_PERSONE);
            return false;
        }
        else if(!data_valida(giorno, mese, anno, ora)){
            printf("La data inserita non e' valida.\n");
            return false;
        }
        else{
            //Se i controlli sono tutti validi, mando al server il comando cosi' che mi restituisca i dati da stampare
            strcpy(buffer, p_comandointero);
            if(!invia_messaggio(p_socket, buffer, "Errore in fase di invio riga di comando find.")) exit(1);
            gv_num_tavoli_disponibili = 0;
            while(1){
                if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione lista tavoli disponibili.")) continue;
                if(strcmp(buffer, "FINE") == 0){
                    if(gv_num_tavoli_disponibili == 0){
                        printf("Non ci sono tavoli disponibili per la sua prenotazione.\n");
                        break;
                    }
                    printf("Scegli una delle opzioni con il comando book opz.\n");
                    break;
                }
                gv_num_tavoli_disponibili++;
                sscanf(buffer, "Tavolo: %d", &id_tavolo_trovato);
                nuovo_tavolo = new_tavolo_trovato(id_tavolo_trovato);
                ins_tavolo_trovato(&gv_id_tavoli_disp_dopo_find, nuovo_tavolo);
                printf("%d) %s\n", gv_num_tavoli_disponibili, buffer);
            }
        }
    }
    else{
        printf("Comando find inserito con parametri non validi. Riprovare.\n");
        return false;
    }
    return true;
}

//gestisce il comando book mandando al server l'opzione scelta e ricevendo il codice della prenotazione
bool gestisci_comando_book(int p_socket, char* p_comandointero, char* p_ultimofind){
    char comando[COMANDO_SIZE];
    int opzione;
    struct TavoloTrovato* tmp = gv_id_tavoli_disp_dopo_find;
    int i;
    int id_tavolo_prenotato;
    char buffer[BUFFER_SIZE];

    if(sscanf(p_comandointero, "%s %d", comando, &opzione) == 2){
        if(gv_id_tavoli_disp_dopo_find == NULL){
            printf("Prima di chiamare il comando book, chiamare il comando find.\n");
            return false;
        }
        if(opzione < 1 || opzione > gv_num_tavoli_disponibili){
            printf("Numero opzione non valido, riprovare con un numero opzione tra quelli elencati.\n");
            return false;
        }
        opzione--;
        for(i = 0; i < opzione; i++){
            tmp = tmp->next;
        }
        id_tavolo_prenotato = tmp->id;
        sprintf(buffer, "book %d %s", id_tavolo_prenotato, p_ultimofind);
        if(!invia_messaggio(p_socket, buffer, "Errore in fase di invio riga di comando book.")) return false;
        if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione codice prenotazione (comando book).")) return false;
        printf("Prenotazione effettuata correttamente!\nCodice prenotazione: %s.\n", buffer);
        svuota_lista_tavoli_trovati(&gv_id_tavoli_disp_dopo_find);
        gv_id_tavoli_disp_dopo_find = 0;
    }
    else{
        printf("Comando book inserito con parametri non validi. Riprovare.\n");
        return false;
    }
    return true;
}