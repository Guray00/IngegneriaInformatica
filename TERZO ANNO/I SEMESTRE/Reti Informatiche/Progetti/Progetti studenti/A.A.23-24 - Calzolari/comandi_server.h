#ifndef COMANDI_SERVER_H
#define COMANDI_SERVER_H
#include "account.h"
#include "sessione.h"
#include "tuttigli.h"


int comando_login(int sd, struct Account **lista);
void comando_rooms(uint8_t room, int id, struct Sessione **lista);
bool check_vittoria(int sd, struct Sessione* sessione);

// comandi di gioco del client
void comando_look(int sd, struct Sessione* sessione, int type);
void comando_objs(int sd, struct Sessione* sessione, int type);
void comando_take(int sd, struct Sessione* sessione, int type);
void comando_use(int sd, struct Sessione* sessione, int type);

#endif