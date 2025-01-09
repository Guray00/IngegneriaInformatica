#ifndef COMANDI_CLIENT_H
#define COMANDI_CLIENT_H
#include "tuttigli.h"

// identificazione
int manda_informazioni(int sd, char *email, char *passw);
void gestione_partita1(int sd);
void gestione_partita2(int sd);
int ping_server(int sd);

#endif