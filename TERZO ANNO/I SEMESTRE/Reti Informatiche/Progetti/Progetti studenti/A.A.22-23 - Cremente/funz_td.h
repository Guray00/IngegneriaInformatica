//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef FUNZ_TD_H
#define FUNZ_TD_H

void guida_comandi_td();
void gestisci_comando_help();
void gestisci_comando_menu(int, char*);
void gestisci_comando_comanda(int, char*, int);
bool controlla_comanda(char*);
void gestisci_comando_conto(int, char*, int);
void gestisci_comando_take_td(char*);
void gestisci_comando_set_td(char*);
void gestisci_comando_stop_td(int);

#endif