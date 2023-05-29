#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#define COMMAND_LENGTH 100
#define USERNAME_LENGTH 50
#define PASSWORD_LENGTH 50
#define BUFFER_LENGTH 500

int listener, porta, fdmax; 
fd_set master, read_fds;

struct informazioni_utente {
	char user_dest[USERNAME_LENGTH];
	int port;
	int sckt; 
	
	time_t timestamp_login;
	time_t timestamp_logout;
	
	struct informazioni_utente* next;
	
    struct messagebox_mittente* mittenti;
    struct messagebox_mittente* fine_mittenti;
};

struct messagebox_mittente {
    struct informazioni_utente* mittente;
    time_t latest_timestamp;
    int counter; 
    
    struct messaggio_mittente* messages;
    struct messaggio_mittente* final_messages;
    
    struct messagebox_mittente* next;
};

struct messaggio_mittente {
    char message[BUFFER_LENGTH];
    
    struct messaggio_mittente* next;
};

struct informazioni_utente* registro_utenti;
struct informazioni_utente* fine_registro_utenti;

void inizializzazione_registro_utenti(); 
struct informazioni_utente* controllo_presenza_username(const char* username);
struct informazioni_utente* controllo_presenza_sckt(const int sckt);
void inserimento_utenti_registro(const char* username);
void inserimento_messaggio(struct informazioni_utente* utente_dest, struct informazioni_utente* utente_mitt, const char* message);
void gestione_messaggi_peer_offline(const int sckt, const char* receiver);

void funzione_stdin();
void funzione_socket_ascolto();
void funzione_socket_comunicazione(int sckt);

void output_server_comandi();
void comando_server_help();
void comando_server_list();
void comando_server_esc();
void comando_client_signup(const int sckt, const char* parameters_buffer);
void comando_client_in(const int sckt, const char* parameters_buffer);
void comando_client_chat(const int sckt, const char* parameters_buffer);
void comando_client_out(const int sckt);
void comando_client_hanging(const int sckt);
void comando_client_show(const int sckt, const char* mittente);

void ping();
void gestione_errori(int error);
void debug_struct();

int main(int argc, char** argv) { 		
	int i, ret;
 	
 	struct sockaddr_in my_addr;
 	
 	// Porta parametro opzionale: 
	porta = (argc > 1) ? strtol(argv[1], NULL, 10) : 4242;
	
	// Puntatori al registro utenti
	registro_utenti = NULL;
 	fine_registro_utenti = NULL;
 	
 	// Creazione del socket che il server utilizzera' per ricevere richieste dai client
	listener = socket(AF_INET, SOCK_STREAM, 0);
	if(listener < 0)
		gestione_errori(0); 
	
	// Creazione della struttura dati con indirizzo e porta, associazione della stessa al socket
 	memset(&my_addr, 0, sizeof(my_addr));
 	my_addr.sin_family = AF_INET;
 	my_addr.sin_port = htons(porta); // Porta definita precedentemente
 	my_addr.sin_addr.s_addr = INADDR_ANY;
 	ret = bind(listener, (struct sockaddr*)&my_addr, sizeof(my_addr) );
 	if(ret < 0)
 		gestione_errori(1);

	// Dichiarazione del socket come socket di ascolto
 	listen(listener, 10);
 	
 	// Inizializzazione dei set di file descriptor e della variabile fdmax per la funzione select
 	FD_ZERO(&master);
 	FD_ZERO(&read_fds);
 	FD_SET(0, &master); // standard input ha FD 0
 	FD_SET(listener, &master);
 	fdmax = listener;
 	
 	// Inizializzazione del registro utenti
 	inizializzazione_registro_utenti();
 	
 	// Interfaccia utente e gestione delle richieste dai client con primitiva select e set di FD 	
 	system("clear");
 	output_server_comandi();

 	while(1) {
		read_fds = master;
		ret = select(fdmax+1, &read_fds, NULL, NULL, NULL);
		if(ret < 0)
			gestione_errori(2);
			
 		for(i = 0; i <= fdmax; i++) {
 			if(FD_ISSET(i, &read_fds)) {
 				if(i == 0) // standard input ha FD 0
 					funzione_stdin();
 				else if(i == listener) // Socket di ascolto
 					funzione_socket_ascolto();
 				else // Socket di comunicazione
 					funzione_socket_comunicazione(i);
			}
		}
	}	
	
	return 0;
}

void inizializzazione_registro_utenti() {
	// Si legge il file users.txt e si ricrea la lista di utenti in registro_utenti
	// In questo modo file e lista risulteranno sempre allineati
	
	// Necessaria la presenza del file user.txt vuoto prima del primo lancio del server, altrimenti va in segmentation fault.
	
	FILE* f; 
    char* res;
    char buffer[BUFFER_LENGTH];
	char username[USERNAME_LENGTH];
	char password[PASSWORD_LENGTH];
	
	f = fopen("users.txt", "r");
    if(f > 0) {
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
			sscanf(buffer, "%s %s", username, password);
        	inserimento_utenti_registro(username);
        }
    }
    fclose(f);
}

struct informazioni_utente* controllo_presenza_username(const char* username) {
    // Si verifica che e' presente una struttura informazioni_utente avente l'username indicato
    struct informazioni_utente* pointer = registro_utenti;
      
    while(pointer != NULL) {
        if(strcmp(username, pointer->user_dest) == 0)
            break;
         
        pointer = pointer->next;      
    }   
    
    if(pointer == NULL)
        printf("Puntatore nullo username, puppa\n");
        
    return pointer;              
}


struct informazioni_utente* controllo_presenza_sckt(const int sckt) {
    // Si verifica che e' presente una struttura informazioni_utente avente il socket indicato
    struct informazioni_utente* pointer = registro_utenti;
      
    while(pointer != NULL) {
        if(pointer->sckt == sckt)
            break;
         
        pointer = pointer->next;      
    }   
    
    if(pointer == NULL)
        printf("Puntatore nullo sckt, puppa\n");
        
    return pointer;     
}

void inserimento_utenti_registro(const char* username) {
	if(registro_utenti == NULL) {	
    	registro_utenti = (void*)malloc(sizeof(struct informazioni_utente));
    	fine_registro_utenti = registro_utenti;
    		
    	strcpy((registro_utenti)->user_dest, username);
    	(registro_utenti)->port = -1;
    	(registro_utenti)->sckt = -1;
    	(registro_utenti)->timestamp_login = (time_t)NULL;
    	(registro_utenti)->timestamp_logout = (time_t)NULL;
    	(registro_utenti)->next = NULL;  
    	
    	(registro_utenti)->mittenti = NULL;
    	(registro_utenti)->fine_mittenti = NULL;
	}
	else {
    	(fine_registro_utenti)->next = (void*)malloc(sizeof(struct informazioni_utente));
    	fine_registro_utenti = (fine_registro_utenti)->next;
    		
    	strcpy((fine_registro_utenti)->user_dest, username);
    	(fine_registro_utenti)->port = -1;
    	(fine_registro_utenti)->sckt = -1;
    	(fine_registro_utenti)->timestamp_login = (time_t)NULL;
    	(fine_registro_utenti)->timestamp_logout = (time_t)NULL;
    	(fine_registro_utenti)->next = NULL;
    	
    	(fine_registro_utenti)->mittenti = NULL;
    	(fine_registro_utenti)->fine_mittenti = NULL;
	}	
}

void inserimento_messaggio(struct informazioni_utente* utente_dest, struct informazioni_utente* utente_mitt, const char* message) {
    // La funzione si articola nei seguenti passaggi:
    // - Individuazione della struttura dedicata al peer mittente, se non e' presente la si crea
    // - Inserimento del messaggio nella relativa lista
    struct messagebox_mittente* pointer1 = utente_dest->mittenti;
    struct messaggio_mittente* pointer2;
    
    if(utente_dest == NULL || utente_mitt == NULL) // Non ha senso proseguire se uno dei due puntatori e' nullo
        return;
    
    // PRIMO PASSO: GESTIONE STRUTTURA messagebox_mittente (creazione o aggiornamento)
    while(pointer1 != NULL) {
        if(strcmp((pointer1->mittente)->user_dest, utente_mitt->user_dest) == 0)
            break;
        
        pointer1 = pointer1->next;               
    }   
    
    if(pointer1 == NULL) { // Se pointer1 e' null va creata la struttura
        if(utente_dest->mittenti == NULL) {	            
    	    utente_dest->mittenti = (void*)malloc(sizeof(struct messagebox_mittente));
    	    utente_dest->fine_mittenti = utente_dest->mittenti;		
    	    
    	    (utente_dest->mittenti)->mittente = utente_mitt;
    	    (utente_dest->mittenti)->counter = 1; // stiamo aggiungendo il primo messaggio
    	    (utente_dest->mittenti)->latest_timestamp = (time_t)NULL;
    	    
    	    pointer1 = utente_dest->fine_mittenti;
	    }
	    else {
	        (utente_dest->fine_mittenti)->next = (void*)malloc(sizeof(struct messagebox_mittente));
    	    utente_dest->fine_mittenti = (utente_dest->fine_mittenti)->next;
    	    
    	    (utente_dest->fine_mittenti)->mittente = utente_mitt;
    	    (utente_dest->fine_mittenti)->counter = 1; // stiamo aggiungendo il primo messaggio
    	    (utente_dest->fine_mittenti)->latest_timestamp = (time_t)NULL;
    	    
    	    pointer1 = utente_dest->fine_mittenti;
	    }	            
    }
    else { // La struttura esiste, aggiorno il timestamp e il contatore
         pointer1->counter++;
    	 time(&pointer1->latest_timestamp); 
    }
    
    // SECONDO PASSO: Aggiunta struttura messaggio_mittente
    // A questo punto pointer1 punta, in ogni possibile caso, il messagebox del mittente
    // Dobbiamo solo aggiungere il messaggio, lo facciamo mettendolo in testa
    if(pointer1->messages == NULL) { 
        // Primo messaggio
        pointer2 = (void*)malloc(sizeof(struct messaggio_mittente));           
        strcpy(pointer2->message, message);
        pointer2->next = NULL;
        
        pointer1->messages = pointer2; 
        pointer1->final_messages = pointer2;
    }
    else { 
        // Nuovo messaggio, metto in coda        
        pointer2 = (void*)malloc(sizeof(struct messaggio_mittente));           
        strcpy(pointer2->message, message);
        pointer2->next = NULL;
        
        (pointer1->final_messages)->next = pointer2;
        pointer1->final_messages = pointer2;
    }    
}  

void funzione_stdin() {
	char comando[COMMAND_LENGTH];
	
	memset(&comando, 0, sizeof(comando));
	fgets(comando, BUFFER_LENGTH, stdin);   
	
	if(strcmp(comando, "help\n") == 0) {
		system("clear");
		comando_server_help();
	}
	else if(strcmp(comando, "list\n") == 0) {
		system("clear");
		comando_server_list();
	}	
	else if(strcmp(comando, "esc\n") == 0) {
		system("clear");
		comando_server_esc();
	}	
	else if(strcmp(comando, "debugstruct\n") == 0) {
        system("clear");
        debug_struct();     
    }
	else if(strcmp(comando, "back\n") == 0) {
		system("clear");
		output_server_comandi();
	}	
	else {
		gestione_errori(3);
	}
}

void output_server_comandi() {
	printf("***************************** SERVER STARTED *********************************\n");
	printf("Digita un comando:\n\n");
	printf("1) help\n");
	printf("2) list\n");
	printf("3) esc\n\n");
}

void comando_server_help() {
	printf("*************************** DESCRIZIONE COMANDI *******************************\n");
	printf("2) list\n Mostra l'elenco degli utenti connessi alla rete. Viene restituito username, timestamp di connessione e numero di porta.\n");
	printf("3) esc\n Termina il server. Le chat in corso proseguono, ma ulteriori utenti non potranno fare login mentre il server rimane offline.\n");
	printf("x) back\n Il server viene riportato alla pagina iniziale con l'elenco dei comandi\n");
}

void comando_server_list() {
	struct informazioni_utente* pointer = registro_utenti;
	char extra_buffer[50];
	
	system("clear");
	printf("*************************** UTENTI CONNESSI *******************************\n");
	while(pointer != NULL) {
        // Supposizione ideale: gli utenti si disconnettono in modo regolare 
		if(pointer->sckt != -1 && pointer->port != -1) { // In questo caso timestamp login e' sicuramente non nullo e timestamp logout sicuramente nullo          
            strftime(extra_buffer, 50, "%Y-%m-%d %H:%M:%S", localtime(&pointer->timestamp_login));    
            
            printf("> %s, Porta: %i, Timestamp login: %s\n", pointer->user_dest, pointer->port, extra_buffer);
        } 
      
		pointer = pointer->next;
	}
}

void comando_server_esc()  {
     struct informazioni_utente* pointer = registro_utenti; 
	 system("clear");
	 printf("*************************** DISCONNESSIONE *******************************\n");
     while(pointer != NULL) {
         if(pointer->sckt != -1) 
             close(pointer->sckt);
             
         pointer = pointer->next;
     }
     
     printf("Le connessioni coi peer sono state chiuse.");
     exit(0);
}

void funzione_socket_ascolto() {
	struct sockaddr_in cl_addr;
	socklen_t addrlen;
	int newfd; 
	
	addrlen = sizeof(cl_addr);

	newfd = accept(listener, (struct sockaddr *)&cl_addr, &addrlen);
	if(newfd < 0)
		gestione_errori(5);
		
	FD_SET(newfd, &master); 

	if(newfd > fdmax){ 
		fdmax = newfd; 
	} 
}

void funzione_socket_comunicazione(int sckt) {
	// La ricezione di un comando si compone di due eventi: 
	// spedizione della lunghezza del comando e spedizione del comando stesso
	char buffer[BUFFER_LENGTH];
	char* pointer_parameters;
	int int_length, ret;
	uint16_t length;
	
	// PRIMA COSA: Ricezione della lunghezza del comando
	ret = recv(sckt, (void*)&length, sizeof(uint16_t), 0);
	if(ret == 0) {
	    comando_client_out(sckt);
	    return;    
    }
	    
    if(ret < 0) 
    	gestione_errori(4);
	int_length = ntohs(length);
	
	// SECONDA COSA: Ricezione del comando
	ret = recv(sckt, (void*)buffer, int_length, 0);
    if(ret < 0) 
    	gestione_errori(4);
	
	// TERZA COSA: Scomposizione del comando
	// Ogni pacchetto presenta come struttura COMANDO|Parametri, si divide il comando dai parametri sfruttando il divisore |
	// La divisione dei parametri e' rimandata alle funzioni specifiche, in modo tale da rendere flessibile il numero e il tipo di parametri
	// Se il comando non ha parametri lo si invia senza |, non e' un problema
	pointer_parameters = strtok(buffer, "|");
	pointer_parameters = strtok(NULL, "|");
	
	// QUARTA COSA: Esecuzione della richiesta da parte del client, se valida
	if(strcmp(buffer, "CLIENTSIGNUP") == 0)
		comando_client_signup(sckt, pointer_parameters);
	else if(strcmp(buffer, "CLIENTIN") == 0)
		comando_client_in(sckt, pointer_parameters);
    else if(strcmp(buffer, "CLIENTCHAT") == 0)
        comando_client_chat(sckt, pointer_parameters);
    else if(strcmp(buffer, "MESSAGE") == 0) 
        gestione_messaggi_peer_offline(sckt, pointer_parameters);
    else if(strcmp(buffer, "REQUESTHANGING") == 0) 
        comando_client_hanging(sckt);
    else if(strcmp(buffer, "REQUESTMESSAGES") == 0) 
        comando_client_show(sckt, pointer_parameters);
	
	// QUINTA COSA: Pulizia in previsione di utilizzi successivi
	memset(&buffer, 0, BUFFER_LENGTH);
}

void gestione_messaggi_peer_offline(const int sckt, const char* receiver) {
    char buffer[BUFFER_LENGTH];
	int int_length, ret;
	uint16_t length;
	struct informazioni_utente* pointer;
	struct informazioni_utente* pointer2;
	
    memset(&buffer, 0, BUFFER_LENGTH);
	
	// Per prima cosa ricevo la lunghezza del messaggio
	ret = recv(sckt, (void*)&length, sizeof(uint16_t), 0);
	if(ret < 0) 
    	gestione_errori(4);
	int_length = ntohs(length);
	
	// Infine ricevo il messaggio
	ret = recv(sckt, (void*)buffer, int_length, 0);
    if(ret < 0) 
    	gestione_errori(4);
    	
    pointer = controllo_presenza_username(receiver); // ottengo puntatore a struttura del destinatario
    pointer2 = controllo_presenza_sckt(sckt); // ottengo puntatore a struttura del mittente
    
    if(pointer != NULL && pointer2 != NULL)
        inserimento_messaggio(pointer, pointer2, buffer);
}

void comando_client_signup(const int sckt, const char* parameters_buffer) {
	// Verifica della presenza di duplicati
	// Si apre il file "users.txt" utilizzando la fopen, con a+
	// Se l'username non e' presente si arrivera' in fondo al buffer, e faremo append
	// Se l'username e' presente ci fermeremo prima e non faremo append
	FILE* f;
    char* res;
    char buffer[BUFFER_LENGTH];
	char username[USERNAME_LENGTH];
	char password[PASSWORD_LENGTH];
    int duplicato;
    
	int int_length, ret;
	uint16_t length;
	
	sscanf(parameters_buffer, "%s %s", username, password);

	if(strcmp(username, "") == 0 || strcmp(password, "") == 0) {
		printf("Dati non compilati correttamente");
		// L'applicazione lato client gia' verifica la consistenza dei due parametri
		return; 	
	} 	
	
    memset(&buffer, 0, BUFFER_LENGTH);
	duplicato = 0;
	
    f = fopen("users.txt", "a+");
    if(f > 0) {
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
            if(strncmp(buffer, username, strlen(username)) == 0) {
                duplicato = 1; 
                break;
            }
        }
    }
    
    if(duplicato == 1) { // Presente duplicato, dobbiamo avvertire il client 
    	// Chiudo il FILE
    	fclose(f);
    	
    	// Invio un DUPLICATESIGNUP al client
    	memset(&buffer, 0, BUFFER_LENGTH);
    	strcpy(buffer, "DUPLICATESIGNUP");
		int_length = strlen(buffer);
		length = htons(int_length);
	 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
    
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);
	}
	else { 
		// Non c'e' duplicato, facciamo append
    	fprintf(f, "%s %s\n", username, password);
    	
    	// Chiudo il FILE
    	fclose(f);
    	
    	// Invio un ACKSIGNUP al client
    	strcpy(buffer, "ACKSIGNUP");
		int_length = strlen(buffer);
		length = htons(int_length);
	 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
    
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);
    	
    	// Inserimento nel registro
    	inserimento_utenti_registro(username);		
	}
}

void comando_client_in(const int sckt, const char* parameters_buffer) { 
	// Verificare la presenza dell'utente
	FILE* f;
    char* res;
    char buffer[BUFFER_LENGTH];
	char username[USERNAME_LENGTH];
	char password[PASSWORD_LENGTH];
    char dati_concatenati[USERNAME_LENGTH+PASSWORD_LENGTH];

	int porta, valido;
    struct informazioni_utente* pointer;
    
	int int_length, ret;
	uint16_t length;
	
	sscanf(parameters_buffer, "%s %s %i", username, password, &porta);

	if(strcmp(username, "") == 0 || strcmp(password, "") == 0) {
		printf("Dati non compilati correttamente");
		// L'applicazione lato client gia' verifica la consistenza dei due parametri
		return; 	
	} 	
	
    memset(&buffer, 0, BUFFER_LENGTH);
    memset(&dati_concatenati, 0, USERNAME_LENGTH+PASSWORD_LENGTH);
	strcpy(dati_concatenati, username);
	strcat(dati_concatenati, " ");
	strcat(dati_concatenati, password);
	    	
	valido = 0;
	
    f = fopen("users.txt", "r");
    if(f > 0) {
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
            if(strncmp(buffer, dati_concatenati, strlen(dati_concatenati)) == 0) {
                valido = 1; 
                break;
            }
        }
    }
    fclose(f);
    
    if(valido == 0) { // Login fallito
    	// Invio un FAILEDIN al client
    	memset(&buffer, 0, BUFFER_LENGTH);
    	strcpy(buffer, "FAILEDIN");
		int_length = strlen(buffer);
		length = htons(int_length);
	 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
    
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);
	}
	else { // Login riuscito
    	// Invio un ACKIN al client
    	strcpy(buffer, "ACKIN");
		int_length = strlen(buffer);
		length = htons(int_length);
	 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
    
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);	
    		
    	// Aggiornamento del registro
    	// Dato che a inizializzazione del server vengono generate le strutture dati leggendo il file users
    	// si suppone che non possa non essere presente l'utente
    	pointer = registro_utenti;
    	while(1) {
			if(strncmp(pointer->user_dest, username, strlen(username)) == 0)
				break;

			pointer = pointer->next; 
		}
    	
    	time(&pointer->timestamp_login); 
		pointer->timestamp_logout = (time_t)NULL; 
		pointer->port = porta;  
		pointer->sckt = sckt;		
	}
}

void comando_client_chat(const int sckt, const char* parameters_buffer) { 
	// Per prima cosa individuo la relativa struttura dati 
	// Verifico quanto tempo e passato dall'ultimo ping: se sono passati piu di cinque minuti il server si rivolge al client per saperne di piu'
	// Altrimenti dice al client che tutto va bene
    char buffer[BUFFER_LENGTH];
	int int_length, ret;
	uint16_t length;
	
	struct informazioni_utente* pointer = registro_utenti;
	char char_porta[10];
	
    memset(&buffer, 0, BUFFER_LENGTH);
	while(pointer != NULL) {
		if(strcmp(pointer->user_dest, parameters_buffer) == 0)
			break; 
			
		pointer = pointer->next;
	}
	
    memset(&buffer, 0, BUFFER_LENGTH);
    
    // La lista e' inizializzats ad avvio server
    // Se il puntatore e' nullo il peer non si e' mai registrato presso il server
	if(pointer == NULL) {
		strcpy(buffer, "UNKOWNPEER");
	
		int_length = strlen(buffer);
		length = htons(int_length);
		 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
   	 
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);	
	}
	else if(pointer->sckt == -1) {
        memset(&buffer, 0, sizeof(buffer));
        strcpy(buffer, "CHATOFFLINE");
	
		int_length = strlen(buffer);
		length = htons(int_length);
		 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
   	 
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);	
    }
    else {
        strcpy(buffer, "REQUESTPING");
	    int_length = strlen(buffer);
	    length = htons(int_length);
	 
	    ret = send(pointer->sckt, &length, sizeof(uint16_t), 0);
        if(ret < 0) 
	        gestione_errori(6);
        
        ret = send(pointer->sckt, &buffer, int_length, 0);
        if(ret < 0)
            gestione_errori(6); 
        
        memset(&buffer, 0, sizeof(buffer));
        ret = recv(pointer->sckt, (void*)&length, sizeof(uint16_t), 0);
        
        if(ret < 0) {
    	    gestione_errori(4);
        }
   	    else if(ret == 0) { // Il peer si e' disconnesso
            memset(&buffer, 0, sizeof(buffer));
            strcpy(buffer, "CHATOFFLINE");
	
		    int_length = strlen(buffer);
		    length = htons(int_length);
		 
		    ret = send(sckt, &length, sizeof(uint16_t), 0);
    	    if(ret < 0)
    		    gestione_errori(6);
   	 
		    ret = send(sckt, &buffer, int_length, 0);
    	    if(ret < 0)
    		    gestione_errori(6);	

		    return;	
        }
	    int_length = ntohs(length);
		
        ret = recv(pointer->sckt, (void*)&buffer, int_length, 0);
        if(ret < 0) { // Qualcosa e' andato storto
            gestione_errori(4); 
        }
        else if(ret == 0) { // Il peer si e' disconnesso
            memset(&buffer, 0, sizeof(buffer));
            strcpy(buffer, "CHATOFFLINE");
	
		    int_length = strlen(buffer);
		    length = htons(int_length);
		 
		    ret = send(sckt, &length, sizeof(uint16_t), 0);
    	    if(ret < 0)
    		    gestione_errori(6);
   	 
		    ret = send(sckt, &buffer, int_length, 0);
    	    if(ret < 0)
    		    gestione_errori(6);	

		    return;	
        }
        else if(strncmp(buffer, "CLIENTPING", 10) == 0) {
            memset(&buffer, 0, sizeof(buffer));
            strcpy(buffer, "CHATACK");
		    strcat(buffer, "|");
		    sprintf(char_porta, "%i", pointer->port);
		    strcat(buffer, char_porta);
		
		    int_length = strlen(buffer);
	        length = htons(int_length);
	        ret = send(sckt, &length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(6);
    	
            ret = send(sckt, &buffer, int_length, 0);
            if(ret < 0)
    	        gestione_errori(6);	
        }
    }
} 

void comando_client_hanging(const int sckt) {
    char buffer[BUFFER_LENGTH*3];
    char extra_buffer[50];
	struct informazioni_utente* pointer = controllo_presenza_sckt(sckt); // ottengo puntatore a struttura del sckt
    struct messagebox_mittente* pointer2 = pointer->mittenti;
	int int_length, ret;
	uint16_t length;
    
    memset(&buffer, 0, sizeof(buffer));
    
    if(pointer2 == NULL)
       strcpy(buffer, "NOMESSAGES");
    
    while(pointer2 != NULL) {           
       strcat(buffer, "> ");
       strcat(buffer, (pointer2->mittente)->user_dest);
       strcat(buffer, ", Numero messaggi: ");
       
       sprintf(extra_buffer, "%i", pointer2->counter);
       strcat(buffer, extra_buffer); 
       memset(&extra_buffer, 0, sizeof(extra_buffer));
       
       strcat(buffer, ", Ultimo timestamp: ");
       strftime(extra_buffer, 50, "%Y-%m-%d %H:%M:%S", localtime(&pointer2->latest_timestamp));    
       strcat(buffer, extra_buffer);
       
       strcat(buffer, "\n");   
       
       pointer2 = pointer2->next;     
    }
    
    int_length = strlen(buffer);
	length = htons(int_length);
	ret = send(sckt, &length, sizeof(uint16_t), 0);
    if(ret < 0)
        gestione_errori(6);
    	
    ret = send(sckt, &buffer, int_length, 0);
    if(ret < 0)
        gestione_errori(6);	
}

void comando_client_show(const int sckt, const char* mittente) {
	struct informazioni_utente* pointer; 
	struct messagebox_mittente* pointer2;
	struct messaggio_mittente* pointer3;
	struct messaggio_mittente* pointer4;
	char buffer[BUFFER_LENGTH*100]; 
	int int_length, ret;
	uint16_t length;
	
    pointer = controllo_presenza_sckt(sckt); // ottengo puntatore a struttura di chi richiede
    pointer2 = pointer->mittenti;
	
    while(pointer2 != NULL) {
        if(strcmp((pointer2->mittente)->user_dest, mittente) == 0)
            break; 
            
        pointer2 = pointer2->next;               
    }
	
    if(pointer2 == NULL || pointer2->counter == 0) { // Non c'e' niente da trasmettere        
        memset(&buffer, 0, sizeof(buffer));
   	    strcpy(buffer, "NOTHING");
		int_length = strlen(buffer);
		length = htons(int_length);
	 
		ret = send(sckt, &length, sizeof(uint16_t), 0);
    	if(ret < 0)
    		gestione_errori(6);
    
		ret = send(sckt, &buffer, int_length, 0);
    	if(ret < 0)
    		gestione_errori(6);	         
    }
    else { // C'e' qualcosa da trasmettere
         // Il contatore ha sicuramente un valore > 0
         
         memset(&buffer, 0, sizeof(buffer));
         
         pointer3 = pointer2->messages; 
         while(pointer3 != NULL) {
             strcat(buffer, pointer3->message);
             if(pointer3->next != NULL)
                 strcat(buffer, "\n");
                 
             pointer3 = pointer3->next;              
         }
         
		 int_length = strlen(buffer);
		 length = htons(int_length);
	 
		 ret = send(sckt, &length, sizeof(uint16_t), 0);
    	 if(ret < 0)
    		gestione_errori(6);
         
		 ret = send(sckt, &buffer, int_length, 0);
    	 if(ret < 0)
    		gestione_errori(6);	  
    		
 		 pointer2->counter = 0;
 		 pointer3 = pointer2->messages;
 		 while(pointer3 != NULL) {
             pointer4 = pointer3;
             pointer3 = pointer3->next;     
             free(pointer4);          
         }
         pointer2->messages = NULL;
         pointer2->final_messages = NULL;
         
 		 // AVVERTO il mittente dei messaggi che questi sono stati trasmessi al PEER
 		 // Prima il comando
         memset(&buffer, 0, sizeof(buffer));
   	     strcpy(buffer, "OLDMESSAGESSENT");
		 int_length = strlen(buffer);
		 length = htons(int_length);
	 
		 ret = send((pointer2->mittente)->sckt, &length, sizeof(uint16_t), 0);
    	 if(ret < 0)
    		gestione_errori(6);
    
		 ret = send((pointer2->mittente)->sckt, &buffer, int_length, 0);
    	 if(ret < 0)
    		gestione_errori(6);	
    		
 		 // Poi l'username
 		 int_length = strlen(pointer->user_dest);
		 length = htons(int_length);
	 
		 ret = send((pointer2->mittente)->sckt, &length, sizeof(uint16_t), 0);
    	 if(ret < 0)
    		gestione_errori(6);
    
		 ret = send((pointer2->mittente)->sckt, &pointer->user_dest, int_length, 0);
    	 if(ret < 0)
    		gestione_errori(6);	
    }
}

void comando_client_out(const int sckt) {
     // Il server ha ricevuto l'avviso di disconnessione da parte di un peer
     // Si recupera la struttura informazioni_utente usando il socket, si aggiornano i contenuti
     // e infine si rimuove il client dal set di descrittori      
     struct informazioni_utente* pointer = controllo_presenza_sckt(sckt); 
     
     close(pointer->sckt);
     FD_CLR(pointer->sckt, &master);
     pointer->sckt = -1;
     pointer->port = -1;
     time(&pointer->timestamp_logout);
} 

void gestione_errori(int error) {
	switch (error) {
		case 0: 
		perror("Errore nella creazione del socket: ");
 		exit(0);
		case 1: 
		perror("Errore con la funzione bind: ");
 		exit(0);
 		case 2:
 		perror("Errore con la funzione select: ");
 		exit(0);
 		case 3:
 		printf("Errore: comando inserito non riconosciuto. Riprovare!\n");
 		break;
 		case 4:
 		perror("Errore con la funzione receive: ");
 		exit(0);
 		case 5:
 		perror("Errore con la funzione accept: ");
 		exit(0);
 		case 6:
 		perror("Errore con la funzione send: ");
 		exit(0);
		default: 
		printf("Errore.");
		break;
	}	
}

void debug_struct() {
    struct informazioni_utente* pointer = registro_utenti;
    struct messagebox_mittente* pointer2;
    struct messaggio_mittente* pointer3; 
    
    while(pointer != NULL) {
        printf("|--------------------------------|\n");
        printf("user_dest: %s\n", pointer->user_dest);  
        printf("port: %i\n", pointer->port);  
        printf("sckt: %i\n", pointer->sckt);  
        printf("MESSAGEBOX MITTENTI:\n");
        
        pointer2 = pointer->mittenti;
        if(pointer2 == NULL)
            printf("Non ci sono mittenti\n");
        else {
             while(pointer2 != NULL) {
                 printf("> Messagebox di %s\n", (pointer2->mittente)->user_dest);         
                 printf("Counter: %i\n", pointer2->counter);
                 
                 pointer3 = pointer2->messages;
                 if(pointer3 == NULL)
                     printf("Non ci sono messaggi\n"); 
                     
                 while(pointer3 != NULL) {
                     printf("Messaggio: %s\n", pointer3->message);
                     pointer3 = pointer3->next;
                 }
                 
                 pointer2 = pointer2->next;
             }
        }
        
        pointer = pointer->next;
        
        printf("|--------------------------------|\n");           
    }
} 
