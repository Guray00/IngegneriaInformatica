#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <signal.h>

#include "include/common.h"
#include "include/params.h"

// Funzione che previene il comportamento standard in caso di SIGPIPE, che termina il processo.
// Viene stampato un messaggio di errore e si permette al gestore degli errori di send di gestire l'errore.
void handle_sigpipe(int sig)
{
    printf("Connessione chiusa dal server\n");
}

// Funzione che stampa il messaggio di benvenuto
void stampaMenu()
{
    printf("Menù:\n");
    printf("1 - Comincia una sessione di Trivia\n");
    printf("2 - Esci\n");
    printplus();
}

// Funzione che gestisce l'interfaccia iniziale del client
bool menuIniziale()
{
    int scelta = 0;
    int ret = 0;
    do
    {
        intro();
        stampaMenu();
        printf("\nLa tua scelta: ");
        ret = scanf("%d", &scelta);
        // Pulisco il buffer di input per gestire il caso in cui l'utente abbia inserito
        // input non numerici
        while (getchar() != '\n')
            ;
        if (ret != 1 || (scelta != 1 && scelta != 2))
        {
            printf("\nScelta non valida\n\n");
        }
        else if (scelta == 2)
        {
            return false;
        }
    } while (scelta != 1);
    return true;
}

// Funzione che gestisce l'interfaccia per la scelta del nickname
void scegliNickname(int sd)
{
    char buffer[TEXTLEN], ok[TEXTLEN];
    intro();
    while (1)
    {
        printf("Inserisci il tuo nickname (max %d caratteri): ", TEXTLEN - 1);
        // Leggo il nickname da tastiera
        if (fgets(buffer, sizeof(buffer), stdin) != NULL)
        {
            size_t len = strlen(buffer);
            // Rimuovo il carattere di nuova linea se presente
            if (len > 0 && buffer[len - 1] == '\n')
            {
                buffer[len - 1] = '\0';
                len--;
            }
            else
            {
                // Se non c'è un carattere di nuova linea, allora l'input è stato troncato
                // e devo svuotare il buffer di input
                int ch;
                while ((ch = getchar()) != '\n' && ch != EOF)
                    ;
                printf("Errore: il nickname supera la lunghezza massima di %d caratteri\n", TEXTLEN - 1);
                continue;
            }

            // Controllo se l'input è vuoto
            if (len == 0)
            {
                printf("Errore: il nickname non può essere vuoto\n");
                continue;
            }

            break; // Esco dal ciclo se il nickname è stato letto correttamente
        }
        else
        {
            printf("Errore durante la lettura dell'input\n");
        }
    }
    inviaMsg(buffer, sd, false); // Invio il nickname al server
    riceviMsg(ok, sd, false);    // Ricevo la risposta del server
    if (strcmp(ok, "1") == 0)
    {
        printf("\nNickname accettato\n\n");
    }
    else if (strcmp(ok, "0") == 0)
    {
        printf("\nNickname rifiutato\n\n");
        scegliNickname(sd);
    }
    else
    {
        printf("Errore durante la ricezione della risposta del server\n");
        exit(EXIT_FAILURE);
    }
}
// Funzione che mostra la classifica
void mostraClassifica(int sd)
{
    int num_temi;
    char bufferOut[TEXTLEN];
    riceviMsg(bufferOut, sd, false); // Ricevo il numero di temi
    num_temi = atoi(bufferOut);
    printf("\n");
    intro();
    for (int k = 0; k < num_temi; k++)
    {
        int num_partecipanti;
        riceviMsg(bufferOut, sd, false); // Ricevo il numero di partecipanti
        num_partecipanti = atoi(bufferOut);
        printf("Punteggio tema %d\n", k + 1);
        for (int j = 0; j < num_partecipanti; j++)
        {
            int punteggio;
            riceviMsg(bufferOut, sd, false); // Ricevo il nickname
            punteggio = atoi(bufferOut);
            riceviMsg(bufferOut, sd, false); // Ricevo il punteggio
            printf("- %s %d\n", bufferOut, punteggio);
        }
        printf("\n");
    }
}

// Funzione che gestisce l'interfaccia per la scelta del quiz
// Restituisce false se non ci sono quiz disponibili, true altrimenti
bool scegliQuiz(int sd, char *nomeQuiz)
{
    // Recupero i quiz dal server
    char buffer[TEXTLEN];
    int numQuiz, scelta = 0, ret = 0;
    riceviMsg(buffer, sd, false); // Ricevo il numero di quiz disponibili
    numQuiz = atoi(buffer);
    if (numQuiz == 0)
    {
        printf("Non ci sono quiz disponibili\n");
        return false;
    }
    char *nomiTemi[numQuiz];
    printf("Quiz disponibili:\n");
    printplus();
    printf("\n");
    for (int i = 1; i <= numQuiz; i++) // Ricevo i nomi dei quiz
    {
        riceviMsg(buffer, sd, false);
        nomiTemi[i - 1] = (char *)malloc((strlen(buffer) + 1) * sizeof(char));
        gestisciErroriMalloc(nomiTemi[i - 1]);
        strcpy(nomiTemi[i - 1], buffer);
        printf("%d - %s\n", i, buffer);
    }

    printplus();
    printf("\n");
    do {
        char buffer[TEXTLEN];
        printf("La tua scelta: ");
        if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
            // Rimuovo il carattere di nuova linea se presente
            size_t len = strlen(buffer);
            if (len > 0 && buffer[len - 1] == '\n') {
                buffer[len - 1] = '\0';
            }

            // Controllo se l'input è ENDQUIZ o SHOWSCORE
            if (strcmp(buffer, FINEQUIZ) == 0) {
                printf("Quiz terminato.\n");
                inviaMsg(buffer, sd, false);
                return false;
            } else if (strcmp(buffer, MOSTRAPUNTEGGIO) == 0) {
                inviaMsg(buffer, sd, false);
                mostraClassifica(sd);
                continue;
            }

            // Converto l'input in un numero
            ret = sscanf(buffer, "%d", &scelta);
            if (ret != 1 || scelta < 1 || scelta > numQuiz) {
                printf("Scelta non valida\n");
            }
        } else {
            printf("Errore durante la lettura dell'input\n");
        }
} while (scelta < 1 || scelta > numQuiz);
    sprintf(buffer, "%d", scelta);
    inviaMsg(buffer, sd, false);            // Invio la scelta al server
    strcpy(nomeQuiz, nomiTemi[scelta - 1]); // Salvo il nome del quiz scelto
    for(int i=0; i<numQuiz; i++){
        free(nomiTemi[i]);
    }
    return true;
}



// Funzione che gestisce l'esperienza client durante il quiz
// Restituisce false se l'utente decide di uscire dal quiz, true altrimenti
// Gestisce anche la richiesta di visualizzazione del punteggio
bool giocaQuiz(int sd, char *nomeQuiz)
{
    char bufferIn[TEXTLEN], bufferOut[TEXTLEN];
    bool ok;
    for (int i = 0; i < THEMESIZE; i++)
    {
        riceviMsg(bufferIn, sd, false); // Ricevo la domanda
        while (1)
        {
            size_t len;
            printf("Quiz - %s\n", nomeQuiz);
            printplus();
            printf("\n");
            printf("%s\n\nRisposta: ", bufferIn);
            if (fgets(bufferOut, sizeof(bufferOut), stdin) == NULL)
            {
                printf("Errore durante la lettura dell'input\n");
                continue;
            }
            len = strlen(bufferOut);
            // Rimuovo il carattere di nuova linea se presente
            if (len > 0 && bufferOut[len - 1] == '\n')
            {
                bufferOut[len - 1] = '\0';
                len--;
            }
            else
            {
                // Se non c'è un carattere di nuova linea, allora l'input è stato troncato
                // e devo svuotare il buffer di input
                int ch;
                while ((ch = getchar()) != '\n' && ch != EOF)
                    ;
                printf("Errore: il messaggio supera la lunghezza massima di %d caratteri\n", TEXTLEN - 1);
                continue;
            }

            // Controllo se l'input è vuoto
            if (len == 0)
            {
                printf("Errore: il messaggio non può essere vuoto\n");
                continue;
            }

            break; // Esco dal ciclo se il messaggio è stato letto correttamente
        }

        inviaMsg(bufferOut, sd, false); // Invio la risposta al server
        if (strcmp(bufferOut, FINEQUIZ) == 0)
        {
            printf("Quiz terminato.\n");
            return false;
        }
        if (strcmp(bufferOut, MOSTRAPUNTEGGIO) == 0)
        {
            i--; // Decremento i in modo che la prossima iterazione mostri la domanda corrente
            mostraClassifica(sd);
            continue;
        }
        riceviMsg(bufferOut, sd, false); // Ricevo la valutazione della risposta
        ok = strcmp(bufferOut, "1") == 0;
        if (ok)
        {
            printf("\nRisposta corretta\n\n");
        }
        else
        {
            printf("\nRisposta errata\n\n");
        }
    }
    return true;
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Client lanciato in modo errato.\nUtilizzo corretto: ./client <porta>\n");
        exit(EXIT_FAILURE);
    }
    signal(SIGPIPE, handle_sigpipe);
    while (menuIniziale())
    {
        char nomeQuiz[TEXTLEN];
        int ret, sd;
        struct sockaddr_in server_address;
        sd = socket(AF_INET, SOCK_STREAM, 0);
        if (sd == -1)
        {
            perror("Errore durante la creazione del socket");
            exit(EXIT_FAILURE);
        }
        // inizializzo la struttura per la connessione al server
        server_address.sin_family = AF_INET;
        server_address.sin_port = htons(atoi(argv[1]));
        inet_pton(AF_INET, SERVER_IP, &server_address.sin_addr);
        // mi connetto al server
        ret = connect(sd, (struct sockaddr *)&server_address, sizeof(server_address));
        // controllo se la connessione è andata a buon fine
        if (ret == -1)
        {
            perror("Errore durante la connessione al server");
            exit(EXIT_FAILURE);
        }
        scegliNickname(sd);
        while (scegliQuiz(sd, nomeQuiz) && giocaQuiz(sd, nomeQuiz))
            ;
        close(sd); // chiudo la connessione con il server
    }
    return 0;
}
