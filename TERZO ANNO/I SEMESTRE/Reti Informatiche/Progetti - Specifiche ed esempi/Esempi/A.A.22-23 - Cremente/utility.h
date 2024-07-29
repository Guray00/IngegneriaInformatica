#ifndef UTILITY_H
#define UTILITY_H

//#include <stdint.h>
//#include <stddef.h>

#define QUEUE_SIZE 10
#define BUFFER_SIZE 1024
#define CLIENTE_SIZE 50
#define COMANDO_SIZE 50
#define MAX_NUM_PERSONE 20
#define COD_PRENOTAZIONE_SIZE 6
#define COD_PIATTO_SIZE 5
#define RIGA_TESTO_SIZE 100
#define STATO_COMANDA_SIZE 20

uint16_t gestisci_porta(int argc, char* argv[]);
bool invia_messaggio(int p_socket, char* p_messaggio, char* p_errore);
bool ricevi_messaggio(int p_socket, char* p_messaggio, char* p_errore);
bool data_valida(int, int, int, int);

#endif