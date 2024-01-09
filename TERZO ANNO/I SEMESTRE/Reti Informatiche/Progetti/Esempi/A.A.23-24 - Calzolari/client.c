#include "tuttigli.h"
#include "comandi_client.h"
#include "utility.h"

/*
struct sockaddr_in {
    sa_family_t     sin_family; // Address family, si mette AF_INET
    in_port_t       sin_port;   // network order
    struct in_addr  sin_addr;   // indirizzo
}

struct in_addr {
    uint32_t s_addr;
};
*/

int main(int argc, char* argv[]){
    int ret, sd;
    uint8_t room = 0;
    int i, c;
    uint16_t porta;
    char buf[256], comando[6], email[30], passw[20];
    struct sockaddr_in server_addr;

    // Verifica che ci sia un argomento per la porta
    if (argc != 2) {
        printf("Inserire correttamente la porta.\n\n\tSintassi: ./client <porta>\n\n");
        exit(1);
    }
    porta = htons(4242);

    // Creazione socket client
    sd = creazione_indirizzo_server(&server_addr, porta);
    printf("Inizializzata struttura per l'indirizzo del server e socket del client\n");
    
    // Connessione al server
    for(i = 0; i < 5; i++){
        printf("Tentativo di connessione con il server...\n");
        ret = connect(sd, (struct sockaddr*)&server_addr, sizeof(server_addr));
        if(!ret)
            break;
        sleep(3);
    }
    if(ret == -1){
        perror("Errore");
        exit(1);
    }
    printf("Connessione Stabilita con porta: %d\n", ntohs(porta));
    
    // Connessione effettuata, inizia lo scambio di informazioni con il server
    printf("Per favore identificati.\nNOTA: Se sei il secondo giocatore, prima di loggarti assicurati che l'altro giocatore abbia scelto la mappa\n");
    printf("Email: ");
    scanf("%29s", email);
    printf("Password: ");
    scanf("%19s", passw);

    // Mando email e password in formato binary
    ret = manda_informazioni(sd, email, passw);
    if(ret == -1){
        perror("Errore");
        exit(1);
    }
    // Mi aspetto un messaggio per sapere se sono stato autenticato o registrato
    ret = recv(sd, buf, 2, 0);
    if(ret < 2){
        perror("Errore nella ricezione dell'esito del login");
        exit(1);
    }

    // Qua ci aspettiamo il la risposta alla richiesta di connessione
    if(!strcmp(buf, "1")){
        printf("Autenticato! Bentornato nell'escape room!\n");
    } else if(!strcmp(buf, "0")){
        printf("Account non trovato, ti abbiamo registrato!\n");
    } else {
        printf("Account già online o password errata, impossibile connettersi!\n");
        return 0;
    }

    // Pulizia stdin perché può rimanere sporco
    while ((c = getchar()) != '\n' && c != EOF);
    
    // Aspetto di sapere se mi sto unendo ad una sessione o la sto creando
    ret = recv(sd, (void *)&room, sizeof(room), 0);
    if(ret == -1){
        perror("Errore nella ricezione della sessione");
        exit(1);
    }

    if(!room){

        // Ora devo far scegliere la room all'utente.
        mostra_possibili_scenari();
        
        // gestione input
        while(1){

            // stringa e naturale su 8 bit
            fgets(buf, sizeof(buf), stdin);
            sscanf(buf, "%5s %hhu", comando, &room);
            if(!strcmp(comando, "start") && room == 1)
                break;
            if(!strcmp(comando, "start") && room == 2){
                printf("Sii paziente, presto arriverà\n");
                continue;
            }
            printf("Comando non valido, prova con\n\n\t start <room>\n\n");
            
        }
        printf("Hai selezionato la stanza %d\n", room);

        // Mando il comando
        strcpy(comando, "rooms");
        ret = send(sd, comando, sizeof(comando), 0);
        if(ret == -1){
            perror("Errore nell'invio dello scenario");
            exit(1);
        }

        // Mando il numero dello scenario
        ret = send(sd, (void*)&room, sizeof(room), 0);
        if(ret == -1){
            perror("Errore nell'invio dello scenario");
            exit(1);
        }

        printf("Hai selezionato la la stanza numero %hhu\n", room);
    }

    // Inizia gioco
    // A seconda dello scenario scelto devo gestire la partita in maniera diversa
    if(room == 1){
        // Schermata di benvenuto
        inizio_gioco1();
        gestione_partita1(sd);
    } else {
        // gestione per altre stanze
    }

    // Il client esegue questo codice in seguito al comando "end"
    // Devo mostrare le informazioni e chiudere la connessione
    close(sd); 
    exit(0);
}
