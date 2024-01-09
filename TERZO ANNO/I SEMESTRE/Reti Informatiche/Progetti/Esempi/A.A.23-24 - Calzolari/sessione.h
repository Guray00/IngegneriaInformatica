#ifndef SESSIONE_H
#define SESSIONE_H

#include "tuttigli.h"

struct Sessione{
    int id_account;
    int token;
    int flags[20];
    struct Sessione *next;
};

// serve per gestire la sessione co-op, definito in sessione.c
extern int client_online;

struct Sessione* new_sessione(int id, int room);
struct Sessione* check_sessione(struct Sessione* lista, uint8_t id);
void ins_sessione(struct Sessione** lista, struct Sessione* sessione);
void del_sessione(struct Sessione** lista, struct Sessione* sessione, int type);

#endif