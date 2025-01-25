#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <fcntl.h>
#include <unistd.h>

#include "include/game.h"
#include "include/database.h"
#include "include/params.h"
#include "include/common.h"

// gestisco il segnale SIGPIPE evitando il comportamento di default
void handle_sigpipe(int sig) {}
// fai notare la modularità dei quiz
// fai notare che hai definito un tuo formato per i quiz
// fai notare lo standard c89
// fai notare gli alberi binari come strutture dati
// fai notare la gestione dei segnali
// fai notare la gestione dei thread
// il terminatore di stringa non viaggia sulla rete
// parla dei vari moduli del codice
// parla del formato dei quiz che lascia flessibilità nei testi e permette risposte multiple

int main()
{
    int server_socket, client_socket, ret, n_temi, flags;
    struct sockaddr_in server_address;
    struct datiPdC *dati;
    struct classifica *score;
    struct utenti *players;
    pthread_t *thread;
    struct quiz q;
    signal(SIGPIPE, handle_sigpipe);
    // effettuo il parsing dei dati dei quiz
    parse(&q);
    // inizializzo la lista degli utenti
    players = (struct utenti *)malloc(sizeof(struct utenti));
    gestisciErroriMalloc(players);
    players->root = NULL;
    pthread_mutex_init(&players->mutex, NULL);
    players->numUtenti = 0;
    // inizializzo la classifica
    n_temi = q.n_temi;
    score = (struct classifica *)malloc(sizeof(struct classifica));
    gestisciErroriMalloc(score);
    score->vettorePunteggi = malloc(n_temi * sizeof(struct punteggio));
    gestisciErroriMalloc(score->vettorePunteggi);
    score->vettoreMutex = malloc(n_temi * sizeof(pthread_mutex_t));
    gestisciErroriMalloc(score->vettoreMutex);
    score->vettorePartecipanti = malloc(n_temi * sizeof(int));
    gestisciErroriMalloc(score->vettorePartecipanti);
    score->vettoreCompletati = malloc(n_temi * sizeof(int));
    gestisciErroriMalloc(score->vettoreCompletati);
    for (int i = 0; i < n_temi; i++)
    {
        pthread_mutex_init(score->vettoreMutex + i * sizeof(pthread_mutex_t), NULL);
        score->vettorePartecipanti[i] = 0;
        score->vettorePunteggi[i] = NULL;
        score->vettoreCompletati[i] = 0;
    }
    // inizializzo la struttura con i dati da passare al thread che gestisce il pannello di controllo
    dati = (struct datiPdC *)malloc(sizeof(struct datiPdC));
    gestisciErroriMalloc(dati);
    dati->players = players;
    dati->score = score;
    dati->q = &q;
    // configuro stdin per la modalità non bloccante
    flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);
    // creo un thread per il pannello di controllo
    thread = (pthread_t *)malloc(sizeof(pthread_t));
    gestisciErroriMalloc(thread);
    ret = pthread_create(thread, NULL, pannelloDiControllo, (void *)dati);
    if (ret)
    {
        perror("Errore durante la creazione del thread che gestisce il pannello di controllo");
        exit(EXIT_FAILURE);
    }

    // inizializzo il socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1)
    {
        perror("Errore durante la creazione del socket");
        exit(EXIT_FAILURE);
    }
    // inizializzo la struttura per il server
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(PORT);
    inet_pton(AF_INET, SERVER_IP, &server_address.sin_addr);
    // effettuo il binding del socket
    ret = bind(server_socket, (struct sockaddr *)&server_address, sizeof(server_address));
    if (ret == -1)
    {
        perror("Errore durante il binding del socket");
        exit(EXIT_FAILURE);
    }
    ret = listen(server_socket, BACKLOG);
    if (ret == -1)
    {
        perror("Errore durante la listen del socket");
        exit(EXIT_FAILURE);
    }
    // accetto connessioni
    while (1)
    {
        struct sockaddr_in client_address;
        socklen_t client_address_len = sizeof(client_address);
        client_socket = accept(server_socket, (struct sockaddr *)&client_address, &client_address_len);
        if (client_socket == -1)
        {
            perror("Errore durante la connessione con il client");
            exit(EXIT_FAILURE);
        }

        // crea un nuovo thread per ogni client
        pthread_t *thread = (pthread_t *)malloc(sizeof(pthread_t));
        gestisciErroriMalloc(thread);
        // inizializzo la struct game con i dati da passare al thread
        struct game *g = (struct game *)malloc(sizeof(struct game));
        gestisciErroriMalloc(g);
        g->q = &q;
        g->players = players;
        g->classifica = score;
        g->socket = client_socket;
        ret = pthread_create(thread, NULL, partita, (void *)g);
        if (ret)
        {
            perror("Errore durante la creazione di un nuovo thread");
            exit(EXIT_FAILURE);
        }
    }

    return 0;
}
