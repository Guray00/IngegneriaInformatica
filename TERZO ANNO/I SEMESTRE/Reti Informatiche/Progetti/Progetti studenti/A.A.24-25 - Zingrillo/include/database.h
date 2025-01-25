#include "quiz.h"
#include <stdbool.h>
#include <pthread.h>

// Strutture dati e funzioni finalizzati a contenere i dati degli utenti e a gestire le operazioni su di essi

struct punteggioTema
{
    bool completato; // true se il tema è stato completato dall'utente, false altrimenti
    bool giocato;    // true se l'utente ha giocato il tema, false altrimenti
    int punteggio;   // punteggio ottenuto dall'utente nel tema
};

// Struttura dati per l'albero binario di ricerca degli utenti
// Ordinato per nickname alfabeticamente
struct utente
{
    char nickname[TEXTLEN]; // nickname dell'utente
    struct punteggioTema *punteggioTemi;
    struct utente *left;  // puntatore al figlio sinistro nell'albero binario di ricerca
    struct utente *right; // puntatore al figlio destro nell'albero binario di ricerca
};

// Struttura dati per l'albero binario di ricerca dei punteggi
// Ordinato per punteggio decrescente e, in caso di parità, per nickname alfabeticamente
struct punteggio
{
    struct utente *giocatore; // utente a cui è associato il punteggio
    int punti;                // punteggio ottenuto dall'utente
    struct punteggio *left;   // puntatore al figlio sinistro nell'albero binario di ricerca
    struct punteggio *right;  // puntatore al figlio destro nell'albero binario di ricerca
};
struct utenti
{
    struct utente *root;   // radice dell'albero binario di ricerca
    pthread_mutex_t mutex; // mutex per la mutua esclusione
    int numUtenti;         // numero di utenti registrati
};
struct classifica
{
    struct punteggio **vettorePunteggi; // vettore di punteggi per ogni tema
    int *vettorePartecipanti;           // vettore con il numero di partecipanti per ogni tema
    int *vettoreCompletati;             // vettore con il numero di utenti che hanno completato il tema
    pthread_mutex_t *vettoreMutex;      // vettore di mutex per la mutua esclusione
};
// Struttura dati da passare al thread che gestisce la connessione con un client
struct game
{
    struct quiz *q;                // quiz
    struct utenti *players;        // utenti
    struct classifica *classifica; // classifica
    int socket;                    // socket
};

// Struttura dati da passare al thread che gestisce il pannello di controllo
struct datiPdC
{
    struct utenti *players;   // utenti
    struct classifica *score; // classifica
    struct quiz *q;           // quiz
};

void inserisciUtente(struct utenti *, struct utente *);
bool controllaNickname(char *, struct utenti *);
struct punteggio *creaPunteggio(struct utente *, int);
void inserisciInClassifica(struct classifica *, struct utente *, int, int);
void eliminaDaClassifica(struct classifica *, char *, int, int);
void eliminaTuttiPunteggi(struct classifica *, struct utente *, int);
struct utente *eliminaUtente(struct utente *, char *nickname, int, struct classifica *);
void eliminaDaDB(struct utenti *, char *, int, struct classifica *);
void svuotaDBMutex(struct utenti *);
void svuotaClassifica(struct classifica *, int);
