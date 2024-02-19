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
    bool auth = false;
    desc_msg msg;
    desc_resp resp;

    bool status;
    int gameid = 0;
    
    desc_story story;

    if(argc != 2){
        printf("client: \t\targomento non valido.");
        return 0;
    }
    
    /* tentare l'inizializzazione del client, uso della socket e connect fino a che non si riesce */
    do{
        sd = init_client();  
        sleep(1);
    }while(sd == -1);
    system("clear");

    /* parte di login o signup */
    resp.notify_code = -1;
    do{
        if(resp.notify_code != -1)
            printf("\n%s\n", notify[resp.notify_code]);
        sleep(1);
        system("clear");
        
        printf("****************************** AUTENTICAZIONE **********************************\n");
        printf("> login \t --> per accedere al proprio account\n");
        printf("> signup\t --> per creare un nuovo account\n");
        printf("********************************************************************************\n");
        printf("> ");
        read_from_stdin(buff);
        /* analizzare ciò che l'utente ha scritto e eseguire login o signup */
        if(!strcmp(buff, "login")){            
            if(login_client(sd, &resp))
                auth = true;
        } else if(!strcmp(buff, "signup")){
            if(signup_client(sd, &resp))
                auth = true;
        } else resp.notify_code = 25;
    }while(!auth);
    printf("\n%s\n", notify[resp.notify_code]);
    sleep(1);
    system("clear");
    
    /* vengono mostrati all'utente i comandi del gioco e le relative room che lo comprendono (solamente 1) */
    do{
        printf("****************************** GAME STARTED **********************************\n");
        printf("Lista dei comandi:\n");
        printf("> start room \t--> avvia il gioco nella stanza specificata da un numero intero\n");
        printf("> look [location | object] \t--> fornisce una breve descrizione della stanza, delle sue locazioni e dei suoi oggetti\n");
        printf("> take object \t--> raccogliere l'oggetto presente nella stanza corrente\n");
        printf("> use object1 [object2] \t--> usare l'oggetto 1 già raccolto, oppure usarlo su un oggetto 2 non ancora raccolto\n");
        printf("> objs \t--> mostra l'elenco degli oggetti raccolti in quel momento\n");
        printf("> drop object \t--> rimuovere un oggetto dalla borsa\n");
        printf("> end \t--> termina il gioco e la connessione col server\n");
        printf("\n\nLista delle stanze:\n");
        printf("1. Nella casa di Guran Turino\n");
        printf("******************************************************************************\n");
        printf("> ");
        read_from_stdin(buff);
        /* l'utente prima di tutto deve iniziare il gioco digitando start game */
        msg = normalize_command(buff, COMMAND, &status);
        /* controllare che il comando sia quello che ci si aspetti, si può solo usare la start in questo punto */
        if(status && !strcmp(msg.command, "start") && msg.num_operand == 1){
            /* scegliamo il gioco */
            gameid = string_to_int(msg.operand_1);
            msg_to_string(msg, buff);
            /* notificare al server che gioco ha scelto l'utente */
            send_to_socket(sd, buff);
            
            /* il server invierà i dati necessari all'utente come token necessari e tempo */
            receive_from_socket(sd, buff_resp);
            string_to_resp(buff_resp, &resp);
            if(resp.status == false){
                printf("\n%s", notify[resp.notify_code]);   
                sleep(2);  
                system("clear");
                continue;
            }
        }
        system("clear");
    }while(resp.status == false);
    
    /* bisogna mostrare la schermata di gioco, lo storytelling e poi richiedere un comando da tastiera */
    /* dal momento in cui viene inviato il primo comando il tempo inizia a scorrere */
    story = stories[gameid - 1];
    story.request_token = resp.token;
    reload_screen(story, resp)  ;
    
    /* programma di gioco */
    while(1){
        /* lettura di un comando da tastiera di massimo due argomenti o una risposta testuale */
        do{
            printf("\n> ");
            read_from_stdin(buff);
            if(resp.expeted == COMMAND)
                msg = normalize_command(buff, COMMAND, &status);
            else if(resp.expeted == RESPONSE_TEXT) 
                msg = normalize_command(buff, RESPONSE_TEXT, &status);

            if(!status)
                reload_screen(story, resp);
            
        } while(!status);
        
        /* il messaggio potrebbe anche essere errato, se ne occuperà il server per controllare la sua accuratezza */
        /* invio al server del messaggio in formato text */
        msg_to_string(msg, buff);
        send_to_socket(sd, buff);
        
        /* ricezione della risposta dal server sempre in formato text */
        if(receive_from_socket(sd, buff_resp) == 0){
            printf("\nIl server ha terminato la sua esecuzione.");
            close_socket(sd);
            exit(EXIT_FAILURE);
        }
        string_to_resp(buff_resp, &resp);
        
        /* tempo scaduto, utente ha fatto end (e il server ha messo seconds a 0) */
        if(resp.seconds == 0){
            if(strcmp(msg.command, "end"))
                reload_screen(story, resp);
            else 
                printf("Hai terminato spontaneamente la partita, alla prossima!");
            
            close_socket(sd);
            getchar();          /* aspettare prima di chiudere il terminale */
            return 0;
        }
        
        /* c'è un nuovo token e nel caso se l'utente ha vinto */
        if(resp.token == 1) {
            story.token++;
            if(story.request_token == story.token){
                reload_screen(story, resp);
                /* chiudere il client inviando una end al server */
                end_client(sd, &resp);
                close_socket(sd);
                getchar();      /* aspettare prima di chiudere il terminale */
                return 0;
            }
        }
        reload_screen(story, resp);    
    }
}