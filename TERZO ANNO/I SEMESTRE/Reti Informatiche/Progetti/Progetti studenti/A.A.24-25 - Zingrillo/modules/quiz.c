// Modulo server per la gestione del quiz
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>

#include "../include/quiz.h"
#include "../include/common.h"
#include "../include/params.h"

// Funzione di utilità utilizzata nel parsing
// Legge un file, inserendo il contenuto in un buffer, fino a un carattere terminatore
// Prende in input il buffer, il file descriptor, la posizione di partenza, il carattere terminatore e un puntatore a intero
// Ritorna la lunghezza del buffer
// Supporta due modalità: se il puntatore a intero è NULL, legge fino al carattere terminatore
// Se il puntatore a intero è diverso da NULL, legge fino al carattere terminatore o al carattere '\n' e ritorna,
// tramite il puntatore a intero, 1 se il primo carattere è il terminatore, 0 altrimenti
int readUntil(char *buffer, int fd, int start, char terminator, bool *cause)
{
    char *pointer = buffer;
    lseek(fd, start, SEEK_SET); // sposta il cursore alla posizione start
    while (read(fd, pointer, 1) > 0 && *(pointer) != terminator && (*pointer != '\n' || cause == NULL))
        pointer++;
    if (cause != NULL)
        *cause = *(pointer) == terminator ? 1 : 0;
    *(pointer) = '\0';
    return pointer - buffer + 1 + start;
}

// Funzione di utilità per convertire una stringa in minuscolo
// Utilizzata per confrontare le risposte
void toLowerCase(char *str)
{
    while (*str)
    {
        *str = tolower((unsigned char)*str);
        str++;
    }
}

// Funzione per visualizzare la lista dei temi
void listaTemi(struct quiz *q)
{
    intro();
    printf("Temi:\n");
    for (int i = 0; i < q->n_temi; i++)
        printf("%d - %s\n", i + 1, q->temi[i].nome);
    printplus();
    printf("\n\n");
}

// Funzione per verificare se una risposta è corretta
bool rispostaCorretta(struct domanda *d, char *risposta)
{
    struct risposta *r;
    toLowerCase(risposta);
    r = &d->risposte;
    while (r != NULL)
    { // scorro la lista di risposte
        if (strcmp(r->testo, risposta) == 0)
            return true;
        r = r->next;
    }
    return false;
}

// Funzione per il parsing dei quiz
// Note sul formato dei quiz:
// - Ogni tema è contenuto in un file .quiz
// - Il file indice.quiz contiene il numero di temi e il nome di ciascun tema
// - Ogni domanda termina con un carattere '|'
// - Le risposte sono separate da caratteri '~'
void parse(struct quiz *q)
{
    int indice;
    char buffer[TEXTLEN];
    int indexcursor = 0, numtemi;
    // mi posiziono nella cartella quiz
    if (chdir("quiz") != 0)
    {
        perror("Si è verificato un errore durante il cambio di directory");
        exit(EXIT_FAILURE);
    }
    // apro il file indice
    indice = open("indice.quiz", O_RDONLY);
    if (indice == -1)
    {
        perror("Si è verificato un errore durante l'apertura del file indice.quiz");
        exit(EXIT_FAILURE);
    }
    // leggo la prima riga del file indice, che contiene il numero di temi
    indexcursor = readUntil(buffer, indice, indexcursor, '\n', NULL);
    numtemi = atoi(buffer);
    // istanzio le necessarie strutture dati
    q->n_temi = numtemi;
    q->temi = (struct tema *)malloc(numtemi * sizeof(struct tema));
    gestisciErroriMalloc(q->temi);
    for (int i = 0; i < numtemi; i++)
    { // per ogni tema
        char stringa_file_tema[QUIZFILENAMELEN];
        int file_tema;
        sprintf(stringa_file_tema, "%d.quiz", i + 1); // ricavo il nome del file tema
        file_tema = open(stringa_file_tema, O_RDONLY);
        if (file_tema == -1)
        {
            perror("Si è verificato un errore durante l'apertura dei file di quiz");
            exit(EXIT_FAILURE);
        }
        int themecursor = 0;
        struct tema t;
        indexcursor = readUntil(buffer, indice, indexcursor, '\n', NULL); // leggo il nome del tema dal file indice
        strcpy(t.nome, buffer);
        for (int j = 0; j < THEMESIZE; j++)
        {                                                                       // per ogni domanda
            themecursor = readUntil(buffer, file_tema, themecursor, '|', NULL); // leggo il testo della domanda
            struct domanda d;
            struct risposta *r;
            bool cause = 1;
            strcpy(d.testo, buffer);
            r = &d.risposte;
            while (cause)
            { // Scorro le risposte
                themecursor = readUntil(buffer, file_tema, themecursor, '~', &cause);
                strcpy(r->testo, buffer);
                if (cause)
                {
                    r->next = (struct risposta *)malloc(sizeof(struct risposta));
                    gestisciErroriMalloc(r->next);
                    r = r->next;
                }
                else
                {
                    r->next = NULL;
                }
            }
            t.domande[j] = d;
        }
        q->temi[i] = t;
        close(file_tema);
    }
    close(indice);
}
// Funzione per eliminare un quiz
void eliminazioneQuiz(struct quiz *q)
{
    for (int i = 0; i < q->n_temi; i++)
    {
        struct tema t = q->temi[i];
        for (int j = 0; j < THEMESIZE; j++)
        {
            struct domanda d = t.domande[j];
            struct risposta *r = &d.risposte;
            bool primaRisposta = true;
            while (r != NULL)
            {
                struct risposta *temp = r;
                r = r->next;
                if (!primaRisposta)
                    free(temp);
                primaRisposta = false;
            }
        }
    }
    free(q->temi);
}
