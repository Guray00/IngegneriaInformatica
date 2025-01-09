//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef FUNZ_SERV_H
#define FUNZ_SERV_H

struct Tavolo;
struct Prenotazione;
struct Piatto;
struct Comanda;
struct TableDevice;
struct KitchenDevice;

struct Tavolo* gv_tavoli_disponibili;

void guida_comandi_serv();
void gestisci_comando_stat(char*, struct Comanda*);
void gestisci_comando_stop(char*, struct Comanda**, struct KitchenDevice**, struct TableDevice**, struct Prenotazione**, struct Tavolo*, struct Piatto**, int*, int);
void stat_no_parametri(struct Comanda*);
void stat_num_tavolo(int, struct Comanda*);
void stat_con_lettera(char, struct Comanda*);
void gestisci_comando_find_server(int, char*, struct Tavolo*);
void gestisci_comando_book_server(int, char*, struct Prenotazione*, struct Tavolo*);
void gestisci_comando_prenotazione_server(int, char*, struct Prenotazione**, struct Tavolo*, struct TableDevice**);
void gestisci_comando_menu_server(int, char*, struct Piatto*);
void gestisci_comando_comanda_server(int, char*, struct Piatto*, struct Comanda**, struct KitchenDevice*);
int genera_numero_comanda(int, struct Comanda*);
void notifica_kd(struct Comanda*, struct KitchenDevice*);
void gestisci_comando_conto_server(int, char*, struct Piatto*, struct Comanda*);
void gestisci_comando_take_server(int, char*, struct Comanda*, struct TableDevice*, struct KitchenDevice*);
void gestisci_comando_set_server(int, char*, struct Comanda*, struct TableDevice*);

#endif