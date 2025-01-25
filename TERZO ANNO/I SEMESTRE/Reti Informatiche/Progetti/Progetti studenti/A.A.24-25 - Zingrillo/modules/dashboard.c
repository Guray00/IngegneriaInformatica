// Modulo server finalizzato alla gestione del pannello di controllo

#include "../include/dashboard.h"
#include "../include/database.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <fcntl.h>

// Funzione che stampa i punteggi di un utente, facendo una visita in-order dell'albero binario di ricerca
void stampaPunteggi(struct punteggio *root)
{
    if (root != NULL)
    {
        stampaPunteggi(root->left);
        printf("- %s %d\n", root->giocatore->nickname, root->punti);
        stampaPunteggi(root->right);
    }
}
// Funzione che stampa gli utenti, facendo una visita in-order dell'albero binario di ricerca
void stampaUtente(struct utente *root)
{
    if (root != NULL)
    {
        stampaUtente(root->left);
        printf("- %s\n", root->nickname);
        stampaUtente(root->right);
    }
}

// Funzione che prende il lock sul mutex degli utenti e invoca stampaUtente
void stampaPartecipanti(struct utenti *players)
{
    pthread_mutex_lock(&players->mutex);
    printf("Partecipanti (%d)\n", players->numUtenti);
    stampaUtente(players->root);
    pthread_mutex_unlock(&players->mutex);
}

// Funzione che stampa gli utenti che hanno completato un tema, facendo una visita in-order dell'albero binario di ricerca
void stampaCompletatiTema(struct utente *root, int tema)
{
    if (root != NULL)
    {
        stampaCompletatiTema(root->left, tema);
        if (root->punteggioTemi[tema].completato)
            printf("- %s\n", root->nickname);
        stampaCompletatiTema(root->right, tema);
    }
}

// Funzione che prende il lock sul mutex degli utenti e invoca stampaCompletatiTema
void stampaCompletati(struct utenti *players, int num_temi, struct classifica *score)
{
    pthread_mutex_lock(&players->mutex);
    for (int i = 0; i < num_temi; i++)
    {
        printf("Quiz Tema %d completato\n", i + 1);
        if (score->vettoreCompletati[i])
            stampaCompletatiTema(players->root, i);
        else
            printf("------\n");
        printf("\n");
    }
    pthread_mutex_unlock(&players->mutex);
}

// Funzione che prende il lock sul mutex di ogni tema e invoca stampaPunteggi
void stampaClassifica(struct classifica *score, int num_temi)
{
    for (int i = 0; i < num_temi; i++)
    {
        pthread_mutex_lock(score->vettoreMutex + i);
        printf("Punteggio tema %d\n", i + 1);
        stampaPunteggi(score->vettorePunteggi[i]);
        printf("\n");
        pthread_mutex_unlock(score->vettoreMutex + i);
    }
}

// Funzione che gestisce il pannello di controllo del server
void *pannelloDiControllo(void *dati)
{
    // recupero i dati passati al thread
    struct datiPdC *datiConvertiti = (struct datiPdC *)dati;
    struct utenti *players = datiConvertiti->players;
    struct classifica *score = datiConvertiti->score;
    struct quiz *q = datiConvertiti->q;

    listaTemi(q);                // Stampo i temi
    stampaPartecipanti(players); // Stampo i partecipanti
    printf("\n");
    stampaClassifica(score, q->n_temi);          // Stampo la classifica
    stampaCompletati(players, q->n_temi, score); // Stampo gli utenti che hanno completato un tema
    printf("Premere 'q' seguito da invio per terminare il server\n");
    sleep(UPDATETIME);                           // Attendo UPDATETIME secondi
    char buffer[3];                              // Se viene digitato 'q' seguito da invio, il server termina
    if (fgets(buffer, sizeof(buffer), stdin) != NULL)
    {
        if (buffer[0] == 'q' && buffer[1] == '\n')
        {
            printf("Terminazione del server...\n");
            svuotaDBMutex(players);             // Svuoto il database utenti
            svuotaClassifica(score, q->n_temi); // Svuoto la classifica
            eliminazioneQuiz(q); // Elimino il quiz
            free(dati); // Libero la memoria allocata per la struttura dati
            exit(EXIT_SUCCESS);
        }
    }
    printf("Pulisco lo schermo\n"); // Pulisco lo schermo
    system("clear");                // Pulisco lo schermo

    fflush(stdout);            // Svuoto il buffer di output
    pannelloDiControllo(dati); // Richiamo ricorsivamente la funzione
    return NULL;
}
