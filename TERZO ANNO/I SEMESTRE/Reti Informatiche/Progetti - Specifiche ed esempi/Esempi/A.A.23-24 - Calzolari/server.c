
#include "tuttigli.h"
#include "comandi_server.h"
#include "utility.h"
#include "sessione.h"
#include "account.h"

/*
struct sockaddr_in {
    sa_family_t     sin_family; // Address family, si mette AF_INET
    in_port_t       sin_port;   // network order
    struct in_addr  sin_addr;   // indirizzo
}

struct in_addr {
    uint32_t s_addr;
};
*/


int main(){
    int sd_game, new_sd; // Socket file descriptors
    int ret, len, fd_max = 0, i, j, client_connessi = 0;
    int id[2]; //array contenente gli id dell'account dei client
    char buf[256], comando[6]; //array usati per lo scambio di messaggi
    bool acceso = 0;
    fd_set read_fs;
    fd_set master;
    uint16_t porta;
    uint8_t room;
    char dati[2];
    struct sockaddr_in my_addr, client_addr;

    // inizializzazione strutture dati
    struct Account* lista_account = NULL;
    struct Sessione* lista_sessioni[2];
    for (i = 0; i < 2; i++) {
        lista_sessioni[i] = NULL;
    }

    // Strutture dati contenenti informazioni sulla partita in corso
    uint8_t dove_giocano;
    struct Sessione *sess_cur = NULL;
    
    // Inizializza il set di file descriptor
    FD_ZERO(&master);
    FD_ZERO(&read_fs);

    // Aggiungi l'input standard (stdin) al set
    FD_SET(STDIN_FILENO, &master);

    printf("Fine inizializzazione\n");
    // mostro la console dei comandi
    mostra_comandi_console();

    while(1){

        // Azzero la variabile dei comandi e buf
        memset(comando, 0, sizeof(comando));
        memset(buf, 0, sizeof(buf));

        //salvo la lista di descrittori master in un'altra lista per poi usare la select();
        read_fs = master;

        //ciclo per tutto il nuovo set contente solo i fd pronti
        select(fd_max+1, &read_fs, NULL, NULL, NULL);

        for(i = 0; i <= fd_max; i++){

            if(FD_ISSET(i, &read_fs)){ // Se è pronto in lettura stdin, il socket listener o uno di scambio dati

                if(i == STDIN_FILENO){

                    // Comando inserito nella console del server
                    // Gestione input
                    fgets(buf, sizeof(buf), stdin);

                    // So di aspettarmi un comando di max 5 caratteri e un intero su 16 bit
                    ret = sscanf(buf, "%5s %hu", comando, &porta);
                    porta = htons(porta);

                    if (ret == 2 && !strcmp(comando, "start")) {
                        // start <port>, inserisco nell'fd_set il descrittore per un nuovo server
                        
                        printf("Avvio del server di gioco...\n");

                        // Se server già acceso non fa nulla
                        if(acceso){
                            printf("Server già acceso sulla porta %d\n", ntohs(porta));
                            continue;
                        }
                        sd_game = creazione_sock_server(&my_addr, porta);

                        // Metto il socket del server nel set
                        FD_SET(sd_game, &master);
                        if(sd_game > fd_max){
                            fd_max = sd_game; // fd_max contiene ora il valore massimo dei descrittori di socket master
                        }

                        // Resto in ascolto per giocatori che si vogliono connettere alla mia partita
                        ret = listen(sd_game, 2);
                        if(ret == -1){
                            perror("Errore nella listen del server");
                            exit(1);
                        }
                        printf("Socket in ascolto, è possibile collegarsi alla porta %d per giocare.\n", ntohs(porta));
                        
                        acceso = true; // setto il server come acceso per evitare di riaccenderlo.
                            
                    } else if (ret == 1 && !strcmp(comando, "stop")){
                        // stop
                        
                        if(!client_connessi){
                            close(sd_game);
                            printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                            continue;
                        }

                        // controlla se ci sono client connessi
                        for(j = 1; j <= fd_max; j++){
                            if(FD_ISSET(j, &master)){
                                FD_CLR(j, &master);
                                close(j);
                                offline_account_by_id(&lista_account, id[i]);
                                client_connessi--;
                                printf("Chiuso il socket %d\n", j);

                                // Qua ho il comando end oppure è chiuso il client e ret == 0.
                                // Lo tolgo correttamente dal set e chiudo il socket.
                                printf("Socket del client chiuso, procedo a chiudere il socket %d.\n", i);
                                
                                
                                printf("Socket %d chiuso, continuo...\n", i);
                                continue;
                            }
                        }
                        
                        printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                        
                        if(!client_connessi){
                            close(sd_game);
                        }


                    } else {
                        // Il comando inserito nella console non è supportato.
                        printf("Comando inesistente.\n");
                        mostra_comandi_console();
                    }
                    printf("\n");

                } else if(i == sd_game){
                    // Richiesta di connessione.
                    len = sizeof(client_addr);

                    // Le richieste arrivano quando un nuovo giocatore vuole connettersi.
                    new_sd = accept(sd_game, (struct sockaddr*)&client_addr, (socklen_t*)&len);
                    if(new_sd == -1){
                        perror("Errore nell'accept");
                        close(new_sd);
                        continue;
                    }
                    printf("Connessione accettata sulla porta %d\n", ntohs(porta));

                    /* tengo traccia dei client connessi, mi serve per il comando stop. */
                    client_connessi++;

                    // Inserisco il nuovo socket nel set.
                    FD_SET(new_sd, &master);
                    if(new_sd > fd_max){
                        fd_max = new_sd; // fd_max contiene ora il valore massimo dei descrittori di socket master.
                    }
                }
                else{

                    // Un giocatore ha immesso un comando, lo identifico dato che è sempre su 5 caratteri.
                    ret = recv(i, comando, sizeof(comando), 0);
                    if(!ret){

                        // Qua ho il comando end oppure è chiuso il client e ret == 0.
                        // Lo tolgo correttamente dal set e chiudo il socket.
                        printf("Socket del client chiuso, procedo a chiudere il socket %d.\n", i);
                        close(i);
                        FD_CLR(i, &master);
                        offline_account_by_id(&lista_account, id[i]);
                        client_connessi--;
                        printf("Socket %d chiuso, continuo...\n", i);
                        continue;
                        
                    }
                    if(ret == -1){
                        // Nel caso in cui fallisca la recv.
                        perror("Errore in fase di ricezione da un client");
                        continue;
                    }

                    // Comando login del client.
                    if(!strcmp(comando, "login")){

                        // Salvo l'ID dell'account in un array di ID.
                        id[i] = comando_login(i, &lista_account);

                        // Se è già online chiudo la connessione.
                        // Lo tolgo correttamente dal set e chiudo il socket.
                        if(id[i] == -1 || id[i] == -2){
                            printf("Client già online o password errata, procedo a chiudere il socket %d.\n", i);
                            strcpy(dati, "2");
                            send(i, dati, sizeof(dati), 0);
                            close(i);
                            FD_CLR(i, &master);
                            client_connessi--;
                            client_online--;
                            printf("Socket %d chiuso, continuo...\n", i);
                            continue;
                        }

                        // Mando un messaggio al client per avvisarlo se è la sessione è sua o si sta unendo a un'altra
                        // Se mando 0 deve sceglierla, altrimenti è quella già esistente
                        if(!client_online){
                            room = client_online;
                        }
                        else{
                            room = dove_giocano;
                            client_online++;
                        }
                        
                        ret = send(i, (void *)&room, sizeof(room), 0);
                        if(ret == -1){
                            perror("Errore nella send della room al secondo client");
                            exit(1);
                        }
                        
                    }
                    // Comando per decidere lo scenario
                    if(!strcmp(comando, "rooms")){
                        ret = recv(i, (void *)&room, sizeof(uint8_t), 0);
                        if(ret == -1){
                            perror("Errore nella ricezione della stanza nella comando_rooms");
                            exit(1);
                        }

                        // lo salvo in dove_giocano
                        dove_giocano = room;

                        // A seconda dello scenario scelto leggo metto nella lista corretta
                        comando_rooms(room, id[i], &lista_sessioni[dove_giocano-1]);
                        sess_cur = check_sessione(lista_sessioni[dove_giocano-1], id[i]);

                    }
                    if(!strcmp(comando, "look")){

                        // 
                        comando_look(i, sess_cur, dove_giocano);

                        // Devo controllare se ha vinto e nel caso toglierlo dalle sessioni
                        ret = check_vittoria(i, sess_cur);
                        if(ret == 1){
                            // Sono gli ultimi due aggiunti, quindi sono ultimo e penultimo
                            if(i == fd_max)
                                close(i-1);
                            else
                                close(i+1);
                            close(i);
                            del_sessione(&lista_sessioni[dove_giocano-1], sess_cur, dove_giocano); // Partita finita
                            close(sd_game);
                            printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                        }
                    }
                    if(!strcmp(comando, "take")){

                        // 
                        comando_take(i, sess_cur, dove_giocano);

                        // Devo controllare se ha vinto e nel caso toglierlo dalle sessioni
                        ret = check_vittoria(i, sess_cur);
                        if(ret == 1){
                            // Sono gli ultimi due aggiunti, quindi sono ultimo e penultimo
                            if(i == fd_max)
                                close(i-1);
                            else
                                close(i+1);
                            close(i);
                            del_sessione(&lista_sessioni[dove_giocano-1], sess_cur, dove_giocano); // Partita finita
                            close(sd_game);
                            printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                        }
                    }
                    if(!strcmp(comando, "use")){
                        
                        //
                        comando_use(i, sess_cur, dove_giocano);

                        // Devo controllare se ha vinto e nel caso toglierlo dalle sessioni
                        ret = check_vittoria(i, sess_cur);
                        if(ret == 1){
                            // Sono gli ultimi due aggiunti, quindi sono ultimo e penultimo
                            if(i == fd_max)
                                close(i-1);
                            else
                                close(i+1);
                            close(i);
                            del_sessione(&lista_sessioni[dove_giocano-1], sess_cur, dove_giocano); // Partita finita
                            close(sd_game);
                            printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                        }
                    }
                    if(!strcmp(comando, "objs")){

                        comando_objs(i, sess_cur, dove_giocano);

                        // Devo controllare se ha vinto e nel caso toglierlo dalle sessioni
                        ret = check_vittoria(i, sess_cur);
                        if(ret == 1){
                            // Sono gli ultimi due aggiunti, quindi sono ultimo e penultimo
                            if(i == fd_max)
                                close(i-1);
                            else
                                close(i+1);
                            close(i);
                            del_sessione(&lista_sessioni[dove_giocano-1], sess_cur, dove_giocano); // Partita finita
                            close(sd_game);
                            printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                        }
                    }
                    if(!strcmp(comando, "msg")){
                        //Uno dei due client vuole comunicare con l'altro

                        ret = recv(i, buf, sizeof(buf), 0);
                        if(ret == -1){
                            perror("Errore nella recv del messaggio");
                            exit(1);
                        }
                        
                        printf("\nInbox: %s\n\n", buf);

                        // Se non hoi entrambi i giocatori online non mando niente
                        if(client_online == 2){
                            ret = send((i == fd_max ? i-1 : i+1), buf, sizeof(buf), 0);
                            if(ret == -1){
                                perror("Errore nella send del messaggio");
                                exit(1);
                            }
                        }

                        // Devo controllare se ha vinto e nel caso toglierlo dalle sessioni
                        ret = check_vittoria(i, sess_cur);
                        if(ret == 1){
                            // Sono gli ultimi due aggiunti, quindi sono ultimo e penultimo
                            if(i == fd_max)
                                close(i-1);
                            else
                                close(i+1);
                            close(i);
                            del_sessione(&lista_sessioni[dove_giocano-1], sess_cur, dove_giocano); // Partita finita
                            close(sd_game);
                            printf("Arresto del server, spero di averti intrattenuto con l' Escape Room!\n");
                        }
                    }
                }
            }
        }
    }
}
