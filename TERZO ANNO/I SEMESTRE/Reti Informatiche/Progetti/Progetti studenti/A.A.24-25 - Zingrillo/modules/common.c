// Modulo di utilità in comune tra client e server

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <unistd.h>
#include <errno.h>
#include "../include/params.h"
#include "../include/common.h"

// Funzione di utilità che stampa un numero di caratteri '+' pari a NUMPLUS
void printplus()
{
    for (int i = 0; i < NUMPLUS; i++)
        printf("+");
}

// Funzione di utilità che stampa il messaggio di benvenuto
void intro()
{
    printf("Trivia Quiz\n");
    printplus();
    printf("\n");
}

// Funzione di utilità che gestisce gli errori di invio
void gestisciErroriSend(int ret, int len, int sd, bool callFromThread)
{
    if (ret != len)
    {
        // Se la connessione è stata chiusa dall'altro host, chiudo la connessione e termino il thread o il processo
        if (ret == -1 && (errno == EPIPE || errno == ECONNRESET))
        {
            close(sd);
            callFromThread ? pthread_exit(NULL) : exit(CONNECTION_CLOSED);
        }
        else
        {
            // Altrimenti, stampo un messaggio di errore e termino il processo (nel caso di un thread server, l'intero processo)
            perror("Errore durante l'invio del messaggio");
            exit(EXIT_FAILURE);
        }
    }
}

// Funzione di utilità che invia un messaggio al socket sd
// Il parametro callFromThread è true se la funzione è chiamata da un thread, false altrimenti
void inviaMsg(char *msg, int sd, bool callFromThread)
{
    uint32_t lenNet; // utilizzo un tipo certificato per la lunghezza del messaggio
    int len, ret;
    // invio la lunghezza del messaggio, non comprensiva del carattere di terminazione
    len = strlen(msg);
    lenNet = htonl(len); // converto la lunghezza in formato network
    ret = send(sd, &lenNet, sizeof(u_int32_t), 0);
    gestisciErroriSend(ret, sizeof(u_int32_t), sd, callFromThread);
    // invio il messaggio
    ret = send(sd, msg, len, 0);
    gestisciErroriSend(ret, len, sd, callFromThread);
}

// Funzione di utilità che gestisce gli errori di ricezione
void gestisciErroriRecv(int ret, int len, bool callFromThread, int sd)
{
    // Se la connessione è stata chiusa dall'altro host, chiudo la connessione e termino il thread o il processo
    if (!ret)
    {
        printf("La connessione è stata chiusa\n");
        close(sd);
        callFromThread ? pthread_exit(NULL) : exit(CONNECTION_CLOSED);
    }
    // Altrimenti, stampo un messaggio di errore e termino il processo (nel caso di un thread server, l'intero processo)
    else if (ret != len)
    {
        perror("Errore durante la ricezione del messaggio");
        close(sd);
        exit(EXIT_FAILURE);
    }
}
// Funzione di utilità che riceve un messaggio dal socket sd
// Il parametro callFromThread è true se la funzione è chiamata da un thread, false altrimenti
void riceviMsg(char *msg, int sd, bool callFromThread)
{
    int ret;
    uint32_t len; // utilizzo un tipo certificato per la lunghezza del messaggio
    // ricevo la lunghezza del messaggio
    ret = recv(sd, &len, sizeof(uint32_t), 0);
    len = ntohl(len); // converto la lunghezza in formato host
    gestisciErroriRecv(ret, sizeof(uint32_t), callFromThread, sd);
    // ricevo il messaggio
    ret = recv(sd, msg, len, 0);
    gestisciErroriRecv(ret, len, callFromThread, sd);
    // aggiungo il carattere di terminazione della stringa
    msg[len] = '\0';
}

// Funzione di utilità che gestisce gli errori di allocazione della memoria
void gestisciErroriMalloc(void *ptr)
{
    if (ptr == NULL)
    {
        perror("Errore durante l'allocazione della memoria");
        exit(EXIT_FAILURE);
    }
}