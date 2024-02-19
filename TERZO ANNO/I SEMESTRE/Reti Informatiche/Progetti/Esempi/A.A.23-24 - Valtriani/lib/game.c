#include "game.h"

/***************** DEFINIZIONE STRUTTURE DATI CLIENT  ********************/
/* informazioni per il client sulle varie room che sono disponibili  */
desc_story stories[MAX_STORIES] = {
            {  /* la casa di guran turino */
                .id = 1, 
                .title = 
                " ██████  ██    ██ ██████   █████  ███    ██     ████████ ██    ██ ██████  ██ ███    ██  ██████ \n"
                "██       ██    ██ ██   ██ ██   ██ ████   ██        ██    ██    ██ ██   ██ ██ ████   ██ ██    ██\n"
                "██   ███ ██    ██ ██████  ███████ ██ ██  ██        ██    ██    ██ ██████  ██ ██ ██  ██ ██    ██\n"
                "██    ██ ██    ██ ██   ██ ██   ██ ██  ██ ██        ██    ██    ██ ██   ██ ██ ██  ██ ██ ██    ██\n"
                " ██████   ██████  ██   ██ ██   ██ ██   ████        ██     ██████  ██   ██ ██ ██   ████  ██████ "
                ,
                .description = 
                "Tu, discepolo affiliato, che vuoi entrare a far parte della più importante famiglia, la famosa \"Guran "
                "Turino\" dovrai meritare questo onore mostrandoci quanto hai studiato la nostra storia e conosci le nostre radici.\n"
                "Se riuscirai ad uscire prima dello scadere del tempo da questa casa risolvendo tutti gli enigmi allora potrai essere realmente messo alla prova "
                "davanti ai 10 membri della famiglia, di seguito i loro nomi in codice: \n"
                "Gotrax, Doc, Makise, Mikashita, Mevok, Axel, Veve, Marmo, Bomba, Doc Ciambella",
                .token = 0   
            }
};

/* notifiche pre-impostate per ridurre il traffico in rete durante l'invio di queste */
char notify[34][MAX_DIM_NOTIFY] = {
    "Autenticazione effettuata con successo!",
    "Password errata, riprova!",
    "Username non presente...",
    "Inserisci sia username che password!",
    "L'username scelto è già stato usato da qualcun altro, scegliene un altro!",
    "Registrazione avvenuta con successo!",
    "Inserisci un idgame valido per iniziare a giocare!",
    "Stai già giocando, prima finisci la tua partita!",
    "Non hai ancora iniziato il gioco, usa il comando start idgame",
    "Usa la seguente sintassi per il comando:\nlook [location | object]",
    "Il parametro passato al comando non fa riferimento a nessuna location o oggetto.",
    "Usa la seguente sintassi per il comando:\n take [object]",
    "Il parametro passato al comando non fa riferimento a nessun oggetto prendibile.",
    "Hai la borsa piena!",
    "Hai gia preso l'oggetto!",
    "Usa la seguente sintassi per il comando:\n use object [object]",
    "Il primo parametro passato al comando non fa riferimento a nessun oggetto utilizzabile.",
    "Il secondo parametro passato al comando non fa riferimento a nessun oggetto utilizzabile.",
    "Per utilizzare l'oggetto devi prima prenderlo.",
    "Questo non puoi farlo!",
    "Usa la seguente sintassi per il comando:\n objs",
    "Hai lo zaino vuoto!",
    "Usa la seguente sintassi per il comando:\n drop [object]",
    "Il parametro passato al comando non fa riferimento a nessun oggetto già preso.",
    "Usa la seguente sintassi per il comando:\n end",
    "Comando non esistente, inseriscine uno valido...",
    "Hai risposta in modo errato, riprova!",
    "Usa la seguente sintassi per il comando:\n list",
    "Ancora nessun giocatore attivo...",
    "Usa la seguente sintassi per il comando: + idutente secondi",
    "Il seguente utente non sta giocando...",
    "Il numero di secondi inserito non è valido, deve essere un numero maggiore di zero",
    "Partita terminata senza vittoria! Puoi sempre riprovare se vuoi...",
    "Ciao giocatore ombra torna quando vuoi..."
};

/**************** DEFINIZIONE STRUTTURE DATI SERVER  *********************/
/* informazioni totali sulle varie room disponibili, come locazioni e oggetti */
desc_room rooms[MAX_STORIES] = {
            {
                .id = 1,
                .description = 
                    "Ti trovi in una stanza multidimensionale, tutto ciò che trovi fa parte dell'intera Lore di Guran Turino, le cose prese singolarmente potrebbero non avere senso, ma non ti preoccupare, devi seguire il tuo spirito da candidato membro"
                    " ripercorrendo alcune storie che fanno parte della nostra storia. Al completamento di queste riuscirai ad ottenere token e se li ottieni tutti entro il tempo limite, allora, significa che sei degno di poter ambire al ruolo di membro della famiglia!\n"
                    "Per ogni enigma sbagliato verrà decrementato il tempo rimanente come penitenza.\nAttorno a te trovi: ",
                .tokens = 2,
                .dim_bag = 2,
                .num_location = 4,
                .num_object = 9,
                .seconds = 600,
                .victory = "\n\nHai vinto, complimenti!",
                .locations = {
                    {   
                        .name = "scrivania",
                        .description_room = "\nLa ++scrivania++ di Makise, uno dei membri di Guran con sopra: ",
                        .description = "Ti trovi davanti alla scrivania di Makise, di media dimensione, sopra di essa "
                    },
                    {
                        .name = "finestra",
                        .description_room = "\nUna ++finestra++ sulla destra con accanto",
                        .description = "Vicino a te si trova una finestra con vetri di color giallo con accanto"
                    },
                    {
                        .name = "scaffale",
                        .description_room = "\nUno ++scaffale++ sopra di te pieno di libri",
                        .description = "Sopra di te si trova uno scaffale polveroso, pieno di libri"
                    },
                    {
                        .name = "studio",
                        .description_room = "\nLo ++studio++ di Gotrax con un pc acceso sopra di esso",
                        .description = "Accento a te ti trovi lo studio di Gotrax, il capo supremo della famiglia con un pc "
                    }
                },
                .objs = {
                    {
                        .name = "post-it",
                        .description = 
                            "Pin del telefono: \n"
                            "(prime due cifre) ultime due cifre dell'anno di nascita della famiglia Guran Turino.\n"
                            "(ultime due cifre) ultime due cifre dell'anno di nascita del grande uomo del rinascimento fiorentino che lavorò anche come ambasciatore e aveva una sua idea su come si dovesse comandare un regno.",
                        .description_location = ", un **post-it** giallo con scritto qualcosa",
                        .location = "scaffale",
                        .visible = true,
                        .takeable = true,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = false,
                        .exists_enigma_u  = false,
                        .enigma_u = "",
                        .risposta_u = '\0',
                        .to_use = "",
                        .to_sblock = "",
                        .to_show = "",
                        .to_hide = "",
                        .response_after_use = "",
                        .token = false
                    },
                    {   
                        .name = "cellulare",
                        .description = "Il telefono di Makise, c'è un messaggio per te da Matilde. Sblocca il telefono per leggerlo, forse il pin sarà scritto da qualche parte...",
                        .description_location = "un **cellulare** con schermo rotto e un messaggio whatsapp a te recapitato",
                        .location = "scrivania",
                        .visible = true,
                        .takeable = true,
                        .exists_enigma_t = true,
                        .enigma_t = 
                            "Pin del telefono: \n"
                            "a) 1669\n"
                            "b) 1764\n"
                            "c) 2089",
                        .risposta_t = 'a',
                        .response_after_take = 
                            "Messaggio da Matilde: \"Oddio, ho un terribile presagio, credo che in qualche maniera il mio ragazzo mi"
                            " stia tradendo, ho paura...\"\n"
                            "Forse puoi fare qualcosa te, intanto rispondile.",
                        .usable = true,
                        .usable_without_take = false,
                        .exists_enigma_u  = true,
                        .enigma_u = 
                            "a) tranquillizza matilde.\n"
                            "b) scrivi al suo ragazzo con un profilo fake.\n"
                            "c) chiedile direttamente di uscire.",
                        .risposta_u = 'b',
                        .to_use = "",
                        .to_sblock = "penna",
                        .to_show = "",
                        .to_hide = "",
                        .response_after_use = 
                            "Matilde si arrabbia con te dopo che hai sganciato la 'bomba' perchè non glielo hai detto subito.\n"
                            "Sei dispiaciuto e vuoi cercare di rimediare in qualche modo facendole capire le tue vere intenzioni.",
                        .token = false
                    },
                    {
                        .name = "penna",
                        .description = "E' una penna a quattro colori (una quadrupla), magari puoi usarla per scrivere da qualche parte.\n",
                        .description_location = ", una **penna** a quattro colori funzionante",
                        .location = "scrivania",
                        .visible = true,
                        .takeable = true,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = false,
                        .exists_enigma_u  = true,
                        .enigma_u = 
                            "a) scrivi una lettera a Matilde dicendole che era tutto uno scherzo.\n"
                            "b) dille che ti sei stancato, tu l\'hai fatto per lei e lei non ha apprezzato la tua buona azione.\n"
                            "c) scrivi che ti dispiace e che le vuoi comunque tanto bene.",
                        .risposta_u = 'c',
                        .to_use = "foglio",
                        .to_sblock = "lettera",
                        .to_show = "lettera",
                        .to_hide = "foglio",
                        .response_after_use = 
                            "Ecco bravo, ora che le hai scritto una bella lettera puoi madargliela.",
                        .token = false
                    },
                    {
                        .name = "foglio",
                        .description = "E' un semplice foglio bianco in formato A4.\n",
                        .description_location = ", un **foglio** bianco",
                        .location = "scrivania",
                        .visible = true,
                        .takeable = true,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = false,
                        .exists_enigma_u  = false,
                        .enigma_u = "",
                        .risposta_u = '\0',
                        .to_use = "",
                        .to_show = "",
                        .to_hide = "",
                        .response_after_use = "",
                        .token = false
                    },
                    {
                        .name = "lettera",
                        .description = 
                            "La lettera per Matilde che hai scritto con tanto amore per cercare di farle capire che non "
                            "l'hai fatto per cattiveria.\n",
                        .description_location = 
                            ", una **lettera** piena d'amore che hai scritto a Matilde per cercare di farti "
                            "perdonare",
                        .location = "scrivania",
                        .visible = false,
                        .takeable = true,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = false,
                        .exists_enigma_u  = false,
                        .enigma_u = "",
                        .risposta_u = '\0',
                        .to_use = "piccione",
                        .to_show = "",
                        .to_hide = "lettera",
                        .response_after_use = 
                            "Hai ottenuto un token ripercorrento le vicende di Makise!\nSei riuscito ad inviarle la lettera, ti spoilero che non andrà a finire bene"
                            " anche se le piacerà la tua lettera e forse la conserverà. Lei si lascerà (grazie a te),"
                            " però si metterà con qualcun altro.",
                        .token = true
                    },
                    {
                        .name = "piccione",
                        .description = 
                            "Un piccione del Biasci grigio, molto bello, lui ne ha tanti, casualmente in questa stanza "
                            " multidimensionale se ne trova uno.\n",
                        .description_location = " un **piccione** grigio del Biasci",
                        .location = "finestra",
                        .visible = true,
                        .takeable = false,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = false,
                        .exists_enigma_u  = false,
                        .enigma_u = "",
                        .risposta_u = '\0',
                        .to_use = "",
                        .to_show = "",
                        .to_hide = "",
                        .response_after_use = "",
                        .token = false
                    },
                    {
                        .name = "quiz-1",
                        .description = 
                            "Il quiz che mostra fa parte del pretest per entrare in Guran, prima parte del grande esame, "
                            "interagiscici per provare a rispondere alla prima domanda...",
                        .description_location = " che mostra kahoot aperto con un **quiz-1**",
                        .location = "studio",
                        .visible = true,
                        .takeable = false,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = true,
                        .usable_without_take = true,
                        .exists_enigma_u  = true,
                        .enigma_u = 
                            "Doc, uno dei membri di Guran ha scritto una canzone nella sua vecchia vita, una parte di quest'ultima "
                            "recita ad un certo punto:  \"anche se fa male\";\n"
                            "Quale tra queste frasi la anticipa o la segue?\n"
                            "a) lasciami andare\n"
                            "b) domani tutto passa\n"
                            "c) etapa my nigga",
                        .risposta_u = 'a',
                        .to_use = "",
                        .to_sblock = "quiz-2",
                        .to_show = "quiz-2",
                        .to_hide = "quiz-1",
                        .response_after_use = 
                            "Esattamente, la canzone fa: \"Lasciami andare... anche se fa male, prova a colpirmi più su, non ti "
                            " preoccuparee\"\n"
                            "La canzone è ascoltabile gratuitamente al seguente link youtube: \n"
                            "https://www.youtube.com/watch?v=jqLLvY_FNsY",
                        .token = false
                    },
                    {
                        .name = "quiz-2",
                        .description = 
                            "Il quiz che mostra fa parte del pretest per entrare in Guran, prima parte del grande esame, "
                            "interagiscici per provare a rispondere alla seconda domanda...",
                        .description_location = " che mostra kahoot aperto con un **quiz-2**",
                        .location = "studio",
                        .visible = false,
                        .takeable = false,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = true,
                        .exists_enigma_u  = true,
                        .enigma_u = 
                            "Come si chiama la divinità terrestre in cui Guran Turino crede?\n"
                            "a) Non crede in nessuna divinità, è una famiglia laica\n"
                            "b) Nel Dio Pirani\n"
                            "c) In Tony",
                        .risposta_u = 'b',
                        .to_use = "",
                        .to_sblock = "quiz-3",
                        .to_show = "quiz-3",
                        .to_hide = "quiz-2",
                        .response_after_use = 
                            "Esattamente, Pirani è un amico della maggior parte dei membri di Guran, spesso ha litigato con loro "
                            "per vari motivi, ma la loro ammirazione verso di lui è sempre rimasta immacolata.",
                        .token = false
                    },
                    {
                        .name = "quiz-3",
                        .description = 
                            "Il quiz che mostra fa parte del pretest per entrare in Guran, prima parte del grande esame, "
                            "interagiscici per provare a rispondere alla terza domanda...",
                        .description_location = " che mostra kahoot aperto con un **quiz-3**",
                        .location = "studio",
                        .visible = false,
                        .takeable = false,
                        .exists_enigma_t = false,
                        .enigma_t = "",
                        .risposta_t = '\0',
                        .response_after_take = "",
                        .usable = false,
                        .usable_without_take = true,
                        .exists_enigma_u  = true,
                        .enigma_u = 
                            "Con quale ragazzo della famiglia, Veve (l'unica ragazza del gruppo) doveva sposarsi a Lucca Comics "
                            "anni e anni fa?\n"
                            "a) Guran non ammette relazione tra membri della stessa famiglia\n"
                            "b) Con Bomba\n"
                            "c) Con Makise",
                        .risposta_u = 'b',
                        .to_use = "",
                        .to_show = "",
                        .to_hide = "quiz-3",
                        .response_after_use = 
                            "Hai ottenuto un token rispondendo correttamente a tutte le domande!\n"
                            "Il matrimonio che avrebbe dovuto tenersi a Lucca Comics non si è svolto alla fine, poichè "
                            "Bomba si tirò indietro, da quel momento in Guran non si ammettono relazioni tra membri poichè "
                            "i membri si reputano tra loro, come fratelli.",
                        .token = true
                    }
                }
            }
};

/*************************** FUNZIONI SERVER *****************************/
/* la funzione principale che viene chiamata nel main del server per effettuare le azioni in funzione del messaggio */
desc_resp execute(int sd, desc_msg msg){
    desc_resp resp;
    /* inizializzazione campi di default */
    resp.notify_code = -1;
    resp.token = 0;
    resp.seconds = -1;
    resp.status = false;
    resp.expeted = COMMAND;
    strcpy(resp.response, "");
    
    /* l'utente ha inviato un comando */
    if(msg.type == COMMAND){ 
        if(!strcmp(msg.command, "login")){
            login(sd, msg, &resp);
        } else if(!strcmp(msg.command, "signup")){
            signup(sd, msg, &resp);
        } else if(!strcmp(msg.command, "start")){
            start(sd, msg, &resp);
        } else if(!strcmp(msg.command, "look")){
            look(sd, msg, &resp);
        } else if(!strcmp(msg.command, "take")){
            take(sd, msg, &resp);
        } else if(!strcmp(msg.command, "use")){
            use(sd, msg, &resp);
        } else if(!strcmp(msg.command, "objs")){
            objs(sd, msg, &resp);
        } else if(!strcmp(msg.command, "end")){
            end(sd, msg, &resp);
        } else if(!strcmp(msg.command, "drop")){
            drop(sd, msg, &resp);
        } else {
            command_not_found(&resp);
        }
    
    /* è stato inviato un messaggio testuale di risposta ad un enigma */
    } else if(msg.type == RESPONSE_TEXT) {
        response_text(sd, msg, &resp); 

    /* l'utente ombra ha inviato un comando */
    } else if(msg.type == SHADOW){  
        if(!strcmp(msg.command, "list")){
            list(msg, &resp);
        } else if(!strcmp(msg.command, "+")){
            more_seconds(msg, &resp);
        } else if(!strcmp(msg.command, "-")){
            less_seconds(msg, &resp);
        } else if(!strcmp(msg.command, "end")){
            end_shadow(msg, &resp);
        } else {
            command_not_found(&resp);
        }
    }
    
    /* solo se non è end calcola i secondi rimanenti */
    if(strcmp(msg.command, "end")){
        resp.seconds = remaining_seconds(sd);
        if(resp.seconds == 0)
            end(sd, msg, &resp);
    } else 
        resp.seconds = 0;
    
    resp.dim_response = strlen(resp.response) + 1;
    return resp;
}

/****** di seguito i vari handler usati dalla funzione "execute" per il client  ******/
void login(int sd, desc_msg msg, desc_resp* resp){
    char _psw[MAX_DIM_BUFF];
    
    /* controllare che gli operandi che sono stati inviati siano esattamente due */ 
    if(msg.num_operand != 2){
        resp->notify_code = 3;
        return;
    }

    /* controllare che esista uno stesso username nel file user.txt e leggere quindi riga per riga */
    if(username_exists(msg.operand_1, _psw)){
        /* se l'username è presente all'interno del file confronto le due password */
        if(!strcmp(msg.operand_2, _psw)){
            /* autenticazione eseguita con successo */
            resp->notify_code = 0;
            resp->status = true;
            return;
        } else {
            /* password sbagliata */
            resp->notify_code = 1;
            return;
        }   
    } else {
        /* username non presente, devi ancora registrarti */
        resp->notify_code = 2;
        return;
    }    
}

void signup(int sd, desc_msg msg, desc_resp* resp){   
    /* controllare che gli operandi che sono stati inviati siano esattamente due */ 
    if(msg.num_operand != 2){
        resp->notify_code = 3;
        return;
    }

    /* controllo che l'username non esista già all'interno della lista degli utenti */  
    if(username_exists(msg.operand_1, msg.operand_2)){
        resp->notify_code = 4;
        return;
    } 

    /* adesso posso inserire la mia coppia user, password dentro la lista e registrarmi */
    save_user_into_file(msg.operand_1, msg.operand_2);
    resp->notify_code = 5;
    resp->status = true;
}

void start(int sd, desc_msg msg, desc_resp* resp){
    int id_game;
    desc_user* user;
    desc_room room;

    /* controllare che utilizzi sintassi corretta usando un solo parametro */
    if(msg.num_operand != 1) {
        resp->notify_code = 6;
        return;
    }
    /* controllo che il numero passato sia contenuto nel range di giochi disponibili */
    id_game = string_to_int(msg.operand_1);
    if(id_game > MAX_STORIES || id_game < 1) {
        resp->notify_code = 6;
        return;
    }

    /* controllare che non ci sia già l'utente */
    user = get_user(sd);
    if(user != NULL){
        resp->notify_code = 7;
        return;
    }
    
    /* allocazione nuovo utente e inserimento in lista utenti attivi */
    room = rooms[id_game - 1];
    insert_active_user(sd, user, room);

    /* adesso devo creare il messaggio di risposta per il client */
    strcpy(resp->response, stories[id_game - 1].description);
    resp->token = room.tokens;
    resp->seconds = room.seconds;
    resp->status = true;
}

void look(int sd, desc_msg msg, desc_resp* resp){
    desc_user* user;
    desc_location* loc;
    desc_obj* obj;

    /* controllare che il giocatore abbia iniziato già a giocare */
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 8;
        return;
    }

    /* controllare che ci siano numero di operandi corretti */
    if(msg.num_operand > 1 || msg.num_operand < 0){
        resp->notify_code = 9;
        return;
    }

    if(msg.num_operand == 1){
        /* controllare che sia stato passato nel caso per parametro una location o un oggetto che l'utente può vedere */
        loc = get_location(user, msg.operand_1);
        if(loc == NULL){
            obj = get_object(user, msg.operand_1);
            if(obj == NULL || obj->visible == false){
                resp->notify_code = 10;
                return;
            }
        }

        /* adesso definiamo due flussi di esecuzione, uno se è stato passato un oggetto e uno per la location */
        if(loc != NULL){    /* location passata */
            strcpy(resp->response, loc->description);       /* descrizione della location */
            append_description_location(resp->response, loc->name, user);
        } else if(obj != NULL){
            strcpy(resp->response, obj->description);
        }   
    } else if(msg.num_operand == 0){
        /* mostrare la descrizione della room intera */
        strcpy(resp->response, rooms[user->room].description);       /* descrizione della stanza */
        append_description_room(resp->response, user);
    }
    resp->status = true;
}

void take(int sd, desc_msg msg, desc_resp* resp){
    desc_user* user;
    desc_obj* obj;
    int obj_max_taken;

    /* controllare che il giocatore abbia iniziato già a giocare */
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 8;
        return;
    }

    /* controllare che utilizzi sintassi corretta usando un solo parametro */
    if(msg.num_operand != 1) {
        resp->notify_code = 11;
        return;
    } 

    /* controlla che l'oggetto sia effettivamente prendibile, visibile ed esistente */
    obj = get_object(user, msg.operand_1);
    if(obj == NULL || obj->visible == false || obj->takeable == false){
        resp->notify_code = 12;
        return;
    }

    /* controlla che non si superi il limite massimo degli oggetto prendibili */
    obj_max_taken = rooms[user->room].dim_bag;
    if(user->num_obj_taken == obj_max_taken){
        resp->notify_code = 13;
        return;
    }

    /* controllo che l'oggetto non sia già stato preso */
    if(get_object_taken(user, msg.operand_1) != NULL){
        resp->notify_code = 14;
        return;
    }

    /* controllare se esiste o meno un enigma associato alla take così da gestire il flusso di esecuzione */
    if(obj->exists_enigma_t){
        /* c'è l'enigma e lo mostriamo all'utente */
        strcpy(resp->response, obj->enigma_t);
        resp->status = true;
        resp->expeted = RESPONSE_TEXT;

        /* per ricordarci rispetto a cosa l'enigma è relativo */
        user->obj_enigma = obj;
        user->type_enigma = TAKE;
    } else {
        /* aggiunta dell'oggetto nella lista degli oggetti presi */
        obj->next = user->objs_taken;
        user->objs_taken = obj;

        user->num_obj_taken++;

        /* non c'è l'enigma, allora consideriamo l'utente sbloccato e quindi subito ottenibile */
        sprintf(resp->response, "Hai preso l'oggetto: %s", msg.operand_1);
        resp->status = true;
    }
}

void use(int sd, desc_msg msg, desc_resp* resp){
    desc_user* user;
    desc_obj* obj;
    desc_obj* obj2;

    /* controllare che il giocatore abbia iniziato già a giocare */
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 8;
        return;
    }

    if(msg.num_operand == 0){
        resp->notify_code = 15;
        return;
    }

    /* controllo che il primo oggetto sia utilizzabile e visibile e non abbia un enigma sul take ancora da risolvere */
    obj = get_object(user, msg.operand_1);
    if(obj == NULL || obj->visible == false || obj->usable == false || obj->exists_enigma_t == true){
        resp->notify_code = 16;
        return;
    }

    /* controllo che il primo oggetto sia visibile */
    if(msg.num_operand == 2){
        obj2 = get_object(user, msg.operand_2);
        if(obj2 == NULL || obj2->visible == false){
            resp->notify_code = 17;
            return;
        }
    }
    
    /* il primo operando devi averlo per forza in mano per usarlo */
    if(obj->usable_without_take == false && get_object_taken(user, msg.operand_1) == NULL){
        resp->notify_code = 18;
        return;
    }

    /* controllo della possibilità di effettuare l'operazione o meno */
    if((msg.num_operand == 2 && strcmp(obj->to_use, msg.operand_2)) || (msg.num_operand == 1 && strcmp(obj->to_use, ""))){
        resp->notify_code = 19;
        return;
    }

    if(obj->exists_enigma_u){
        /* se esiste un'enigma associato a questa azione */
        strcpy(resp->response, obj->enigma_u);
        resp->status = true;
        resp->expeted = RESPONSE_TEXT;

        /* per ricordarci rispetto a cosa l'enigma è relativo */
        user->obj_enigma = obj;
        user->type_enigma = USE;
    } else {
        /* eseguire l'azione e le sue conseguenze */
        obj->usable = false;
        sblock_obj(user, obj->to_sblock);
        show_obj(user, obj->to_show);
        hide_obj(user, obj->to_hide);
        /* rimuovo l'oggetto da nascondere dall'inventario se c'è */
        remove_object_taken(user, obj->to_hide);

        if(obj->token){
            resp->token = 1;
            user->remaining_tokens--;
        }
        
        strcpy(resp->response, obj->response_after_use);
        if(user->remaining_tokens == 0)
            strcat(resp->response, rooms[user->room].victory); 

        resp->status = true;
    }
}

void objs(int sd, desc_msg msg, desc_resp* resp){
    desc_user* user;
    desc_obj* obj;
    desc_room room;
    char str[MAX_DIM_RESP];

    /* controllare che il giocatore abbia iniziato già a giocare */
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 8;
        return;
    }

    /* controllare che non ci siano operandi */
    if(msg.num_operand != 0){
        resp->notify_code = 20;
        return;
    }

    if(user->num_obj_taken == 0){
        resp->notify_code = 21;
        resp->status = true;
    } else {
        obj = user->objs_taken;
        room = rooms[user->room];
        sprintf(resp->response, "Zaino: (%d/%d)\n", user->num_obj_taken, room.dim_bag);
        while(obj != NULL){
            sprintf(str, "- %s\n", obj->name);
            strcat(resp->response, str);
            obj = obj->next;
        }
        resp->status = true;
    }
}

void drop(int sd, desc_msg msg, desc_resp* resp){
    desc_user* user;
    desc_obj* obj;

    /* controllare che il giocatore abbia iniziato già a giocare */
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 8;
        return;
    }

    /* controllare che utilizzi sintassi corretta usando un solo parametro */
    if(msg.num_operand != 1) {
        resp->notify_code = 22;
        return;
    } 

    /* controlla che l'oggetto sia effettivamente già stato preso */
    obj = get_object_taken(user, msg.operand_1);
    if(obj == NULL){
        resp->notify_code = 23;
        return;
    }

    /* rimuoverlo dalla lista e diminuire il numero degli oggetti presi */
    remove_object_taken(user, msg.operand_1);

    sprintf(resp->response, "L'oggetto %s è stato rimosso dalla borsa.", msg.operand_1);
    resp->status = true;
}

void end(int sd, desc_msg msg, desc_resp* resp){
    desc_user* user;

    /* controllare che il giocatore abbia iniziato già a giocare */
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 8;
        return;
    }

    /* controllare che non ci siano parametri */
    if(msg.num_operand != 0){
        resp->notify_code = 24;
        return;
    }

    /* rimuovo dalla lista degli utenti che stanno giocando l'utente */
    remove_active_user(sd);

    resp->notify_code = 32;
    resp->status = true;
}

void command_not_found(desc_resp* resp){
    resp->notify_code = 25;
}

void response_text(int sd, desc_msg msg, desc_resp* resp){
    /* l'utente ha inviato una risposta testuale in seguito ad un enigma a risposta multipla */
    desc_obj* obj;
    desc_user* user;
    char risposta_utente;
    resp->token = 0;
    resp->seconds = 0;
    resp->status = false;
    resp->expeted = RESPONSE_TEXT;

    /* controllo che la lunghezza sia 1 carattere */
    user = get_user(sd);
    obj = user->obj_enigma;
    if(strlen(msg.command) != 1){
        /* voglio rimostrare l'enigma all'utente che ha sbagliato a scrivere sintatticamente la risposta */
        if(user->type_enigma == TAKE) strcpy(resp->response, obj->enigma_t);
        else if(user->type_enigma == USE) strcpy(resp->response, obj->enigma_u);

    } else {
        /* controlliamo la correttenzza della risposta data */
        risposta_utente = msg.command[0];
        switch (user->type_enigma){
            case TAKE:
                if(risposta_utente == obj->risposta_t){
                    /* rimuovere l'enigma sull'oggetto */
                    obj->exists_enigma_t = false;
                    
                    strcpy(resp->response, obj->response_after_take);
                    resp->status = true;
                } else {
                    /* tolgo secondi di tempo per la risposta errata */
                    user->start_time -= 20;
                    resp->notify_code = 26;
                }
                break;
            case USE:
                if(risposta_utente == obj->risposta_u){
                    /* sblocca, mostra, nasconde oggetti se l'azione ha questo come conseguenza */
                    obj->usable = false;
                    sblock_obj(user, obj->to_sblock);
                    show_obj(user, obj->to_show);
                    hide_obj(user, obj->to_hide);
                    /* rimuovo l'oggetto da nascondere dall'inventario se c'è */
                    remove_object_taken(user, obj->to_hide);

                    /* dopo aver effettuato la use è possibile che si possa ottenere un token */
                    if(obj->token){
                        resp->token = 1;
                        user->remaining_tokens--;
                    }
                    
                    strcpy(resp->response, obj->response_after_use);
                    if(user->remaining_tokens == 0)
                        strcat(resp->response, rooms[user->room].victory);    

                    resp->status = true;
                } else {
                    /* tolgo secondi di tempo per la risposta errata */
                    user->start_time -= 20;
                    resp->notify_code = 26;
                }
                break;
        }
        resp->expeted = COMMAND;
    }
}

/****** di seguito i vari handler usati dalla funzione "execute" per l'ombra  *******/
void list(desc_msg msg, desc_resp* resp){
    char temp[MAX_DIM_RESP];
    desc_user* user;

    /* controllare che non ci siano operandi */
    if(msg.num_operand != 0){
        resp->notify_code = 27;
        return;
    }

    /* se non ci sono utenti attivi allora segnalalo */
    if(users == NULL){
        resp->notify_code = 28;
        return;
    }
    
    /* devo ritornare la lista di tutti gli utenti attivi */
    user = users;
    strcpy(resp->response, "Lista degli utenti attivi:\n");
    while(user != NULL){
        sprintf(temp, "%d.\tsta giocando nella room %d\n", user->sd, user->room + 1);
        strcat(resp->response, temp);
        user = user->next;
    }
    resp->status = true;
}

void more_seconds(desc_msg msg, desc_resp* resp){
    int seconds;
    int sd;
    desc_user* user;

    /* controllare che ci siano due operandi */
    if(msg.num_operand != 2){
        resp->notify_code = 29;
        return;
    }

    /* controllare che l'utente sia esistente */
    sd = string_to_int(msg.operand_1);
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 30;
        return;
    }

    /* controllare che il secondo numero sia un numero valido e positivo maggiore di zero */
    seconds = string_to_int(msg.operand_2);
    if(seconds <= 0){
        resp->notify_code = 31;
        return;
    }
    
    /* aumento del tempo */
    user->start_time += seconds;
    resp->status = true;
    sprintf(resp->response, "Hai aggiunto %d secondi al tempo rimanente dell'utente %d", seconds, sd);
}

void less_seconds(desc_msg msg, desc_resp* resp){
    int seconds;
    int sd;
    desc_user* user;

    /* controllo che ci sono due operandi */
    if(msg.num_operand != 2){
        resp->notify_code = 29;
        return;
    }

    /* controllare che l'utente sia esistente */
    sd = string_to_int(msg.operand_1);
    user = get_user(sd);
    if(user == NULL){
        resp->notify_code = 30;
        return;
    }

    /* controllare che il secondo numero sia un numero valido e positivo maggiore di zero */
    seconds = string_to_int(msg.operand_2);
    if(seconds <= 0){
        resp->notify_code = 31;
        return;
    }

    /* riduzione del tempo */
    user->start_time -= seconds;
    resp->status = true;
    sprintf(resp->response, "Hai ridotto di %d secondi il tempo rimanente all'utente %d", seconds, sd);
}

void end_shadow(desc_msg msg, desc_resp* resp){
    /* controllare che non ci siano altri operandi */
    if(msg.num_operand != 0){
        resp->notify_code = 24;
        return;
    }

    resp->notify_code = 33;
    resp->status = true;
}

/****** di seguito varie funzioni ausiliarie usate dal server ******/
/* usate per la look */
void append_description_location(char* str, char* location, desc_user* user){
    int n = user->num_object;
    int i;
    desc_obj* obj = user->objs;
    for(i=0; i<n; i++){
        if(obj[i].visible && !strcmp(obj[i].location, location)){
            strcat(str, obj[i].description_location);
        }
    }
}

void append_description_room(char* str, desc_user* user){
    int n = user->num_location;
    int i;
    desc_location* loc = user->locations;
    for(i=0; i<n; i++){
        strcat(str, loc[i].description_room);
        append_description_location(str, loc[i].name, user);
    }
}

/* usate per la use */
void sblock_obj(desc_user* user, const char* name){
    desc_obj* obj;
    obj = get_object(user, name);
    if(obj != NULL) obj->usable = true;
}

void show_obj(desc_user* user, const char* name){
    desc_obj* obj;
    obj = get_object(user, name);
    if(obj != NULL) obj->visible = true;
}

void hide_obj(desc_user* user, const char* name){
    desc_obj* obj;
    obj = get_object(user, name);
    if(obj != NULL) obj->visible = false;
}

/* usata per la drop */
void remove_object_taken(desc_user* user, const char* name){
    desc_obj* curr_obj;
    desc_obj* prec_obj;

    if(!strcmp(name, ""))
        return;

    if(user == NULL)
        return;

    if(get_object_taken(user, name) == NULL)
        return;
    
    curr_obj = user->objs_taken;
    prec_obj = NULL;
    while (curr_obj != NULL && strcmp(curr_obj->name, name)) {
        prec_obj = curr_obj;
        curr_obj = curr_obj->next;
    }

    if (prec_obj != NULL) {
        prec_obj->next = curr_obj->next;
    } else {
        user->objs_taken = curr_obj->next;
    }
    user->num_obj_taken--;
}

/* usata per la end */
void remove_active_user(int sd){
    desc_user* curr_user;
    desc_user* prec_user; 

    curr_user = users;
    prec_user = NULL;
    while (curr_user != NULL && curr_user->sd != sd) {
        prec_user = curr_user;
        curr_user = curr_user->next;
    }

    if (prec_user != NULL) {
        prec_user->next = curr_user->next;
    } else {
        users = curr_user->next;
    }
    free(curr_user);
}

/* usata per la start */
void insert_active_user(int sd, desc_user* user, desc_room room){
    int i;
    
    user = malloc(sizeof(desc_user));
    user->sd = sd;
    user->room = room.id - 1;
    user->remaining_tokens = room.tokens;
    user->num_location = room.num_location;
    user->num_object = room.num_object;
    user->num_obj_taken = 0;
    time(&user->start_time);
    user->locations = malloc(sizeof(desc_location)*room.num_location);
    user->objs = malloc(sizeof(desc_obj)*room.num_object);
    user->objs_taken = NULL;
    for(i=0; i<room.num_location; i++){
        user->locations[i] = room.locations[i];
    }
    for(i=0; i<room.num_object; i++){
        user->objs[i] = room.objs[i];
    }

    /* inseirmento in testa nella lista degli utenti */
    user->next = users;
    users = user;
}

/* funzioni per la fase di login-signup */
bool username_exists(char* user, char* psw){
    char buff[MAX_DIM_BUFF];
    char _user[MAX_DIM_BUFF];
    FILE *file;

    /* aprire il file per la lista degli utenti */
    file = fopen("user.txt", "r");
    if(file == NULL){
        perror("\nclient --> errore nell'apertura del file\n");
        exit(EXIT_FAILURE);
    }
    
    /* controlla ogni singola riga del file, confrontando la prima parola con l'username */
    while (fgets(buff, sizeof(buff), file) != NULL) {
        /* rimuovo il carattere di nuova linea */
        buff[strlen(buff)-1] = '\0';

        sscanf(buff, "%s %s", _user, psw);
        if(!strcmp(user, _user)){
            fclose(file);
            return true;
        }
    }
    fclose(file);
    return false;
}

void save_user_into_file(char* user, char* psw){   
    FILE* file;

    file = fopen("user.txt", "a");
    if(file == NULL){
        perror("\nclient --> errore nell'apertura del file\n");
        exit(EXIT_FAILURE);
    }
    
    /* scrittura nel file */
    fprintf(file, "%s %s\n", user, psw);
    fclose(file);
}

/* funzioni generali */
int remaining_seconds(int sd){
    time_t current_time;
    desc_user* user;

    user = get_user(sd);
    if(user == NULL) 
        return -1;
    time(&current_time);
    
    int diff = difftime(current_time, user->start_time);
    if (diff >= rooms[user->room].seconds)
        return 0;

    return rooms[user->room].seconds - diff;
}

bool active_users(){
    if(users == NULL)
        return false;
    return true;
}

/* get_* per locations, objects, users */
desc_location* get_location(desc_user* user, const char* name){
    desc_location* loc = user->locations;
    int n = user->num_location;
    int i;
    for(i=0; i<n; i++){
        if(!strcmp(loc[i].name, name)){
            return &loc[i];
        }
    }
    return NULL;
}

desc_obj* get_object(desc_user* user, const char* name){
    desc_obj* obj = user->objs;
    int n = user->num_object;
    int i;
    for(i=0; i<n; i++){
        if(!strcmp(obj[i].name, name)){
            return &obj[i];
        }
    }
    return NULL;
}

desc_user* get_user(int id){
    desc_user* u = users;
    while (u != NULL) {
        if (u->sd == id) {
            return u;
        }
        u = u->next;
    }
    return NULL;
}

desc_obj* get_object_taken(desc_user* user, const char* name){
    desc_obj* temp = user->objs_taken;
    while(temp != NULL){
        if(!strcmp(temp->name, name)){
            return temp;
        }
        temp = temp->next;
    }
    return NULL;
}

/************************* FUNZIONI CLIENT ************************/
/**** funzioni per la parte di login-signup ****/
bool login_client(int sd, desc_resp* resp){
    char user[MAX_DIM_BUFF];
    char psw[MAX_DIM_BUFF];
    desc_msg msg;
    char buff[MAX_DIM_BUFF];
    char bresp[MAX_DIM_BUFF];

    /* ottenimento dei due campi */
    /* ottenimento dei campi */
    insert_username(user);
    insert_password(psw);

    strcpy(msg.command, "login");
    strcpy(msg.operand_1, user);
    strcpy(msg.operand_2, psw);
    msg.num_operand = 2;
    msg.type = COMMAND;
    
    msg_to_string(msg, buff);
    send_to_socket(sd, buff);

    receive_from_socket(sd, bresp);
    string_to_resp(bresp, resp);

    return resp->status;
}

bool signup_client(int sd, desc_resp* resp){
    char user[MAX_DIM_BUFF];
    char psw[MAX_DIM_BUFF];
    desc_msg msg;
    char buff[MAX_DIM_BUFF];
    char bresp[MAX_DIM_BUFF];

    /* ottenimento dei campi */
    insert_username(user);
    insert_password(psw);

    strcpy(msg.command, "signup");
    strcpy(msg.operand_1, user);
    strcpy(msg.operand_2, psw);
    msg.num_operand = 2;
    msg.type = COMMAND;

    msg_to_string(msg, buff);
    send_to_socket(sd, buff);

    receive_from_socket(sd, bresp);
    string_to_resp(bresp, resp);

    return resp->status;
}

void insert_username(char* buff){
    printf("username: ");
    read_from_stdin(buff);
}

void insert_password(char* buff){
    /* voglio che l'utente inserisca la password in segretezza, non mostrando i caratteri che ogni volta digita */
    struct termios old, newt;
    int i = 0;
    char ch;
    
    printf("password: ");
    /* Salva la configurazione corrente del terminale */
    tcgetattr(STDIN_FILENO, &old);
    newt = old;

    /* Disabilita l'echo (visualizzazione) dei caratteri */
    newt.c_lflag &= ~(ECHO | ECHOE | ECHOK | ECHONL | ICANON);

    /* Applica le nuove impostazioni */
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);

    /* Leggi la password carattere per carattere */
    while (i < MAX_DIM_BUFF - 1) {
        ch = getchar();
        if (ch == '\n' || ch == '\r') {
            break;
        } else {
            buff[i++] = ch;
        }
    }

    /* Aggiungi il terminatore di stringa */
    buff[i] = '\0';

    /* Ripristina le impostazioni originali del terminale */
    tcsetattr(STDIN_FILENO, TCSANOW, &old);
    printf("\n");
}

/**** procedura usata dal client per finire il gioco col server ****/
void end_client(int sd, desc_resp* resp){
    desc_msg msg;
    char buff[MAX_DIM_BUFF];

    msg.type = COMMAND;
    msg.num_operand = 0;
    strcpy(msg.command, "end");
    strcpy(msg.operand_1, "");
    strcpy(msg.operand_2, "");

    msg_to_string(msg, buff);
    send_to_socket(sd, buff);
    
    receive_from_socket(sd, buff);
}

/**** procedura usata per ricaricare lo schermo dopo un comando inserito ****/
void reload_screen(desc_story story, desc_resp resp){
    system("clear");
    printf("%s\n\n", story.title);
    printf("%d/%d token\t\t%s\n\n", story.token, story.request_token, remaining_time(resp.seconds));
    if(resp.notify_code == -1)
        printf("\n%s\n", resp.response);
    else
        printf("\n%s\n", notify[resp.notify_code]);
}
