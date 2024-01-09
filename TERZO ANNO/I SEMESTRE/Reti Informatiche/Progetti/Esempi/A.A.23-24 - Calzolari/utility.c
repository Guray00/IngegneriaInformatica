#include "utility.h"
#include "tuttigli.h"

/* Funzione che mostra a video i comandi disponibili per il server*/
void mostra_comandi_console(){
    printf("\n************************** CONSOLE DEL SERVER **************************\n\n");
    printf("Seleziona un comando:\n\n");
    printf("1)  start <port> --> Avvia un nuovo server di gioco\n");
    printf("2)  stop --> Ferma il server\n");
    printf("************************************************************************\n\n");

}

/* Racchiude socket() e bind(), la porta deve essere fornita in formato network.
Restituiscce il socket*/
int creazione_sock_server(struct sockaddr_in *my_addr, int porta){
    int sd, ret;

    // Creazione socket
    sd = socket(AF_INET, SOCK_STREAM, 0);
    if(sd == -1){
        perror("Errore nella creazione del socket");
        exit(1);
    }
    printf("Socket creato\n");
    
    // Inizializzazione
    memset(my_addr, 0, sizeof(*my_addr));

    my_addr->sin_port = porta;
    my_addr->sin_family = AF_INET;
    inet_pton(AF_INET, "127.0.0.1", &my_addr->sin_addr);

    ret = bind(sd, (struct sockaddr*)my_addr, sizeof(*my_addr));
    if(ret == -1){
        perror("Errore nella bind");
        exit(1);
    }
    printf("Assegnato indirizzo e porta al socket\n");

    return sd;
}

/* Racchiude socket(), la porta deve essere fornita in formato network.
Restituisce il socket*/
int creazione_indirizzo_server(struct sockaddr_in *server_addr, int porta){
    int sd;

    // Creazione socket
    sd = socket(AF_INET, SOCK_STREAM, 0);
    if(sd == -1){
        perror("Errore socket non creato");
        exit(1);
    }
    printf("Socket creato\n");
    
    // Inizializzazione
    memset(server_addr, 0, sizeof(*server_addr));

    server_addr->sin_port = porta;
    server_addr->sin_family = AF_INET;
    inet_pton(AF_INET, "127.0.0.1", &server_addr->sin_addr);

    return sd;
}

/* Stampa a schermo i possibili scenari*/
void mostra_possibili_scenari(){
    printf("\n************************** ESCAPE ROOM *******************************\n\n");
    printf("Seleziona uno scenario con il comando 'start <room>'\n\n");
    printf("1)  Teatro\n");
    printf("2)  Coming soon...\n");
    printf("************************************************************************\n\n");
}

/* Mostra una schermata di benvenuto alla partita*/
void inizio_gioco1(){
    printf("\n****************************** TEATRO ***********************************\n");
    printf("Benvenuto nell'escape room.\n");
    printf("Hai 5m di tempo per uscire da questo teatro, ricostruisci la scena iconica\n");
    printf("della tragedia di William Shakespeare\n");
    printf("***************************************************************************\n\n");
}
/* */