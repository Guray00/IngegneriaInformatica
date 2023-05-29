#include "head.h"
#include "utility.h"
#include "ComInPrep.h"
#include "Ordine.h"
#include "funz_kd.h"

int main(int argc, char* argv[]){
    int ret; //variabile per testare errori
    int sd; //socket
    int i; //indice eventuali for

    char comandointero[COMANDO_SIZE] = ""; //comando da stdin, con tanto di eventuali parametri
    char comando[COMANDO_SIZE] = ""; //conterra' la prima parola del comando, senza parametri
    char buffer[BUFFER_SIZE] = "";

    uint16_t porta = gestisci_porta(argc, argv);

    struct ComInPrep* comande = NULL;

    // Set di descrittori da monitorare
	fd_set master;
	
	// Set di descrittori pronti
	fd_set read_fds;
	
	// Descrittore max
	int fdmax;

    struct sockaddr_in my_addr, srv_addr; 

    /* Devo comunque creare un socket di ascolto per monitorare almeno lo standard input e ricevere i comandi*/
    sd = socket(AF_INET, SOCK_STREAM, 0);

    memset(&my_addr, 0, sizeof(my_addr));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = porta;
    my_addr.sin_addr.s_addr = INADDR_ANY;
    ret = bind(sd, (struct sockaddr*)&my_addr, sizeof(my_addr));
    if (ret < 0){
        perror("Errore in fase di bind kd: \n");
        printf("Termino il kd.\n");
        exit(1);
    } 

    /* Creazione indirizzo del server */
    memset(&srv_addr, 0, sizeof(srv_addr));
    srv_addr.sin_family = AF_INET;
    srv_addr.sin_port = htons(4242);
    inet_pton(AF_INET, "127.0.0.1", &srv_addr.sin_addr);

    ret = connect(sd, (struct sockaddr*)&srv_addr, sizeof(srv_addr));

    if(ret < 0){
        perror("Errore in fase di connessione: \n");
        printf("Termino il kd.\n");
        exit(1);
    }

    /* Prima di iniziare a monitorare lo stdin e mostrare/accettare comandi, devo concludere la connessione con il server.
       Dal momento che quando un server accetta una connessione non puo' sapere a prescindere se chi l'ha richiesta era un 
       td, un kd o un client, ognuno di essi dovrebbe identificarsi in qualche modo cosi' che il server possa sapere con chi
       sta parlando. */

    // Invio il messaggio. Non ho bisogno di specificare o mandare alcun tipo di lunghezza perche' il server sa gia'
    // che gli arrivera' un messaggio lungo 3 caratteri, appena riceve una connessione.
	ret = send(sd, "KD", 3, 0);
    if(ret < 3){
        perror("Errore in fase di invio comando (sigla riconoscimento kd): \n");
        exit(1);
    }

    // Come risposta, il server mandera' OK se ha accettato la connessione
    ret = recv(sd, buffer, 3, 0);
    if(ret < 3){
        perror("Errore in fase di invio ricevimento segnale \"OK\" \n");
        exit(1);
    }

    // Se non abbiamo ricevuto NO abbiamo sicuramente ricevuto OK, salvo errori di altro tipo. Per cui non stiamo a controllare.

    /* Apro la coda */
	listen(sd, QUEUE_SIZE);
	
	// Reset dei descrittori
	FD_ZERO(&master);
	FD_ZERO(&read_fds);
	
    // Aggiungo lo standard input al set master, lo devo monitorare per
    // comandi vari o input.
    FD_SET(0, &master);
	// Aggiungo il socket di ascolto 'listener' ai socket monitorati
	FD_SET(sd, &master);
	// Tengo traccia del nuovo fdmax
	fdmax = sd;

    guida_comandi_kd();

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
                    fgets(comandointero, COMANDO_SIZE, stdin);

                    //Prendo la prima parola del comando per capire cosa sto invocando
                    sscanf(comandointero, "%s", comando);

                    if(strcmp(comando, "take") == 0){
                        gestisci_comando_take(sd, comandointero, &comande);
                    }
                    else if(strcmp(comando, "show") == 0){
                        gestisci_comando_show(comandointero, comande);
                    }
                    else if(strcmp(comando, "set") == 0){
                        gestisci_comando_set(sd, comandointero, &comande);
                    }
                    else{
                        printf("Comando inserito non valido.\n");
                    }
                }
                else if(i == sd){
                    if(!ricevi_messaggio(i, buffer, "Errore ricezione messaggio da server.")) continue;

                    //mi salvo l'input ricevuto dentro una variabile comando
                    sscanf(buffer, "%s", comando);

                    //comando 'find' mandato dal client
                    if(strcmp(comando, "notifica") == 0){
                        gestisci_comando_notifica(buffer);
                    }
                    //comando 'stop' mandato dal server
                    if(strcmp(comando, "stop") == 0){
                        gestisci_comando_stop_kd(sd);
                    }
                }
            }
        }
    }
    return 0;
}