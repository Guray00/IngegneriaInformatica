#include <stdio.h>
#include "costanti.h"

// se l'indice di una stanza e' valido o no
int is_valid(int r){
    if(r > MAX_ROOMS)
        return -1;
    return 0;
}

void newline(){
    printf("\n");
}

// dato il puntatore fp cerca nel file auth.txt le credenziali passate come argomento
int find_credentials(FILE *fp, char* usr, char* psw){
    char s_u[MAX_CR_SIZE];
    char s_p[MAX_CR_SIZE];

    while(fscanf(fp, "%s\n%s", s_u, s_p) != EOF){
        if((strcmp(usr, s_u) == 0) && (strcmp(psw, s_p) == 0)){
            printf("DBG: credenziali trovate!\n");
            return 1;
        }
    }
    return 0;
}

void print_help(){
    printf(
        "\n\033[1;32mGUIDA ALL'UTILIZZO DEI COMANDI\033[0m\n\n"
        "\033[1;35mlook [location | object]\033[0m\tDigitare senza argomenti per una descrizione della stanza, oppure specificare una location o un oggetto per ispezionarli.\n\n"
        "\033[1;35mtake object\033[0m\tDigitare insieme all'oggetto che si vuole prendere\n\n"
        "\033[1;35muse object1 [object2]\033[0m\tDigitare per utilizzare l'oggetto object1, se e' possibile si pissono far interagire due oggetti digitandone i nomi\n\n"
        "\033[1;35mobjs\033[0m\tDigitare per ottenere una lista degli oggetti attualmente posseduti\n\n"
        "\033[1;35mdrop object\033[0m\tPermette di lasciare a terra un oggetto posseduto per fare spazio\n\n"
        "\033[1;35mdiceroll\033[0m\tSfida lo Shadowman per ottenere temp extra (o perderlo)\n\n"
        "\033[1;35mend\033[0m\tSe digitato permette di arrendersi e terminare la partita\n\n"
    );
}

void print_resoconto(int timer, int raccolti, int mancanti){
    newline();
    printf("\033[1;35m\nTempo rimasto: %d:%d\033[0m\n", timer/60, timer%60);
    printf("\033[1;35mToken raccolti: %d\033[0m\n", raccolti);
    printf("\033[1;35mToken mancanti: %d\033[0m\n", mancanti);
}

// pulisce il buffer di ingresso dello standard input per evitare comportamenti anomali
// durante l'input da tastiera
void clean_stdin(){
    while (getchar() != '\n');
}

// Dato l'array degli oggetti e un oggetto restituisce 1 se
// il giocatore possiede l'oggetto, 0 altrimenti
int you_have(char objs[OBJECTS][MAX_DESCR_SIZE], char* arg){
    int i;
    for(i = 0; i < HOLDABLE; i++){
        if(strcasecmp(objs[i], arg) == 0)
            return 1;
    }

    return 0;
}