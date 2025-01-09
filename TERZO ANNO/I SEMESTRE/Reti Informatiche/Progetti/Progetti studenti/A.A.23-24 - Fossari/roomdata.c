#include "definizioni.c"

/*
############################################################################################################

                    STRUTTURE PER L'IMPLEMENTAZIONE DELLE ESCAPE ROOM

############################################################################################################
*/

// struttura per tenere traccia dei socket in ascolto
struct select_list{
    int sd;                     // descrittore di socket
    struct select_list * next;  // puntatore al prossimo elemento
    struct partita * match;     // ogni socket (meno che stdin e listener) sono relativi ad una connessione, e quindi ad una partita
    char user[FIELD_LEN];       // nome del giocatore associato
};

// struttura per ogni descrittore di oggetto, ovvero il numero di oggetti effettivamente implementati
struct oggetto{
    char nome [NAME_LEN];       // nome oggetto
    char descr [DESCR_OBJS];    // descrizione oggetto
    struct oggetto * next;      // per implementare liste di oggetti
    struct enigma * e;          // per implementare l'enigma che sblocca l'oggetto
};

// struttura per gli indovinelli nella escape room
struct enigma{
    char domanda[QUESTION_LEN];             // domanda e risposta per enigmi verbali
    char risposta[ANSWER_LEN];

    int overtime;                           // tempo guadagnato in secondi risolvendo l'enigma
    int token;                              // token guadagnati dall'enigma

    int requires[2];                        // un array di -1 se l'enigma è solo verbale, contiene gli indici di due oggetti in objs[] se devono essere usati per sbloccarlo

    int grants;                             // indice di un ipotetico oggetto che l'enigma sblocca

    int updates;                            // indice di un ipotetico oggetto che viene modificato in seguito alla risoluzione dell'enigma
    char new_nome[NAME_LEN];                // nuovo nome per l'oggetto objs[updates]
    char new_descr[DESCR_OBJS];             // nuova descrizione per l'oggetto objs[updates]
    struct enigma * new_e;                  // nuovo enigma per l'oggetto objs[updates]

    char custom_message[CUSTOM_MEX_LEN];    // messaggio speciale che può apparire in risposta alla risoluzione

    int ttl;                                // tentativi rimanenti
};

// struttura descrittore di una location
struct location{
    char nome[NAME_LEN];                        // nome locazione
    char descr[DESCR_LOCS];                     // descrizione locazione
    int graffito;                               // indice del graffito relativo alla locazione in graf_array[]
};

// struttura descrittore di una escape room
struct room{
    char nome[NAME_LEN];                // nome room
    char descr[DESCR_LOCS];             // descrizione room
    struct location locs[LOC_NUM];      // array delle locazion della room
    struct oggetto objs[OBJ_NUM];       // array di tutti gli oggetti relativi ad una room
    struct enigma en[ENIGMA_NUM];       // array di tutti gli enigmi relativi ad una room
    struct oggetto * avail_objs;        // testa della lista degli oggetti "visibili"
};

// struttura per una partita
struct partita{
    struct oggetto * inv;           // inventario del giocatore
    struct room er;                 // escape room relativa alla partita
    struct oggetto * pending_obj;   // se un oggetto è bloccato da un enigma che richiede risposta, allora l'oggetto si blocca qui in attesa che il client risponda
};

struct graffito{
    char content[GRAF_LEN];         // struttura per memorizzare i graffiti
};

/*
############################################################################################################

                    PARAMETRI DI INIZIALIZZAZIONE ESCAPE ROOM

############################################################################################################
*/

int room_init(struct partita * p, int id){
    struct room * r = &p -> er;
    p->inv = NULL;
    p->pending_obj = NULL;

    if(id == 0){    // inizializzazione room 0
        // ROOM     nome        descrizione     oggetti
        strcpy(r->nome,"Alla deriva.\0");
        strcpy(r->descr, "Il motore della tua barca ti ha abbandonato in una battuta di pesca. Usa gli oggetti che trovi in ++cambusa++, presso la ++plancia++ o la ++prua++ per aggiustare il ++motore++ e pescare qualcosa, per non tornare a casa a mani vuote.\0");
        r->avail_objs = &r->objs[0];

        // LOCATION:        nome        descrizione     graffito
        r->locs[0] =    (struct location){"cambusa\0", "Uno spazio stretto ma umano. Nel piccolo magazzino vi sono dei **remi** e la tua cassetta della pesca: contiene un **coltello**, delle **lenze** e dell'**esca**. Magari potresti trovare qualcos'altro?\0", 0};
        r->locs[1] =    (struct location){"plancia\0", "E' qui che è possibile pilotare la barca. Sopra il timone vi sono una **bussola** e la postazione di una **radio**.\0", 1};
        r->locs[2] =    (struct location){"prua\0", "Ancora ti confondi su quale sia la poppa e quale la prua. La **cima** con la quale sei solito attraccare è sversata a terra, mentre la piccola **ancora** è fissata alla ringhiera.\0", 2};
        r->locs[3] =    (struct location){"motore\0", "Ah ecco, si è scollegato un tubo del gasolio. Prendi il **cacciavite** nella tua cassetta degli attrezzi in ++cambusa++ per restringere la **fascetta**.\0", 3};

        // OGGETTO:     nome        descrizione     prossimo        enigma
        // r->objs[] =    (struct oggetto){"placeholder_name\0", "placerholder_descr\0", NULL, NULL };
        r->objs[0] =    (struct oggetto){"remi\0", "Devi essere davvero disperato se sei costretto a prenderli.\0", &r->objs[1], &r->en[0]};
        r->objs[1] =    (struct oggetto){"radio\0", "Certo, se funzionasse sarebbe tutto più facile.\0", &r->objs[2], &r->en[4] };
        r->objs[2] =    (struct oggetto){"coltello\0", "In acciaio inossidabile, così non si ossida. Una data, (23/03) è incisa sulla lama.\0", &r->objs[3], &r->en[1] };
        r->objs[3] =    (struct oggetto){"lenze\0", "Sgrovigliarle sarà sicuramente divertente.\0", &r->objs[4], NULL };
        r->objs[4] =    (struct oggetto){"cima\0", "Solitamente la usi per attraccare. Certo, però, è difficile trovare un molo in mezzo al mare.\0", &r->objs[5], NULL };
        r->objs[5] =    (struct oggetto){"esca\0", "I pesci ne vanno ghiotti. Fissale alle **lenze** per ottenere una **paratura**.\0", &r->objs[7], NULL };
        r->objs[6] =    (struct oggetto){"pesce\0", "Una cernia, per l'esattezza.\0", NULL, NULL};
        r->objs[7] =    (struct oggetto){"bussola\0", "Magnetico!\0", &r->objs[8], NULL };
        r->objs[8] =    (struct oggetto){"fascetta\0", "Si è allentata, ma restringendola tornerà a funzionare.\0", &r->objs[9], NULL };
        r->objs[9] =    (struct oggetto){"cacciavite\0", "Ma è a stella, a taglio, esagonale, triangolare?\0", &r->objs[10] , NULL };
        r->objs[10] =    (struct oggetto){"ancora\0", "Non l'hai mai usata per paura si incagliasse.\0", NULL , NULL };

        // ENIGMA       domanda     risposta        overtime        token       richiede        grants      updates     new_n       new_d       new_e       messaggio       ttl
        // r->en[] =  (struct enigma){"placeholder_quest\0", "placeholder_answ\0", 10, 3, {-1, -1}, -1, -1, "placeholder_new_n\0", "placeholder_new_d\0", NULL, "\0", -1};
        r->en[0] =  (struct enigma){"Trova la parola nascosta:\n\tagqhmlrdx\n\tfotvnewik\n\tlcdxlrdxa\n\tvenvjknek\n\tdaekecdad\n\tbndjoijdw\n\taonneoykv\0", "oceano\0", 10, 1, {-1, -1}, -1, -1, "\0", "\0", NULL, "\0", -1};
        r->en[1] =  (struct enigma){"Una ninfea cresce in un lago e copre ogni giorno il doppio dell'area del giorno precedente. Se il 30 del mese copre tutto il lago, che numero era il giorno che ne ha coperto metà?\0", "29\0", 10, 1, {-1, -1}, -1, -1, "\0", "\0", NULL, "\0", 3};
        r->en[2] =  (struct enigma){"\0", "\0", 10, 1, {5, 3}, -1, 3, "paratura\0", "Lenze sgrovigliate e pronte all'uso.\0", NULL, "Hai ora una **paratura**. Prova ad usarla per pescare.\0", -1};
        r->en[3] =  (struct enigma){"\0", "\0",  5, 3, {3, -1}, 6, -1, "\0", "\0", NULL, "Hai lanciato la paratura fuori bordo ed hai pescato qualcosa!\0",-1};
        r->en[4] =  (struct enigma){"Prendendo in mano la radio vai sovrapensiero: 'ma certo, il suo inventore è...'. Ricorda il suo cognome:\0", "marconi\0", 5, 1, {-1, -1}, -1, -1, "\0", "\0", NULL, "Ah si ovvio, lui.\0",3};
        r->en[5] =  (struct enigma){"\0", "\0", 10, 3, {8, 9}, -1, -1, "\0", "\0", NULL, "Ingegneria meccanica ti si addiceva proprio!\0", -1};
        return 0;
    }

    // eventuali altre room andrebbero qui

    return -1;
}