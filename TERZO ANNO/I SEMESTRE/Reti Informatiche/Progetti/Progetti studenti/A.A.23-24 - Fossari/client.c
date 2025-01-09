#include "definizioni.c"
#include <signal.h>

// variabili globali e dichiarazioni funzioni
int score, server_socket, inv_num;

int cproc(struct sockaddr_in *);
void client_start_message();
void format_by_protocol(char *,char *, char *, char *);
void reverse_prize_protocol(void *);
void timerh(int);
void inctimer(int);
void checkwin();
int timeleft();

int main(int argc, char *argv[] ){

    // tutte le variabili che vengono utilizzate dal client
    int ret, port, len, current_room, argnum;
    size_t str_len;
    struct sockaddr_in server_struct;
    char cmdbuf[FIELD_LEN], arg1[FIELD_LEN], arg2[FIELD_LEN], user[FIELD_LEN];
    char buffer[XCH_BUF_LEN];
    char ack;

    // controlli preliminari sugli argomenti del processo
    if(argc > 2) {
        printf("Usa \"./client <port>\" per inizializzare il client.\n");
        exit(1);
    }
    if(argc == 1) port = 4242;
    else port = atoi(argv[1]);

    // inserito per bloccare il processo: se non vi fosse, eseguendo client e server all'unisono allora il client proverebbe a connettersi ad un server inattivo
    printf("Premi un tasto per iniziare!\n");
    getchar();

    // inizializzazione variabili di partenza
    str_len = sizeof(struct sockaddr_in);
    strcpy(user,"\0");
    current_room = -1;
    score = 0;
    inv_num = 0;

    // inizializzazione struttura sockaddr_in per il server
    memset(&server_struct, 0, str_len);
    sockinit(&server_struct,"127.0.0.1", port);

    // inizializzazione connessione verso il server. in "cproc" sono contenute le operazioni di socket() e connect()
    server_socket = cproc(&server_struct);
    if(server_socket == -1){
        perror("Impossibile inizializzare client.\n");
        exit(1);
    }

    // messa a video dei primi messaggi
    client_start_message();

    while(1){
        // segnamo come vuoti i vecchi campi
        memset(buffer, 0, XCH_BUF_LEN);
        arg1[0] ='\0';
        arg2[0] = '\0';
        printf("\n");
        // messa a video del tempo e dei token rimanenti
        if(current_room != -1) printf("Hai a disposizione %d secondi (%d token mancanti).\n", timeleft(), TO_WIN - score);

        // leggiamo da tastiera un comando
        fgets(buffer, XCH_BUF_LEN, stdin);
        if(buffer[0] == 10) continue;       // se leggiamo un semplice ritorno carrello allora non fare nulla
        argnum = sscanf(buffer, "%31s %31s %31s", cmdbuf, arg1, arg2);      // componiamo il comando su tre array: comando, argomento_1, argomento_2
        argnum--;                                                           // in argnum il numero di argomenti di un comando

        // END: chiudiamo la connessione, mettiamo a video delle statistiche ed usciamo
        if(!strcmp(cmdbuf,"end\0")){
            close(server_socket);
            if(current_room != -1) printf("Partita persa con %d token ottenuti. (%d token rimasti)\n", score, TO_WIN-score);
            exit(0);
        }

        // HELP: messa a video dei comandi disponibili al client
        if(!strcmp(cmdbuf,"help\0")){
            client_start_message();
            continue;
        }

        // REGISTER: ogni user deve prima registrarsi per giocare
        if(!strcmp(cmdbuf,"register")){
            if(argnum != 2){        // gli argomenti potrebbero essere troppi o troppo pochi
                WRONG_FORMAT
                continue;
            }
            if(strcmp(user,"\0")){      // se siamo già loggati allora non procedere
                printf("Utente già loggato come \"%s\"\n",user);
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, arg2);     // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));   // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta di register.\n");
                continue;
            }
            ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack in ritorno
            switch(ack){
                case '0':       // ack == '0'
                    perror("Impossibile effettuare la registrazione.\n");
                    continue;
                break;
                case '2':       // ack == '2'
                    printf("Nome utente già registrato.\n");
                    continue;
                break;
                default:    // ack == altro
                    printf("Registrazione effettuata con successo. Effettua ora il login.\n");
            }
            continue;
        }

        // LOGIN: ogni utente deve loggarsi prima di giocare
        if(!strcmp(cmdbuf,"login")){
            if(argnum != 2){        // gli argomenti potrebbero essere troppi o troppo pochi
                WRONG_FORMAT
                continue;
            }
            if(strcmp(user,"\0")){      // se siamo già loggati impediamo di poterci riloggare
                printf("Utente già loggato come \"%s\"\n",user);
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, arg2);     // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));   // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta di login.\n");
                continue;
            }
            ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack in ritorno
            switch(ack){
                case '0':       // ack == '0'
                    perror("Impossibile effettuare il login.\n");
                    continue;
                break;
                case '2':       // ack == '2'
                    printf("Utente non registrato.\n");
                    continue;
                break;
                default:        // ack == altro
                    printf("Login effettuato con successo.\n");
                    strcpy(user,arg1);      // se il login ha successo allora dai un nome al client
            }
            continue;
        }

        // i comandi successivi sono disponibili ai soli utenti loggati. maschera la loro esistenza ai non loggati
        if(user[0] == '\0'){
            printf("Effettua il login prima di effettuare questo comando. Usa \"help\" se hai bisogno di aiuto.\n");
            continue;
        }

        // START: per giocare va scelta una stanza
        if(!strcmp(cmdbuf,"start\0")){
            if(argnum != 1){        // gli argomenti potrebbero essere troppi o troppo pochi
                WRONG_FORMAT
                continue;
            }
            if(current_room != -1){     // se siamo già in una stanza impedisci la creazione di un'altra
                printf("Hai già iniziato una partita.\n");
                continue;
            }
            ret = atoi(arg1);
            if(ret < 0 || ret >= ROOM_NUM){     // se viene inserito un numero di stanza non valido allora mostralo
                printf("Il valore della room deve essere compreso tra 0 e %d.\n", ROOM_NUM - 1);
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, NULL);     // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta di start.\n");
                continue;
            }
            ret = recv(server_socket, &len, sizeof(int), 0);    // ci aspettiamo di ritorno un intero che rappresenta la stanza
            if(ret == -1){
                perror("Impossibile ricevere esito start.\n");
                continue;
            }
            len = ntohl(len);   // da network ad host
            if(len == -1){
                perror("Impossibile inizializzare partita.\n");
                continue;
            }
            current_room = len;         // settiamo il campo current_room
            signal(SIGALRM, timerh);    // associamo a SIGALARM l'handler "timerh"
            alarm(COUNTDOWN);           // facciamo partire il timer
            printf("Partita iniziata:\n");
            continue;
        }

        // i comandi successivi sono visibili ai soli utenti che hanno fatto start. mascherarli a chi non sta giocando
        if(current_room == -1){
            printf("Prima di effettuare questo comando comincia una partita con il comando \"start <room>\"\n");
            continue;
        }

        // OBJS: mette a video il contenuto dell'inventario
        if(!strcmp(cmdbuf,"objs\0")){
            // nessun controllo sul numero degli argomenti: verrebbero ignorati in ogni caso da format_by_protocol
            format_by_protocol(buffer, cmdbuf, NULL, NULL);     // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile effettuare richiesta objs.\n");
                continue;
            }
            len = doppia_recv(server_socket, buffer);       // ci aspettiamo in arrivo una coppia lunghezza, messaggio
            if(len == -1){
                perror("Impossibile ricevere messaggio in objs.\n");
                continue;
            }
            if(!len){       // se len == 0 allora il nostro inventario è vuoto
                printf("Inventario vuoto.\n");
            } else printf("oggetti nell'inventario:\n%s", buffer);      // altrimenti mettilo a video
            continue;
        }

        // LOOK: mette a video le descrizioni della room, delle locazioni e degli oggetti
        if(!strcmp(cmdbuf,"look\0")){
            if(argnum > 1){        // gli argomenti potrebbero essere troppi
                WRONG_FORMAT
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, NULL);         // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta di look.\n");
                continue;
            }
            ret = doppia_recv(server_socket, buffer);   // ci aspettiamo una coppia len, messaggio. messaggio contiene la descrizione dell'argomento
            if(ret == -1){
                perror("Impossibile ricevere messaggio look.\n");
                continue;
            }
            if(!ret){   // se riceviamo len = 0 allora non esiste una sua descrizione: l'oggetto non esiste
                printf("Oggetto inesistente.\n");
                continue;
            }
            printf("%s\n", buffer);     // metti a video la descrizione
            continue;
        }

        // TAKE: prendi un oggetto o chiama in maniera trasparente al giocatore una "answer" per risolvere l'enigma
        if(!strcmp(cmdbuf,"take\0")){
            if(argnum != 1){        // gli argomenti potrebbero essere troppi o troppo pochi
                WRONG_FORMAT
                continue;
            }
            if(inv_num == INVSIZE){     // se l'inventario è pieno bisogna lasciare qualcosa
                printf("Inventario pieno.\n");
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, NULL);     // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta take.\n");
                continue;
            }
            ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack che ci dica cosa sia successo
            if(ret == -1){
                perror("Impossibile ricevere ack.\n");
                continue;
            }
            switch(ack){
                case '0':       // ack == '0'
                    printf("L'oggetto richiesto non esiste o è già in tuo possesso.\n");
                break;
                case '1':       // ack == '1': l'oggetto non era bloccato
                    inv_num++;
                    printf("Oggetto raccolto.\n");
                break;
                case '2':       // ack == '2': l'oggetto è bloccato da un enigma
                    printf("Per prendere l'oggetto devi prima rispondere all'enigma seguente:\n");
                    ret = doppia_recv(server_socket, buffer);       // ci aspettiamo indietro una coppia len, messaggio che contenga la domanda
                    if(ret == -1){
                        perror("Impossibile ricevere la domanda.\n");
                        continue;
                    }
                    if(!ret){       // se riceviamo 0 allora non esiste domanda
                        perror("Domanda non disponibile.\n");
                        continue;
                    }
                    printf("%s\n", buffer);     // mostriamo la domanda

                    strcpy(cmdbuf, "answer\0");     // componiamo in maniera trasparente all'utente il comando answer <risposta>
                    fgets(buffer, FIELD_LEN, stdin);
                    sscanf(buffer, "%31s", arg1);
                    format_by_protocol(buffer, cmdbuf, arg1, NULL);     // formuliamo la richiesta secondo protocollo
                    ret = doppia_send(server_socket, buffer, strlen(buffer));   // inviamo la risposta
                    if(ret == -1){
                        perror("Impossibile rispondere all'enigma.\n");
                        continue;
                    }
                    ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack
                    if(ret == -1){
                        perror("Impossibile ricevere esito risposta.\n");
                        continue;
                    }
                    if(ack == '2'){     // ack == '2': i tentativi per risolvere l'enigma sono terminati e la partita è persa
                        printf("Tentativi terminati.\n");
                        close(server_socket);                                                                       // chiudiamo la connessione
                        printf("Partita persa con %d token ottenuti. (%d token rimasti)\n", score, TO_WIN-score);   // messa a video di statistiche
                        exit(0);        // termine
                    }
                    if(ack == '1'){
                        printf("Risposta esatta. Riesegui il comando take per prendere l'oggetto.\n");
                        ret = doppia_recv(server_socket, buffer);        // riceviamo le ricompense per aver risolto l'enigma
                        if(ret == -1){
                            perror("Impossibile ricevere esito enigma.\n");
                            continue;
                        }
                        reverse_prize_protocol(buffer);     // le ricompense sono trasmesse secondo protocollo

                    } else printf("Risposta sbagliata. Riesegui il comando take per ritentare.\n");     // caso in cui la risposta è sbagliata
                break;
                case '3':   // ack == '3': si tratta di un enigma da risolvere con una USE
                    printf("E' richiesto un altro oggetto per sbloccarlo.\n");
                break;
                default:
                    printf("Ricevuto un ack sconosciuto. %c\n", ack);
            }
            continue;
        }

        // DROP
        if(!strcmp(cmdbuf,"drop\0")){
            if(argnum != 1){       // gli argomenti potrebbero essere troppi o troppo pochi
                WRONG_FORMAT
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, NULL);         // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta use.\n");
                continue;
            }
            ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack
            if(ret == -1){
                perror("Impossibile ricevere esito use.\n");
                continue;
            }
            switch(ack){
                case '0':       // ack == '0'
                    printf("Oggetto non presente nel tuo inventario.\n");
                break;
                case '1':       // ack == '1'
                    printf("Oggetto lasciato.\n");
                    inv_num--;
                break;
                default:
                    printf("Ricevuto un ack sconosciuto.\n");
            }
            continue;
        }

        // USE: proviamo ad utilizzare uno o due oggetti
        if(!strcmp(cmdbuf,"use\0")){
            if(argnum < 1 || argnum > 2){       // gli argomenti potrebbero essere troppi o troppo pochi
                WRONG_FORMAT
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, arg2);         // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile inoltrare richiesta use.\n");
                continue;
            }
            ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack
            if(ret == -1){
                perror("Impossibile ricevere esito use.\n");
                continue;
            }
            switch(ack){
                case '0':       // ack == '0'
                    printf("Oggetto non presente nel tuo inventario.\n");
                break;
                case '1':       // ack == '1': un oggetto non ha una funzione o la coppia di oggetti non può essere usata in coppia
                    printf("Non sembra funzionare.\n");
                break;
                case '2':       // ack == '2': abbiamo trovato un uso per l'oggetto
                    printf("Oggetto usato.\n");
                    ret = doppia_recv(server_socket, buffer);       // ci aspettiamo di ricevere dei premi
                    if(ret == -1){
                        perror("Impossibile ricevere esito use.\n");
                        continue;
                    }
                    reverse_prize_protocol(buffer);     // riceviamo i premi secondo protocollo
                break;
                default:
                    printf("Ricevuto un ack sconosciuto.\n");
            }
            continue;
        }
        
        // GRAFFITO: lascia presso una locazione un graffito che gli altri possono leggere o prova semplicemente a leggere un graffito lasciato da altri
        if(!strcmp(cmdbuf, "graffito\0")){
            if(argnum < 1){     // gli argomenti potrebbero essere troppo pochi
                WRONG_FORMAT
                continue;
            }
            format_by_protocol(buffer, cmdbuf, arg1, arg2);     // formuliamo la richiesta secondo protocollo
            ret = doppia_send(server_socket, buffer, strlen(buffer));       // inviamo la richiesta
            if(ret == -1){
                perror("Impossibile effettuare richiesta graffito.\n");
                continue;
            }
            ret = recv(server_socket, &ack, sizeof(char), 0);       // ci aspettiamo un Ack
            if(ret == -1){
                perror("Impossibile ricevere ack graffito.\n");
                continue;
            }
            switch(ack){
                case '0':
                    printf("Location non trovata.\n");
                break;
                case '1':
                    printf("Graffito scritto.\n");
                break;
                case '3':
                    printf("Nessun graffito da leggere.\n");
                break;
                case '2':   // ack == '2': esiste un graffito da leggere
                    ret = doppia_recv(server_socket, buffer);       // riceviamo una coppia len, messaggio che contiene il graffito
                    if(ret == -1){
                        perror("Impossibile ricevere contenuto graffito.\n");
                        continue;
                    }
                    printf("[%s]\n",buffer);        // mettilo a video
                break;
                default:
                    printf("Ricevuto un ack sconosciuto.\n");
            }
            continue;
        }

        // arriviamo qui solo se non è stato riconosciuto il comando
        WRONG_FORMAT
    }
}

// =============================================================================================================

void client_start_message(){        // funzione di messaa video dei messaggi iniziali client
    printf("***************************** COMANDI UTENTE *********************************\nDigita un comando:\n");
    printf("1)register [usr] [passwd] > invia una richiesta di iscrizione.\n2)login [usr] [passwd] > accedi al tuo account dopo esserti registrato.\n3)start [room] > comincia una partita nella stanza di id \"room\".\n4)look [location | object] > ottieni una descrizione di oggetti e location. Ritorna la descrizione della stanza se senza argomenti.\n5)take [object] > prendi \"object\". La risoluzione di un enigma potrebbe essere richiesta.\n6)use [object] [object2] > utilizza \"object\" da solo, o tenta di utilizzarlo con \"object2\".\n7)objs > controlla il contenuto del tuo inventario.\n8)graffito [location] [text] --> lascia un messaggio \"text\" in \"location\". Per leggere i graffiti in un una location basta omettere \"text\". ATTENZIONE: i graffiti si scoloriscono col tempo.\n9)end > termina la connessione con il server di gioco.\n");
    printf("******************************************************************************\n");
}

int cproc(struct sockaddr_in * str){                                // funzione che generalizza la creazione di un processo client
    int sd, ret;
    socklen_t str_len;
    str_len = sizeof(*str);
    sockstats(*str);                                                // messa a video delle informazioni nella client_struct

    sd = socket(AF_INET, SOCK_STREAM, 0);                           // socket()
    if( sd == -1) {
        perror("impossibile creare il socket.\n");
        return -1;
    }
    // connetti socket
    ret = connect(sd, (const struct sockaddr*) str, str_len);       // connect()
    if( ret == -1) {
        perror("Impossibile effettuare connect.\n");
        return -1;
    }
    return sd;
}

void format_by_protocol(char * buffer, char * cmdbuf, char * arg1, char * arg2){    // funzione che formatta "buffer" in modo che rispetti il protocollo di comunicazione client>server utilizzato
    if(!strcmp(cmdbuf,"register\0")){                                               // anzichè trasmettere per intero un comando (n byte) trasmettiamo un suo identificativo (un solo byte)
        buffer[0] = REGISTER;
    } else if(!strcmp(cmdbuf,"login\0")){
        buffer[0] = LOGIN;
    }else if(!strcmp(cmdbuf,"objs\0")){
        buffer[0] = OBJS;
    }else if(!strcmp(cmdbuf,"look\0")){
        buffer[0] = LOOK;
    }else if(!strcmp(cmdbuf,"take\0")){
        buffer[0] = TAKE;
    }else if(!strcmp(cmdbuf,"answer\0")){
        buffer[0] = ANSWER;
    }else if(!strcmp(cmdbuf,"use\0")){
        buffer[0] = USE;
    }else if(!strcmp(cmdbuf,"start\0")){
        buffer[0] = START;
    }else if(!strcmp(cmdbuf,"graffito\0")){
        buffer[0] = GRAFFITO;
    }else if(!strcmp(cmdbuf,"drop\0")){
        buffer[0] = DROP;
    }
    buffer[1] = '\0';
    if(arg1 != NULL && arg1[0] != '\0'){                                            // inserisci un primo argomento se richiesto
        strcat(buffer, " ");
        strcat(buffer, arg1);
    }
    if(arg2 != NULL && arg1[0] != '\0'){                                           // inserisci un secondo argmento se richiesto
        strcat(buffer, " ");
        strcat(buffer, arg2);
    }
}

void reverse_prize_protocol(void * buffer){                                             // funzione per scomporre un messaggio di vittoria per il client, secondo il protocollo server>client                                                  
    int i, len_g = 1;                                                                   // iiii  iiii    str   str
    char c;                                                                             // 0123  4567    8     8 + len_g
    printf("Hai ricevuto delle ricompense:\n");
    memcpy(&i, buffer, sizeof(int));                                                    // numero ti token ricevuti
    i = ntohl(i);
    if(i) printf("\t+%d token!\n", i);
    score += i;                                                                         // incrementa i punti
    memcpy(&i, buffer + 4, sizeof(int));                                                // tempo guadagnato
    i = ntohl(i);
    if(i) printf("\t+%d secondi!\n", i);
    inctimer(i);                                                                        // incrementa lo scadere del timer
    c = *((char*)(buffer + 8));
    if(c != '\0'){                                                                      // se buffer[8] != '\0' allora abbiamo ottenuto un nuovo oggetto
        printf("Un nuovo oggetto è disponibile: **%s**.\n", (char *)(buffer + 8));
        len_g = strlen((char *)(buffer + 8)) + 1;
    }
    printf("%s\n",(char *)(buffer + len_g + 8));                                        // potresti aver ricevuto un messaggio speciale
    checkwin();                                                                         // controlla di aver vinto (la partita potrebbe terminare qui)
}

void timerh(int segnale) {                                                                      // funzione in risposta allo scadere del timer
    printf("Timer scaduto!\n");
    close(server_socket);                                                                       // la partita è finita, chiudiamo la connessione
    printf("Partita persa con %d token ottenuti. (%d token rimasti)\n", score, TO_WIN-score);   // messa a video di statistiche
    exit(0);                                                                                    // termine
}

void inctimer(int time){                // funzione per incrementare il tempo rimanente
    int remaining = alarm(0);           // cancelliamo il vecchio timer, otteniamo i secondi mancanti
    alarm(remaining + time);            // ripartiamo il timer con "time" secondi in più
}

void checkwin(){                                                // funzione per il controllo di una vittoria
    if(score < TO_WIN) return;                                  // non fare nulla se i punti sono troppo pochi
    close(server_socket);                                       // chiudi la connessione
    printf("Hai vinto con %d secondi rimasti!\n", alarm(0));    // messaggio di vittoria e cancellazione del timer
    exit(0);                                                    // termine
}

int timeleft(){                 // ritorna il numero di secondi rimanenti allo scoccare del timer
    int remaining = alarm(0);
    alarm(remaining);
    return remaining;
}