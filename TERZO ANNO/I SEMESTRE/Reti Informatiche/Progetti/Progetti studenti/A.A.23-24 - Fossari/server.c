#include "roomdata.c"

// variabili globali
struct select_list * socket_iter;               // struttura per scorrere la lista di socket
struct select_list sdlist, listenlist;          // testa della lista dei socket monitorati (stdin) e socket di ascolto
fd_set master, readset;                         // set di descrittori di socket
struct graffito graf_array[GRAF_NUM];           // array globale per i graffiti

// dichiarazione funzioni server
int server_start_message();
void shutdown_server();
int sproc(struct sockaddr_in *, int);
void sdlist_in(struct select_list *);
int sdlist_out(int);
void print_list();
char register_user(char *, char *);
char login_user(char *, char *);
void termine_connessione();
int prize_protocol(char *, int, int, char *, char *);
void scolorisci(struct select_list *);
void printf_obj(struct oggetto *);


int main(int argc, char* argv[] ){
    // dichiarazione delle variabili
    int listsd, skt, port, maxfd, i, len, ret, argnum;
    socklen_t socklen;
    struct sockaddr_in client_struct;
    struct sockaddr_in server_struct;
    char cmdbuf[FIELD_LEN], arg1[FIELD_LEN], arg2[FIELD_LEN];
    char buffer[XCH_BUF_LEN];
    char ack;
    struct oggetto * o, * t;
    struct room * r;
    struct enigma * e;
    struct select_list * list_elem;

    // controlli preliminari sugli argomenti del processo
    if(argc > 2) {
        printf("Usa \"./server <port>\" per inizializzare il server.\n");
        exit(1);
    }
    if(argc == 1) port = 4242;
    else port = atoi(argv[1]);

    // messa a video dei messaggi iniziali. chiusura in caso di comando STOP
    if(!server_start_message()){
        exit(1);
    }
    printf("Server avviato.\n");
    
    // inizializzazione di variabili e della struttura del server
    socklen = sizeof(struct sockaddr_in);
    memset(&server_struct, 0, socklen);
    sockinit(&server_struct,"127.0.0.1", port);
    for ( i= 0; i < GRAF_NUM; i++) graf_array[i].content[0] = '\0';     // inizializzazione array graffiti

    listsd = sproc(&server_struct, 10);         // funzione per generalizzare lo start del server
    if (listsd == -1){
        perror("Impossibile avviare server.");
        exit(1);
    }

    // inizializzazzione dei set. Inizializziamo master in modo che contenga listening e stdin
    FD_ZERO(&master);
 	FD_ZERO(&readset);
 	FD_SET(0, &master);
 	FD_SET(listsd, &master);

    // inizializzazione della lista. All'avvio avremo [sdlist [0]] -> [listenlist [listsd]] -> NULL
    listenlist.sd = listsd;
    listenlist.next = NULL;
    listenlist.match = NULL;
    strcpy(listenlist.user,"listening");
    sdlist.sd = 0;
    sdlist.next = & listenlist;
    sdlist.match = NULL;
    strcpy(sdlist.user,"stdin");

    while(1){
        // inizializzazione del set
        readset = master;

        // inizializzazione del descrittore massimo: la coda è ordinata per sd descrescenti dopo stdin, dunque stdin.next = descrittore massimo
        maxfd = sdlist.next->sd;
        ret = select(maxfd + 1, &readset, NULL, NULL, NULL);        // chiamata della select
        if( ret == -1){
            perror("Errore nella select: ");    // errore non recuperabile
            shutdown_server();      // arrestiamo il server
        }
        
        // scorriamo la lista dei descrittori ed agiamo su quelli pronti
        for(socket_iter = & sdlist; socket_iter != NULL; socket_iter = socket_iter -> next)
            if(FD_ISSET(socket_iter->sd, &readset)){

                skt = socket_iter->sd;      // settiamo skt per questa iterazione del for sopra

                // LISTENER
                if(skt == listsd){
                    ret = accept(listsd, (struct sockaddr *) &client_struct, &socklen);     // accettiamo chi è in attesa sulla coda
                    if( ret == -1){
                        perror("Impossibile accettare nuova connessione: ");
                        continue;
                    }
                    FD_SET(ret,&master);        // inseriamo la nuova connesione nel set
                    list_elem = (struct select_list *) malloc (sizeof(struct select_list));     // creazione strutture per la gestione del nuovo socket
                    if(!list_elem){             // se non è possibile creare una struttura select_list per il socket allora chiudi la connessione
                        perror("Impossibile allocare nuovi descrittori in lista.\n");
                        termine_connessione();
                    }
                    memset(list_elem, 0, sizeof(struct select_list));       // pulizia dei campi ora occupati da list_elem
                    list_elem->sd = ret;        // in ret vi è ancora il descrittore di socket
                    sdlist_in(list_elem);       // inseriamo list_elem nella coda di gestione dei socket
                    printf("Nuova connessione (%d)\n",ret);
                    print_list();               // per far vedere sul server la lista dei client
                    continue;
                }

                // STDIN
                if(skt == 0){
                    fgets(buffer, XCH_BUF_LEN, stdin);
                    sscanf(buffer, "%s", cmdbuf);
                    scanf("%s", cmdbuf);

                    if(!strcmp(cmdbuf,"stop\0")){
                        // procedura di chiusura del server
                        // chiudi il server se e solo se non esiste nessun client connesso, ovvero se in lista esistono solo listen e stdin
                        if(sdlist.next->next){
                            printf("Impossibile arrestare il server. Almeno un client è ancora connesso.\n");
                            continue;
                        }
                        else shutdown_server();
                    }

                    if(!strcmp(cmdbuf,"list\0")){
                        print_list();
                        continue;
                    }
                   printf("Comando inserito invalido. Prova nuovamente.\n");
                   continue;
                }

                // COMANDO DA CLIENT
                memset(buffer, 0, XCH_BUF_LEN);         // pulizia dai dati precedenti
                memset(cmdbuf, 0, FIELD_LEN);
                memset(arg1, 0, FIELD_LEN);
                memset(arg2, 0, FIELD_LEN);

                len = doppia_recv(skt, buffer);         // riceviamo il comando
                if(len == -2 || len == -1){             // se otteniamo un codice particolare (close() oppure -1) terminiamo la connessione
                    termine_connessione();
                    continue;
                }
                argnum = sscanf(buffer, "%s %s %s", cmdbuf, arg1, arg2);     // componiamo il comando dal buffer
                argnum--;
                printf("%d) %s [%d args] => ", skt, buffer, argnum);      // messa a video del comando ricevuto

                // REGISTER
                if(cmdbuf[0] == REGISTER){
                    ack = register_user(arg1, arg2);    // chiama la funzione register_user
                    switch(ack){        // messa a video possibili esiti
                        case '0':
                            printf("Impossibile registrare utente.\n");
                        break;
                        case '2':
                            printf("Utente già registrato.\n");
                        break;
                        default:
                            printf("Utente registrato con successo.\n");
                    }
                    ret = send(skt, &ack, sizeof(char), 0);     // invio esito
                    if(ret == -1){
                        printf("Errore in risposta al client.\n");
                    }
                    continue;
                }

                // LOGIN
                if(cmdbuf[0] == LOGIN){
                    ack = login_user(arg1, arg2);       // chiamata login_user
                    switch(ack){        // messa a video possibili esiti
                        case '0':
                        printf("Impossibile effettuare il login.\n");
                        break;
                        case '2':
                        printf("Nome utente non registrato.\n");
                        break;
                        default:
                        printf("Login effettuato con successo.\n");
                    }
                    ret = send(skt, &ack, sizeof(char), 0);     // invio esito
                    if(ret == -1){
                        printf("Errore in risposta al client.\n");
                        continue;
                    }
                    if(ack == '1') strcpy(socket_iter->user,arg1);      // associamo al socket un nome utente
                    continue;
                }

                // START
                if(cmdbuf[0] == START){
                    socket_iter->match = (struct partita *) malloc(sizeof(struct partita));     // creiamo una struttura partita all'interno della struttura relativa alla connessione
                    if(!socket_iter->match){
                        perror("Impossibile allocare una struttura partita.\n");
                        ret = -1;
                    } else {
                        ret = atoi(arg1);
                        printf("Inizializzando una partita nella stanza %d.\n", ret);       // inizializzazione della stanza secondo "roomdata.c"
                        ret = room_init(socket_iter->match, ret);
                    }
                    ret = htonl(ret);       // inviamo la codifica della stanza in big endian
                    ret = send(skt, &ret, sizeof(int), 0);      // invio codifica stanza
                    if( ret == -1){
                        printf("Impossibile comunicare con il client.\n");
                        termine_connessione();
                        continue;
                    }
                    printf("\tPartita inizializzata.\n");
                    continue;
                }

                //OBJS
                if(cmdbuf[0] == OBJS){
                    o = socket_iter->match->inv;    // calcoliamo prima la lunghezza dell'inventario
                    len = 0;
                    while(o!= NULL){        // ciclo while per sommare tutti i nomi
                        len += strlen(o->nome);
                        o = o->next;
                    }
                    if(!len){       // se len = 0 l'inventario è vuoto, non serve mandare il buffer
                        len = htonl(len);       // lunghezza in big endian
                        ret = send(skt, &len, sizeof(int), 0);      // invio lunghezza
                        if(ret == -1){
                            printf("Impossibile comunicare con il client.\n");
                            termine_connessione();
                        }
                    } else {        // len > 0. va inviato anche il buffer
                        strcpy(buffer,"\0");    // componiamo il buffer come un'unica stringa
                        o = socket_iter->match->inv;
                        while(o!= NULL){
                            strcat(buffer, o->nome);    // la sua forma sarà obj1\nobj2\n ecc...
                            strcat(buffer, "\n");
                            len++;      // aggiungiamo +1 a len perchè stiamo aggiungendo un carattere '\n' per ogni oggetto nell'inventario
                            o = o->next;
                        }
                        ret = doppia_send(skt, buffer, len);        // inviamo la coppia len, messaggio
                        if(ret == -1){
                            printf("Impossibile comunicare con il client.\n");
                            termine_connessione();
                        }
                    }
                    printf("Inventario inviato.\n");
                    continue;
                }

                //LOOK
                if(cmdbuf[0] == LOOK){
                    ack = '0';  // non usato nella trasmissione, ma solo per dire di aver trovato o meno il target
                    r = &socket_iter->match->er;
                    if(!argnum){        // se la richiesta è senza argomenti allora il target è la room
                        ret = doppia_send(skt, r->descr, strlen(r->descr));     // invio descrizione room
                            if(ret == -1){
                                perror("Impossibile inviare descrizione.\n");
                                termine_connessione();
                            }
                        continue;
                    }
                    for(i = 0; i < LOC_NUM; i++){       // controlliamo ogni locazione della room
                        if(!strcmp(r->locs[i].nome, arg1)){     // se il nome coincide con quello richiesto allora è lei il target
                            ret = doppia_send(skt, r->locs[i].descr, strlen(r->locs[i].descr));     // invio coppia len, messaggio
                            if(ret == -1){
                                perror("Impossibile inviare descrizione.\n");
                                termine_connessione();
                            }
                            ack ='1';   // target trovato
                            break;
                        }
                    }
                    if(ack == '1'){     // non avrei potuto fare una continue nel for perchè avrebbe semplicemente saltato l'iterazione, ecco perchè serve ack == '1'
                        printf("Descrizione locazione inviata.\n");
                        continue;
                    }
                    for(i = 0; i < OBJ_NUM; i++){   // ripetiamo lo stesso procedimento per gli oggetti nella room
                        if(!strcmp(r->objs[i].nome, arg1)){     // se il nome coincide allora è lui il target
                            ret = doppia_send(skt, r->objs[i].descr, strlen(r->objs[i].descr));     // invio coppia len, messaggio
                            if(ret == -1){
                                perror("Impossibile inviare descrizione.\n");
                                termine_connessione();
                            }
                            ack = '1';  // target trovato
                            break;
                        }
                    }
                    if(ack == '1'){     // ripetiamo lo stesso procedimento visto 15 righe sopra
                        printf("Descrizione oggetto inviata.\n");
                        continue;
                    }
                    len = htonl(0);     // arriviamo qui se ack == '0': inviamo len = 0 per dire che non esiste una descrizione
                    ret = send(skt, &len, sizeof(int), 0);
                    if(ret == -1){
                        perror("Impossibile inviare descrizione.\n");                        
                    } else printf("Oggetto non trovato.\n");
                    continue;
                }

                //TAKE
                if(cmdbuf[0] == TAKE){
                    r = &socket_iter->match->er;
                    ack = '0';      // con ack == '0' l'oggetto non è trovato
                    t = r->avail_objs;      // controlliamo nella room se l'oggetto esista o meno
                    if(!strcmp(t->nome,arg1)){      // trovato in testa
                        // caso 1: l'oggetto non ha enigma e può essere subito preso
                        // caso 2: l'oggetto è bloccato da un enigma e va messo in pending_objs. Verrà poi sbloccato da una answer
                        if(t->e != NULL){
                            if(t->e->requires[0] != -1){
                                ack = '3';                  // oggetto raccoglibile tramite una use
                            } 
                            else {
                                ack = '2';                  // oggetto raccoglibile dopo un enigma
                                socket_iter->match->pending_obj = t;        // lasciamo l'oggetto in sospeso. il client risponderà più tardi
                            }
                        } 
                        else {
                            ack = '1';                          // oggetto raccoglibile
                            r->avail_objs = t->next;            // togliamo t dagli oggetti a terra
                            t->next = socket_iter->match->inv;  // mettiamo t nell'inventario del giocatore
                            socket_iter->match->inv = t;        // aggiorniamo l'inventario
                        }
                    }
                    if(ack == '0'){         // se non è in testa scorriamo la lista per cercarlo
                        o = r->avail_objs;
                        t = o->next;
                        while(t != NULL){
                            if(!strcmp(t->nome,arg1)){
                                // caso 1: l'oggetto non ha enigma e può essere subito preso
                                // caso 2: l'oggetto è bloccato da un enigma e va messo in pending_objs. Verrà poi sbloccato da una answer  ->o->t->next
                                if(t->e != NULL){
                                    if(t->e->requires[0] != -1){
                                    ack = '3';
                                    } 
                                    else {
                                        ack = '2';
                                        socket_iter->match->pending_obj = t;    // lasciamo l'oggetto in sospeso. il client risponderà più tardi
                                    }
                                }
                                else {
                                    ack = '1';                          // oggetto preso
                                    o->next = t->next;                  // togliamo t dagli oggetti a terra
                                    t->next = socket_iter->match->inv;  // mettiamo t nell'inventario del giocatore
                                    socket_iter->match->inv = t;        // aggiorniamo l'inventario
                                }
                            }
                            o = t;              // scorriamo la lista
                            t = t->next;
                        }
                    }
                    switch(ack){        // alcuni esiti mostrati a video lato server
                        case '0':
                            printf("Oggetto non trovato.\n");
                        break;
                        case '1':
                            printf("Oggetto preso.\n");
                        break;
                        case '2':
                            printf("Risposta richiesta.\n");
                        break;
                        default:
                            printf("Serve una use.\n");
                    }
                    ret = send(skt, &ack, sizeof(char), 0);     // inviamo l'esito come Ack
                    if(ret == -1){
                        perror("Impossibile comunicare con il client.\n");
                        termine_connessione();
                        continue;
                    }
                    if(ack != '2') continue;        // nel caso in cui ack == '2' il client si aspetta anche un enigma
                    ret = doppia_send(skt, socket_iter->match->pending_obj->e->domanda, strlen(socket_iter->match->pending_obj->e->domanda));       // inviamo la domanda associata all'oggeto in sospeso
                    if(ret == -1){
                        perror("Impossibile comunicare con il client.\n");
                        termine_connessione();
                    }
                    continue;
                }

                // ANSWER
                if(cmdbuf[0] == ANSWER){
                    r = &socket_iter->match->er;
                    o = socket_iter->match->pending_obj;        // o inizializzato come l'oggeto in sospeso
                    if(!strcmp(o->e->risposta, arg1)){          // se la risposta coincide con quella del client allora la risposta è esatta
                        ack = '1';
                        printf("Risposta esatta.\n");
                        ret = send(skt, &ack, sizeof(char), 0);     // comunichiamo al client di aver azzeccato la risposta
                        if(ret == -1){
                            perror("Impossibile comunicare con il client.\n");
                            termine_connessione();
                            continue;
                        }
                        e = o->e;       // se è stato inoltrato ack == '1' allora il client si aspetta anche delle ricompense
                        len = prize_protocol(buffer, e->token, e->overtime, (e->grants != -1) ? r->objs[e->grants].nome : "\0", e->custom_message);      // formuliamo il messaggio del premio come protocollo
                        ret = doppia_send(skt, buffer, len);        // invio del messaggio come coppia len, messaggio
                        if(ret == -1){
                            perror("Impossibile comunicare con il client.\n");
                            termine_connessione();
                            continue;
                        }
                        o->e = NULL;        // se abbiamo inviato le reward possiamo rimuovere l'enigma di pending_obj
                        if(e->updates != -1){       // se l'enigma prevedeva di updatare i campi di un altro oggetto allora fallo
                            printf("\tUpdate oggetto: %d %s %s\n", e->updates, e->new_nome ? "nome" : " ", e->new_descr ? "descr" : " ");
                            o = &r->objs[e->updates];
                            if(e->new_nome != '\0') strcpy(o->nome, e->new_nome);
                            if(e->new_descr != '\0') strcpy(o->descr, e->new_descr);
                            if(e->new_e) o->e = e->new_e;
                        }
                        if(e->grants != -1){        // se l'enigma prevedeva che il giocatore avrebbe dovuto ottenere un nuovo oggetto allora daglielo
                            printf("\tNuovo oggetto: %s\n", r->objs[e->grants].nome);
                            r->objs[e->grants].next = r->avail_objs;
                            r->avail_objs = &r->objs[e->grants];
                        }
                    }
                    else {      // se il le risposte non coincidono allora la risposta dell'utente è sbagliata
                        printf("Risposta errata.\n");
                        o->e->ttl--;        // diminuiamo i tentativi di riposta
                        if(!o->e->ttl) ack = '2';       // se sono terminati allora inoltra ack == '2'
                        else ack = '0';
                        ret = send(skt, &ack, sizeof(char), 0);         // comunichiamo al client di aver sbagliato la risposta o di aver terminato i tentativi
                        if(ret == -1){
                            perror("Impossibile comunicare con il client.\n");
                            termine_connessione();
                        }
                    }
                    socket_iter->match->pending_obj = NULL;     // rimuoviamo l'oggetto in sospeso: il client deve ritentare con una nuova take
                    continue;
                }

                // USE
                if(cmdbuf[0] == USE){
                    r = &socket_iter->match->er;        // verifichiamo prima che l'argomento_1 sia nell'inventario
                    o = socket_iter->match->inv;
                    while(o != NULL){
                        if(!strcmp(o->nome, arg1)) break;
                        o = o->next;
                    }
                    if(!o){
                        ack = '0';                              // se non si trova l'oggetto nell'inventario allora è impossibile usarlo
                        printf("Oggetto non presente.\n");
                        ret = send(skt, &ack, sizeof(char), 0);     // invia Ack
                        if(ret == -1){
                            perror("Impossibile comunicare con il client.\n");
                            termine_connessione();
                        }
                        continue;
                    }
                    ack = '1';      // per ora con ack == '1' comunichiamo di aver trovato l'oggetto. se resta '1' allora quell'oggetto non può essere usato
                    if(argnum == 1){        // caso use su un solo oggetto
                        for(i = 0; i < ENIGMA_NUM; i++){        // cerchiamo l'enigma che riguardi l'oggetto
                            if(r->en[i].requires[0] == -1) continue;    // se non riguarda una use allora cercane un altro
                            if(!strcmp(r->objs[r->en[i].requires[0]].nome, arg1) && r->en[i].requires[1] == -1){        // se ne trova uno dove è lui quello che va usato ed il secondo oggetto richiesto è nullo allora siamo davanti ad una use di un singolo oggetto
                                ack = '2';      // ack == '2' per uenigma use trovato
                                e = &r->en[i];
                                e->requires[0] = -1;             // mettiamo requires[0] a -1, in modo che alla prossima iterazione del for precedente questo enigma non verrà più selezionato
                                break;
                            }
                        }
                    } else {        // caso use con due argomenti. arg2 può essere nell'inventario o fuori, non importa
                        for(i = 0; i < ENIGMA_NUM; i++){
                            if(r->en[i].requires[0] == -1) continue;    // non riguarda una use
                                if((!strcmp(r->objs[r->en[i].requires[0]].nome, arg1) && !strcmp(r->objs[r->en[i].requires[1]].nome, arg2)) || (!strcmp(r->objs[r->en[i].requires[1]].nome, arg1) && !strcmp(r->objs[r->en[i].requires[0]].nome, arg2))){       // se gli oggetti negli argomenti del comando hanno nome uguale a quelli richiesti dall'enigma (non importa l'ordine), allora è questo l'enigma che ci interessa
                                    // se gli oggetti coincidono ad i campi in requires (obj1.nome == arg1 && obj2.nome == arg2) || (obj2.nome == arg1 && obj1.nome == arg2) allora la soluzione è trovata
                                    ack = '2';      // ack == '2' per enigma use trovato
                                    e = &r->en[i];
                                    e->requires[0] = -1;        // mettiamo requires[0] a -1, in modo che alla prossima iterazione del for precedente questo enigma non verrà più selezionato
                                    break;
                                }
                            }
                        }
                    ret = send(skt, &ack, sizeof(char), 0);     // inviamo l'esito come ack
                    if(ret == -1){
                        perror("Impossibile comunicare con il client.\n");
                        termine_connessione();
                        continue;
                    }
                    printf("Oggetto usato.\n");
                    if(ack != '2') continue;        // se ack != '2' l'operazione è finita, altrimenti continua
                    len = prize_protocol(buffer, e->token, e->overtime, (e->grants != -1) ? r->objs[e->grants].nome : "\0", e->custom_message);      // inviamo al client le sue ricompense secondo protocollo
                    ret = doppia_send(skt, buffer, len);        // invio delle ricompense come len, messaggio
                    if(ret == -1){
                        perror("Impossibile comunicare con il client.\n");
                        termine_connessione();
                        continue;
                    }
                    if(e->updates != -1){       // se l'enigma prevedeva l'update di un oggetto allora fallo
                        printf("\tUpdate oggetto: %d %s %s\n", e->updates, e->new_nome ? "nome" : " ", e->new_descr ? "descr" : " ");
                        o = &r->objs[e->updates];
                        if(e->new_nome != '\0') strcpy(o->nome, e->new_nome);
                        if(e->new_descr != '\0') strcpy(o->descr, e->new_descr);
                        if(e->new_e) o->e = e->new_e;
                    }
                    if(e->grants != -1){        // se l'enigma prevedeva di dare un nuovo oggetto al client allora daglielo
                        printf("\tNuovo oggetto: %s\n", r->objs[e->grants].nome);
                        r->objs[e->grants].next = r->avail_objs;
                        r->avail_objs = &r->objs[e->grants];
                    }
                    continue;
                }

                // GRAFFITO: funzione a piacere. usata con argomenti [location] ci mostra il graffito in "location", usata come [location] [text] setta "text" come nuovo graffito in "location"
                if(cmdbuf[0] == GRAFFITO){
                    r = &socket_iter->match->er;
                    ack = '0';      // ack == '0' se non viene fatto nulla
                    for( i = 0; i < LOC_NUM; i++){      // cerchiamo prima la location
                        if(!strcmp((r->locs[i].nome),arg1)){        // se il nome coincide allora è quella il target
                            if(argnum == 1){        // se vi è un solo argomento per il comando allora vogliamo solo leggere il graffito
                                printf("lettura graffito.\n");
                                if(graf_array[r->locs[i].graffito].content[0] == '\0'){     // se il graffito è vuoto allora ack = '3'
                                    ack = '3';
                                }
                                else ack = '2';     // se il graffito non è vuoto ack = '2'
                            } else {        // se gli argomenti sono due allora vogliamo modificare il graffito
                                printf("Modifica graffito.\n");
                                strcpy(graf_array[r->locs[i].graffito].content,arg2);       // sovrascriviamo il graffito precedente
                                ack = '1';
                            }
                            break;
                        }
                    }
                    if(ack == '0'){     // se ack == '0' la location non è stata trovata
                        printf("Location non trovata.\n");
                    }
                    ret = send(skt, &ack, sizeof(char), 0);     // invia un esito come Ack
                    if(ret == -1){
                        perror("Impossibile comunicare con il client.\n");
                        termine_connessione();
                        continue;
                    }
                    if( ack == '2'){
                    ret = doppia_send(skt,graf_array[r->locs[i].graffito].content,strlen(graf_array[r->locs[i].graffito].content));     // se abbiamo solo letto il graffito allora invialo come coppia len, text
                        if(ret == -1){
                            perror("Impossibile comunicare con il client.\n");
                            termine_connessione();
                            break;
                        }
                    }
                    continue;
                }

                // DROP
                if(cmdbuf[0] == DROP){
                    r = &socket_iter->match->er;
                    ack = '0';      // con ack == '0' l'oggetto non è trovato
                    t = socket_iter->match->inv;    // controlliamo nell'inventario se l'oggetto esista o meno
                    if(t){
                        if(!strcmp(t->nome,arg1)){      // trovato in testa
                            ack = '1';                              // oggetto trovato
                            socket_iter->match->inv = t->next;      // togliamo t dall'inventario
                            t->next = r->avail_objs;                // mettiamo t a terra
                            r->avail_objs = t;                      // aggiorniamo gli oggetti a terra
                        }
                        if(ack == '0'){         // se non è in testa scorriamo la lista per cercarlo
                            o = socket_iter->match->inv;
                            t = o->next;
                            while(t != NULL){
                                if(!strcmp(t->nome,arg1)){
                                        ack = '1';                          // oggetto lasciato
                                        o->next = t->next;                  // togliamo t dall'inventario
                                        t->next = r->avail_objs;            // mettiamo t a terra
                                        r->avail_objs = t;                  // aggiorniamo
                                }
                                o = t;              // scorriamo la lista
                                t = t->next;
                            }
                        }
                    }
                    switch(ack){        // esiti mostrati a video lato server
                        case '0':
                            printf("Oggetto non trovato.\n");
                        break;
                        default:
                            printf("Oggetto lasciato.\n");
                    }
                    ret = send(skt, &ack, sizeof(char), 0);     // inviamo l'esito come Ack
                    if(ret == -1){
                        perror("Impossibile comunicare con il client.\n");
                        termine_connessione();
                    }
                    continue;
                }
                
                printf("Comando inserito invalido. Prova nuovamente.\n");
        }
    }
}

// ===============================================================================================================================================================================================================================================================================

int server_start_message(){                                             // funzione di messa a video dei comandi iniziali del server
    char buf[5];
    printf("***************************** SERVER STARTED *********************************\nDigita un comando:\n1) start --> avvia it server di gioco.\n2) stop --> termina it server.\n3) list --> una volta attivato il server, viene usato per mettere a video una lista delle connessioni correnti.\n******************************************************************************\n");
    while(1){
        scanf("%s",buf);
        if(!strcmp(buf,"start")) return 1;                              // ritorna 1 se facciamo uan start, 0 se facciamo una stop
        if(!strcmp(buf,"stop")) return 0;
        printf("Comando inserito invalido. Prova nuovamente.\n");       // richiede un nuovo comando se è diverso da start o stop
    }
}

void shutdown_server(){                                         // funzione di chiusura totale del server
    struct select_list * tmp;
    socket_iter = sdlist.next;                                  // deallochiamo sdlist partendo dal successivo alla testa: la testa è un elemento statico senza partita

    printf("Deallocazione heap.\n");
    while(socket_iter != NULL){                                 // cominciamo a deallocare lo heap
        if(socket_iter->sd == listenlist.sd){                   // se ci troviamo di fronte al listening socket allora ignoriamolo: è statico e senza partita
            close(listenlist.sd);                               // chiudiamo il socket di listening
            socket_iter = socket_iter->next;
            continue;
        }
        if(socket_iter->match) free(socket_iter->match);        // liberiamo la struttura relativa alla partita del socket
        tmp = socket_iter;
        free(tmp);                                              // distruggiamo la struttura select_list relativa a quel socket
        socket_iter = socket_iter->next;
    }
    close(sdlist.sd);                                           // chiudiamo il socket stdin
    printf("Termine applicazione.\n");
    exit(0);
}

int sproc(struct sockaddr_in * str, int bllen){                     // funzione che generalizza tutti i passaggi per la creazione di un processo server
    int sd, ret;
    socklen_t str_len;
    str_len = sizeof(*str);
    sockstats(*str);                                                // messa a video delle informazioni nella server_struct

    sd = socket(AF_INET, SOCK_STREAM, 0);                           // socket()
    if( sd == -1) {
        printf("impossibile creare il socket.\n");
        return -1;
    }
    ret = bind(sd, (struct sockaddr*) str, str_len);                // bind()
    if( ret == -1){
        printf("impossibile effettuare bind.\n");
        return -1;
    }
    ret = listen(sd, bllen);                                        // listen()
    if( ret == -1){
        printf("impossibile effettuare listen.\n");
        return -1;
    }
    return sd;
}

void sdlist_in(struct select_list * elem){                          // funzione di inserimento di un nuovo elemento nella lista sdlist
    int value = elem->sd;
    struct select_list * iter = &sdlist;
    struct select_list * tmp;
    while(iter->next != NULL && iter->sd > value)                   // si tratta di un inserimento ordinato per id di socket: tornerà utile per determinare max_sd nella select()
        iter = iter->next;
    tmp = iter -> next;
    iter -> next = elem;
    elem -> next = tmp;
}

int sdlist_out(int sd){                                             // una funzione di rimozione dalla select_list
    struct select_list * prev = &sdlist;
    struct select_list * succ = prev->next;
    while(succ != NULL){
        if(succ->sd == sd){                                         // se il socket è quello che stiamo cercando allora rimuovilo
            prev->next = succ->next;
            if(succ->match != NULL){                                // la connessione potrebbe star chiudendo anche prima che il client abbia creato una partita
                memset(succ->match, 0, sizeof(struct partita));     // se una partita è stata aperta allora pulisci la memoria e libera quelle locazioni heap
                free(succ->match);
            } 
            memset(succ, 0, sizeof(struct select_list));            // pulisci le strutture di tipo select_list utilizzate nella connessione
            free(succ);                                             // libera lo heap
            return 1;
        }
        prev = succ;
        succ = succ->next;
    }
    return 0;
}

void print_list(){                                      // funzione di utilità: stampa a video informazioni relative ai socket al momento impegnati
    struct select_list * iter = &sdlist;
    while(iter != NULL){
        printf("[%d]-[%s]\n",iter->sd,iter->user);      // formato messa a video: [descrittore socket]-[username_player]
        iter = iter->next;
    }
}

void scolorisci(struct select_list * elem){                 // funzione che fa scolorire il graffito a mano a mano che qualcuno finisce uan partita nella stessa room
    struct room * r;
    int i, random, j;
    char * str;
    if(!elem->match) return;
    r = &elem->match->er;                                   // puntatore alla escape room che stiamo chiudendo
    for( i = 0; i < LOC_NUM; i++){                          // cicliamo tutte le location della room
        str = graf_array[r->locs[i].graffito].content;      // cicliamo tutti i graffiti nelle location
        for( j = 0; *(str + j) != '\0'; j++){
            if(*(str + j) != '#'){                     
                random = rand() % 5;                        // ogni carattere del graffito che non sia già "#" viene cancellato con una chance del 20%
                if(!random) *(str + j) = '#';
            }
        }
    }
}

void termine_connessione(){                                         // funzione che termina la connessione con il client al momento puntato da socket_iter
    printf("%d) La connessione è terminata:\n",socket_iter->sd);
    FD_CLR(socket_iter->sd, &master);                               // rimuoviamo il socket della connessione terminata dal set
    close(socket_iter->sd);                                         // chiusura effettiva socket
    scolorisci(socket_iter);                                        // scolorisci i graffiti nella room
    sdlist_out(socket_iter->sd);                                    // rimuovi le strutture dati relative alla partita appena chiusa
    print_list();                                                   // debug: mostra a video la nuova lista
}

char register_user(char user[], char passwd[]){                 // funzione per registrare un utente
    char buffer[FIELD_LEN*2 +1];
    char field1[FIELD_LEN], field2[FIELD_LEN];
    FILE * fd = fopen("playerdata.txt", "r+");                  // apriamo il file "playerdata.txt" in lettura/scrittura
    if(fd == NULL){
        perror("Impossibile aprire il file playerdata.\n");
        return '0';
    }
    while (fgets(buffer, sizeof(buffer), fd) != NULL) {         // se appare una riga del tipo "user passwd" allora l'utente è già registrato
        if (sscanf(buffer, "%s %s", field1, field2) == 2) {
            if (strcmp(field1, user) == 0) {
                fclose(fd);
                return '2';                                     // utente già registrato
            }
        }
    }
    if (fd != NULL) {                                           // inseriamo una nuova riga in coda al file
        fprintf(fd, "%s %s\n", user, passwd);
        fclose(fd);
    } else {
        perror("Errore nella scrittura delle credenziali.\n");
        return '0';
    }
    return '1';
}

char login_user(char user[], char passwd[]){                        // funzione per far loggare un client
    char buffer[FIELD_LEN*2 + 1], looking_for[FIELD_LEN*2 + 1];
    FILE * fd = fopen("playerdata.txt", "r");                       // apriamo il file "playerdata.txt" in lettura/scrittura
    if (fd == NULL) {
        perror("Impossibile aprire il file playerdata.\n");
        return '0';
    }
    strcpy(looking_for,user);                                       // assembliamo la stringa che stiamo cercando
    strcat(looking_for," ");
    strcat(looking_for, passwd);
    strcat(looking_for, "\n");

    while (fgets(buffer, sizeof(buffer), fd) != NULL) {             // scorriamo il contenuto del file e cerchiamo se esiste la stringa che abbiamo assemblato
        if (!strcmp(buffer,looking_for)) {
                fclose(fd);
                return '1';                                         // utente trovato
        }
    }
    fclose(fd);
    return '2';                                                     // utente non trovato
}

int prize_protocol(char * buffer, int token, int time, char* granted, char* message){           // funzione che assembla un messaggio di ricompense per il client.
    int n, len_g = 1;                                                                           // iiii iiii    str   str
    n = htonl(token);                                                                           // 0123 4567    8     8 + len_g ...
    memcpy(buffer, &n, sizeof(int));
    n = htonl(time);
    memcpy(buffer + 4, &n, sizeof(int));
    if(granted[0] != '\0'){
        len_g = strlen(granted) + 1;
        strncpy(buffer + 8, granted, len_g);
    } else memset(buffer + 8, 0, 1);
    strcpy(buffer + 8 + len_g, message);
    return strlen(message) + 2*sizeof(int) + len_g;                                             // ritorniamo la lunghezza di tutta la baracca, calcolata individualmente (token,time e granted protebbero contenere 0x00 = '\0') e quindi una strlen(buffer) verrebbe troncata
}