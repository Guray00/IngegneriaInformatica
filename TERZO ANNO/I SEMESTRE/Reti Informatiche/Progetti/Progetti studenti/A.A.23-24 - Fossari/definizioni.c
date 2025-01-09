#include <stdlib.h>                 //sc
#include <arpa/inet.h>              //sc  
#include <string.h>                 //sc
#include <unistd.h>                 //sc
#include <stdio.h>                  //sc

// definizione macro ==================================================================================
#define NAME_LEN 32                             // lunghezza dei nomi
#define DESCR_LOCS 256                          // lunghezza descrizioni location
#define DESCR_OBJS 128                          // lunghezza descrizioni oggetto
#define FIELD_LEN 32                            // lunghezza di un qualsiasi parametro
#define QUESTION_LEN 256                        // lunghezza indovinelli
#define ANSWER_LEN 32                           // lunghezza risposte
#define CUSTOM_MEX_LEN 128                      // lunghezza messaggi speciali
#define XCH_BUF_LEN 1024                        // lunghezza massima buffer di scambio dei messaggi
#define ROOM_NUM 1                              // numero di escape room diverse
#define LOC_NUM 4                               // numero di location per room
#define OBJ_NUM 16                              // numero massimo di oggetti generato in una room
#define ENIGMA_NUM 8                            // numero di enigmi per room
#define GRAF_LEN 24                             // lunghezza del contenuto dei graffiti
#define COUNTDOWN 500                           // numero di secondi di tempo per vincere una room
#define TO_WIN 10                               // token necessari a vincere
#define GRAF_NUM LOC_NUM*ROOM_NUM               // numero di graffiti supportati
#define INVSIZE 3                               // dimensione inventario
#define REGISTER 'q'                            // anzichè spedire tutto il comando, mandiamo invece un carattere che lo rappresenti -> inviamo un char invece che una stringa intera
#define LOGIN 'w'
#define START 'e'
#define OBJS 'r'
#define LOOK 't'
#define TAKE 'y'
#define ANSWER 'u'
#define USE 'i'
#define GRAFFITO 'o'
#define DROP 'p'
#define WRONG_FORMAT printf("Comando non valido. Digita \"help\" se hai bisogno di aiuto.\n");  // messaggio generico di risposta ad un comando erroneo

// funzioni di utilità ed inizializzazione ============================================================

void sockstats(struct sockaddr_in addr){                            // una funzione che mette a video alcuni dati relativi alle strutture sockaddr_in
    char ip_buf[INET_ADDRSTRLEN];
    inet_ntop(AF_INET,  &addr.sin_addr, ip_buf, INET_ADDRSTRLEN);
    printf("IP_port: %s:%hu\n", ip_buf, ntohs(addr.sin_port));
}

void sockinit(struct sockaddr_in * addr, const char * ip, uint16_t port){       // funzione che generalizza l'inizializzazione di una sockaddr_in
    addr->sin_family = AF_INET;
    addr->sin_port = htons(port);
    inet_pton(AF_INET, ip, &addr->sin_addr);
}

int doppia_recv(int sd, void * buff){               // funzione che riceve una coppia len ,messaggio
    int ret, len;
    ret = recv(sd, &len, sizeof(int), 0);           // ricevi lunghezza
    if(ret == -1){
        perror("len doppia_recv. ");
        return -1;
    }
    if(!ret){                                       // se torna 0 allora si è ricevuta una close()
        printf("Ricevuta close()\n");
        return -2;                                  // una close ritorna -2 in doppia_recv
    }
    len = ntohl(len);                               // network to host
    //printf("---doppia_recv: %d byte\n", len);
    if(!len) return 0;                              // se abbiamo ricevuto len = 0 allora il messaggio sarà vuoto
    ret = recv(sd, buff, len, 0);                   // ricevi il messaggio
    if(ret == -1){
        perror("buf doppia_recv. ");
        return -1;
    }
    memset(buff + ret, 0, 1);                       // inseriamo il carattere '\0' alla fine del buffer appena ricevuto
    //printf("---doppia_recv buffer: %s\n", buff);
    return len;
}

int doppia_send(int sd, void * buff, int len){      // funzione che invia una coppia len, messaggio
    int ret;
    ret = htonl(len);                               // lunghezza in big endian
    ret = send(sd, &ret, sizeof(int), 0);           // inviamo la lunghezza
    //printf("---doppia_send: %d byte\n", len);
    if(ret == -1){
        perror("len doppia_send. ");
        return -1;
    }
    if(!ntohl(len)) return 0;                       // se abbiamo inviato len = 0 allora il messaggio è vuoto
    ret = send(sd, buff, len, 0);                   // invio del messaggio
    //printf("---doppia_send buffer: %s\n", buff);
    if(ret == -1){
        perror("buf doppia_send. ");
        return -1;
    }
    return ret;
}