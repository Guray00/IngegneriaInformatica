#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include "utility.h"

#ifndef TCP_H
#define TCP_H

#define MAX_DIM_BUFF 1024
#define MAX_DIM_PARAM 64
#define MAX_DIM_RESP 2048

enum TypeMessage {
    RESPONSE_TEXT,
    COMMAND,
    SHADOW
};

enum TypeLog {
    STDIN,
    NEW_SOCKET,
    SOCKET_READY,
    SOCKET_CLOSE,
    MESSAGE_ARRIVED,
    MESSAGE_SENT,
    START_SERVER,
    STOP_SERVER,
    ERROR,
};

enum TypeStruct {
    DESC_MSG,
    DESC_RESP
};

/* descrittore del messsaggio da client a server, definisce il protocollo che il client e il server condividono */
typedef struct desc_msg {
    enum TypeMessage type;           /* RESPONSE_TEXT, COMMAND, SHADOW */
    char command[MAX_DIM_PARAM];     /* definisce l'operazione che il client ha richiesto o la risposta testuale */
    char operand_1[MAX_DIM_PARAM];   /* definisce il primo operando dell'operazione, se lo ha */
    char operand_2[MAX_DIM_PARAM];   /* definisce il secondo operando dell'operazione, se lo ha */
    int num_operand;                 /* definisce il numero di operandi (0, 1, 2) */
} desc_msg;

/* descrittore del messaggio da server a client, definiscono il protocollo che il client e il server condividono */
typedef struct desc_resp {
    enum TypeMessage expeted;        /* ciò che il server si aspetta al prossimo messaggio inviato dal client */
    int dim_response;                /* dimensione della risposta testuale */
    char response[MAX_DIM_RESP];     /* messaggio che il server comunica al client */
    
    int token;                       /* usato la prima volta per dire al client quanti token sono necessari, succesivamente per segnalare la presenza di un token ottenuto */
    int seconds;                     /* usato per dire al client i secondi rimanenti */
    
    int notify_code;                 /* contiene il tipo di notifica che l'utente dovrà visualizzare */
    bool status;                     /* notifica all'utente se la cosa è andata a buon fine */
} desc_resp;

/**** GESTIONE DELL'I/O MULTIPLEXING CON LE LISTE ****/
typedef struct desc_fd {            
    int id;                 /* id del file descriptor */
    struct desc_fd* next;   /* puntatore al succesivo elemento della lista */
} desc_fd;

fd_set master;              /* set principale gestito attraverso la macro */  
fd_set read_fds;            /* set di lettura gestito tramite la select */
int fdmax;                  /* numero max del descrittore */

desc_fd* head_fd;           
void insert_fd_decreasing(desc_fd**, int);

/* procedure per il server */
int init_server(int);
int accept_request(int);
int find_socket_ready();
void remove_socket(int);
void _log_server_(enum TypeLog, int, void*);
void to_string(enum TypeStruct, void*, char*);
void string_to_msg(const char*, desc_msg*);
void resp_to_string(desc_resp, char*);

/* procedure per il client */
int init_client();
desc_msg normalize_command(char*, enum TypeMessage, bool*);
void msg_to_string(desc_msg, char*);
void string_to_resp(char*, desc_resp*);

/* procedure condivise da entrambi */
int send_to_socket(int, const char*);
int receive_from_socket(int, char*);
int close_socket(int);

#endif