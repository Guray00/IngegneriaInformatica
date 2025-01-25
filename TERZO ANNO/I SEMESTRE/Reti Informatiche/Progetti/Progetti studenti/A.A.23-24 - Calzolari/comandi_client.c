#include "comandi_client.h"
#include "tuttigli.h"

/* Conversione di email e password*/
int manda_informazioni(int sd, char *email, char *passw){
    char buf[256];
    char comando[6];
    strcpy(comando, "login");
    int ret;

    // mando il comando
    ret = send(sd, comando, sizeof(comando), 0);
    if(ret == -1){
        perror("Errore nella send del comando login");
    }

    // converto in binary e mando email
    strncpy(buf, email, 30);
    ret = send(sd, buf, 30, 0);
    if(ret == -1){
        perror("Errore nell'invio dell'email");
    }

    // converto in binary e mando email
    strncpy(buf, passw, 20);
    ret = send(sd, buf, 20, 0);
    if(ret == -1){
        perror("Errore nell'invio della password");
    }
    
    return ret;
}

/* Stampa della look senza argomenti*/
void show_look(int room){
    if(room == 1)
        printf("Sei in un teatro abbandonato, ti trovi sul ++palco++ e davanti a te vedi un ++balcone++.\n");
    
}

/* Qua troviamo il codice che gestisce la partita*/
void gestione_partita1(int sd){
    int ret;
    char buf[256];
    char buf_stdin[256];
    char risposta[20];
    char comando[6], arg1[10], arg2[10];
    uint8_t esito;

    // Per il timer
    time_t start_time, cur_time; // Faccio partire il timer
    int tempo_trascorso;

    time(&start_time);

    // Si cicla infinitamente aspettando i comandi dell'utente
    while(1){
        
        
        memset(buf, 0, sizeof(buf));
        memset(buf_stdin, 0, sizeof(buf_stdin));
        memset(comando, 0, sizeof(comando));
        memset(arg1, 0, sizeof(arg1));
        memset(arg2, 0, sizeof(arg2));
        memset(risposta, 0, sizeof(risposta));

        //inserimento input
        if(fgets(buf_stdin, sizeof(buf_stdin), stdin) == NULL){
            printf("Errore durante la lettura da stdin\n");
            exit(1);
        }

        // Controllo se è scaduto il tempo
        time(&cur_time);
        tempo_trascorso = 300 - difftime(cur_time , start_time);
        if(tempo_trascorso <= 0){
            printf("Tempo scaduto, hai perso!\n");
            break;
        }

        // Controllo se ci sono messaggi nella casella di posta
        // Serve anche per capire se il server è stato chiuso
        ret = recv(sd, buf, sizeof(buf), MSG_DONTWAIT);
        if(ret == -1){
            if(errno == EWOULDBLOCK){
                printf("\nInbox: Non ci sono nuovi messaggi\n\n");
            }
            else {
                perror("Errore nella ricezione del msg");
                exit(1);
            }
        } else if(ret > 0){
            printf("\nInbox: %s\n", buf);
        } else {
            close(sd);
            printf("Il server è stato chiuso, arrivederci\n");
            exit(0);
        }

        ret = sscanf(buf_stdin, "%s %s %s", comando, arg1, arg2);
        //Gestione input

        // look [location | object]
        if((ret == 1 || ret == 2) && !strcmp(comando, "look")){
            if(ret == 2){
                // Qua è stato inserito una location o un object
                ret = send(sd, comando, sizeof(comando), 0);
                if(ret == -1){
                    perror("Errore nella send del comando look");
                    exit(1);
                }

                ret = send(sd, arg1, sizeof(arg1), 0);
                if(ret == -1){
                    perror("Errore nella send dell'arg1 della look");
                    exit(1);
                }

                // Qua mi aspetto il testo da stampare da parte del server
                ret = recv(sd, buf, sizeof(buf), 0);
                if(ret == -1){
                    perror("Errore nell'invio dell'esito");
                    exit(1);
                }
                printf("%s\n", buf);
                
            } else {
                // Qua è stato inserito look senza parametri aggiuntivi
                show_look(1);

                // Devo skippare la check_vittoria perché è gestito unicamente lato client
                continue;
            }
        } else if(ret == 2 && !strcmp(comando, "take")){ // take object

            // Mando il comando al server
            ret = send(sd, comando, sizeof(comando), 0);
            if(ret == -1){
                perror("Errore nella send del comando take");
                exit(1);
            }
            
            // Devo mandare il parametro al server
            ret = send(sd, arg1, sizeof(arg1), 0);
            if(ret == -1){
                perror("Errore nella send dell'argomento della take");
                exit(1);
            }

            // Devo ricevere la stringa da stampare
            ret = recv(sd, buf, sizeof(buf), 0);
            if(ret == -1){
                perror("Errore nella recv della stringa della take");
                exit(1);
            }

            // Stampa l'esito della take
            printf("%s", buf);

            // Se la stringa ricevuta è quella dell'enigma allora devo proporlo al giocatore
            if(!strcmp(buf, "La vetrina è chiusa. Devi risolvere l'enigma!\nCompleta la frase...\nOh Romeo, Romeo, perché sei tu Romeo? Rinnega tuo padre, e rifiuta il tuo ...!\n") || !strcmp(buf, "Il baule è bloccato. Devi risolvere l'enigma!\nIn quale città si trova il balcone della donna amata da Romeo?\n")){
                fgets(risposta, sizeof(risposta), stdin);
            
                // Mando la risposta al server
                ret = send(sd, risposta, sizeof(risposta), 0);
                if(ret == -1){
                    perror("Errore nella send della risposta all'enigma");
                    exit(1);
                }

                // Ricevo l'esito dal server
                ret = recv(sd, buf, sizeof(buf), 0);
                if(ret == -1){
                    perror("Errore nella recv dell'esito della risposta all'enigma");
                    exit(1);
                }

                printf("%s", buf);
            }

        } else if((ret == 2 || ret == 3) && !strcmp(comando, "use")){ // use object1 [object2]

            // Devo gestire il caso con due oggetti e il caso con un oggetto
            // In questa mappa non ho use con un oggetto quindi lo gestisco facile

            if(ret == 2){
                printf("Non puoi usare questo oggetto!\n");
            } else {
                // Caso con due argomenti
                // Ho due possibilità, usare romeo con il braccio e Giulietta con la testa

                if((!strcmp(arg1, "giulietta") && !strcmp(arg2, "testa")) || (!strcmp(arg2, "giulietta") && !strcmp(arg1, "testa"))){
                    // Mando il comando al server
                    ret = send(sd, comando, sizeof(comando), 0);
                    if(ret == -1){
                        perror("Errore nella send del comando use");
                        exit(1);
                    }
                    
                    // Gli argomenti sono validi, devo mandarli al server
                    // Posso mandare solo il primo dato che il controllo sui parametri è statp svolto qua
                    ret = send(sd, arg1, sizeof(arg1), 0);
                    if(ret == -1){
                        perror("Errore nella send del primo argomento della use");
                        exit(1);
                    }

                } else if((!strcmp(arg1, "romeo") && !strcmp(arg2, "braccio")) || (!strcmp(arg2, "romeo") && !strcmp(arg1, "braccio"))){
                    // Mando il comando al server
                    ret = send(sd, comando, sizeof(comando), 0);
                    if(ret == -1){
                        perror("Errore nella send del comando use");
                        exit(1);
                    }

                    // Gli argomenti sono validi, devo mandarli al server
                    // Posso mandare solo il primo dato che il controllo sui parametri è statp svolto qua
                    ret = send(sd, arg1, sizeof(arg1), 0);
                    if(ret == -1){
                        perror("Errore nella send del primo argomento della use");
                        exit(1);
                    }
                } else {
                    printf("Non hai questi oggetti oppure non puoi usarli insieme!\n");
                    continue;
                }

                ret = recv(sd, buf, sizeof(buf), 0);
                if(ret == -1){
                    perror("Errore nella recv dell'esito della use");
                    exit(1);
                }
                printf("%s", buf);
            }
            
        } else if(ret == 1 && !strcmp(comando, "objs")){ // objs

            // Devo mandare il comando al server
            ret = send(sd, comando, sizeof(comando), 0);
            if(ret == -1){
                perror("Errore nella send del comando objs");
                exit(1);
            }

            // Devo ricevere la stringa da stampare
            ret = recv(sd, buf, sizeof(buf), 0);
            if(ret == -1){
                perror("Errore nella recv del comando objs");
                exit(1);
            }
            printf("%s", buf);

        } else if(ret == 1 && !strcmp(comando, "msg")){ // msg

            // Devo mandare il comando al server
            ret = send(sd, comando, sizeof(comando), 0);
            if(ret == -1){
                perror("Errore nella send del comando msg");
                exit(1);
            }

            printf("Inserisci il messaggio: ");
            // Non posso mettere il messaggio su arg1 perché sarebbe limitato a pochi caratteri
            // Devo inserirlo successivamente 
            fgets(buf, sizeof(buf), stdin);

            ret = send(sd, buf, sizeof(buf), 0);
            if(ret == -1){
                perror("Errore nella send del messaggio");
                exit(1);
            }


        } else if(ret == 1 && !strcmp(comando, "end")){ // end

            printf("Arrivederci!\n");
            break;

        } else {
            printf("Comando non valido, riprova.\nI comandi validi sono:\n");
            printf("\tlook [location | object]\n");
            printf("\ttake object\n");
            printf("\tuse object1 [object2]\n");
            printf("\tobjs\n");
            printf("\tmsg\n");
            printf("\tend\n");     
            continue;
        }

        // Devo mostrare numero di token raccolti, mancanti e il tempo rimanente
        // Dopo ogni comando il server manda al client l'esito che dobbiamo gestire

        ret = recv(sd, (void *)&esito, sizeof(esito), 0);
        if(ret == -1){
            perror("Errore nella ricezione dell'esito");
            exit(1);
        }

        if(esito == 2){
            printf("Complimenti hai vinto!!!\nAdesso puoi goderti lo spettacolo!\n");
            break;
        }

        time(&cur_time);
        tempo_trascorso = 300 - difftime(cur_time , start_time);
        printf("Tempo rimanente: %d secondi\t Token raccolti: %d\t Token rimasti: %d\t\n\n", tempo_trascorso, esito, 2-esito);

    }
}
