#include "head.h"
#include "utility.h"
#include "Prenotazione.h"
#include "Tavolo.h"
#include "Piatto.h"
#include "Ordine.h"
#include "Comanda.h"
#include "TableDevice.h"
#include "KitchenDevice.h"
#include "funz_serv.h"

int main(int argc, char* argv[]){
    /* Come prima cosa, creo le variabili di cui ho bisogno
    (Alcune potenzialmente vengono aggiunte man mano) */
    int ret; //variabile controllo errori
    int newfd; //socket per nuove connessioni
    int listener; //socket in ascolto
    int addrlen; //dimensione dell'indirizzo del client
    int i; //indice for per ciclare i socket
    uint16_t porta = gestisci_porta(argc, argv);
    char buffer[BUFFER_SIZE]; //buffer per scambio di messaggi
    int len; //lunghezza messaggio
    u_int16_t lmsg; //gestione endianness

    char comandointero[COMANDO_SIZE] = ""; //comando intero ricevuto da stdin
    char comando[COMANDO_SIZE] = ""; //prima parola di comandointero
    
    int tavoli = MAX_TAVOLI; //variabile che indica il numero di tavoli nel ristorante

    int tdonline = 0; //numero che indica quanti td sono connessi con il server in questo momento
	
	// Set di descrittori da monitorare
	fd_set master;
	
	// Set di descrittori pronti
	fd_set read_fds;
	
	// Descrittore max
	int fdmax;
	
	struct sockaddr_in my_addr, cl_addr;

    struct Prenotazione* elencoPrenotazioni = NULL;
    struct Tavolo elencoTavoli[MAX_TAVOLI];
    struct Piatto* elencoPiatti = NULL;
    struct Comanda* elencoComande = NULL;
    struct TableDevice* elencoTD = NULL;
    struct KitchenDevice* elencoKD = NULL;

    /* Ora, prima di eseguire altro, recupero i dati gia' scritti a mano che ho inserito nei file */
    recupera_tavoli(elencoTavoli);
    elencoPrenotazioni = recupera_prenotazioni(elencoTavoli);
    elencoPiatti = recupera_piatti();

    /* Creazione socket di ascolto */
	listener = socket(AF_INET, SOCK_STREAM, 0);
	
	/* Creazione indirizzo di bind */
	memset(&my_addr, 0, sizeof(my_addr));
	my_addr.sin_family = AF_INET;
	my_addr.sin_port = porta;
	my_addr.sin_addr.s_addr = INADDR_ANY;

    //uso questo codice per poter connettere il server sempre alla stessa porta senza avere errori di binding
    int yes=1;
    //char yes='1'; // use this under Solaris

    if (setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) == -1) {
        perror("setsockopt");
        exit(1);
    }
	
	/* Aggancio */
	ret = bind(listener, (struct sockaddr*)&my_addr, sizeof(my_addr));
	if(ret < 0){
		perror("Bind non riuscita\n");
		exit(0);
	}

    /* Apro la coda */
	listen(listener, 10);
	
	// Reset dei descrittori
	FD_ZERO(&master);
	FD_ZERO(&read_fds);
	
    // Aggiungo lo standard input al set master, lo devo monitorare per
    // comandi vari o input.
    FD_SET(0, &master);
	// Aggiungo il socket di ascolto 'listener' ai socket monitorati
	FD_SET(listener, &master);
	// Tengo traccia del nuovo fdmax
	fdmax = listener;

    //prima di iniziare a ciclare, mostro il menu dei comandi
    guida_comandi_serv();

    //for sempre
    for(;;){
        //azzero il comando, altrimenti mi rimane nel buffer cio' che c'era scritto prima
        memset(comando, 0, sizeof(comando));

        // Imposto il set di socket da monitorare in lettura per la select()
		// NOTA: select() modifica il set 'read_fds' lasciando solo i descrittori pronti
		// ma non modifica il set 'master' dei descrittori monitorati!
		read_fds = master;

        // Mi blocco (potenzialmente) in attesa dei descrittori pronti
		// Attesa ***senza timeout*** (ultimo parametro attuale 'NULL')
		select(fdmax+1, &read_fds, NULL, NULL, NULL);

        // Scorro ogni descrittore 'i'
		for(i = 0; i<=fdmax; i++) {

            // Se il descrittore 'i' e' rimasto nel set 'read_fds', cioe' se la select()
			// ce lo ha lasciato, allora 'i' e' pronto	
			if(FD_ISSET(i, &read_fds)){
                
                // Se il descrittore pronto 'i' e' 0, allora e' stdin
                if(i == 0){
                    fgets(comandointero, 50, stdin);
                    
                     //Prendo la prima parola del comando per capire cosa sto invocando
                    sscanf(comandointero, "%s", comando);

                    if(strcmp(comando, "stat") == 0){
                        gestisci_comando_stat(comandointero, elencoComande);
                    }
                    else if(strcmp(comando, "stop") == 0){
                        gestisci_comando_stop(comandointero, &elencoComande, &elencoKD, &elencoTD, &elencoPrenotazioni, elencoTavoli, &elencoPiatti, &tdonline, listener);
                    }
                    else{
                        printf("Comando inserito non valido.\n");
                    }
                }

                // Se il descrittore pronto 'i' e' il listening socket 'listener'
				// ho ricevuto una richiesta di connessione
				else if(i == listener) {

                    // Calcolo la lunghezza dell'indirizzo del client
				    addrlen = sizeof(cl_addr);
					
				    // Accetto la connessione e creo il socket connesso ('newfd')
				    newfd = accept(listener, (struct sockaddr*)&cl_addr, (socklen_t*)&addrlen);
                    if (newfd < 0){
                        perror("Errore in fase di accept(): \n");
                        continue;
                    }  

                    //accettata una connessione, so gia' che ricevero' un identificatore di 3 caratteri a seconda che 
                    //chi si e' connesso sia un td, un kd, o un client (cl)
					ret = recv(newfd, buffer, 3, 0);
                    if (ret < 3){
                        printf("Qualcosa e' andato storto nello stabilire la nuova connessione. \n");
                        close(newfd);
                        continue;
                    }

                    if(strcmp(buffer, "CL") == 0){
                        ret = send(newfd, "OK", 3, 0);
                        if (ret < 3){
                            printf("Errore nell'avvisare il td la connessione e' stata accettata \n");
                            close(newfd);
                            continue;
                        }
                        printf("Si e' connesso un nuovo client. \n");
                    }
                    else if(strcmp(buffer, "TD") == 0){
                        if(tdonline == tavoli){
                            //ho gia' tutti i tavoli occupati, devo interrompere la connessione
                            ret = send(newfd, "NO", 3, 0);
                            if (ret < 3){
                                printf("Errore nell'avvisare il td che i tavoli sono tutti occupati \n");
                                close(newfd);
                                continue;
                            }
                            close(newfd);
                            continue;
                        }
                        else{
                            ret = send(newfd, "OK", 3, 0);
                            if (ret < 3){
                                printf("Errore nell'avvisare il td la connessione e' stata accettata \n");
                                close(newfd);
                                continue;
                            }
                            tdonline++;
                            printf("Si e' connesso un nuovo td. \n");
                        } 
                    }
                    else if(strcmp(buffer, "KD") == 0){
                        ret = send(newfd, "OK", 3, 0);
                        if (ret < 3){
                            printf("Errore nell'avvisare il kd la connessione e' stata accettata \n");
                            close(newfd);
                            continue;
                        }
                        struct KitchenDevice* tmp = new_kd(newfd);
                        ins_kd(&elencoKD, tmp);
                        printf("Si e' connesso un nuovo kd. \n");
                    }

				    // Aggiungo il socket connesso al set dei descrittori monitorati
				    FD_SET(newfd, &master);

                    // Aggiorno l'ID del massimo descrittore
				    if(newfd > fdmax){
					    fdmax = newfd;
				    }


                } else {

                    // Altrimenti, ho ricevuto una richiesta di servizio. Procedo a ricevere il messaggio e capire 
                    // che tipo di richiesta ho ricevuto
                    // Ricezione della dimensione del messaggio
				    ret = recv(i, &lmsg, sizeof(uint16_t), 0);

                    //Il server qui si aspetta di ricevere la lunghezza di un comando, ma nel caso cosi' non fosse perche'
                    //Dall'altro lato il socket si e' chiuso, devo catturare la cosa e agire di conseguenza
                    if(ret == 0){
                        printf("Socket chiuso, procedo a rimuovere il socket %i.\n", i);
                        close(i);
                        FD_CLR(i, &master);
                        printf("Chiusura socket avvenuta, continuo... \n");
                        continue;
                    }
				
				    // Conversione in formato 'host'
				    len = ntohs(lmsg);
				
				    // Ricezione del messaggio
				    ret = recv(i, buffer, len, 0);
				
				    if(ret < 0){
					    perror("Errore in fase di ricezione comando da un qualche client: \n");
					    continue;
				    }

                    //mi salvo l'input ricevuto dentro una variabile comando
                    sscanf(buffer, "%s", comando);

                    //comando 'find' mandato dal client
                    if(strcmp(comando, "find") == 0){
                        gestisci_comando_find_server(i, buffer, elencoTavoli);
                    }
                    //comando 'book' mandato dal client
                    else if(strcmp(comando, "book") == 0){
                        gestisci_comando_book_server(i, buffer, elencoPrenotazioni, elencoTavoli);
                    }
                    //comando 'prenotazione' mandato dal table device
                    else if(strcmp(comando, "prenotazione") == 0){
                        gestisci_comando_prenotazione_server(i, buffer, &elencoPrenotazioni, elencoTavoli, &elencoTD);
                    }
                    //comando 'menu' mandato dal table device
                    else if(strcmp(comando, "menu") == 0){
                        gestisci_comando_menu_server(i, buffer, elencoPiatti);
                    }
                    //comando 'comanda' mandato dal table device
                    else if(strcmp(comando, "comanda") == 0){
                        gestisci_comando_comanda_server(i, buffer, elencoPiatti, &elencoComande, elencoKD);
                    }
                    else if(strcmp(comando, "conto") == 0){
                        gestisci_comando_conto_server(i, buffer, elencoPiatti, elencoComande);
                    }
                    //comando 'take' mandato dal kitchen device
                    else if(strcmp(comando, "take") == 0){
                        gestisci_comando_take_server(i, buffer, elencoComande, elencoTD, elencoKD);
                    }
                    //comando 'set' mandato dal kitchen device
                    else if(strcmp(comando, "set") == 0){
                        gestisci_comando_set_server(i, buffer, elencoComande, elencoTD);
                    }
                }
            }
        }
    }
    printf("CHIUDO IL LISTENER!\n");
	fflush(stdout);
	close(listener);
}