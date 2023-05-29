#include "head.h"
#include "utility.h"
#include "funz_td.h"

void guida_comandi_td(){
    printf("***************************** BENVENUTO *****************************\n");
    printf("Digita un comando:\n\n");
    printf("1) help           --> mostra i dettagli dei comandi\n");
    printf("2) menu           --> mostra il menu dei piatti\n");
    printf("3) comanda        --> invia una comanda\n");
    printf("4) conto          --> chiede il conto\n");
    return;
}

void gestisci_comando_help(){
    printf("- menu: mostra il menu, cioe' l'abbinamento fra codici, nomi dei piatti e relativi prezzi.\n");
    printf("- comanda: invia una comanda alla cucina. Il comando e' da eseguirsi nel seguente formato:\n");
    printf("\t\tcomanda cod-qnt cod-qnt\n");
    printf("dove cod e' il codice del piatto, e qnt e' la quantita' delle portate che si desiderano per quel piatto.\n");
    printf("- conto: invia la richiesta del conto, che verra' mostrato a video. Dopo aver richiesto il conto, il pasto e' terminato.\n");
    return;
}

//gestisce il comando menu mandando al server la richiesta di far vedere il menu.
//stampa poi il menu ricevuto.
void gestisci_comando_menu(int p_socket, char* p_comandointero){
//    char comando[COMANDO_SIZE];
    char buffer[BUFFER_SIZE];

    if(strcmp(p_comandointero, "menu\n") == 0){
        if(!invia_messaggio(p_socket, p_comandointero, "Errore in fase di invio riga di comando menu.")) return;
        while(1){
            if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione menu.")) continue;
            if(strcmp(buffer, "FINE") == 0){
                break;
            }
            printf("%s\n", buffer);
        }
    }
    else{
        printf("Comando menu inserito in modo non valido. Riprovare.\n");
        return;
    }
}

void gestisci_comando_comanda(int p_socket, char* p_comandointero, int p_indice_tavolo){
    char buffer[BUFFER_SIZE];

    sprintf(buffer, "comanda %d %s", p_indice_tavolo, p_comandointero);
    if(!invia_messaggio(p_socket, buffer, "Errore in fase di invio riga di comando menu.")) return;
    if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione menu.")) return;
    if(strcmp(buffer, "NO") == 0){
        printf("Il comando non e' stato inserito correttamente, o alcuni codici sono errati. Riprovare.\n");
        printf("Ricorda che puoi usare il comando \"help\" per vedere come scrivere il comando in modo corretto.\n");
        return;
    }

    printf("%s\n", buffer);
}

void gestisci_comando_conto(int p_socket, char* p_comandointero, int p_indice_tavolo){
    char buffer[BUFFER_SIZE];
//    char comando[COMANDO_SIZE]; //conterra' la parola conto, da ignorare

    if(strcmp(p_comandointero, "conto\n") == 0){
        sprintf(buffer, "conto %d", p_indice_tavolo);
        if(!invia_messaggio(p_socket, buffer, "Errore in fase di invio richiesta comando conto.")) return;
        if(!ricevi_messaggio(p_socket, buffer, "Errore ricezione conto.")) return;
        printf("%s\n", buffer);
    }
    else{
        printf("Il comando conto non e' stato inserito correttamente.\n");
    }
    return;    
}

void gestisci_comando_take_td(char* p_buffer){
    char comando[COMANDO_SIZE]; //conterra' la parola 'take', da ignorare
    char messaggio[RIGA_TESTO_SIZE];

    sscanf(p_buffer, "%s %[^\n]", comando, messaggio);
    printf("%s\n", messaggio);
    return;
}

//questa funzione e' solo per mantenere un ordine concettuale... in realta' fa la stessa identica cosa della take, per cui chiamo direttamente quella
void gestisci_comando_set_td(char* p_buffer){
    gestisci_comando_take_td(p_buffer);
    return;
}

void gestisci_comando_stop_td(int p_socket){
    printf("Ricevuto comando \"stop\" dal server, arresto il device.\n");
    fflush(stdout);
    close(p_socket);
    exit(0);
}