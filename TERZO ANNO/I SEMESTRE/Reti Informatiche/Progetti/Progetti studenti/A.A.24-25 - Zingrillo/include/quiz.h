#include "params.h"
#include <stdbool.h>

// Struttura dati per le risposte, organizzate in una lista
struct risposta
{
    char testo[TEXTLEN];   // Testo della risposta
    struct risposta *next; // Puntatore alla risposta successiva
};

// Struttura dati per le domande, organizzate in un array statico
struct domanda
{
    char testo[TEXTLEN];      // Testo della domanda
    struct risposta risposte; // Risposte della domanda
};

// Struttura dati per i temi, organizzati in un array dinamico
struct tema
{
    char nome[TEXTLEN];                // Nome del tema
    struct domanda domande[THEMESIZE]; // Domande del tema
};

struct quiz
{
    int n_temi;        // Numero di temi, dinamico perché deciso al momento del parsing
    struct tema *temi; // Temi del quiz
};

void parse(struct quiz *);
bool rispostaCorretta(struct domanda *, char *);
void listaTemi(struct quiz *);
void eliminazioneQuiz(struct quiz *);