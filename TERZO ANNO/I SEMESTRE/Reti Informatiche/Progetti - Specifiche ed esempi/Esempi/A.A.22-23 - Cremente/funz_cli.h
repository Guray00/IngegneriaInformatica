//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef FUNZ_CLI_H
#define FUNZ_CLI_H

int gv_num_tavoli_disponibili; //serve a contare quanti tavoli disponibili sono restituiti dal server
struct TavoloTrovato* gv_id_tavoli_disp_dopo_find;

void guida_comandi_cli();
bool gestisci_comando_find(int, char*);
bool gestisci_comando_book(int, char*, char*);

#endif