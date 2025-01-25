#include "tcp.h"

/************************* FUNZIONI SERVER ***********************/
int init_server(int port) {
    struct sockaddr_in server_addr;
    const int BACKLOG = 20;

    /* azzero i set */
    FD_ZERO(&master);
    FD_ZERO(&read_fds);

    /* creazione socket di ascolto */
    int listener = socket(AF_INET, SOCK_STREAM, 0);
    if (listener == -1) {
        _log_server_(ERROR, port, "creazione socket non riuscita.");
        exit(EXIT_FAILURE);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr);
    server_addr.sin_port = htons(port);

    /* associare alla socket la porta e l'indirizzo ip */    
    if (bind(listener, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        _log_server_(ERROR, port, "esecuzione primitiva bind non riuscita.");
        close(listener);
        sleep(5);
        exit(EXIT_FAILURE);
    }
    
    /* mettersi in ascolto con una backlog di 20 richieste max accodate */
    if (listen(listener, BACKLOG) == -1) {
        _log_server_(ERROR, port, "esecuzione primitiva listen non riuscita.");
        close(listener);
        exit(EXIT_FAILURE);
    }
    
    /* agggiungo stdin al master */
    FD_SET(STDIN_FILENO, &master); 
    /* aggiungo il listener al master */
    FD_SET(listener, &master); 

    /* aggiungo i descrittori alla lista (listener e stdin)*/
    insert_fd_decreasing(&head_fd, listener);
    insert_fd_decreasing(&head_fd, STDIN_FILENO);
    fdmax = head_fd->id;

    _log_server_(START_SERVER, port, "");
    return listener;
}

int accept_request(int listener){
    struct sockaddr_in ind_client;
    socklen_t len = sizeof(ind_client);
    
    /* accettazione di una nuova richiesta di connessione da parte di un client */
    int sd_dati = accept(listener, (struct sockaddr*) &ind_client, &len);
    
    if(sd_dati == -1){  
        perror("server -> errore su accept.\n");	
        exit(EXIT_FAILURE);
    }
    
    /* aggiungo il fd al set master */
    FD_SET(sd_dati, &master);

    /* devo aggiungere un nuovo fd alla lista del fd */
    insert_fd_decreasing(&head_fd, sd_dati);
    /* aggiorno la fdmax */
    fdmax = head_fd->id;

    return sd_dati;
}

int find_socket_ready(){
    read_fds = master;
    select(fdmax + 1, &read_fds, NULL, NULL, NULL);
    
    /* controllo nella lista quale fd è pronto */
    desc_fd* fd = head_fd;
    while (fd != NULL) {
        if(FD_ISSET(fd->id, &read_fds))
            return fd->id;
        fd = fd->next;
    }
    return -1;
}

void remove_socket(int fd){
    /* rimozione della socket dalla lista di desc_fd */
    desc_fd* curr_fd = head_fd;
    desc_fd* prec_fd = NULL;
    while(curr_fd != NULL && curr_fd->id != fd){
        prec_fd = curr_fd;
        curr_fd = curr_fd->next;
    }
    
    if(curr_fd != NULL){
        if(prec_fd == NULL){
            head_fd = curr_fd->next;
        } else {
            prec_fd->next = curr_fd->next;
        }
        free(curr_fd);
        
        /* rimozione dal set master */
        FD_CLR(fd, &master);

        /* nuovo fd max */
        fdmax = head_fd->id;
    }
}

void _log_server_(enum TypeLog type, int sd, void* info){
    char str[MAX_DIM_BUFF];

    switch (type){
        case STDIN:
            printf("[%s] ho letto %s.\n", timestamp(), (char*) info); 
            break;  

        case START_SERVER:  
            printf("[%s] START:\t il server è in ascolto sulla porta %d.\n", timestamp(), sd); 
            break;

        case STOP_SERVER:
            printf("[%s] STOP:\t il server ha smesso di servire richieste.\n", timestamp()); 
            break;

        case NEW_SOCKET:
            printf("[%s] ho creato un nuovo socket %i.\n", timestamp(), sd);
            break;

        case SOCKET_READY:
            printf("[%s] il socket %i è pronto.\n", timestamp(), sd);
            break;

        case SOCKET_CLOSE:
            printf("[%s] il socket %i è stato chiuso.\n", timestamp(), sd);
            break;

        case MESSAGE_ARRIVED:
            to_string(DESC_MSG, info, str);
            printf("[%s] ho ricevuto da %d: \"%s\"\n", timestamp(), sd, str);
            break;

        case MESSAGE_SENT:
            to_string(DESC_RESP, info, str);
            printf("[%s] ho inviato a %d: \"%s\"\n", timestamp(), sd, str);
            break;

        case ERROR:
            printf("[%s] %s\n", timestamp(), (char *) info);
            break;
    }
}

void to_string(enum TypeStruct type, void* desc, char* str){
    desc_msg* msg;
    desc_resp* resp;
    char temp[MAX_DIM_BUFF]; 
    
    /* in funzione del tipo di struttura effettuiamo la to_string relativa */
    switch (type){
        case DESC_MSG:
            msg = (desc_msg *) desc;
            if(msg->type == COMMAND)
                strcpy(str, "< COMMAND, ");
            else if(msg->type == RESPONSE_TEXT)
                strcpy(str, "< RESPONSE_TEXT, ");
            else if(msg->type == SHADOW)
                strcpy(str, "< SHADOW, ");
            
            sprintf(temp, "\"%s\", \"%s\", \"%s\", %d >", msg->command, msg->operand_1, msg->operand_2, msg->num_operand);
            strcat(str, temp);
            break;
        case DESC_RESP:
            resp = (desc_resp *) desc;
            if(resp->expeted == COMMAND)
                strcpy(str, "< COMMAND, ");
            else if(resp->expeted == RESPONSE_TEXT)
                strcpy(str, "< RESPONSE_TEXT, ");

            sprintf(temp, "%d, \"", resp->dim_response - 1);
            strcat(str, temp);

            strcpy(temp, "");   
            substr(resp->response, temp, 0, 10);
            if(strlen(temp) != 0) 
                strcat(temp, "...\", ");
            else 
                strcat(temp, "\", ");
            strcat(str, temp);

            sprintf(temp, "%d, %d, %d, ", resp->token, resp->seconds, resp->notify_code);
            strcat(str, temp);

            if(resp->status)
                strcat(str, "true >");
            else 
                strcat(str, "false >");
            
            break;
    }
}

void string_to_msg(const char* msg, desc_msg* msg_norm){
    sscanf(msg, "%d %s %s %s %d", (int*)&msg_norm->type, msg_norm->command, msg_norm->operand_1, msg_norm->operand_2, &msg_norm->num_operand);

    /* durante la strasmissione del messaggio una stringa vuota viene inviata codificata con il carattere '*' */
    if(!strcmp(msg_norm->command, "*")) strcpy(msg_norm->command, "");
    if(!strcmp(msg_norm->operand_1, "*")) strcpy(msg_norm->operand_1, "");
    if(!strcmp(msg_norm->operand_2, "*")) strcpy(msg_norm->operand_2, "");
}

void resp_to_string(desc_resp resp, char* str){
    /* codifico i valori da stringa nulla */
    if(!strcmp(resp.response, "")){
        strcpy(resp.response, "*");
        resp.dim_response = 1;
    }
    sprintf(str, "%d %d %s %d %d %d %d", resp.expeted, resp.dim_response, resp.response, resp.token, resp.seconds, resp.status, resp.notify_code);
}

/************************** FUNZIONI LATO CLIENT **********************/

int init_client(){
	struct sockaddr_in indirizzo;
	int ret;
    int port = 4242;
    int sd;
    
    sd = socket(AF_INET, SOCK_STREAM, 0);
    if (sd == -1) {
        perror("errore -> creazione socket non riuscita.\n");
        exit(EXIT_FAILURE);
    }   
    
    indirizzo.sin_family = AF_INET;
	indirizzo.sin_port = htons(port);
	inet_pton(AF_INET, "127.0.0.1", &indirizzo.sin_addr);

	ret = connect(sd, (struct sockaddr*) &indirizzo, sizeof(indirizzo));
	if(ret == -1){
		perror("errore -> server non raggiungibile.\n");
        close_socket(sd);
        return ret;
	}
    return sd;
}

desc_msg normalize_command(char* command, enum TypeMessage type, bool* status){
    char* str = malloc(strlen(command)+1);
    int count = 0;
    desc_msg msg_norm;
    msg_norm.type = type;
    
    if(type == COMMAND || type == SHADOW){  /* l'utente vuole inviare un comando */
        /* innanzitutto bisogna capire quanti operatori sono stati associati al comando */
        /* conto gli spazi " " all'interno della stringa */

        /* rimuvere spazi all'inizio e in fondo */
        trim(command);

        /* backup del comando */
        strcpy(str, command); 
        /* conto gli spazi */
        while ((str = strchr(str, ' ')) != NULL) {
            count++;
            str++; 
        }   
        
        /* se ci sono più di due spazi è un errore, non è ammesso alcun comando simile */
        if(count > 2){
            printf("errore --> comando non disponibile.\n");
            *status = false;
            return msg_norm;
        }

        /* assegnamento del comando/operandi richiesti dall'utente nel descrittore di messaggio */
        strcpy(msg_norm.command, strtok(command, " "));  /* ottenimento del comando */
        msg_norm.num_operand = count;                    /* attribuzione del numero di operandi nel comando */
        strcpy(msg_norm.operand_1, "");                  /* pulizia dei campi, potrebbero non essere usati */
        strcpy(msg_norm.operand_2, "");
        
        if(count > 0){
            strcpy(msg_norm.operand_1, strtok(NULL, " "));  /* ottenimento del primo operando */
            if(count > 1){
                strcpy(msg_norm.operand_2, strtok(NULL, " "));  /* ottenimento del secondo operando */
            }
        }
        free(str);
        *status = true;
    } else if(type == RESPONSE_TEXT){   /* utente vuole inviare una risposta testuale */
        strcpy(msg_norm.command, command);
        msg_norm.num_operand = 0;                        /* attribuzione del numero di operandi nel comando */
        strcpy(msg_norm.operand_1, "");                  /* pulizia dei campi, potrebbero non essere usati */
        strcpy(msg_norm.operand_2, "");
        *status = true;
    }
    return msg_norm;
}

void msg_to_string(desc_msg msg_norm, char* msg){
    /* codifico i valori da stringa nulla */
    if(!strcmp(msg_norm.command, "")) strcpy(msg_norm.command, "*");
    if(!strcmp(msg_norm.operand_1, "")) strcpy(msg_norm.operand_1, "*");
    if(!strcmp(msg_norm.operand_2, "")) strcpy(msg_norm.operand_2, "*");

    sprintf(msg, "%d %s %s %s %d", msg_norm.type, msg_norm.command, msg_norm.operand_1, msg_norm.operand_2, msg_norm.num_operand);
}

void string_to_resp(char* str, desc_resp* resp){
    char* temp = malloc(sizeof(desc_resp));
    char* temp2 = malloc(sizeof(desc_resp));
    char dim[4];
    strcpy(temp, str);
    /* si estraggono i primi due parametri interi */
    sscanf(temp, "%d %d", (int*)&resp->expeted, &resp->dim_response);
    /* il successivo carattere è la risposta che contiene anche spazi e quindi bisogna usare la funzioni stringa */
    sprintf(dim, "%d", resp->dim_response);
    substr(temp, temp2, 3 + strlen(dim), 0);
    substr(temp2, resp->response, 0, resp->dim_response);
    substr(temp2, temp, resp->dim_response, 0);
    
    sscanf(temp, "%d %d %d %d", &resp->token, &resp->seconds, (int*)&resp->status, &resp->notify_code);
    
    if(!strcmp(resp->response, "*")) {
        strcpy(resp->response, "");
        resp->dim_response = 0;
    }
    free(temp);
    free(temp2);
}

/************************** FUNZIONI PER ENTRAMBI *********************/

int send_to_socket(int sd, const char* buff){
    /* prima di tutto devo comunicare la dimensione del messaggio al server */
    int len = strlen(buff) + 1;
    uint16_t dim = htons(len);

    int ret;
    ret = send(sd, &dim, sizeof(uint16_t), 0);
    if(ret < 0){
        perror("errore -> invio della dimensione del messaggio non avvenuto.\n");
        exit(EXIT_FAILURE);
    }

    /* adesso invio il messaggio vero e proprio */
    ret = send(sd, (void*) buff, len, 0);
    if(ret < 0){
        perror("errore -> invio del messaggio non avvenuto.\n");
        exit(EXIT_FAILURE);
    }
    return ret;
}   

int receive_from_socket(int sd, char* buff){
    /* innanzitutto devo ricevere la dimensione del messaggio */
    int len;
    uint16_t dim;
    
    int ret = recv(sd, &dim, sizeof(uint16_t), 0);
    if(ret < 0){
        perror("errore -> ricezione della dimensione del messaggio non avvenuta.\n");
        exit(EXIT_FAILURE);
    } else if(ret == 0)
        return 0;

    len = ntohs(dim);
    /* adesso sono pronto a ricevere il messaggio */
    ret = recv(sd, (void*) buff, len, 0);
    if(ret < 0){
        perror("errore -> ricezione del messaggio non avvenuta.\n");
        exit(EXIT_FAILURE);
    }
    return ret;
}

int close_socket(int sd){
    return close(sd);
}

void insert_fd_decreasing(desc_fd** head, int id) {
    desc_fd* newfd = malloc(sizeof(desc_fd));
    if (newfd == NULL) {
        perror("server -> impossibile allocare memoria per un fd");
        exit(EXIT_FAILURE);
    }

    /* insrimento in lista in ordine decrescente */
    newfd->id = id;
    newfd->next = NULL;

    if (*head == NULL || id > (*head)->id) {
        newfd->next = *head;
        *head = newfd;
    } else {
        desc_fd* current = *head;
        while (current->next != NULL && current->next->id > id) {
            current = current->next;
        }
        newfd->next = current->next;
        current->next = newfd;
    }
}