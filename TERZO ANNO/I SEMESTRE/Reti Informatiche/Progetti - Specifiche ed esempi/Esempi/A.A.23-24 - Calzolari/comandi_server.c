#include "account.h"
#include "sessione.h"
#include "tuttigli.h"
#include "comandi_server.h"

/* Si occupa del protocollo di login con il client, restituisce l'ID dell'account associato al client
    Se account già online ritorna -1*/
int comando_login(int sd, struct Account **lista){
    int ret;
    char buf[256];
    char email[30];
    char passw[20];
    char dati[2];

    // Email è massimo 29+\0 caratteri
    ret = recv(sd, buf, 30, 0);
    if(ret == -1){
        perror("Errore nella ricezione dell'email");
    }
    printf("Email ricevuta\n");
    strncpy(email, buf, 30);

    // Password è massimo 19+\0 caratteri
    ret = recv(sd, buf, 20, 0);
    if(ret == -1){
        perror("Errore nella ricezione della password");
    }
    printf("Password ricevuta\n");
    strncpy(passw, buf, 20);

    // Devo controllare se l'account ha già una sessione attiva
    struct Account *temp = check_account(lista, email, passw);

    //Controllo se è presente l'account
    if(temp != NULL){
        // Se è presente login

        // Ma se è già online ritorno -1
        if(temp->status == online){
            return -1;
        }

        strcpy(dati, "1");
        ret = send(sd, dati, sizeof(dati), 0);
        if(ret == -1){
            perror("Errore nella send della comando_login");
            exit(1);
        }
        printf("Accesso da parte dell'account con id: %d\n", temp->id);
    } else {
        // Non è presente e registro automaticamente

        if(check_account_solo_email(lista, email) != NULL){
            // Se è presente significa che ha sbagliato la password
            return -2;
        }
        strcpy(dati, "0");
        ret = send(sd, dati, sizeof(dati), 0);
        if(ret == -1){
            perror("Errore nella send della comando_login");
            exit(1);
        }
        temp = new_account(email, passw);
        ins_account(lista, temp);
        printf("Nuovo account con id: %d\n", temp->id);
        temp->status = online;
    }

    return temp->id;
}

/* Si occupa di gestire il comando "room" del client */
void comando_rooms(uint8_t room, int id, struct Sessione **lista){
    // Ora devo gestire le sessioni, iniziarne una o recuperarla,
    // devo metterla se creata nella giusta lista.

    // Qua controllo se è già presente nella lista
    struct Sessione* temp = check_sessione(*lista, id);

    // Altrimenti la creo e la inserisco
    if(temp == NULL){
        temp = new_sessione(id, room);
        ins_sessione(lista, temp);
        printf("Sessione creata e inserita\n");
    }

    client_online++;
    // Da qui in poi il server si aspetta di ricevere solo comandi di gioco

}

/* Chiamata dopo un comando da input client, controlla se il giocatore ha vinto
    Se ha vinto restituisce 1, 0 altrimenti*/
bool check_vittoria(int sd, struct Sessione* sessione){
    int ret;
    uint8_t esito = sessione->token;
    
    // Vittoria
    ret = send(sd, (void *)&esito, sizeof(esito), 0);
    if(ret == -1){
        perror("Errore nell'invio dell'esito");
        exit(1);
    }

    if(esito == 2)
        return 1;
    return 0;
}

void comando_look(int sd, struct Sessione* sessione, int type){
    char buf[256];
    int ret;

    // Mi aspetto l'argomento del client
    ret = recv(sd, buf, sizeof(buf), 0);
    if(ret == -1){
        perror("Errore nell'invio dell'esito");
        exit(1);
    }
    // In base al tipo di room gestisco gli scenari
    if(type == 1){
        // Si guardano anche i flag per cambiare la frase stampata al client
        if(!strcmp(buf, "balcone")){

            strcpy(buf, "Noti un **baule** e un manichino in abiti da donna, deve essere **Giulietta**.");
            
        } else if(!strcmp(buf, "baule")){
            if(!sessione->flags[2])
                strcpy(buf, "Il baule è bloccato da un lucchetto speciale");
            else 
                strcpy(buf, "Hai già raccolto il braccio!");

        } else if(!strcmp(buf, "giulietta")){
            if(!sessione->flags[0])
                strcpy(buf, "Giulietta è rivolta verso il palco ma non sai dove stia guardando perché le manca la testa");
            else if(sessione->flags[2] && !sessione->flags[4]){
                strcpy(buf, "All'interno vedi la testa di un manichino");
            } else
                strcpy(buf, "Giulietta sta guardando il manichino di Romeo");

        } else if(!strcmp(buf, "palco")){

            strcpy(buf, "Di fronte a te vedi una **vetrina** portaoggetti e un manichino di un uomo, deve essere **Romeo**.");
        
        } else if(!strcmp(buf, "vetrina")){
            if(!sessione->flags[3])
                strcpy(buf, "Vedi una vetrina con una testa di un manichino al suo interno ma è chiusa");
            else if(sessione->flags[3] && !sessione->flags[5]){
                strcpy(buf, "All'interno vedi la testa di un manichino");
            } else 
                strcpy(buf, "Hai già raccolto la testa del manichino");
            

        } else if(!strcmp(buf, "romeo")){
            if(!sessione->flags[1])
                strcpy(buf, "Romeo sta guardando in alto verso il balcone ma gli manca un braccio");
            else
                strcpy(buf, "Romeo è completo e continua ad osservare Giulietta");
        } else {

            strcpy(buf, "Argomento non valido, prova con una location o un oggetto");

        }

        ret = send(sd, buf, sizeof(buf), 0);
        if(ret == -1){
            perror("Errore nell'invio dell'esito");
            exit(1);
        }
    } else {
        // Qua posso gestire gli scenari futuri
    }
}

void comando_objs(int sd, struct Sessione* sessione, int type){
    char buf[256] = "";
    int ret;
    // A seconda dello scenario devo gestire diversamente il comando

    if(type == 1){
        // Controllo il flag associato alla sessione
        if(sessione->flags[4] == 1){
            strcat(buf, "braccio\n");
        }
        // Controllo il flag associato alla sessione
        if(sessione->flags[5] == 1){
            strcat(buf, "testa\n");
        }
    } else {
        // Coming soon...
    }

    // Mando tutto al client per la stampa
    ret = send(sd, buf, sizeof(buf), 0);
    if(ret == -1){
        perror("Errore nell'invio dell'esito");
        exit(1);
    }
}

void comando_take(int sd, struct Sessione* sessione, int type){
    char buf[256];
    char arg1[10];
    char risposta[20];
    int ret;

    ret = recv(sd, arg1, sizeof(arg1), 0);
    if(ret == 1){
        perror("Errore nella ricezione del parametro della take");
        exit(1);
    }

    if(type == 1){

        // Nella stanza numero due possiamo usare la take solamente sul baule e sulla vetrina
        // Gli indovinelli non hanno un limite di tentativi
        if(!strcmp("baule", arg1)){
            
            // Controllo i flag per gestire i vari casi
            if(!sessione->flags[2]){
                // Devo mostrare l'enigma se il baule è bloccato (flag 2 == 0)
                strcpy(buf, "Il baule è bloccato. Devi risolvere l'enigma!\nIn quale città si trova il balcone della donna amata da Romeo?\n");

                ret = send(sd, buf, sizeof(buf), 0);
                if(ret == -1){
                    perror("Errore nella send dell'enigma del baule");
                    exit(1);
                }

                // Ci aspettiamo la risposta giusta che è giulietta
                ret = recv(sd, risposta, sizeof(risposta), 0);
                if(ret == -1){
                    perror("Errore nella recv della risposta all'enigma del baule");
                    exit(1);
                }
                
                // Controllo la risposta e se giusta setto il flag
                if(!strcmp(risposta, "verona\n")){
                    strcpy(buf, "Il lucchetto si è aperto e dentro vedi un braccio di un manichino\n");
                    sessione->flags[2] = 1;
                } else {
                    strcpy(buf, "Il lucchetto non si apre\n");
                }

                // Mandiamo l'esito dell'indovinello con la send finale (quella in fondo al ciclo)
                

            } else if(sessione->flags[2] && !sessione->flags[4]){
                // baule aperto e braccio non possesso
                strcpy(buf, "Hai preso il braccio\n");
                sessione->flags[4] = 1;
            } else {
                // l'altro caso rimasto è quando abbiamo già preso il braccio
                strcpy(buf, "Il baule è vuoto\n");
            }

        } else if(!strcmp("vetrina", arg1)){

            // Controllo i flag per gestire i vari casi
            if(!sessione->flags[3]){
                // La vetrina è chiusa
                // Devo mostrare l'enigma (flag 3 == 0)
                strcpy(buf, "La vetrina è chiusa. Devi risolvere l'enigma!\nCompleta la frase...\nOh Romeo, Romeo, perché sei tu Romeo? Rinnega tuo padre, e rifiuta il tuo ...!\n");

                ret = send(sd, buf, sizeof(buf), 0);
                if(ret == -1){
                    perror("Errore nella send dell'enigma della vetrina");
                    exit(1);
                }

                // Ci aspettiamo la risposta giusta che è giulietta
                ret = recv(sd, risposta, sizeof(risposta), 0);
                if(ret == -1){
                    perror("Errore nella recv della risposta all'enigma della vetrina");
                    exit(1);
                }

                // Controllo la risposta e se giusta setto il flag
                if(!strcmp(risposta, "nome\n")){
                    strcpy(buf, "Il lucchetto si è aperto e dentro e puoi prendere la testa del manichino\n");
                    sessione->flags[3] = 1;
                } else {
                    strcpy(buf, "Non è successo niente\n");
                }

                // Mandiamo l'esito dell'indovinello con la send finale (quella in fondo al ciclo)
                

            } else if(sessione->flags[3] && !sessione->flags[5]){
                // La vetrina è aperta ma non ho ancora preso l'oggetto
                strcpy(buf, "Hai preso la testa\n");
                sessione->flags[5] = 1;
            } else{
                // Vetrina aperta e ho già preso l'oggetto
                strcpy(buf, "La vetrina è vuota");
            }
        } else {
            strcpy(buf, "Argomento non valido\n");
        }
    } else {
        // Coming soon...
    }

    // Mando la stringa contenente l'esito della take
    ret = send(sd, buf, sizeof(buf), 0);
    if(ret == 1){
        perror("Errore nella send dell'esito della take");
        exit(1);
    }
}

void comando_use(int sd, struct Sessione* sessione, int type){
    char buf[256], arg[10];
    int ret;

    if(type == 1){

        // Mi aspetto uno degli argomenti della use dato che:
        // - Non sono presenti use con un singolo argomento
        // - I controlli sui parametri sono gestiti lato client
        ret = recv(sd, arg, sizeof(arg), 0);
        if(ret == 1){
            perror("Errore nella recv del primo argomento della use");
            exit(1);
        }
        printf("%s\n", arg);

        // Devo guardare quale tra i due casi mi è stato mandato
        // E successivamente devo guardare i flag per gestire il comando

        if(!strcmp(arg, "romeo") || !strcmp(arg, "braccio")){
            // Caso del baule di Romeo
            if(sessione->flags[4]){
                // Se ho la il braccio posso metterlo
                strcpy(buf, "Il braccio si incastra perfettamente, hai guadagnato un token!\n");

                // Devo rimuovere il braccio dall'inventario
                // Devo settare il flag del manichino e dare un token ai player
                sessione->flags[4] = 0;
                sessione->flags[1] = 1;
                sessione->token++;
            } else{
                // Non possiedo il braccio o lo ho già messo
                strcpy(buf, "Non hai questi oggetti oppure non puoi usarli insieme\n");
            }    

        } else {
            // L'unico altro caso è quello della testa di Giulietta

            if(sessione->flags[5]){
                // Se ho la testa posso metterla
                strcpy(buf, "Hai messo la testa al suo posto, hai guadagnato un token!\n");

                // Devo rimuovere la testa dall'inventario
                // Devo settare il flag del manichino e dare un token ai player
                sessione->flags[5] = 0;
                sessione->flags[0] = 1;
                sessione->token++;
            } else{
                // Non possiedo la testa o lo ho già messa
                strcpy(buf, "Non hai questi oggetti oppure non puoi usarli insieme\n");
            }
        }

        // Mando la stringa da stampare al client
        ret = send(sd, buf, sizeof(buf), 0);
        if(ret == -1){
            perror("Errore nella send dell'esito della use");
            exit(1);
        }


    } else {
        // Coming soon...   
    }
}