#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <signal.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "strutture.h"
#include "funzioni.h"

int timer = TIMER_INIT;

void timer_init(int sig){
    if(sig == SIGALRM){
        timer--;

        if(timer > 0)
            alarm(1);
    }
}

int main(int argc, char** argv) {
    int srv_sd,
        shadow_sd,
        ret,
        i,
        raccolti = 0,
        mancanti = TOKENS,
        held = 0,
        solved[OBJECTS] = {0, 0, 0, 0, 1, 0, 1};
    uint16_t len;
    struct sockaddr_in srv_addr;
    struct sockaddr_in shadow_addr;
    char buffer[MAX_BUFFER_SIZE];
    char cmd[10];
    char arg1[MAX_DESCR_SIZE] = "";
    char arg2[MAX_DESCR_SIZE] = "";
    char objs[HOLDABLE][MAX_DESCR_SIZE] = {"--", "--", "--"};
    char dots[3][5] = {".", ". .", ". . ."};

// ===============================================================================
// ||                          CONNESSIONE AL SERVER                            ||
// ===============================================================================

    srv_sd = socket(AF_INET, SOCK_STREAM, 0);

    memset(&srv_addr, 0, sizeof(srv_addr));
    srv_addr.sin_family = AF_INET;
    srv_addr.sin_port = htons(DEFAULT_SVR_PORT);
    inet_pton(AF_INET, LOCALHOST, &srv_addr.sin_addr);

    i = 0;
    while(1){
        printf("Tento di connettermi al server%s\n", dots[i]);
        ret = connect(srv_sd, (struct sockaddr *)&srv_addr, sizeof(srv_addr));
        if(ret >= 0)
            break;
        i = (i+1)%3;
        sleep(1);
        system("clear");
    }
// ===============================================================================
// ||                              LOGIN/SIGNUP                                 ||
// ===============================================================================

    char usr[MAX_CR_SIZE];
    char psw[MAX_CR_SIZE];
    char re_psw[MAX_CR_SIZE];
    uint8_t log_sign, auth_res;

    system("clear");
    printf("Client running\n");
    printf("\033[1;31m    _/      _/    _/_/_/_/    _/        _/_/_/_/     _/_/_/_/     _/    _/     _/_/_/_/\n");
    printf("   _/ _/   _/    _/          _/        _/           _/    _/     _/_/ _/_/    _/       \n");
    printf("  _/_/ _/ _/    _/_/_/      _/        _/           _/    _/     _/  _/ _/    _/_/_/    \n");
    printf(" _/      _/    _/          _/        _/           _/    _/     _/     _/    _/         \n");
    printf("_/      _/    _/_/_/_/    _/_/_/_/  _/_/_/_/     _/_/_/_/     _/     _/    _/_/_/_/    \033[0m\n");

    print_help();

    printf(
        "Si puo' giocare nelle seguenti room:\n"
        "1: Una domenica pomeriggio a Pisa"
    );

    printf("\n\n1) Login\n2) Signup\n");
    l_s:
    printf("> ");
    while(scanf("%hhu", &log_sign) != 1){
        printf("Input errato, riprova!\n> ");
        clean_stdin();
    }
    if(log_sign < 1 || log_sign > 2){
        printf("Questa voce di menu non esiste, riprova!\n");
        goto l_s;
    }

    ret = send(srv_sd, (void*)&log_sign, DIM_UINT8, 0);
    if(ret < DIM_UINT8){
        perror("Problemi con l'invio del comando di login/signup\n");
        exit(1);
    }

    if(log_sign == 2){
        sign:
        printf("\nUser: ");
        scanf("%s", usr);
        // Non ci sono vincoli sul
        // formato che deve avere la password
        printf("Password: ");
        scanf("%s", psw);
        printf("Re-password: ");
        scanf("%s", re_psw);
        clean_stdin();

        if(strcmp(psw, re_psw) != 0){
            printf("Le password non coincidono!\nRiprova\n");
            goto sign;
        }

        sprintf(buffer, "%s %s", usr, psw);
        len = strlen(buffer);
        ret = send(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con l'invio della lunghezza delle credenziali");
            exit(1);
        }        

        ret = send(srv_sd, (void*)buffer, len, 0);
        if(ret < len){
            perror("Problemi con l'invio delle credenziali");
            exit(1);
        }

        ret = recv(srv_sd, (void*)&auth_res, DIM_UINT8, 0);
        if(ret < DIM_UINT8){
            perror("Problemi con la ricezione del risultato dell'operazione");
            exit(1);
        }

        if(auth_res != 0){
            printf("Problemi con il salvataggio dell'account!\nRiprovare piu' tardi\n");
            goto sign;
        }
    } else if(log_sign == 1){
        auth:
        auth_res = 0;
        printf("\nUser: ");
        scanf("%s", usr);
        printf("Password: ");
        scanf("%s", psw);
        clean_stdin();

        sprintf(buffer, "%s %s", usr, psw);
        len = strlen(buffer);

        ret = send(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con l'invio della lunghezza delle credenziali");
            exit(1);
        }

        ret = send(srv_sd, (void*)buffer, strlen(buffer), 0);
        if(ret < strlen(buffer)){
            perror("Problemi con l'invio delle credenziali");
            exit(1);
        }

        ret = recv(srv_sd, (void*)&auth_res, DIM_UINT8, 0);
        if(ret < DIM_UINT8){
            perror("Problemi con la ricezione del risultato dell'operazione");
            exit(1);
        }

        if(auth_res != 0){
            printf("Credenziali errate!\nRiprovare\n");
            goto auth;
        }
    }

    // scelta stanza
    printf("Scegliere la stanza");
    room:
    printf("\n> ");
    scanf("%[^\n]s", buffer);
    clean_stdin();

    uint8_t room;
    sscanf(buffer, "%s %hhu", cmd, &room);
    if(strcasecmp(cmd, "start") != 0){
        printf("Formato del comando errato!\n");
        printf("start <room>\nDove room e' la stanza scelta\n");
        goto room;
    }
    if((is_valid(room) != 0)){
        printf("Numero di stanza non valido!\n");
        printf("scegliere tra 1 e %d\n", MAX_ROOMS);
        goto room;
    }

    // invio al server la stanza desiderata
    ret = send(srv_sd, (void*)&room, DIM_UINT8, 0);
    if(ret < DIM_UINT8){
        perror("Problei con l'invio del numero della stanza");
        exit(1);
    }

// ===============================================================================
// ||                      RICEZIONE INFORMAZIONI STANZA                        ||
// ===============================================================================
    
    struct stanza st;
    // ricevo la lunghezza dell'introduzione
    ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
    if(ret < DIM_UINT16){
        perror("Problemi con la ricezione della lunghezza dell'introduzione");
        exit(1);
    }

    // ricevo l'introduzione
    ret = recv(srv_sd, (void*)buffer, len, 0);
    if(ret < len){
        perror("Problemi con la ricezione dell'introduzione");
        exit(1);
    }
    // allocazione introduzione
    sscanf(buffer, "%[^\n]s", st.intro);

    // ricevo la lunghezza della descrizione
    ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
    if(ret < DIM_UINT16){
        perror("Problemi con la ricezione della lunghezza della descrizione");
        exit(1);
    }
    
    // ricevo la descrizione
    ret = recv(srv_sd, (void*)buffer, len, 0);
    if(ret < len){
        perror("Problemi con la ricezione della descrizione");
        exit(1);
    }
    // allocazione descrizione
    sscanf(buffer, "%[^\n]s", st.descr);

    i = 0;
    for(; i < LOCATIONS; i ++){
        memset(buffer, '\0', MAX_BUFFER_SIZE);
        // ricevo la lunghezza di una location
        ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con la ricezione della lunghezza di una location");
            exit(1);
        }
        
        // ricevo la location
        ret = recv(srv_sd, (void*)buffer, len, 0);
        if(ret < len){
            perror("Problemi con la ricezione di una location");
            exit(1);
        }
        // allocazione location
        sscanf(buffer, "%[^\n]s", st.locations[i]);
    }

    i = 0;
    for(; i < LOCATIONS; i ++){
        memset(buffer, '\0', MAX_BUFFER_SIZE);
        // ricevo la lunghezza di un nome di location
        ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con la ricezione della lunghezza di un nome di location");
            exit(1);
        }
        
        // ricevo il nome
        ret = recv(srv_sd, (void*)buffer, len, 0);
        if(ret < len){
            perror("Problemi con la ricezione di un nome di location");
            exit(1);
        }
        // allocazione nome location
        sscanf(buffer, "%s", st.location_names[i]);
    }

    i = 0;
    for(; i < OBJECTS; i ++){
        memset(buffer, '\0', MAX_BUFFER_SIZE);
        // ricevo la lunghezza di una descrizione oggetto
        ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con la ricezione della lunghezza di una descrizione oggetto");
            exit(1);
        }
        
        // ricevo la descrizione
        ret = recv(srv_sd, (void*)buffer, len, 0);
        if(ret < len){
            perror("Problemi con la ricezione di una descrizione oggetto");
            exit(1);
        }
        // allocazione descrizione
        sscanf(buffer, "%[^\n]s", st.objs[i]);
    }

    i = 0;
    for(; i < OBJECTS; i ++){
        memset(buffer, '\0', MAX_BUFFER_SIZE);
        // ricevo la lunghezza del nome di un oggetto
        ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con la ricezione della lunghezza del nome di un oggetto");
            exit(1);
        }
        
        // ricevo il nome
        ret = recv(srv_sd, (void*)buffer, len, 0);
        if(ret < len){
            perror("Problemi con la ricezione del nome di un oggetto");
            exit(1);
        }
        // allocazione oggetto
        sscanf(buffer, "%s", st.obj_names[i]);
    }

    i = 0;
    for(; i < OBJECTS; i ++){
        memset(buffer, '\0', MAX_BUFFER_SIZE);
        // ricevo la lunghezza della domanda
        ret = recv(srv_sd, (void*)&len, DIM_UINT16, 0);
        if(ret < DIM_UINT16){
            perror("Problemi con la ricezione della lunghezza della domanda");
            exit(1);
        }
        
        // ricevo la domanda
        ret = recv(srv_sd, (void*)buffer, len, 0);
        if(ret < len){
            perror("Problemi con la ricezione della domanda");
            exit(1);
        }
        // allocazione domanda
        sscanf(buffer, "%[^\n]s", st.questions[i]);
    }

    i = 0;
    for(; i < SOLUTIONS; i ++){
        // ricevo la soluzione
        ret = recv(srv_sd, (void*)&st.solutions[i], DIM_UINT8, 0);
        if(ret < DIM_UINT8){
            perror("Problemi con la ricezione di una soluzione");
            exit(1);
        }
    }

// ===============================================================================
// ||                 FINE RICEZIONE INFORMAZIONI STANZA                        ||
// ===============================================================================

    // visualizzazione dell'introduzione
    newline();
    printf("%s\n", st.intro);

    // inizializzazione del timer
    signal(SIGALRM, timer_init);
    alarm(1);

// ===============================================================================
// ||                          LOOP DELLA PARTITA                               ||
// ===============================================================================
    
    uint8_t snd_cmd = 0;
    while (timer > 0) {
        memset(buffer, '\0', MAX_BUFFER_SIZE);
        memset(arg1, '\0', MAX_DESCR_SIZE);
        memset(arg2, '\0', MAX_DESCR_SIZE);
        // input da tastiera
        // prende caratteri finchè non trova un ritorno carrello
        printf("> ");
        scanf("%[^\n]s", buffer);

        // pulisco il buffer di input da tastiera
        // altrimenti vado in loop
        clean_stdin();

        // inizializzo il comando e gli argomenti
        sscanf(buffer, "%s %s %s", cmd, arg1, arg2);

// ===============================================================================
// ||                                 END                                       ||
// ==============================================================================
        if ((strcasecmp(cmd, "end") == 0)){
            newline();
            printf("Ti sei arreso.\n");
            snd_cmd = END;
            ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
            if(ret < DIM_UINT8){
                perror("Errore nell'invio del comando end");
                exit(1);
            }
            goto end;
        }

// ===============================================================================
// ||                          LOOK [LOCATION|OBJ]                              ||
// ==============================================================================
        if(strcasecmp(cmd, "look") == 0){
            newline();
            snd_cmd = LOK;
            ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
            if(ret < DIM_UINT8){
                perror("Problemi con l'invio del comando look");
                exit(1);
            }
            if(strlen(arg1) != 0){
                for(i = 0; i < LOCATIONS; i++){
                    if(strcasecmp(arg1, st.location_names[i]) == 0){
                        printf("%s\n", st.locations[i]);
                        break;
                    }
                }
                for(i = 0; i < OBJECTS; i++){
                    if(strcasecmp(arg1, st.obj_names[i]) == 0){
                        printf("%s\n", st.objs[i]);
                        break;
                    }
                }
            } else {
                printf("%s", st.descr);
            }
            print_resoconto(timer, raccolti, mancanti);
        } 
// ===============================================================================
// ||                                TAKE OBJ                                   ||
// ==============================================================================
        else if(strcasecmp(cmd, "take") == 0){
            newline();
            snd_cmd = TAK;
            ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
            if(ret < DIM_UINT8){
                perror("Problemi con l'invio del comando take");
                exit(1);
            }
            if(strlen(arg1) != 0){
                if(held >= HOLDABLE){
                    printf("Hai gia' raggiunto il massimo numero di oggetti trasportabili!\n");
                    newline();
                    goto held_ext;
                }
                
                for(i = 0; i < held; i++){
                    if(strcasecmp(arg1, objs[i]) == 0){
                        printf("Hai gia' questo oggetto!\n");
                        newline();
                        goto held_ext;
                    }
                }

                if(strcasecmp(arg1, "Cavi") == 0){
                    if(solved[4] == 1){
                        printf("I cavi sono ancora attaccati al muro, servirebbe qualcosa per tagliarne un pezzetto...\n");
                    } else {
                        int j;
                        for(j = 0; j < OBJECTS; j++){
                            if(strcmp(objs[j], "--") == 0){
                                strcpy(objs[j], "Cavi");
                                held++;
                                printf("Hai raccolto \'%s\'", "Cavi");
                                goto held_ext;
                            }
                        }
                    }
                    goto held_ext;
                }

                if(strcasecmp(arg1, "Lucchetto") == 0){
                    printf("Il lucchetto non puo' essere preso con se\n");
                    goto held_ext;
                }

                for(i = 0; i < OBJECTS; i++){
                    if(strcasecmp(arg1, st.obj_names[i]) == 0){
                        if(solved[i] == 1){
                            int j;
                            for(j = 0; j < HOLDABLE; j++){
                                if(strcmp(objs[j], "--") == 0){
                                    strcpy(objs[j], st.obj_names[i]);
                                    held++;
                                    printf("Hai raccolto \'%s\'", arg1);
                                    goto held_ext;
                                }
                            }
                        } else {
                            newline();
                            printf("%s\n> ", st.questions[i]);
                            scanf("%d", &ret);
                            
                            clean_stdin();
                            if(ret == st.solutions[i]){
                                printf("\033[1;32mEsatto!\nHai raccolto l'oggetto \'%s\'\033[0m\n", arg1);
                                solved[i] = 1;
                                mancanti--;
                                raccolti++;                                
                                int j;
                                for(j = 0; j < HOLDABLE; j++){
                                    if(strcmp(objs[j], "--") == 0){
                                        strcpy(objs[j], st.obj_names[i]);
                                        held++;
                                        goto held_ext;
                                    }
                                }
                            } else {
                                printf("\033[1;31mNon e' questa la risposta giusta...\033[0m\n");
                                goto held_ext;
                            }
                        }
                    }
                }
                printf("\'%s\' non e' un oggetto!", arg1);
            } else {
                goto help;
            }
            held_ext:
            print_resoconto(timer, raccolti, mancanti);
        }
// ===============================================================================
// ||                                DROP OBJ                                   ||
// ==============================================================================
        else if(strcasecmp(cmd, "drop") == 0){
            newline();
            snd_cmd = DRP;
            ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
            if(ret < DIM_UINT8){
                perror("Problemi con l'invio del comando drop");
                exit(1);
            }
            if(strlen(arg1) != 0){
                for(i = 0; i < HOLDABLE; i++){
                    if(strcasecmp(arg1, objs[i]) == 0){
                        strcpy(objs[i], "--");
                        held--;
                        printf("Hai depositato \'%s\'", arg1);
                        goto trovato;
                    }
                }
                printf("Non posiedi questo oggetto (%s)\n", arg1);
            } else {
                goto help;
            }
            trovato:
            print_resoconto(timer, raccolti, mancanti);
        }
// ===============================================================================
// ||                               USE OBJ [OBJ2]                             ||
// ==============================================================================
        else if(strcasecmp(cmd, "use") == 0){
            newline();
            snd_cmd = USE;
            ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
            if(ret < DIM_UINT8){
                perror("Problemi con l'invio del comando use");
                exit(1);
            }
            
            if(strlen(arg1) != 0){
                if(( strcasecmp(arg1, st.obj_names[4]) == 0) &&
                    (strcasecmp(arg2, st.obj_names[6]) == 0) &&
                    (you_have(objs, arg2))){
                    
                    if(solved[4] == 1){
                        printf("Hai usato le forbici per tagliare un pezzo dei cavi!\n");
                        solved[4]++;
                        goto fin_use;
                    } else {
                        printf("%s\n", st.questions[4]);
                        goto fin_use;
                    }
                }

                if((strcasecmp(arg1, "Cavi") == 0) && (you_have(objs, arg1))){
                    printf("%s", st.questions[4]);
                    goto fin_use;
                }

                // il lucchetto puo' essere usato sempre non essendo prendibile.
                // essendo la combinazione a 4 cifre attaccarlo a forza bruta non conviene.
                if(strcasecmp(arg1, st.obj_names[3]) == 0){
                    printf("Stai provando a aprire il lucchetto con una combinazione. . .\n");

                    newline();

                    // condizione di vittoria
                    if(raccolti == 4){
                        // stop timer
                        alarm(0);
                        sleep(3);
                        printf("\033[1;32mIl lucchetto si sblocca e con una certa fretta esci dall'abitazione...\033[0m\n");
                        printf("Hai vinto in \033[1;32m%d minuti\033[0m e \033[1;32m%d secondi\033[0m.\n", (TIMER_INIT-timer)/60, (TIMER_INIT-timer)%60);
                        
                        snd_cmd = WIN;
                        ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
                        if(ret < DIM_UINT8){
                            perror("Problemi con l'invio del comando use");
                            exit(1);
                        }

                        goto end;
                    } else
                        sleep(3);
                        printf("\033[1;31mIl luchetto ancora non si apre...\033[0m\n");

                } else {
                    printf("L'oggetto non puo' essere utilizzato.\n");
                }
            } else {
                goto help;
            }

            fin_use:
            print_resoconto(timer, raccolti, mancanti);
        }
// ===============================================================================
// ||                                  OBJS                                     ||
// ==============================================================================
        else if(strcasecmp(cmd, "objs") == 0){
            newline();
            if(held > 0){
                printf("Oggetti attualmente posseduti:\n");
                for(i = 0; i < HOLDABLE; i++){
                    printf("\033[1;33m%s\033[0m\n", objs[i]);
                }
            } else {
                printf("\033[1;33mNon possiedi alcun oggetto!\033[0m\n");
            }

            print_resoconto(timer, raccolti, mancanti);
        }
// ===============================================================================
// ||                                DICEROLL                                   ||
// ==============================================================================
        else if(strcasecmp(cmd, "diceroll") == 0){
            // interagisce con lo shadowman, il quale
            // lancia un dado e il giocatore scommette sulla cifra che uscirà.
            // Se indovina riceverà tempo extra, viceversa lo perderà
            shadow_sd = socket(AF_INET, SOCK_STREAM, 0);

            memset(&shadow_addr, 0, sizeof(shadow_addr));
            shadow_addr.sin_family = AF_INET;
            shadow_addr.sin_port = htons(DEFAULT_SM_PORT);
            inet_pton(AF_INET, LOCALHOST, &shadow_addr.sin_addr);
            ret = connect(shadow_sd, (struct sockaddr *)&shadow_addr, sizeof(shadow_addr));
            if (ret < 0){
                perror("Connect allo shadowman fallita");
                exit(1);
            }

            newline();
            printf(
                "\033[1;35mLo shadowman tirerà un dado a sei facce, se indovini ti verranno regalati 2 minuti\n"
                "Altrimenti, ne perderai 1\033[0m\n"
            );

            uint8_t n;
            do{
                printf("> ");
                if(scanf("%hhu", &n) != 1){
                    printf("Input errato, inserire un numero tra 1 e 6!\n");
                    clean_stdin();
                    continue;
                }
            }while(n > 6 || n < 1);
            
            uint8_t d;
            ret = recv(shadow_sd, (void*)&d, DIM_UINT8, 0);
            if(ret < DIM_UINT8){
                perror("Ricezione dallo shadowman fallita!");
                exit(1);
            }

            printf("Dado: %d\n", d);

            if(d == n){
                printf("\033[1;32mOttimo!\nLo shadowman ti ha concesso 2 minuti extra.\033[0m\n");
                timer += TTG;
            } else{
                printf("\033[1;31mPeccato...\nPurtroppo, lo shadowman ti ha rubato 1 minuto!\033[0m\n");
                timer -= TTS;
                if(timer < 0) timer = 0;
            }

            printf("\033[1;35mTempo rimasto: %d:%d\033[0m\n", timer/60, timer%60);
            getchar();
            close(shadow_sd);
        }
        else{
            help:
            printf("Formato del comando errato!\n");
            print_help();
        }
    }
    printf("Tempo scaduto!\n");
    snd_cmd = TMO;
    ret = send(srv_sd, (void*)&snd_cmd, DIM_UINT8, 0);
    if(ret < DIM_UINT8){
        perror("Problemi con l'invio del segnale di timeout");
        exit(1);
    }

    end:
    close(srv_sd);
    close(shadow_sd);
    return 0;
}