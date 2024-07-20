#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "lib/tcp.h"
#include "lib/utility.h"
#include "lib/game.h"

int main(int argc, char* argv[]){
    int listener;               /* socket description relativa al socket di ascolto */
    int sd;                     /* socket description relativa al socket di connessione col client */
    int fd; 
    char buff[sizeof(desc_msg)];
    char buff_resp[sizeof(desc_resp)];
    desc_msg msg;
    desc_resp resp;
    
    if(argc != 2){
        printf("server: \targomento non valido.\n");
        return 0;
    }
    
    /* all'inizio del programma, viene chiesto all'utente di avviare il server manualmente oppure spegnerlo */
    do{
        printf("***************************** SERVER STARTED *********************************\n");
        printf("Digita un comando:\n");
        printf("1) start --> avvia il server di gioco\n");
        printf("2) stop  --> termina il server\n");
        printf("******************************************************************************\n");
        printf("> ");
        read_from_stdin(buff);
        if(!strcmp(buff, "start")){
            system("clear");
            break;
        } else if(!strcmp(buff, "stop")){
            return 0;
        }
        system("clear");
    }while(1);

    /* inizializzazione del server, uso della socket, bind, e listen */
    listener = init_server(string_to_int(argv[1]));  

    while(1){   
        /* attesa di una nuova richiesta di gioco da un giocatore e ritorna il socket per la trasmissione dati */
        fd = find_socket_ready();

        /* lettura dallo stream di input */
        if(fd == STDIN_FILENO){
            read_from_stdin(buff);
            _log_server_(STDIN, fd, buff);
            /* si accetta come unica stringa da imput solo "stop" */
            if(!strcmp(buff, "stop")){
                /* controllare che non ci siano utenti attivi */
                if(active_users()){
                    _log_server_(ERROR, fd, "Non puoi spegnere il server, ci sono ancora altri giocatori attivi!");
                    continue;
                }
                close_socket(listener);
                printf("Server disattivato!");
                getchar();      /* aspettare prima di chiudere il terminale */
                return 0;
            }
        
        /* allora devo accettare una nuova richiesta di connessione */
        } else if(fd == listener){
            sd = accept_request(listener);
            _log_server_(NEW_SOCKET, sd, "");

        /* allora il giocatore ha inviato dati che devo leggere */
        } else {
            _log_server_(SOCKET_READY, fd, "");     

            /* ottenere il messaggio dal client */
            if(receive_from_socket(fd, buff) == 0){
                /* allora il client si è disconnesso */
                /* rimuovere l'utente dagli utenti attivi */
                remove_active_user(fd);                    
                /* rimozione della socket dal set master */
                remove_socket(fd);  
                close_socket(fd);
                _log_server_(SOCKET_CLOSE, fd, "");
                continue;
            }
            string_to_msg(buff, &msg);
            _log_server_(MESSAGE_ARRIVED, fd, &msg);
            
            /* adesso ho il messaggio, devo analizzarlo e fare le azioni conseguenti */
            resp = execute(fd, msg);
            
            /* converto in stringa e lo invio al client */
            resp_to_string(resp, buff_resp);
            send_to_socket(fd, buff_resp);
            _log_server_(MESSAGE_SENT, fd, &resp);
            
            /* controllare se la partita è terminata o se è stata inviata una "end" */
            if(resp.seconds == 0){
                close_socket(fd);
                remove_socket(fd);
                _log_server_(SOCKET_CLOSE, fd, "");
            }
        }
    }
}