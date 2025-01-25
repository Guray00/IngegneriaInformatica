// Modulo server finalizzato alla gestione dei dati degli utenti e della classifica

#include "../include/database.h"
#include "../include/game.h"
#include "../include/common.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Funzione che inserisce un utente nell'albero binario di ricerca
void inserisciUtente(struct utenti *players, struct utente *new)
{
    pthread_mutex_lock(&players->mutex);
    struct utente **current = &players->root;
    while (*current != NULL)
    {
        if (strcmp(new->nickname, (*current)->nickname) < 0)
        {
            current = &(*current)->left;
        }
        else
        {
            current = &(*current)->right;
        }
    }
    *current = new;
    players->numUtenti++; // Incremento il numero di utenti registrati
    pthread_mutex_unlock(&players->mutex);
}

// Funzione che controlla se un nickname è già presente nell'albero binario di ricerca
bool controllaNickname(char *nickname, struct utenti *players)
{
    struct utente *p = players->root;
    int res;
    while (p != NULL)
    {
        res = strcmp(nickname, p->nickname);
        if (res < 0)
            p = p->left;
        else if (res > 0)
            p = p->right;
        else
            return false;
    }
    return true;
}

// Funzione che crea un nuovo nodo per l'albero binario di ricerca dei punteggi
struct punteggio *creaPunteggio(struct utente *player, int punti)
{
    struct punteggio *newNode = (struct punteggio *)malloc(sizeof(struct punteggio));
    gestisciErroriMalloc(newNode);
    newNode->giocatore = player;
    newNode->punti = punti;
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;
}

// Funzione che inserisce un punteggio nell'albero binario di ricerca
struct punteggio *inserisciPunteggio(struct punteggio *root, struct utente *player, int punti)
{
    // Se l'albero è vuoto, crea un nuovo nodo come radice
    if (root == NULL)
    {
        return creaPunteggio(player, punti);
    }
    // Scorro l'albero per trovare la posizione appropriata
    if (punti > root->punti || (punti == root->punti && strcmp(player->nickname, root->giocatore->nickname) < 0))
    {
        // Inserisco nel sottoalbero sinistro
        root->left = inserisciPunteggio(root->left, player, punti);
    }
    else
    {
        // Inserisco nel sottoalbero destro
        root->right = inserisciPunteggio(root->right, player, punti);
    }

    return root;
}

// Funzione che inserisce un punteggio nella classifica
void inserisciInClassifica(struct classifica *score, struct utente *player, int punteggio, int quizScelto)
{
    pthread_mutex_lock(score->vettoreMutex + quizScelto - 1);
    struct punteggio *p = score->vettorePunteggi[quizScelto - 1];
    score->vettorePartecipanti[quizScelto - 1]++;
    if (p == NULL)
    {
        score->vettorePunteggi[quizScelto - 1] = creaPunteggio(player, punteggio);
        pthread_mutex_unlock(score->vettoreMutex + quizScelto - 1);
        return;
    }
    inserisciPunteggio(p, player, punteggio);
    pthread_mutex_unlock(score->vettoreMutex + quizScelto - 1);
}

// Funzione che trova il punteggio minimo nell'albero binario di ricerca
// Utilizzata per eliminare un nodo con due figli
struct punteggio *trovaPunteggioMinimo(struct punteggio *root)
{
    while (root && root->left != NULL)
    {
        root = root->left;
    }
    return root;
}

// Funzione che trova l'utente con nickname alfabeticamente minimo nell'albero binario di ricerca
// Utilizzata per eliminare un nodo con due figli
struct utente *trovaUtenteMinimo(struct utente *root)
{
    while (root && root->left != NULL)
    {
        root = root->left;
    }
    return root;
}

// Funzione che elimina un nodo dall'albero binario di ricerca
struct punteggio *eliminaPunteggio(struct punteggio *root, char *nickname, int punteggio)
{

    if (root == NULL)
    {
        return root; // Albero vuoto
    }

    // Cercare il nodo da eliminare
    if ((punteggio > root->punti) || (punteggio == root->punti && strcmp(nickname, root->giocatore->nickname) < 0))
    {
        root->left = eliminaPunteggio(root->left, nickname, punteggio);
    }
    else if ((punteggio < root->punti) || (punteggio == root->punti && strcmp(nickname, root->giocatore->nickname) > 0))
    {
        root->right = eliminaPunteggio(root->right, nickname, punteggio);
    }
    else
    {
        // Nodo trovato
        // Caso 1: Nessun figlio o un solo figlio
        if (root->left == NULL)
        {
            struct punteggio *temp = root->right;
            free(root);
            return temp;
        }
        else if (root->right == NULL)
        {
            struct punteggio *temp = root->left;
            free(root);
            return temp;
        }

        // Caso 2: Due figli
        struct punteggio *temp = trovaPunteggioMinimo(root->right); // Successore in ordine
        root->giocatore = temp->giocatore;                          // Copia i dati del successore
        root->punti = temp->punti;
        root->right = eliminaPunteggio(root->right, nickname, punteggio); // Elimina il successore
    }
    return root;
}

// Funzione che elimina un punteggio dalla classifica, prendendo il lock sul mutex del tema e chiamando eliminaPunteggio
void eliminaDaClassifica(struct classifica *score, char *nickname, int punteggio, int quizScelto)
{
    pthread_mutex_lock(score->vettoreMutex + quizScelto - 1);
    struct punteggio *root = score->vettorePunteggi[quizScelto - 1];
    score->vettorePartecipanti[quizScelto - 1]--;
    score->vettorePunteggi[quizScelto - 1] = eliminaPunteggio(root, nickname, punteggio);
    pthread_mutex_unlock(score->vettoreMutex + quizScelto - 1);
}

// Funzione che elimina tutti i punteggi di un utente dalla classifica
void eliminaTuttiPunteggi(struct classifica *score, struct utente *player, int num_temi)
{
    for (int i = 0; i < num_temi; i++)
    {
        if (!player->punteggioTemi[i].giocato)
        {
            continue;
        }
        eliminaDaClassifica(score, player->nickname, player->punteggioTemi[i].punteggio, i + 1);
    }
}

// Funzione che decrementa il numero di utenti che hanno completato un tema
// in fase di eliminazione di un utente
void rimuoviDaiCompletati(struct classifica *score, struct utente *player, int num_temi)
{
    for (int i = 0; i < num_temi; i++)
    {
        if (player->punteggioTemi[i].completato)
        {
            score->vettoreCompletati[i]--;
        }
    }
}

// Funzione che elimina un utente dall'albero binario di ricerca
struct utente *eliminaUtente(struct utente *root, char *nickname, int num_temi, struct classifica *score)
{
    if (root == NULL)
    {
        return root; // Albero vuoto
    }

    // Cerco il nodo da eliminare
    if (strcmp(nickname, root->nickname) < 0)
    {
        root->left = eliminaUtente(root->left, nickname, num_temi, score);
    }
    else if (strcmp(nickname, root->nickname) > 0)
    {
        root->right = eliminaUtente(root->right, nickname, num_temi, score);
    }
    else
    {
        // Nodo trovato

        // Caso 1: Nessun figlio o un solo figlio
        if (root->left == NULL)
        {
            struct utente *temp = root->right;
            rimuoviDaiCompletati(score, root, num_temi);
            free(root);
            return temp;
        }
        else if (root->right == NULL)
        {
            struct utente *temp = root->left;
            rimuoviDaiCompletati(score, root, num_temi);
            free(root);
            return temp;
        }

        // Caso 2: Due figli
        struct utente *temp = trovaUtenteMinimo(root->right);                // Successore in ordine
        strcpy(root->nickname, temp->nickname);                              // Copio i dati del successore
        root->right = eliminaUtente(root->right, nickname, num_temi, score); // Elimino il successore
    }
    return root;
}

// Funzione che elimina un utente dal database, prendendo il lock sul mutex degli utenti e chiamando eliminaUtente
void eliminaDaDB(struct utenti *db, char *nickname, int num_temi, struct classifica *score)
{
    pthread_mutex_lock(&db->mutex);
    struct utente *root = db->root;
    db->root = eliminaUtente(root, nickname, num_temi, score);
    db->numUtenti--;
    pthread_mutex_unlock(&db->mutex);
}



// Funzione che svuota l'albero binario di ricerca degli utenti
void svuotaDB(struct utente*root){
    if(root==NULL){
        return;
    }
    svuotaDB(root->left);
    svuotaDB(root->right);
    free(root->punteggioTemi);
    free(root);
}

// Funzione che svuota il database, prendendo il lock sul mutex
void svuotaDBMutex(struct utenti *db){
    pthread_mutex_lock(&db->mutex);
    svuotaDB(db->root);
    pthread_mutex_unlock(&db->mutex);
    free(db);
}
// Funzione che svuota l'albero binario di ricerca dei punteggi
void svuotaClassificaTema(struct punteggio *root){
    if(root==NULL){
        return;
    }
    svuotaClassificaTema(root->left);
    svuotaClassificaTema(root->right);
    free(root);
}

// Funzione che svuota la classifica, prendendo il lock sul mutex
void svuotaClassifica(struct classifica *score, int num_temi){
    for(int i=0; i<num_temi; i++){
        pthread_mutex_lock(score->vettoreMutex+i);
        svuotaClassificaTema(score->vettorePunteggi[i]);
        pthread_mutex_unlock(score->vettoreMutex+i);
    }
    free(score->vettorePunteggi);
    free(score->vettorePartecipanti);
    free(score->vettoreCompletati);
    free(score->vettoreMutex);
    free(score);
}