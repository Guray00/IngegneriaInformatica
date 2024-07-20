//header guard, per non includere il .h piu' volte nei file sorgenti
#ifndef FUNZ_KF_H
#define FUNZ_KF_H

void guida_comandi_kd();
void gestisci_comando_notifica(char*);
void gestisci_comando_take(int, char*, struct ComInPrep**);
void gestisci_comando_show(char*, struct ComInPrep*);
void gestisci_comando_set(int, char*, struct ComInPrep**);
void gestisci_comando_stop_kd(int);

#endif