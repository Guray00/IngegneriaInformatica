#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "lib/tcp.h"
#include "lib/utility.h"
#include "lib/game.h"

extern char notify[32][MAX_DIM_NOTIFY];

int main(int argc, char* argv[]){
    int sd;
    char buff[sizeof(desc_msg)];
    char buff_resp[sizeof(desc_resp)];
    desc_msg msg;
    desc_resp resp;
    bool status;

    if(argc != 2){
        printf("ombra: \t\targomento non valido.");
        return 0;
    }   
    
    /* tentare l'inizializzazione del client ombra, uso della socket e connect fino a che non si riesce */
    do{
        sd = init_client();  
        sleep(1);
    }while(sd == -1);

    /* corpo dell'utente ombra */
    while(1){
        do{
            system("clear");
            printf("****************************** UTENTE OMBRA ************************************\n");
            printf("> list \t\t --> per ottenere la lista di utenti attivi\n");
            printf("> + id_utente secondi\t --> aggiungere tempo rimanente all'utente\n");
            printf("> - id_utente secondi\t --> diminuire tempo rimanente all'utente\n");
            printf("> end \t\t --> per terminare il programma\n");
            printf("********************************************************************************\n");
            printf("> ");
            read_from_stdin(buff);
            /* analisi di ciò che l'utente ombra ha eseguito */
            msg = normalize_command(buff, SHADOW, &status);
        }while(!status);

        /* il messaggio potrebbe anche essere errato, se ne occuperà il server per controllare la sua accuratezza */
        msg_to_string(msg, buff);
        /* invio del messaggio al server */
        send_to_socket(sd, buff);
        
        /* ricezione del messaggio dal server */
        receive_from_socket(sd, buff_resp);;
        string_to_resp(buff_resp, &resp);
        
        /* mostrare a video la risposta del server */
        if(resp.notify_code == -1)
            printf("\n%s\n", resp.response);
        else
            printf("\n%s\n", notify[resp.notify_code]);
        
        /* controlla se hai fatto end (il server setta seconds a zero) */
        if(resp.seconds == 0){                        
            close_socket(sd);
            return 0;
        }
        sleep(3);
    }
}