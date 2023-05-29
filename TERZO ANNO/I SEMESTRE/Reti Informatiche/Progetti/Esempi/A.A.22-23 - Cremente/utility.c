#include "head.h"
#include "utility.h"

//converte la porta direttamente nel formato corretto
uint16_t gestisci_porta(int argc, char* argv[]){
    return (argc == 2 && argv[1] != NULL) ? htons(atoi(argv[1])) : htons(4242);
}

//invia un messaggio attraverso un socket di comunicazione
bool invia_messaggio(int p_socket, char* p_messaggio, char* p_errore){
    int len = strlen(p_messaggio) + 1;
    uint16_t lmsg = htons(len);
    int ret;

    // Invio al partner la dimensione del messaggio
    ret = send(p_socket, &lmsg, sizeof(uint16_t), 0);
    if(ret < 0){
        perror(strcat(p_errore, " (lunghezza)\n"));
        return false;
    }

    //Invio al partner il messaggio
    ret = send(p_socket, p_messaggio, len, 0);
    if(ret < 0){
        perror(strcat(p_errore, "\n"));
        return false;
    }
    return true;
}

bool ricevi_messaggio(int p_socket, char* p_messaggio, char* p_errore){
    int ret;
    uint16_t lmsg;
    int len;

    ret = recv(p_socket, &lmsg, sizeof(uint16_t), 0);
    if(ret < 0){
        perror(strcat(p_errore, " (lunghezza)\n"));
        return false;
    }
				
    // Conversione in formato 'host'
    len = ntohs(lmsg);

    // Ricezione del messaggio
    ret = recv(p_socket, p_messaggio, len, 0);

    if(ret < 0){
        perror("Errore in fase di ricezione comando da un qualche client: \n");
        return false;
    }
    return true;
}
    
bool data_valida(int giorno, int mese, int anno, int ora) {
    time_t current_time;
    struct tm *current_tm;

    // Verifica della validità della data
    if (giorno < 1 || mese < 1 || mese > 12 || anno < 0 || ora < 0 || ora > 23) {
        return false;
    }

    if (giorno > 31 || (giorno > 30 && (mese == 4 || mese == 6 || mese == 9 || mese == 11)) ||
        (giorno > 29 && mese == 2) || (giorno > 28 && mese == 2 && anno % 4 != 0)) {
        return false;
    }

    // Lettura del tempo corrente
    current_time = time(NULL);
    current_tm = localtime(&current_time);

    // Verifica che la data sia futura e appartenga al secolo corrente
    if (anno > current_tm->tm_year % 100 || (anno == current_tm->tm_year % 100 && mese > current_tm->tm_mon + 1) ||
        (anno == current_tm->tm_year % 100 && mese == current_tm->tm_mon + 1 && giorno > current_tm->tm_mday) ||
        (anno == current_tm->tm_year % 100 && mese == current_tm->tm_mon + 1 && giorno == current_tm->tm_mday && ora > current_tm->tm_hour)) {
        return true;
    } else {
        return false;
    }
}
 
