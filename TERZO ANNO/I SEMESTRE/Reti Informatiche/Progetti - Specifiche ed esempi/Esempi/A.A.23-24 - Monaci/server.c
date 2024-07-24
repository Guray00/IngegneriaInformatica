#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "strutture.h"
#include "funzioni.h"

int main(int argc, char** argv){
    int sd, ret, new_sd, len;
    int port;
    int fdmax;
    uint8_t auth = 0;
    struct sockaddr_in my_addr, cl_addr;
    struct credenziali cr;
    struct stanza st;
    char buffer[1024];
    fd_set master, work;
    pid_t pid;

    // controllo porta passata da CLI
    if(argc == 1 || (atoi(argv[1]) <= 1023)){
        printf("Default port selected\n");
        port = DEFAULT_SVR_PORT;
    }
    else
        port = atoi(argv[1]);

    printf("Server running\n> ");
    char cmd[8] = "";
    while(1){
        scanf("%s", cmd);
        if(strcmp(cmd, "start") == 0)
            break;
    }

    // inizializzazione socket
    sd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&my_addr, 0, sizeof(my_addr));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(port);
    inet_pton(AF_INET, LOCALHOST, &my_addr.sin_addr);

    // bind socket
    ret = bind(sd, (struct sockaddr*) &my_addr, sizeof(my_addr));
    if(ret < 0){
        perror("Bind fallita");
        exit(1);
    }

    // inizializzazione coda richieste
    ret = listen(sd, 10);
    if(ret < 0){
        perror("Listen fallita");
        exit(1);
    }

    printf("Server running on port %d\n", port);

    FD_ZERO(&master);
    FD_ZERO(&work);

    FD_SET(sd, &master);
    FD_SET(STDIN_FILENO, &master);

    fdmax = sd;

    while(1){
        work = master;
        select(fdmax + 1, &work, NULL, NULL, NULL);

        int i = 0;
        for(; i <= fdmax; i++){
            if(FD_ISSET(i, &work)){
                if(i == sd){
                    // In attesa di richieste
                    len = sizeof(cl_addr);
                    new_sd = accept(sd, (struct sockaddr*) &cl_addr, (socklen_t*)&len);
                    if(new_sd == -1){
                        perror("Errore nella accept");
                        exit(1);
                    }
                    printf("\033[1;33mLOG:\033[0m Connessione accettata!\n");

                    // creazione processo figlio
                    pid = fork();

                    if(pid == 0){
                        // processo figlio
                        close(sd);
// ===============================================================================
// ||                          REGISTRAZIONE / LOGIN                            ||
// ===============================================================================
                        // guardo se l'utente vuole loggarsi o registrarsi
                        uint8_t signal;
                        ret = recv(new_sd, (void*)&signal, DIM_UINT8, 0);
                        if(ret < DIM_UINT8){
                            perror("Problemi con la ricezione del comando login/signup\n");
                            exit(1);
                        }

                        if(signal == 1){
                            // user login
                            uint16_t dim;
                            FILE *fptr = fopen("auth.txt", "r");
                            log:
                            auth = 0;

                            // lunghezza credenziali
                            ret = recv(new_sd, (void*)&dim, DIM_UINT16, 0);
                            if(ret < DIM_UINT16){
                                perror("Couldn't receive credentials len");
                                exit(1);
                            }

                            // ricezione credenziali
                            ret = recv(new_sd, (void*)buffer, dim, 0);
                            if(ret < dim){
                                perror("Couldn't receive credentials");
                                printf(" %d\n", ret);
                                exit(1);
                            }
                            // parsing
                            sscanf(buffer, "%s %s", cr.user, cr.password);

                            // controllo se l'utente è registrato
                            if(find_credentials(fptr, cr.user, cr.password) == 0){
                                auth = 1;
                                ret = send(new_sd, (void*)&auth, DIM_UINT8, 0);
                                if(ret < DIM_UINT8){
                                    perror("Couldn't send username bad result");
                                    exit(1);
                                }
                                // Aspetto delle credenziali valide
                                rewind(fptr);
                                goto log;
                            } else {
                                // OK
                                auth = 0;
                                ret = send(new_sd, (void*)&auth, DIM_UINT8, 0);
                                if(ret < DIM_UINT8){
                                    perror("Couldn't send auth good result");
                                    exit(1);
                                }
                            }

                            printf("\033[1;33mLOG:\033[0m utente %s autenticato!\n", cr.user);
                            fclose(fptr);
                        } else if(signal == 2) {
                            // registrazione utente
                            auth = 0;
                            uint16_t dim;
                            ret = recv(new_sd, (void*)&dim, DIM_UINT16, 0);
                            if(ret < DIM_UINT16){
                                perror("Problemi con la ricezione della linghezza delle credenziali");
                                exit(1);
                            }

                            ret = recv(new_sd, (void*)buffer, dim, 0);
                            if(ret < dim){
                                perror("Problemi con la ricezione delle credenziali");
                                exit(1);
                            }
                            // parsing
                            sscanf(buffer, "%s %s", cr.user, cr.password);

                            // salvataggio delle credenziali in un file txt
                            FILE *fptr;

                            fptr = fopen("auth.txt", "a");
                            ret = fprintf(fptr, "%s\n%s\n\n", cr.user, cr.password);
                            if(ret < 0)
                                auth = 1;

                            ret = send(new_sd, (void*)&auth, DIM_UINT8, 0);
                            if(ret < DIM_UINT8){
                                perror("Invio risultato fallito");
                                exit(1);
                            }

                            fclose(fptr);
                        }

// ===============================================================================
// ||                             SELEZIONE STANZA                              ||
// ===============================================================================

                        uint8_t room;
                        ret = recv(new_sd, (void*)&room, DIM_UINT8, 0);
                        if(ret < DIM_UINT8){
                            perror("Couldn't receive room id");
                            exit(1);
                        }

                        switch(room){
                            case 1:
                                // caricamento dei dati della stanza 1
                                st = (struct stanza) {
                                    .intro = "E' una fredda domenica d'inverno quando siete in giro a Pisa e un vostro "
                                            "amico vi invita a casa per una serata di studio. "
                                            "Quando arrivate la porta e' aperta e entrate d'istinto, arrivati in sala "
                                            "pero' la porta vi si chiude alle spalle ed essendo al 4° piano uscire dalla "
                                            "finestra non vi sembra una buona idea. Davanti a voi vedete un ++camino++ con un timer "
                                            "su di esso che indica 7 minuti, e sta scorrendo!\n",
                                    .descr = "Sei in uno studio, la ++porta++ è bloccata da un **luchetto**. "
                                            "Accanto al camino c'è un ++tavolo++ e lì accanto un vecchio ++mobile++ con dei cassetti. "
                                            "Dalla parte opposta del camino vedete una ++finestra++ con i vetri appannati. "
                                            "In un angolo della stanza notate dei **cavi** telefonici, recisi da un taglio netto, uscire da una vecchia presa...\n",
                                    .locations = {
                                            "Una finestra a vetro singolo, notate un **foglietto** un po' rovinato infilato nella chisura\n",
                                            "Notate subito i 4 cassetti del mobile, ma sul piano di legno c'è intagliata una **frase** che sembra un indovinello...\n",
                                            "Sul tavolo c'è un vecchio **taccuino** scarabocchiato e un paio di **forbici**\n",
                                            "Il camino è sporco e pieno di cenere, ma stranamente l'**attizzatoio** è bello splendente.\n",
                                            "La porta è chisa da un **lucchetto**\n"
                                    },
                                    .location_names = {"Finestra", "Mobile", "Tavolo", "Camino", "Porta"},
                                    .questions = {
                                        "Girando l'attizzatoio trovate un adesivo con su scritto: \"1a cifra decimale di arcos(-1)?\"\n",
                                        "Sfogliate il taccuino per trovare qualche informazione, e sull'unica pagina priva di scarabocchi sensa senso c'è scritto: \"Quello di picche speri di non riceverlo mai\"\n",
                                        "Con cautela estraete il foglietto dalla finestra, una scritta dice: \"Sapere che giorno è oggi potrebbe aiutarti a uscire...\"\n",
                                        "Un lucchetto a combinazione numerica, per aprirlo c'è bisogno di sapere 4 cifre.\n",
                                        "Toccando e guardando meglio i cavi, una voce rieccheggia nella tua mente: \"Ricordati, INGEGNERIA NON PUO' NON ESSERE DIFFICILE\"\n",
                                        "La frase incisa sul mobie recita: \"Nei calcolatori moderni gestisco le richieste di interruzione, da quante lettere è composto il mio nome?\"\n",
                                        "<PLACEHOLDER>\n"
                                    },
                                    .obj_names = {"Attizzatoio", "Taccuino", "Foglietto", "Lucchetto", "Cavi", "Frase", "Forbici"},
                                    .objs = {
                                        "Un attizzatoio d'ottone, osservandolo meglio notate che sul retro e' attaccato qualcosa",
                                        "Questo taccuino dall'aria trasandata sembra inutile: chi avrebbe voglia di sfogliarlo tutto?",
                                        "Il foglietto e' rovinato ma si riesce sempre a leggere qualcosa...",
                                        "Un lucchetto a combinazione numerica, per aprirlo c'è bisogno di sapere 4 cifre.",
                                        "Vecchi cavi telefonici, ormai quasi del tutto in disuso.\nSembrano privi di qualsiasi utilita' al momento...",
                                        "Cercate di leggere la frase ma non e' scritta molto bene, ci mettete un po' per leggerla tutta",
                                        "Delle semplici forbici, sembrano abbastanza affilate"
                                    },
                                    .solutions = {1, 2, 7, -1, -1, 4, -1}
                                };

// ===============================================================================
// ||                       INVIO INFORMAZIONI STANZA                           ||
// ===============================================================================

                                // invio introduzione
                                sprintf(buffer, "%s", st.intro);
                                uint16_t dim = strlen(buffer);
                                ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                if(ret < DIM_UINT16){
                                    perror("Problemi con l'invio della dimensione dell'introduzione della stanza");
                                    exit(1);
                                }

                                ret = send(new_sd, (void*)buffer, dim, 0);
                                if(ret < dim){
                                    perror("Problemi con l'invio dell'introduzione della stanza");
                                    exit(1);
                                }

                                // invio descrizione
                                sprintf(buffer, "%s", st.descr);
                                dim = strlen(buffer);
                                ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                if(ret < DIM_UINT16){
                                    perror("Problemi con l'invio della dimensione della descrizione della stanza");
                                    exit(1);
                                }

                                ret = send(new_sd, (void*)buffer, dim, 0);
                                if(ret < dim){
                                    perror("Problemi con l'invio della descrizione della stanza");
                                    exit(1);
                                }

                                // invio descrizioni locations
                                int i = 0;
                                for(; i < LOCATIONS ; i++){
                                    sprintf(buffer, "%s", st.locations[i]);
                                    dim = strlen(buffer);
                                    ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                    if(ret < DIM_UINT16){
                                        perror("Problemi con l'invio della dimensione di una location");
                                        exit(1);
                                    }

                                    ret = send(new_sd, (void*)buffer, strlen(buffer), 0);
                                    if(ret < strlen(buffer)){
                                        perror("Problemi con l'invio di una location");
                                        exit(1);
                                    }
                                }

                                // invio nomi locations
                                i = 0;
                                for(; i < LOCATIONS ; i++){
                                    sprintf(buffer, "%s", st.location_names[i]);
                                    dim = strlen(buffer);
                                    ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                    if(ret < DIM_UINT16){
                                        perror("Problemi con l'invio della dimensione del nome di una location");
                                        exit(1);
                                    }

                                    ret = send(new_sd, (void*)buffer, strlen(buffer), 0);
                                    if(ret < strlen(buffer)){
                                        perror("Problemi con l'invio del nome di una location");
                                        exit(1);
                                    }
                                }

                                // invio descrizione oggetti
                                i = 0;
                                for(; i < OBJECTS; i++){
                                    sprintf(buffer, "%s", st.objs[i]);
                                    dim = strlen(buffer);
                                    ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                    if(ret < DIM_UINT16){
                                        perror("Problemi con l'invio della dimensione dela descrizione di un oggetto");
                                        exit(1);
                                    }

                                    ret = send(new_sd, (void*)buffer, strlen(buffer), 0);
                                    if(ret < strlen(buffer)){
                                        perror("Problemi con l'invio dela descrizione di un oggetto");
                                        exit(1);
                                    }
                                }

                                // invio nomi oggetti
                                i = 0;
                                for(; i < OBJECTS; i++){
                                    sprintf(buffer, "%s", st.obj_names[i]);
                                    dim = strlen(buffer);
                                    ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                    if(ret < DIM_UINT16){
                                        perror("Problemi con l'invio della dimensione del nome di un oggetto");
                                        exit(1);
                                    }

                                    ret = send(new_sd, (void*)buffer, strlen(buffer), 0);
                                    if(ret < strlen(buffer)){
                                        perror("Problemi con l'invio del nome di un oggetto");
                                        exit(1);
                                    }
                                }

                                // invio domande
                                i = 0;
                                for(; i < OBJECTS; i++){
                                    sprintf(buffer, "%s", st.questions[i]);
                                    dim = strlen(buffer);
                                    ret = send(new_sd, (void*)&dim, DIM_UINT16, 0);
                                    if(ret < DIM_UINT16){
                                        perror("Problemi con l'invio della dimensione di una domanda");
                                        exit(1);
                                    }

                                    ret = send(new_sd, (void*)buffer, strlen(buffer), 0);
                                    if(ret < strlen(buffer)){
                                        perror("Problemi con l'invio di una domanda");
                                        exit(1);
                                    }
                                }

                                // invio soluzioni
                                i = 0;
                                for(; i < SOLUTIONS; i++){
                                    ret = send(new_sd, (void*)&st.solutions[i], DIM_UINT8, 0);
                                    if(ret < DIM_UINT8){
                                        perror("Problemi con l'invio di una soluzione");
                                        exit(1);
                                    }
                                }
                                break;
                            default:
                                goto term;
                                break;
                        }
// ===============================================================================
// ||                     FINE INVIO INFORMAZIONI STANZA                        ||
// ===============================================================================

// ===============================================================================
// ||                           LOOP DELLA PARTITA                              ||
// ===============================================================================
                        uint8_t rcv_cmd;
                        while(1){
                            // i token sono le cifre che servono per aprire la porta
                            // il giocatore può avere max 3 oggetti
                            // attesa comandi dal client
                            // può arrivare anche il timeout
                            ret = recv(new_sd, (void*)&rcv_cmd, DIM_UINT8, 0);
                            if(ret < DIM_UINT8){
                                perror("Problemi con la ricezione del comando");
                                exit(1);
                            }

                            switch(rcv_cmd){
                                case 0:
                                    // end
                                    printf("\033[1;33mLOG:\033[0m un utente si e'arreso\n");
                                    goto term;
                                break;
                                
                                case 1:
                                    // look
                                    printf("\033[1;33mLOG:\033[0m un utente ha usato look\n");
                                break;

                                case 2:
                                    // take
                                    printf("\033[1;33mLOG:\033[0m un utente ha usato take\n");
                                break;
                                
                                case 3:
                                    // use
                                    printf("\033[1;33mLOG:\033[0m un utente ha usato use\n");
                                break;
                                
                                case 4:
                                    // objs
                                    printf("\033[1;33mLOG:\033[0m un utente ha usato objs\n");
                                break;

                                case 5:
                                    // timeout
                                    printf("\033[1;33mLOG:\033[0m un utente ha esaurito il tempo\n");
                                break;
                                
                                case 6:
                                    // drop
                                    printf("\033[1;33mLOG:\033[0m un utente ha usato drop\n");
                                break;

                                case 7:
                                    // win
                                    printf("\033[1;33mLOG:\033[0m un utente ha vinto la partita\n");
                                    goto term;
                                break;
                            }
                        }
                        // resa o timeout
                        term:
                        close(new_sd);
                        exit(0);
                    } else {
                        close(new_sd);
                    }
                } else {
                    // stdin per comando di stop
                    char cmd[8] = "";
                    while(1){
                        scanf("%s", cmd);
                        if(strcmp(cmd, "stop") == 0)
                            break;
                    }
                    printf("\033[1;31mServer shutdown. . .\033[0m\n");
                    close(sd);
                    close(new_sd);
                    exit(0);
                }
            }
        }
    }

    return 0;
}