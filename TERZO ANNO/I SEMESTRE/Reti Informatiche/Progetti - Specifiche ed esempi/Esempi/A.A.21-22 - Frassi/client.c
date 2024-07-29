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

int porta;
int listener, fdmax, server_socket, server_port;
char user[USERNAME_LENGTH];
fd_set master, read_fds;

int pagina_chat_aperta;

void gestione_login(); 
void output_client_comandi(int login);
void comando_client_signup(const char* username, const char* password);
int comando_client_in(const char* username, const char* password);
void comando_client_out();

void funzione_stdin();
void funzione_socket_ascolto();
void funzione_socket_comunicazione(int sckt);
void comando_client_hanging();
void comando_client_show();
void comando_client_share();
void comando_client_chat();

void ping();

void carica_chat(const char* first_user, const char* second_user);
void nuovo_messaggio_peer(const char* message, const char* first_user, const char* second_user, int delivered);
void sposta_chat(const char* first_user, const char* second_user);
void svuota_chat(const char* first_user, const char* second_user, int delivered);

void gestione_errori(int error);

// Memorizzazione delle connessioni TCP stabilite coi peer 
// Verifica della presenza del dispositivo al lancio del comando chat
struct connessione_peer {
    char username[USERNAME_LENGTH]; 
    int socket;
    int port_number;
    struct connessione_peer* next;   
}; 
struct connessione_peer* lista_connessioni_peer; // Puntatore inizio lista
struct connessione_peer* fine_lista_connessioni_peer; // Puntatore fine lista
struct connessione_peer* chat_aperta;
struct connessione_peer* controllo_presenza_connessione_username(const char* username); // Presenza di una connessione con l'username indicato
struct connessione_peer* controllo_presenza_connessione_socket(const int socket); // Presenza di una connessione col socket
void inserimento_connessione_peer(const char* username, int socket, int port_number); // Inserimento di un nuovo elemento nella lista
int controlla_status_peer(const char* username); // Controllo presso il server se il peer e' presente, restituisce num di porta

struct chat_gruppo {
    // Se tutti e tre i puntatori sono nulli non c'e' chat di gruppo
    // La chat di gruppo e' formata da al piu' tre utenti (incluso il peer che gestisce la chat, che non e' tra i puntatori)
    // Si riempiono in sequenza primo, secondo e terzo puntatore
    // NOTA: Non e' possibile aggiungere a una chat di gruppo un utente che sta gia' gestendo un'altra chat
    // > Ragione principale: evidare loop nell'invio di messaggi ed espansioni non controllate dei componenti della chat di gruppo
    // La chat di gruppo e' istituita nel contesto del comando chat e viene sciolta quando il peer che l'ha creata esce (scrive \q+INVIO)
    
    struct connessione_peer* first_pointer;
    struct connessione_peer* second_pointer;    
};
struct chat_gruppo status_chat_gruppo;

void inserisci_in_rubrica(const char* owner, const char* new);
void carica_rubrica(const char* owner);

int main(int argc, char** argv) { 
		
	int i, ret;
 	struct sockaddr_in my_addr;
	 		 	
	// Porta parametro obbligatorio
	if(argc > 1) 
		porta = strtol(argv[1], NULL, 10);
	else 
		gestione_errori(0);
		
	if(argc > 2) 
		server_port = strtol(argv[2], NULL, 10);
	else 
        server_port = 4242;
		
 	memset(&user, 0, sizeof(user));
	
	// L'utente non ha fatto login, non si esce dalla funzione fino a quando il login non e' avvenuto
	// Proseguire nel codice significa aver fatto login!
	gestione_login();
	
	chat_aperta = NULL;
	status_chat_gruppo.first_pointer = NULL;
	status_chat_gruppo.second_pointer = NULL;
	
	// Creazione del socket che il peer utilizzera' per ricevere richieste dagli altri peer
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
 		gestione_errori(6);

	// Dichiarazione del socket come socket di ascolto
 	listen(listener, 10);
 	
 	// Inizializzazione dei set di file descriptor e della variabile fdmax per la funzione select
 	FD_ZERO(&master);
 	FD_ZERO(&read_fds);
 	FD_SET(0, &master); // standard input ha FD 0
 	FD_SET(server_socket, &master);
 	FD_SET(listener, &master);
 	
 	if(listener > server_socket)
        fdmax = listener;
    else 
        fdmax = server_socket;
 	
 	system("clear");
 	output_client_comandi(1);

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

void gestione_login() {
	char buffer[COMMAND_LENGTH + USERNAME_LENGTH + PASSWORD_LENGTH];
	char comando[COMMAND_LENGTH], username[USERNAME_LENGTH], password[PASSWORD_LENGTH]; 
	int ret; 
	struct sockaddr_in server_addr;
	
	// PRIMA COSA: Richiedere la porta del server con cui si vuole comunicare
	/*system("clear");
	printf("*************************** INIZIALIZZAZIONE *******************************\n");
	printf("Inserire la srv_port\n");
	memset(&buffer, 0, sizeof(buffer));
	fgets(buffer, BUFFER_LENGTH, stdin);
	sscanf(buffer, "%i", &server_port);*/
	
	// SECONDA COSA: Stabilire una comunicazione col server	(porta indicata poco prima)
	server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if(server_socket < 0)
    	gestione_errori(2);

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(server_port);
    inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr);

    ret = connect(server_socket, (struct sockaddr*)&server_addr, sizeof(server_addr));
    if(ret < 0)
    	gestione_errori(3);
    	
    // TERZA COSA: Gestire i comandi signup e in   
	system("clear");
	output_client_comandi(0); 
	
	while(1) { 
		memset(&buffer, 0, sizeof(buffer));
		fgets(buffer, BUFFER_LENGTH, stdin);
		sscanf(buffer, "%s %s %s", comando, username, password);
		
		if(strcmp(comando, "signup") == 0) {
			system("clear");
			comando_client_signup(username, password);
			output_client_comandi(0); 
		} 
		else if(strcmp(comando, "in") == 0) {
			system("clear");
			
			if(comando_client_in(username, password) == 0)
				output_client_comandi(0); 
			else 
				break; // Esco dal ciclo se ho fatto login
		}
		else if(strcmp(comando, "close") == 0) {
			printf("Connessione col server interrotta.\n");
			exit(0);
		}
		else {
			gestione_errori(1);
		}
	}
}

void output_client_comandi(int login) {
	if(login == 1) {
		printf("***************************** PEER CONNECTED *********************************\n");
		printf("Digita un comando:\n\n");
		printf("1) hanging\n");
		printf("2) show\n");
		printf("3) chat\n");
		printf("4) share\n");
		printf("5) out\n");
	}
	else {
		printf("***************************** PEER STARTED *********************************\n");
		printf("Digita un comando:\n\n");
		printf("1) signup <username> <password>\n");
		printf("2) in <username> <password>\n");
		printf("2) close\n");
	}
}

void comando_client_signup(const char* username, const char* password) {
	// Si trasmette un comando nel formato CLIENTSIGNUP <username> <password>
	// Prima si trasmette la lunghezza del messaggio, poi il comando stesso
	// A seguito della trasmissione si attende l'esito dell'operazione sul server: 
	// - o si riceve ACK;
	// - o si riceve un segnale di errore (DUPLICATESIGNUP, Username gia presente)
	
	int int_length, ret;
	uint16_t length;
	char buffer[BUFFER_LENGTH];

	if(strcmp(username, "") == 0 || strcmp(password, "") == 0) {
		printf("Dati non compilati correttamente");
		return; 	
	} 		
	
    memset(&buffer, 0, sizeof(buffer));
	strcpy(buffer, "CLIENTSIGNUP|");
	strcat(buffer, username);
	strcat(buffer, " ");
	strcat(buffer, password);

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(buffer);
	length = htons(int_length);

    ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
    	
    // Invio il comando
    ret = send(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
    
    // Attesa di ACK, per sapere come muoversi. Prima ricevo la lunghezza e poi l'ACK (o il segnale di errore)
    memset(&buffer, 0, sizeof(buffer));
    ret = recv(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(5);
	int_length = ntohs(length);
	
    ret = recv(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(5);
    	
	if(strcmp(buffer, "DUPLICATESIGNUP") == 0) 
    	printf("Il server ha segnalato la presenza di un username con lo stesso nominativo\n");
	else if(strcmp(buffer, "ACKSIGNUP") == 0) 
		printf("La registrazione ha avuto successo.\n");
}

int comando_client_in(const char* username, const char* password) {
	// Si trasmette un comando nel formato CLIENTIN <username> <password>
	// Prima si trasmette la lunghezza del messaggio, poi il comando stesso
	// A seguito della trasmissione si attende l'esito dell'operazione sul server: 
	// - o si riceve ACK;
	// - o si riceve un segnale di errore (FAILEDIN)
	
	int int_length, ret;
	uint16_t length;
	char buffer[BUFFER_LENGTH];
	char char_porta[10];

    memset(&buffer, 0, sizeof(buffer));
	strcpy(buffer, "CLIENTIN|");
	strcat(buffer, username);
	strcat(buffer, " ");
	strcat(buffer, password);
	strcat(buffer, " ");
	sprintf(char_porta, "%i", porta);
	strcat(buffer, char_porta);

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(buffer);
	length = htons(int_length);

    ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
    	
    // Invio il comando
    ret = send(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
    
    // Attesa di ACK, per sapere come muoversi. Prima ricevo la lunghezza e poi l'ACK (o il segnale di errore)
    memset(&buffer, 0, sizeof(buffer));
    ret = recv(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(5);
	int_length = ntohs(length);
	
    ret = recv(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(5);
    	
	if(strcmp(buffer, "FAILEDIN") == 0) {
    	printf("Login fallito. Password errata o username inesistente!\n");
    	return 0;
	}
	else if(strcmp(buffer, "ACKIN") == 0) {
		printf("Login effettuato.\n");
		strcpy(user, username);
		return 1;
	}
	else {
		return 0;
	}
}

void funzione_stdin() {
	char comando[BUFFER_LENGTH];
	char buffer[BUFFER_LENGTH];
	//int port;
	int int_length, ret;
	uint16_t length;
	struct connessione_peer* pointer;

	memset(&comando, 0, sizeof(comando));
	fgets(comando, BUFFER_LENGTH, stdin);  
	
	// Se l'utente sta visionando una chat si gestiscono i comandi relativi alla chat
	// Altrimenti si gestiscono i comandi del menu
	if(chat_aperta != NULL) {
        if(strcmp(comando, "\\q\n") == 0) {
            // Richiesta l'uscita dalla chat
            chat_aperta = NULL;
            
            // Elimino la chat di gruppo (se presente) ponendo nulli i puntatori
            status_chat_gruppo.first_pointer = NULL;
            status_chat_gruppo.second_pointer = NULL;
            
			system("clear");
			output_client_comandi(1);
        }  
        else if(strcmp(comando, "\\u\n") == 0) {
             // Richiesta la stampa della rubrica, che viene recuperata dall'apposito file
             // La rubrica viene aggiornata con inserimenti in comando_client_chat() e funzione_socket_ascolto()
             carica_rubrica(user);
        } 
        else if(strncmp(comando, "\\a", 2) == 0) {
             // Richiesta l'aggiunta di un utente al gruppo    
   	         comando[strcspn(comando, "\n")] = '\0';
   	         
             sscanf(comando, "\\a %s", buffer);
   	         
   	         if(strcmp(user, buffer) == 0) {
                 printf("[AVVISO: Non puoi aggiungere te stesso]\n");
                 return;      
             } 
             
             pointer = controllo_presenza_connessione_username(buffer);  
             if(pointer == NULL || pointer->socket == -1) {
                 printf("[AVVISO: Il peer indicato non esiste, oppure non e' stata stabilita una connessione precedentemente]\n");
             }
             else {
                 // La connessione e' stata stabilita, il peer e' online e abbiamo il socket a disposizione
                 
                 // Per prima cosa propongo al peer l'aggiunta al gruppo
                 memset(&buffer, 0, sizeof(buffer));
	             strcpy(buffer, "JOINGROUP");
	        
	             int_length = strlen(buffer);
	             length = htons(int_length);

                 ret = send(pointer->socket, (void*)&length, sizeof(uint16_t), 0);
                 if(ret < 0)
    	              gestione_errori(4);
            
                 ret = send(pointer->socket, (void*)&buffer, int_length, 0);
                 if(ret < 0)
    	              gestione_errori(4);
    	              
                 memset(&buffer, 0, sizeof(buffer));
	
	             // PRIMA COSA: Ricezione della lunghezza del comando
	             ret = recv(pointer->socket, (void*)&length, sizeof(uint16_t), 0);
                 if(ret < 0) 
    	             gestione_errori(4);
	             int_length = ntohs(length);
	
	             // SECONDA COSA: Ricezione del comando
	             ret = recv(pointer->socket, (void*)buffer, int_length, 0);
                 if(ret < 0) 
    	             gestione_errori(4);
    	             
   	             if(strcmp(buffer, "APPROVED") == 0) {
                     if(status_chat_gruppo.first_pointer == NULL) {
                         status_chat_gruppo.first_pointer = pointer;
                     }
                     else {
                         if(status_chat_gruppo.second_pointer == NULL) {
                             status_chat_gruppo.second_pointer = pointer;
                         }
                         else {
                             printf("[AVVISO: Capienza massima raggiunta]\n");
                             return;
                         }   
                     }    
                     
                     printf("[AVVISO: Il peer %s e' stato aggiunto con successo]\n", pointer->username);
                 }
                 else {
                     printf("[AVVISO: Il peer indicato non puo' essere aggiunto al gruppo]\n");     
                 }
             }
        }       
        else if(chat_aperta->socket != -1 && chat_aperta->port_number != -1) { // Messaggio inviato direttamente al peer
            // Ogni invio diverso da un comando e' trattato come un messaggio da inviare al destinatario
            memset(&buffer, 0, sizeof(buffer));
	        strcpy(buffer, "MESSAGE");
	        
	        // Invio la lunghezza del comando (che pongo in big endian per la rete)
	        int_length = strlen(buffer);
	        length = htons(int_length);

            ret = send(chat_aperta->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send(chat_aperta->socket, (void*)&buffer, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
   	        
   	        comando[strcspn(comando, "\n")] = '\0';
   	        
            // Invio la lunghezza del messaggio (che pongo in big endian per la rete)
	        int_length = strlen(comando);
	        length = htons(int_length);

            ret = send(chat_aperta->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send(chat_aperta->socket, (void*)&comando, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
    	        
   	        nuovo_messaggio_peer(comando, user, chat_aperta->username, 1);
   	        
   	        if(status_chat_gruppo.first_pointer != NULL) {
                // Ogni invio diverso da un comando e' trattato come un messaggio da inviare al destinatario
                memset(&buffer, 0, sizeof(buffer));
	            strcpy(buffer, "MESSAGE");
	        
	            // Invio la lunghezza del comando (che pongo in big endian per la rete)
	            int_length = strlen(buffer);
	            length = htons(int_length);

                ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
                if(ret < 0)
    	            gestione_errori(4);
            
                // Invio il comando
                ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&buffer, int_length, 0);
                if(ret < 0)
    	            gestione_errori(4);
   	        
                // Invio la lunghezza del messaggio (che pongo in big endian per la rete)
	            int_length = strlen(comando);
	            length = htons(int_length);

                ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
                if(ret < 0)
    	            gestione_errori(4);
            
                // Invio il comando
                ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&comando, int_length, 0);
                if(ret < 0)
    	            gestione_errori(4);
            }
            if(status_chat_gruppo.second_pointer != NULL) {
                // Ogni invio diverso da un comando e' trattato come un messaggio da inviare al destinatario
                memset(&buffer, 0, sizeof(buffer));
	            strcpy(buffer, "MESSAGE");
	        
	            // Invio la lunghezza del comando (che pongo in big endian per la rete)
	            int_length = strlen(buffer);
	            length = htons(int_length);

                ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
                if(ret < 0)
    	            gestione_errori(4);
            
                // Invio il comando
                ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&buffer, int_length, 0);
                if(ret < 0)
    	            gestione_errori(4);
   	        
                // Invio la lunghezza del messaggio (che pongo in big endian per la rete)
	            int_length = strlen(comando);
	            length = htons(int_length);

                ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
                if(ret < 0)
    	            gestione_errori(4);
            
                // Invio il comando
                ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&comando, int_length, 0);
                if(ret < 0)
    	            gestione_errori(4);                                 
            }
        }  
        else if(chat_aperta->socket == -1 && chat_aperta->port_number == -1) { // Messaggio inviato a un peer offline, quindi al server
            memset(&buffer, 0, sizeof(buffer));
	        strcpy(buffer, "MESSAGE");
	        strcat(buffer, "|");
	        strcat(buffer, chat_aperta->username);
	        
	        // Invio la lunghezza del comando (che pongo in big endian per la rete)
	        int_length = strlen(buffer);
	        length = htons(int_length);

            ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send(server_socket, (void*)&buffer, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
   	        
   	        comando[strcspn(comando, "\n")] = '\0';
   	        
            // Invio la lunghezza del messaggio (che pongo in big endian per la rete)
	        int_length = strlen(comando);
	        length = htons(int_length);

            ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send(server_socket, (void*)&comando, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
   	        
   	        nuovo_messaggio_peer(comando, user, chat_aperta->username, 0);
        }  
	}
	else {
		if(strcmp(comando, "hanging\n") == 0) {
			comando_client_hanging();
		}
		else if(strcmp(comando, "show\n") == 0) {
            system("clear");
            comando_client_show();
		}	
		else if(strcmp(comando, "chat\n") == 0) {
            comando_client_chat();
		}	
		else if(strcmp(comando, "share\n") == 0) {
            comando_client_share();
		}	
		else if(strcmp(comando, "out\n") == 0) {
			system("clear");
			comando_client_out();
		}	
		else if(strcmp(comando, "back\n") == 0) {
			system("clear");
			output_client_comandi(1);
		}	
		else {
			gestione_errori(7);
		}	
	}	
}

void funzione_socket_ascolto() {
	// Le richieste di connessione non provengono mai dal server, ma solo dai client 
	char buffer[USERNAME_LENGTH];
	struct sockaddr_in cl_addr;
	socklen_t addrlen;
    int newfd, int_length, ret;
	uint16_t length;
	
	addrlen = sizeof(cl_addr);

	newfd = accept(listener, (struct sockaddr*)&cl_addr, &addrlen);
	if(newfd < 0)
		gestione_errori(8);
	
	FD_SET(newfd, &master); 
	if(newfd > fdmax){ 
		fdmax = newfd; 
	} 
	
	memset(&buffer, 0, sizeof(buffer));
    ret = recv(newfd, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(5);
	int_length = ntohs(length);
	
    ret = recv(newfd, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(5);
	
	inserimento_connessione_peer(buffer, newfd, ntohs(cl_addr.sin_port));
	inserisci_in_rubrica(user, buffer);
}

void funzione_socket_comunicazione(int sckt) {
	// La ricezione di un comando si compone di due eventi: 
	// spedizione della lunghezza del comando e spedizione del comando stesso
	char buffer[BUFFER_LENGTH];
	char buffer2[COMMAND_LENGTH];
	char buffer_file[BUFFER_LENGTH*10];
	FILE* f;
	int int_length, ret;
	uint16_t length;
	struct connessione_peer* pointer; 
	
	memset(&buffer, 0, BUFFER_LENGTH);
	
	// PRIMA COSA: Ricezione della lunghezza del comando
	ret = recv(sckt, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(4);
	int_length = ntohs(length);
	
	// SECONDA COSA: Ricezione del comando
	ret = recv(sckt, (void*)buffer, int_length, 0);
    if(ret < 0) 
    	gestione_errori(4);
	
	// TERZA COSA: Esecuzione della richiesta da parte del client, se valida
	if(strncmp(buffer, "REQUESTPING", 11) == 0) {
        ping();
    }
	else if(strncmp(buffer, "MESSAGE", 7) == 0 && sckt != server_socket) {
		// Gestione ricezione messaggi
		
	    memset(&buffer, 0, BUFFER_LENGTH);
	    memset(&buffer2, 0, BUFFER_LENGTH);
	
		// Per prima cosa ricevo lunghezza del messaggio
		ret = recv(sckt, (void*)&length, sizeof(uint16_t), 0);
    	if(ret < 0) 
    		gestione_errori(4);
		int_length = ntohs(length);
	
		// SECONDA COSA: Ricezione del comando
		ret = recv(sckt, (void*)buffer, int_length, 0);
    	if(ret < 0) 
    		gestione_errori(4);
    		
        pointer = controllo_presenza_connessione_socket(sckt);
		
		nuovo_messaggio_peer(buffer, user, pointer->username, 1);
		 
		// Si stampa il messaggio se il peer sta tenendo aperta la chat col mittente del messaggio
		if(chat_aperta != NULL && sckt == chat_aperta->socket) 
            printf("%s\n", buffer);
            
        if(status_chat_gruppo.first_pointer != NULL && (status_chat_gruppo.first_pointer)->socket != sckt) {
            // Ogni invio diverso da un comando e' trattato come un messaggio da inviare al destinatario
            memset(&buffer2, 0, sizeof(buffer2));
	        strcpy(buffer2, "MESSAGE");
	        
	        // Invio la lunghezza del comando (che pongo in big endian per la rete)
	        int_length = strlen(buffer2);
	        length = htons(int_length);

            ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&buffer2, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
   	        
            // Invio la lunghezza del messaggio (che pongo in big endian per la rete)
	        int_length = strlen(buffer);
	        length = htons(int_length);

            ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send((status_chat_gruppo.first_pointer)->socket, (void*)&buffer, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
        }
        if(status_chat_gruppo.second_pointer != NULL && (status_chat_gruppo.second_pointer)->socket != sckt) {
            // Ogni invio diverso da un comando e' trattato come un messaggio da inviare al destinatario
            memset(&buffer2, 0, sizeof(buffer2));
	        strcpy(buffer2, "MESSAGE");
	        
	        // Invio la lunghezza del comando (che pongo in big endian per la rete)
	        int_length = strlen(buffer2);
	        length = htons(int_length);

            ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&buffer2, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
   	        
            // Invio la lunghezza del messaggio (che pongo in big endian per la rete)
	        int_length = strlen(buffer);
	        length = htons(int_length);

            ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
            
            // Invio il comando
            ret = send((status_chat_gruppo.second_pointer)->socket, (void*)&buffer, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
        }
	}
	else if(strncmp(buffer, "JOINGROUP", 9) == 0 && sckt != server_socket) {
	    memset(&buffer, 0, BUFFER_LENGTH);
	    
        if(status_chat_gruppo.first_pointer == NULL)
            strcpy(buffer, "APPROVED");
        else 
            strcpy(buffer, "REJECTED"); 
            
	    int_length = strlen(buffer);
	    length = htons(int_length);
	
        ret = send(sckt, (void*)&length, sizeof(uint16_t), 0);
        if(ret < 0)
    	    gestione_errori(4);

        ret = send(sckt, (void*)&buffer, int_length, 0);
        if(ret < 0)
    	    gestione_errori(4);       
    }
	else if(strncmp(buffer, "SHARE", 5) == 0 && sckt != server_socket) {
         memset(&buffer, 0, BUFFER_LENGTH); 
         memset(&buffer_file, 0, BUFFER_LENGTH*10); 
         pointer = controllo_presenza_connessione_socket(sckt);
 
         strcpy(buffer, "FILE_");
         strcat(buffer, user);
         strcat(buffer, "_");
         strcat(buffer, pointer->username);
         
         f = fopen(buffer, "wb"); 
         if(f > 0) {
              printf("File aperto\n"); 
              
              while(1) {
                  printf("Prericezione lunghezza frammento\n");
                  
                  // Per prima cosa ricevo lunghezza del frammento
		          ret = recv(sckt, (void*)&length, sizeof(uint16_t), 0);
    	          if(ret < 0) 
    		          gestione_errori(4);
		          int_length = ntohs(length);
		          
		          if(int_length == 0)
                      break;
		          
	              printf("Lunghezza frammento: %i\n", int_length);
	              
		          // SECONDA COSA: Ricezione del framemento
		          ret = recv(sckt, (void*)buffer_file, int_length, 0);
    	          if(ret < 0) 
    		          gestione_errori(4);
                   
                  fwrite(buffer_file, int_length, 1, f);
                  
                  printf("Post fwrite\n");
              }
              fclose(f);
              printf("[HAI RICEVUTO UN NUOVO FILE]\n");
         }
	}
	else if(strncmp(buffer, "OLDMESSAGESSENT", 15) == 0 && sckt == server_socket) {
        // ACK cumulativo: il server segnala al peer che i messaggi che aveva inviato a un certo peer sono stati recapitati
        
        memset(&buffer, 0, BUFFER_LENGTH);
	
		// Per prima cosa ricevo lunghezza dell'username del peer
		ret = recv(sckt, (void*)&length, sizeof(uint16_t), 0);
    	if(ret < 0) 
    		gestione_errori(4);
		int_length = ntohs(length);
	
		// SECONDA COSA: Ricezione dell'username del peer 
		ret = recv(sckt, (void*)buffer, int_length, 0);
    	if(ret < 0) 
    		gestione_errori(4);
   		
   		printf("Username coinvolti: first %s, second %s\n", buffer, user);
   		sposta_chat(user, buffer);
    }
}

void comando_client_out() {
    // Si chiude la connessione con close, il server ne prende atto col risveglio della primitiva select
    // Lato server viene lanciata la funzione funzione_socket_comunicazione, nel primo recv si prende atto della cosa
    // e si lancia un'ulteriore funzione per aggiornare le strutture dati    	
   	close(server_socket);
    
	printf("Disconessione effettuata con successo.\n");
	exit(0);
}

struct connessione_peer* controllo_presenza_connessione_username(const char* username) {
    // Funzione per verificare la presenza di connessioni TCP precedentemente stabilite
    // Se c'e' corrispondenza con l'username si restituisce il puntatore all'elemento
    // Altrimenti si restituisce un puntatore a NULL
    struct connessione_peer* pointer = lista_connessioni_peer;
      
    while(pointer != NULL) {
        if(strcmp(username, pointer->username) == 0)
            break;
         
        pointer = pointer->next;      
    }   
    
    return pointer;              
}

struct connessione_peer* controllo_presenza_connessione_socket(const int socket) {
    struct connessione_peer* pointer = lista_connessioni_peer;
      
    while(pointer != NULL) {
        if(pointer->socket == socket)
            break;
         
        pointer = pointer->next;      
    }   
    
    return pointer;      
}
 
void inserimento_connessione_peer(const char* username, int socket, int port_number) {
	if(lista_connessioni_peer == NULL) {	
    	lista_connessioni_peer = (void*)malloc(sizeof(struct connessione_peer));
    	fine_lista_connessioni_peer = lista_connessioni_peer;
    		
    	strcpy((lista_connessioni_peer)->username, username);
    	(lista_connessioni_peer)->socket = socket;
    	(lista_connessioni_peer)->port_number = port_number;
    	(lista_connessioni_peer)->next = NULL;  
	}
	else {
    	(fine_lista_connessioni_peer)->next = (void*)malloc(sizeof(struct connessione_peer));
    	fine_lista_connessioni_peer = (fine_lista_connessioni_peer)->next;
    		
    	strcpy((fine_lista_connessioni_peer)->username, username);
    	(fine_lista_connessioni_peer)->socket = socket;
    	(fine_lista_connessioni_peer)->port_number = port_number;
    	(fine_lista_connessioni_peer)->next = NULL;  
	}	
}

int controlla_status_peer(const char* username) {
	// La funzione seguente si rivolge al server per chiedere delucidazioni sullo stato di un peer
	// Si invia il comando CLIENTCHAT|<username> al server
	// Il server risponde con un CHATACK (utente online) o con CHATOFFLINE (utente offline)
	// Se l'utente e' online si restituisce la porta indicata dal server, altrimenti si restituisce 0. 
	// Si restituisce -1 se il server segnala l'inesistenza dell'utente
	
	int int_length, ret;
	uint16_t length;
	char buffer[BUFFER_LENGTH];
	char* pointer;

    memset(&buffer, 0, sizeof(buffer));
	strcpy(buffer, "CLIENTCHAT|");
	strcat(buffer, username);

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(buffer);
	length = htons(int_length);

    ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
	
    // Invio il comando
    ret = send(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
     
    // Attesa di ACK, per sapere come muoversi. Prima ricevo la lunghezza e poi l'ACK (o il segnale di errore)
    memset(&buffer, 0, sizeof(buffer));
    ret = recv(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(5);
	int_length = ntohs(length);

    ret = recv(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(5);

	if(strncmp(buffer, "CHATACK", 7) == 0) {
		pointer = strtok(buffer, "|");
		pointer = strtok(NULL, "|");

		return atoi(pointer); // Pongo la stringa in intero
	}
	else if(strncmp(buffer, "CHATOFFLINE", 11) == 0) {
		return 0;
	}
	else if(strncmp(buffer, "UNKOWNPEER", 10) == 0) {
        return -1;
    }
    else {
        return -1;     
    } 
}

void ping() {
	// La funzione viene lanciata per aggiornare il timestamp_ping nel server
	// Potrebbe essere lanciata dal client a seguito di richiesta del server
	int int_length, ret;
	uint16_t length;
	char buffer[BUFFER_LENGTH];

    memset(&buffer, 0, sizeof(buffer));
	strcpy(buffer, "CLIENTPING");

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(buffer);
	length = htons(int_length);

    ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
    	
    // Invio il comando
    ret = send(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
}

void comando_client_hanging() {
    // Richiediamo al server l'elenco dei peer che hanno inviato messaggi mentre eravamo offline
    // Per ogni peer si indica username, numero di messaggi pendenti e timestamp del piu' recente
    int int_length, ret;
	uint16_t length;
	char buffer[BUFFER_LENGTH];

    memset(&buffer, 0, sizeof(buffer));
	strcpy(buffer, "REQUESTHANGING|");

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(buffer);
	length = htons(int_length);

    ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
    	
    // Invio il comando
    ret = send(server_socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
   	
    memset(&buffer, 0, sizeof(buffer));
    	
   	// Ricevo lunghezza del messaggio di risposta
    ret = recv(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(4);
	int_length = ntohs(length);
	
	// Ricevo messaggio di risposta
	ret = recv(server_socket, (void*)buffer, int_length, 0);
    if(ret < 0) 
    	gestione_errori(4);
    
    if(strcmp(buffer, "NOMESSAGES") == 0) {
        system("clear");
        printf("Non hai messaggi in attesa di essere scaricati\n");
        output_client_comandi(1);
    }
    else {
        system("clear");
        printf("*************************** HANGING *******************************\n");
        printf("Messaggi inviati mentre il peer era offline\n\n"); 
        
        printf("%s", buffer); // Stampo il messaggio, che risulta gia' formattato dal server
    }    
} 

void comando_client_chat() {
    int peer_socket, ret;
    struct sockaddr_in peer_addr;
	char username[USERNAME_LENGTH];
	int port, int_length;
	uint16_t length;
	
	// PRIMA COSA: Indicare l'utente con cui si vuole aprire la chat
	system("clear");
	printf("*************************** APERTURA CHAT *******************************\n");
	printf("Indicare l'username della persona che si vuole contattare:");
	memset(&username, 0, sizeof(username));
	fgets(username, USERNAME_LENGTH, stdin);

	username[strcspn(username, "\n")] = '\0';
	
	if(strcmp(user, username) == 0) {
        system("clear");
        printf("Non e' possibile aprire una chat con se stessi.\n");
        output_client_comandi(1); 
        return;
    }
    
    // Per prima cosa verifico se la connessione e' gia stata stabilita precedentemente
    chat_aperta = controllo_presenza_connessione_username(username);
    
    // Se il puntatore restituito e' nullo significa che la connessione TCP deve essere stabilita
    if(chat_aperta == NULL) {
        // Contatto il server per verificare lo stato del peer   
        // Se la connessione puo' essere stabilita la funzione controlla_status_peer restituisce il num. di porta
        // Se il peer e' offline viene restituito zero
	    // Se il peer e' inesistente viene restituito -1
	    port = controlla_status_peer(username);
	
	    if(port == -1) {
            // Non esistono peer con l'username indicato, si esce dalla chat
            system("clear");
            printf("L'utente %s non esiste\n", username);
            output_client_comandi(1);   
            return;     
        }
        else if(port == 0) {
            // Si crea una nuova connessione nella lista, ma si pongono porta e fd uguali a -1
            // Chiaramente se si arriva qua esiste un peer con l'username indicato
            inserimento_connessione_peer(username, -1, -1);
   	        chat_aperta = fine_lista_connessioni_peer;
        }
        else {
            // Andiamo a stabilire la connessione TCP
	        peer_socket = socket(AF_INET, SOCK_STREAM, 0);
            if(peer_socket < 0)
    	        gestione_errori(2);

            memset(&peer_addr, 0, sizeof(peer_addr));
            peer_addr.sin_family = AF_INET;
            peer_addr.sin_port = htons(port);
            inet_pton(AF_INET, "127.0.0.1", &peer_addr.sin_addr);

            ret = connect(peer_socket, (struct sockaddr*)&peer_addr, sizeof(peer_addr));
            if(ret < 0)
    	        gestione_errori(3);
   	        
            // Invio la lunghezza dell'username (che pongo in big endian per la rete)
	        int_length = strlen(user);
	        length = htons(int_length);

            ret = send(peer_socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
    	        gestione_errori(4);
    	
            // Invio l'username
            ret = send(peer_socket, (void*)&user, int_length, 0);
            if(ret < 0)
    	        gestione_errori(4);
    	        
    	    FD_SET(peer_socket, &master); 
	        if(peer_socket > fdmax){ 
                fdmax = peer_socket; 
	        } 
    	        
   	        // Memorizzo la connessione TCP nell'apposita lista   	  
   	        inserimento_connessione_peer(username, peer_socket, port);
   	        inserisci_in_rubrica(user, username);
   	        chat_aperta = fine_lista_connessioni_peer;
        }    
    }
    else if(chat_aperta->socket == -1 && chat_aperta->port_number == -1) {
         // La chat e' stata aperta precedentemente, ma il peer era offline
         // Si controlla se e' possibile stabilire la connessione
         // Non faccio niente se l'username non esiste (cosa impossibile se si arriva qua) o se il peer e' ancora offline
         port = controlla_status_peer(username);
	     
         if(port > 0) {
             // Andiamo a stabilire la connessione TCP
	         peer_socket = socket(AF_INET, SOCK_STREAM, 0);
             if(peer_socket < 0)
     	         gestione_errori(2);

             memset(&peer_addr, 0, sizeof(peer_addr));
             peer_addr.sin_family = AF_INET;
             peer_addr.sin_port = htons(port);
             inet_pton(AF_INET, "127.0.0.1", &peer_addr.sin_addr);

             ret = connect(peer_socket, (struct sockaddr*)&peer_addr, sizeof(peer_addr));
             if(ret < 0)
    	         gestione_errori(3);
   	        
             // Invio la lunghezza dell'username (che pongo in big endian per la rete)
	         int_length = strlen(user);
	         length = htons(int_length);

             ret = send(peer_socket, (void*)&length, sizeof(uint16_t), 0);
             if(ret < 0)
    	         gestione_errori(4);
    	
             // Invio l'username
             ret = send(peer_socket, (void*)&user, int_length, 0);
             if(ret < 0)
    	         gestione_errori(4);
    	        
    	     FD_SET(peer_socket, &master); 
	         if(peer_socket > fdmax){ 
                 fdmax = peer_socket; 
	         } 
    	        
 	         // Aggiorno la struttura
 	         chat_aperta->socket = peer_socket;
 	         chat_aperta->port_number = port;
         }    
    }

    // Se si arriva qui saltando le righe precedenti significa che la connessione TCP e' gia' stata aperta
    // Se la connessione TCP e' gia stata aperta si suppone che l'username indicato sia valido (altrimenti la conn. non sarebbe presente)
    // La consistenza della connessione e' verificata nell'invio dei messaggi, si prevede invio di ACK ad ogni messaggio
    // Se recv restituisce zero significa che l'altro peer si e' disconnesso, in quel caso i messaggi saranno inviati al server
    carica_chat(user, username);
} 

void comando_client_show() {
    int ret, int_length;
	uint16_t length;
	char username[USERNAME_LENGTH];
	char comando[COMMAND_LENGTH + USERNAME_LENGTH];
	char* buffer; 
	
	// PRIMA COSA: Indicare l'utente con cui si vuole aprire la chat
	system("clear");
	printf("*************************** APERTURA CHAT *******************************\n");
	printf("Indicare l'username della peer di cui si vuole ricevere i messaggi:");
	memset(&username, 0, sizeof(username));
	fgets(username, USERNAME_LENGTH, stdin);

	username[strcspn(username, "\n")] = '\0';
	
	if(strcmp(user, username) == 0) {
        system("clear");
        printf("Non e' possibile richiedere i messaggi di se stessi.\n");
        output_client_comandi(1); 
        return; 
    }     
    
    memset(&comando, 0, sizeof(buffer));
	strcpy(comando, "REQUESTMESSAGES|");
	strcat(comando, username);

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(comando);
	length = htons(int_length);

    ret = send(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
    	
    // Invio il comando
    ret = send(server_socket, (void*)&comando, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
   	
    memset(&buffer, 0, sizeof(buffer));
    	
   	// Ricevo lunghezza del messaggio di risposta
    ret = recv(server_socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0) 
    	gestione_errori(4);
	int_length = ntohs(length);
	
	// Considerando la lunghezza del messaggio alloco dinamicamente un buffer
	// Necessario perche' i messaggi arretrati potrebbero portarmi ad avere un numero consistente di messaggi
	buffer = (void*)malloc(int_length);
	
	// Ricevo messaggio di risposta
	ret = recv(server_socket, (void*)buffer, int_length, 0);
    if(ret < 0) 
    	gestione_errori(4);
    
    if(strcmp(buffer, "NOTHING") == 0) {
        system("clear");
        printf("Non c'e' nulla da scaricare per quanto riguarda il peer indicato.\n");
        output_client_comandi(1);
        return;
    }
    else {
         // Inserisco in blocco i messaggi nel file di testo
         inserisci_in_rubrica(user, username);
         nuovo_messaggio_peer(buffer, user, username, 1);
    }    
    
    system("clear");
    printf("I messaggi del peer %s sono scaricati con successo\n", username);
    output_client_comandi(1); 
    
    free(buffer); // disalloco il buffer, ho finito
} 

void carica_chat(const char* first_user, const char* second_user) {
	// I messaggi tra due utenti sono memorizzati in file aventi nome "inviati_<FIRST_USER>_<SECOND_USER>.txt" e "pendenti_<FIRST_USER>_<SECOND_USER>.txt"
	// Si aprono i file con lo scopo di recuperare il contenuto della chat
	// I messaggi sono uno per riga, quindi basta scorrere le righe. Carico prima i messaggi effettivamente inviati e poi e quelli pendenti
	
	FILE* f; 
    char* res;
    char buffer[BUFFER_LENGTH];
    char nome_file1[USERNAME_LENGTH*2 + 10];
    char nome_file2[USERNAME_LENGTH*2 + 10];
    
	memset(&buffer, 0, sizeof(buffer));
	memset(&nome_file1, 0, sizeof(nome_file1));
	memset(&nome_file2, 0, sizeof(nome_file2));

	// Creo il nome del primo file
	strcpy(nome_file1, "inviati_");
	strcat(nome_file1, first_user);
	strcat(nome_file1, "_");
	strcat(nome_file1, second_user);
	strcat(nome_file1, ".txt");

	// Creo il nome del secondo file
	strcpy(nome_file2, "pendenti_");
	strcat(nome_file2, first_user);
	strcat(nome_file2, "_");
	strcat(nome_file2, second_user);
	strcat(nome_file2, ".txt");

	system("clear"); 
	printf("***************************** CHAT *********************************\n");
	printf("Interlocuzione tra %s e %s\n\n", first_user, second_user);
	
	f = fopen(nome_file1, "r");
	if(f == NULL) {
         f = fopen(nome_file1, "a");
         fclose(f);
    }
    else if(f > 0) {
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
        	if(res == NULL)
        		break; 
        		
        	printf("** %s", buffer);
        }
        fclose(f);
    }
  
    f = fopen(nome_file2, "r");
    if(f == NULL) {
         f = fopen(nome_file2, "a");
         fclose(f);
    }
    else if(f > 0) {
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
        	if(res == NULL)
        		break; 
        		
        	printf("* %s", buffer);
        }
        fclose(f);
    }
}

void nuovo_messaggio_peer(const char* message, const char* first_user, const char* second_user, int delivered) {
    char nome_file[USERNAME_LENGTH*2 + 10];
	FILE* f; 
	
    memset(&nome_file, 0, sizeof(nome_file));
    	
    if(delivered == 1)
        strcpy(nome_file, "inviati_");
    else
        strcpy(nome_file, "pendenti_");
        
    strcat(nome_file, first_user);
	strcat(nome_file, "_");
	strcat(nome_file, second_user);
	strcat(nome_file, ".txt");
		
	f = fopen(nome_file, "a");
	fprintf(f, "%s\n", message);
	fclose(f);
}

void sposta_chat(const char* first_user, const char* second_user) {
    // I messaggi pendenti sono spostati nel file dei messaggi ricevuti
    FILE* f1;
    FILE* f2;
    char nome_file1[USERNAME_LENGTH*2 + 10];
    char nome_file2[USERNAME_LENGTH*2 + 10];
    char buffer[BUFFER_LENGTH];
    char* res;

	memset(&buffer, 0, sizeof(buffer));
	memset(&nome_file1, 0, sizeof(nome_file1));
	memset(&nome_file2, 0, sizeof(nome_file2));

	// Creo il nome del primo file
	strcpy(nome_file1, "inviati_");
	strcat(nome_file1, first_user);
	strcat(nome_file1, "_");
	strcat(nome_file1, second_user);
	strcat(nome_file1, ".txt");
    
	// Creo il nome del secondo file
	strcpy(nome_file2, "pendenti_");
	strcat(nome_file2, first_user);
	strcat(nome_file2, "_");
	strcat(nome_file2, second_user);
	strcat(nome_file2, ".txt");
         
    f1 = fopen(nome_file2, "r");
    f2 = fopen(nome_file1, "a");
    
    while((res = fgets(buffer, BUFFER_LENGTH, f1)) > 0) {
       	if(res == NULL)
       		break; 
  		
       	fprintf(f2, "%s", buffer);
    }
 
    fclose(f2);
    fclose(f1);
    
    svuota_chat(first_user, second_user, 0); 
} 

void svuota_chat(const char* first_user, const char* second_user, int delivered) {
    char nome_file[USERNAME_LENGTH*2 + 10];
	
    memset(&nome_file, 0, sizeof(nome_file));
    	
    if(delivered == 1)
        strcpy(nome_file, "inviati_");
    else
        strcpy(nome_file, "pendenti_");
        
    strcat(nome_file, first_user);
	strcat(nome_file, "_");
	strcat(nome_file, second_user);
	strcat(nome_file, ".txt");
		
	fclose(fopen(nome_file, "w"));
} 

void inserisci_in_rubrica(const char* owner, const char* new) {
    FILE* f;
    char nome_file[USERNAME_LENGTH + 10];
    char buffer[BUFFER_LENGTH];
    char* res;
    int duplicato;
    
    memset(&buffer, 0, sizeof(buffer));
   	memset(&nome_file, 0, sizeof(nome_file));

	// Creo il nome del primo file
	strcpy(nome_file, "rubrica");
	strcat(nome_file, "_");
	strcat(nome_file, owner);
	strcat(nome_file, ".txt");
	duplicato = 0;
	
    f = fopen(nome_file, "a+");
    if(f > 0) {
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
            if(strncmp(buffer, new, strlen(new)) == 0) {
                duplicato = 1; 
                break;
            }
        }
        
        if(duplicato == 0) 
            fprintf(f, "%s\n", new);
            
        fclose(f);
    }
} 

void carica_rubrica(const char* owner) {
    // I messaggi pendenti sono spostati nel file dei messaggi ricevuti
    FILE* f;
    char nome_file[USERNAME_LENGTH + 10];
    char buffer[BUFFER_LENGTH];
    char* res;

	memset(&buffer, 0, sizeof(buffer));
	memset(&nome_file, 0, sizeof(nome_file));

	// Creo il nome del primo file
	strcpy(nome_file, "rubrica");
	strcat(nome_file, "_");
	strcat(nome_file, owner);
	strcat(nome_file, ".txt");
 
    f = fopen(nome_file, "r");
    if(f == NULL) {
         f = fopen(nome_file, "a");
         fclose(f);
         
         printf("[AVVISO: Non sono presenti contatti in rubrica]\n");
    }
    else if(f > 0) {
        printf("[INIZIO RUBRICA]\n");
        while((res = fgets(buffer, BUFFER_LENGTH, f)) > 0) {
       	   if(res == NULL)
       	       break; 
  		
       	   printf("%s", buffer);
        }
        fclose(f);
        printf("[FINE RUBRICA]\n");
    }
}

void comando_client_share() {
    FILE* f;
    char username[USERNAME_LENGTH];
    char file[BUFFER_LENGTH];
    char buffer[BUFFER_LENGTH*10];
    int int_length;
    uint16_t length;
    struct connessione_peer* pointer;
    int res, ret;
    
   	// PRIMA COSA: Indicare l'utente con cui si vuole aprire la chat
	system("clear");
	printf("************************ CONDIVISIONE FILE (1/2) ****************************\n");
	printf("Indicare l'username del peer con cui si vuole condividere il file:");
	memset(&username, 0, sizeof(username));
	fgets(username, USERNAME_LENGTH, stdin);

	username[strcspn(username, "\n")] = '\0';
	
	if(strcmp(user, username) == 0) {
        system("clear");
        printf("Non e' possibile condividere un file con se stessi.\n");
        output_client_comandi(1); 
        return;
    }
    
    // Il file sharing e' possibile solo con peer online, con cui siamo gia' connessi (noi che scriviamo chat o noi che accettiamo la connessione)
    pointer = controllo_presenza_connessione_username(username); 
    
    if(pointer == NULL || pointer->socket == -1) {
        system("clear");
        printf("Non esistono peer con l'username indicato, oppure non e' stata aperta una chat col peer precedentemente\n");
        output_client_comandi(1);         
        return;  
    }
    
    // SECONDA COSA: Indicare il file da condividere
	system("clear");
	printf("************************ CONDIVISIONE FILE (2/2) ****************************\n");
	printf("Indicare il file che si vuole condividere con %s:", username);
	memset(&file, 0, sizeof(file));
	fgets(file, BUFFER_LENGTH, stdin);

	file[strcspn(file, "\n")] = '\0';
    
    // Se si arriva qua la connessione col peer e' stata stabilita, e si procede ad inviare il file
    // Prima comando con cui avvertiamo il client, poi il file (diviso in blocchi da mille bit)
    // Si manda alla fine un comando END per segnalare che abbiamo trasmesso tutti i blocchi 
    
    memset(&buffer, 0, sizeof(buffer));
	strcpy(buffer, "SHARE");

	// Invio la lunghezza del comando (che pongo in big endian per la rete)
	int_length = strlen(buffer);
	length = htons(int_length);

    ret = send(pointer->socket, (void*)&length, sizeof(uint16_t), 0);
    if(ret < 0)
    	gestione_errori(4);
    	
    // Invio il comando
    ret = send(pointer->socket, (void*)&buffer, int_length, 0);
    if(ret < 0)
    	gestione_errori(4);
   	
    memset(&buffer, 0, BUFFER_LENGTH*10);
    
    f = fopen(file, "r");
    if(f > 0) {
        while((res = fread(buffer, 1, sizeof(buffer), f)) > 0) {
            // Invio la lunghezza del comando (che pongo in big endian per la rete)
	        length = htons(res);
            
            ret = send(pointer->socket, (void*)&length, sizeof(uint16_t), 0);
            if(ret < 0)
                gestione_errori(4);
   	        
            // Invio il comando
            ret = send(pointer->socket, (void*)&buffer, int_length, 0);
            if(ret < 0)
                gestione_errori(4);
        }
        
	    length = htons(0);
        ret = send(pointer->socket, (void*)&length, sizeof(uint16_t), 0);
        if(ret < 0)
    	    gestione_errori(4);
    	    
        fclose(f);
        
        system("clear");
        printf("Il file e' stato inviato con successo!\n");
        output_client_comandi(1);
    }
}

void gestione_errori(int error) {
	switch (error) {
		case 0: 
		printf("Non e' stata indicata la porta del device (parametro obbligatorio).");
 		exit(0);
 		case 1:
 		printf("Errore: comando inserito non riconosciuto. Riprovare!\n");
 		break;
 		case 2:
		perror("Errore nella creazione del socket: ");
 		exit(0);
 		case 3:
		perror("Errore nella connessione col server (funzione connect): ");
 		exit(0);
 		case 4:
		perror("Errore nella funzione send: ");
 		exit(0);
 		case 5:
		perror("Errore nella funzione receive: ");
 		exit(0);
		case 6: 
		perror("Errore con la funzione bind: ");
 		exit(0);
 		case 7:
 		printf("Errore: comando inserito non riconosciuto. Riprovare!\n");
 		break;
 		case 8:
 		perror("Errore con la funzione accept: ");
 		exit(0);
		default: 
		printf("Errore.");
		break;
	}	
}
