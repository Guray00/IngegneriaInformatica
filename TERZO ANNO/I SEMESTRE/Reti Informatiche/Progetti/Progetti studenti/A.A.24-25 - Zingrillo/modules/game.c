// Modulo server finalizzato alla gestione del gioco di un client
#include <stdio.h>
#include <pthread.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include "../include/database.h"
#include "../include/game.h"
#include "../include/common.h"

// Funzione che registra un utente, controllando che il nickname non sia già presente
// e ritornando un puntatore all'utente registrato
struct utente *registraUtente(int socket, struct utenti *players, int num_temi)
{
    char nickname[TEXTLEN];
    bool ok;
    do
    {
        riceviMsg(nickname, socket, true);         // Ricevo il nickname
        ok = controllaNickname(nickname, players); // Controllo se il nickname è già presente
        inviaMsg(ok ? "1" : "0", socket, true);    // Invio il risultato del controllo
    } while (!ok);
    // Inizialiizzo il nuovo utente
    struct utente *new = (struct utente *)malloc(sizeof(struct utente));
    gestisciErroriMalloc(new);
    strcpy(new->nickname, nickname);
    new->left = NULL;
    new->right = NULL;
    new->punteggioTemi = (struct punteggioTema *)malloc(num_temi * sizeof(struct punteggioTema));
    gestisciErroriMalloc(new->punteggioTemi);
    for (int i = 0; i < num_temi; i++)
    {
        new->punteggioTemi[i].completato = false;
        new->punteggioTemi[i].giocato = false;
        new->punteggioTemi[i].punteggio = 0;
    }
    // Inserisco il nuovo utente nell'albero binario di ricerca
    inserisciUtente(players, new);
    return new;
}

// Funzione che invia all'utente i punteggi relativi a un tema, facendo una visita in-order dell'albero binario di ricerca
void inviaPunteggi(struct punteggio *root, int socket)
{
    if (root != NULL)
    {
        char buffer[TEXTLEN];
        inviaPunteggi(root->left, socket);
        sprintf(buffer, "%d", root->punti);
        inviaMsg(buffer, socket, true); // Invio il punteggio
        sprintf(buffer, "%s", root->giocatore->nickname);
        inviaMsg(buffer, socket, true); // Invio il nickname
        inviaPunteggi(root->right, socket);
    }
}

// Funzione che invia tutti i punteggi relativi ai temi giocati
void inviaTuttiiPunteggi(struct classifica *score, int socket, int num_temi)
{
    char buffer[TEXTLEN];
    sprintf(buffer, "%d", num_temi);
    inviaMsg(buffer, socket, true); // Invio il numero di temi
    for (int i = 0; i < num_temi; i++)
    {
        // prendo il lock sul mutex del tema
        pthread_mutex_lock(score->vettoreMutex + i);
        sprintf(buffer, "%d", score->vettorePartecipanti[i]);
        // invio il numero di partecipanti
        inviaMsg(buffer, socket, true);
        inviaPunteggi(score->vettorePunteggi[i], socket);
        // rilascio il lock
        pthread_mutex_unlock(score->vettoreMutex + i);
    }
}

// Funzione che gestisce la scelta del quiz da parte dell'utente, ritornando il quiz scelto
int proponiQuiz(int socket, struct quiz *q, struct utente *player, struct classifica *score, struct utenti *players)
{
    char buffer[TEXTLEN];
    int scelta, num_temi_disp = 0;
    // num_temi_disp è il numero di temi non ancora giocati
    for (int i = 0; i < q->n_temi; i++)
    {
        if (!player->punteggioTemi[i].giocato)
            num_temi_disp++;
    }
    // Manteniamo la corrispondenza tra la numerazione dei temi non giocati e quella dei temi
    int *corrispondenze = (int *)malloc(num_temi_disp * sizeof(int));
    gestisciErroriMalloc(corrispondenze);
    sprintf(buffer, "%d", num_temi_disp);
    inviaMsg(buffer, socket, true); // Invio il numero di temi non ancora giocati
    if (num_temi_disp == 0)
    { // Se non ci sono temi disponibili l'utente viene eliminato e la connessione chiusa
        eliminaTuttiPunteggi(score, player, q->n_temi);
        eliminaDaDB(players, player->nickname, q->n_temi, score);
        close(socket);
        return 0;
    }
    int ultima_corrispondenza = 0;
    // Invio i temi non ancora giocati
    for (int i = 0; i < q->n_temi; i++)
    {
        if (player->punteggioTemi[i].giocato)
            continue;
        strcpy(buffer, q->temi[i].nome);
        inviaMsg(buffer, socket, true);
        corrispondenze[ultima_corrispondenza] = i;
        ultima_corrispondenza++;
    }
    // Ricevo la scelta dell'utente
    riceviMsg(buffer, socket, true);
    while (true)
    {
        if (strcmp(buffer, FINEQUIZ) == 0)
        {
            eliminaTuttiPunteggi(score, player, q->n_temi);
            eliminaDaDB(players, player->nickname, q->n_temi, score);
            close(socket);
            return 0;
        }
        if (strcmp(buffer, MOSTRAPUNTEGGIO) == 0)
        {
            inviaTuttiiPunteggi(score, socket, q->n_temi);
            riceviMsg(buffer, socket, true);
            continue;
        }
        scelta = atoi(buffer);
        // Controllo lato server che la scelta sia valida
        if (scelta < 1 || scelta > num_temi_disp)
        {
            printf("Scelta non valida\n");
            exit(EXIT_FAILURE);
        }
        break;
    }

    // Aggiorno le strutture dati
    scelta = corrispondenze[scelta - 1] + 1;
    player->punteggioTemi[scelta - 1].giocato = true;
    return scelta;
}



// Funzione che gestisce il quiz, ritornando true se l'utente decide di continuare, false altrimenti
bool gestisciQuiz(int socket, struct quiz *q, int quizScelto, struct utente *player, struct classifica *score, struct utenti *players)
{
    char buffer[TEXTLEN];
    int punteggio = 0;
    bool correct;
    // Inserisco in classifica l'utente con punteggio 0
    inserisciInClassifica(score, player, punteggio, quizScelto);
    for (int i = 0; i < THEMESIZE; i++)
    {
        strcpy(buffer, q->temi[quizScelto - 1].domande[i].testo);
        inviaMsg(buffer, socket, true);  // Invio la domanda
        riceviMsg(buffer, socket, true); // Ricevo la risposta
        if (strcmp(buffer, FINEQUIZ) == 0)
        {                                                             // Se l'utente decide di uscire dal quiz
            eliminaTuttiPunteggi(score, player, q->n_temi);           // Elimino tutti i punteggi dell'utente
            eliminaDaDB(players, player->nickname, q->n_temi, score); // Elimino l'utente dal database
            close(socket);                                            // Chiudo la connessione
            return false;
        }
        if (strcmp(buffer, MOSTRAPUNTEGGIO) == 0)
        {                                                  // Se l'utente chiede di visualizzare i punteggi
            inviaTuttiiPunteggi(score, socket, q->n_temi); // Invio i punteggi
            i--;                                           // Decremento i in modo che la prossima iterazione mostri la domanda corrente
        }
        else
        {
            correct = rispostaCorretta(&q->temi[quizScelto - 1].domande[i], buffer); // Controllo se la risposta è corretta
            inviaMsg(correct ? "1" : "0", socket, true);                             // Invio il risultato
            if (correct)
            { // Se la risposta è corretta, aggiorno coerentemente le strutture dati
                eliminaDaClassifica(score, player->nickname, punteggio, quizScelto);
                punteggio++;
                player->punteggioTemi[quizScelto - 1].punteggio = punteggio;
                inserisciInClassifica(score, player, punteggio, quizScelto);
            }
        }
    }
    // Se l'utente ha completato il quiz, aggiorno le strutture dati
    player->punteggioTemi[quizScelto - 1].completato = true;
    score->vettoreCompletati[quizScelto - 1]++;
    return true;
}

void *partita(void *game)
{
    int quizScelto;
    struct utente *player;
    // recupero i dati passati al thread
    int client_socket = ((struct game *)game)->socket;
    struct utenti *players = ((struct game *)game)->players;
    struct classifica *score = ((struct game *)game)->classifica;
    struct quiz *q = ((struct game *)game)->q;
    int num_temi = q->n_temi;
    // Registro l'utente
    player = registraUtente(client_socket, players, num_temi);
    // Finché l'utente decide di continuare il quiz e ci sono temi disponibili, propongo un quiz e gestisco le risposte
    while ((quizScelto = proponiQuiz(client_socket, q, player, score, players)) && gestisciQuiz(client_socket, q, quizScelto, player, score, players))
        ;
    pthread_exit(NULL);
}