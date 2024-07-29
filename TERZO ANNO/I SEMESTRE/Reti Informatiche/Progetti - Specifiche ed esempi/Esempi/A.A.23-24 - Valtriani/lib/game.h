#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <stdbool.h>
#include "utility.h"
#include "tcp.h"

#ifndef GAME_H
#define GAME_H

#define MAX_STORIES 1
#define MAX_LOCATIONS 10
#define MAX_OBJECTS 50

#define DIM_ASCII_ART 4096
#define DIM_DESCRIPTION 2048
#define MAX_DIM_NAME 32
#define MAX_DIM_NOTIFY 256

enum TypeEnigma {
    TAKE,
    USE
};

/* strutture dati per il client */
typedef struct desc_story {
    int id;
    char title[DIM_ASCII_ART];
    char description[DIM_DESCRIPTION];
    
    int token;
    int request_token;
} desc_story;

desc_story stories[MAX_STORIES];

/* strutture dati per il server */
typedef struct desc_location {
    char name[MAX_DIM_NAME];                       /* nome della locazione */
    char description[DIM_DESCRIPTION];             /* descrizione della locazione quando si effettua una look su di essa */
    char description_room[DIM_DESCRIPTION];        /* descrizione della locazione quando si effettua una look sulla stanza */
} desc_location;

typedef struct desc_obj {
    char name[MAX_DIM_NAME];                        /* nome dell'oggetto */
    char description[DIM_DESCRIPTION];              /* descrizione relativa a quel preciso oggetto */    
    char description_location[DIM_DESCRIPTION];     /* descrizione relativa alla descrizione della location */
    char location[MAX_DIM_NAME];                    /* nome della location di cui fa parte */
    bool visible;                                   /* indica se l'oggetto può essere visto dall'utente */
    
    bool takeable;                                  /* è possibile prenderlo */
    bool exists_enigma_t;                           /* esiste l'enigma quando viene preso */
    char enigma_t[DIM_DESCRIPTION];                 /* domanda risposta multipla enigma */
    char risposta_t;                                /* risposta esatta (a, b, c, d...) */
    char response_after_take[DIM_DESCRIPTION];      /* descrizione da mandare al client dopo che l'enigma take è stato effettuato */

    bool usable;                                    /* è possibile usarlo */
    bool usable_without_take;                       /* è possibile usarlo senza prenderlo prima */
    bool exists_enigma_u;                           /* esiste l'enigma quando viene usato */
    char enigma_u[DIM_DESCRIPTION];                 /* domanda risposta multipla enigma */
    char risposta_u;                                /* risposta esatta (a, b, c, d...) */
    char to_use[MAX_DIM_NAME];                      /* nome dell'oggetto su cui è possibile usarlo, se null allora non si può usare su nulla */
    char to_sblock[MAX_DIM_NAME];                   /* nome dell'oggetto di cui sbloccare l'azione */
    char to_show[MAX_DIM_NAME];                     /* nome dell'oggetto che "crea" se l'azione di use è stata eseguita correttamente */
    char to_hide[MAX_DIM_NAME];                     /* nome dell'oggetto che "distrugge" se l'azione di use è stata eseguita correttamente */
    char response_after_use[DIM_DESCRIPTION];       /* descrizione da mandare al client dopo che l'azione è stata effettuata con successo */
    bool token;                                     /* utilizzo dell'oggetto ti restituisce un token */
    struct desc_obj* next;                          /* puntatore al prossimo desc_obj */
} desc_obj;

typedef struct desc_room {
    int id;                                         /* nome della stanza */
    char description[DIM_DESCRIPTION];              /* descrizione della stanza quando viene usata una look */
    char victory[MAX_DIM_NAME];                     /* testo da far visualizzare in caso di vittoria del gioco */
    int tokens;                                     /* il numero di token totali da ottenere per vincere */
    int dim_bag;                                    /* numero massimo di oggetti che l'utente può prendere contemporaneamente */
    int seconds;                                    /* durata del gioco */
    
    int num_location;                               /* numero di locazioni che ha il gioco */
    desc_location locations[MAX_LOCATIONS];         /* desc_location appartenenti al gioco */
    int num_object;                                 /* numero di oggetti che ha il gioco */
    desc_obj objs[MAX_OBJECTS];                     /* desc_obj appartenenti al gioco */
} desc_room;

desc_room rooms[MAX_STORIES];

typedef struct desc_user {
    int sd;                                         /* id del socket di comunicazione col client relativo all'utente */
    int room;                                       /* id della stanza che sta giocando */
    int remaining_tokens;                           /* numero di token rimanenti */
    time_t start_time;                              /* tempo relativo all'inizio del gioco */
    
    int num_location;                               /* numero di location del gioco */
    int num_object;                                 /* numero di oggetti del gioco */
    struct desc_location* locations;                /* array dinamico di location */
    struct desc_obj* objs;                          /* array dinamico di oggetti */
    
    int num_obj_taken;                              /* numero di oggetti presi */
    struct desc_obj* objs_taken;                    /* lista di oggetti presi */
    
    desc_obj* obj_enigma;                           /* oggetto a cui è riferito l'enigma che sta risolvendo l'utente */
    enum TypeEnigma type_enigma;                    /* l'enigma che sta risolvendo è relativo ad una TAKE o USE */

    struct desc_user* next;                         /* puntatore al prossimo desc_user */
} desc_user;

desc_user* users;

/******************** PROCEDURE PER SOLO SERVER ***************************/
/* procedure per il gioco */
desc_resp execute(int, desc_msg);
void start(int, desc_msg, desc_resp*);
void look(int, desc_msg, desc_resp*);
void login(int, desc_msg, desc_resp*);
void signup(int, desc_msg, desc_resp*);
void take(int, desc_msg, desc_resp*);
void use(int, desc_msg, desc_resp*);
void objs(int, desc_msg, desc_resp*);
void drop(int, desc_msg, desc_resp*);
void end(int, desc_msg, desc_resp*);
void command_not_found(desc_resp*);
void response_text(int, desc_msg, desc_resp*);
void list(desc_msg, desc_resp*);
void more_seconds(desc_msg, desc_resp*);
void less_seconds(desc_msg, desc_resp*);
void end_shadow(desc_msg, desc_resp*);

/* varie funzioni ausiliari */
void append_description_location(char*, char*, desc_user*);
void append_description_room(char*, desc_user*);
bool username_exists(char*, char*);
void save_user_into_file(char*, char*);

void sblock_obj(desc_user*, const char*);
void show_obj(desc_user*, const char*);
void hide_obj(desc_user*, const char*);

void remove_object_taken(desc_user*, const char*);

int remaining_seconds(int);
bool active_users();
void remove_active_user(int);
void insert_active_user(int, desc_user*, desc_room);

desc_location* get_location(desc_user*, const char*);
desc_obj* get_object(desc_user*, const char*);
desc_user* get_user(int);
desc_obj* get_object_taken(desc_user*, const char*);

/********************* PROCEDURE PER SOLO CLIENT **************************/
/* procedure per la fase di login/signup */
bool login_client(int, desc_resp*);
bool signup_client(int, desc_resp*);
void insert_username();
void insert_password();

/* procedura per la fase di fine del gioco */
void end_client(int, desc_resp*);

/* procedura per la visualizzazione della schermata di gioco con info utili */
void reload_screen(desc_story, desc_resp);

#endif