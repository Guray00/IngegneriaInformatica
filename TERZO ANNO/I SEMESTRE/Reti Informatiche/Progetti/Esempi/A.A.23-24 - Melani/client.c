#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#define DIM_BUFFER 1024
#define DIM_CMD 10
#define DIM_ACK 6

int accesso_eseguito=0;
int partita_iniziata=0;
int getn_usata=0;
int listener, socket_server, fdmax, ret, mio_num, num_ricevuto;
fd_set master, read_fds;
struct sockaddr_in getn_addr;

void recv_msg(int sd, char* buffer);
void send_msg(int sd, char* buffer);
void gestione_start();
void gestione_accesso();
void stampa_comandi_partita();
void gestione_comandi_partita();
void gestione_listener();
void gestione_ack(char *ack);
void check_win();

int main(int argc, char* argv[]){
    struct sockaddr_in sv_addr, my_addr;
    int port, sv_port=4242, i;
    char buffer[DIM_BUFFER];

    if(argc>1)
		port=atoi(argv[1]); 

    //creazione e messa in ascolto del socket verso gli altri host
    listener=socket(AF_INET, SOCK_STREAM, 0);
    memset(&my_addr, 0, sizeof(my_addr));
    my_addr.sin_family=AF_INET;
    my_addr.sin_port=htons(port);
    inet_pton(AF_INET, "127.0.0.1", &my_addr.sin_addr);

	ret=bind(listener, (struct sockaddr*) &my_addr, sizeof(my_addr));
	if(ret==-1){
		perror("Error: ");
		exit(1);
		}
	ret=listen(listener, 5);
        if(ret==-1){
            perror("Error: ");
            exit(1);
        }

    //creazione e connessione del socket di comunicazione con il server
    socket_server=socket(AF_INET, SOCK_STREAM, 0);
    if(socket_server<0){
        perror("Error: ");
		exit(1);
    }
    memset(&sv_addr, 0, sizeof(sv_addr));
	sv_addr.sin_family=AF_INET;
	sv_addr.sin_port=htons(sv_port);
	inet_pton(AF_INET, "127.0.0.1", &sv_addr.sin_addr);
    ret=connect(socket_server, (struct sockaddr*)&sv_addr, sizeof(sv_addr));
    if(ret==-1){
            perror("Error: ");
            exit(1);
        }
    //dopo aver connesso il socket di comunicazione con il server invio l'indirizzo a cui sarò contattato dagli altri socket
    inet_ntop(AF_INET, (void*)&my_addr.sin_addr, buffer, INET_ADDRSTRLEN);
    sprintf(buffer+strlen(buffer), " %d", port);
    send_msg(socket_server, buffer);
	//Inizializzazione dei set di file descriptor e della variabile fdmax per la funzione select
 	FD_ZERO(&master);
 	FD_ZERO(&read_fds);
 	FD_SET(0, &master); //standard input ha FD 0
 	FD_SET(listener, &master);
    FD_SET(socket_server, &master);
    if(listener>socket_server)
 	    fdmax = listener;
    else 
        fdmax=socket_server;   
    //l'utente deve innanzitutto effettuare il signup/login
    while(accesso_eseguito==0)
        gestione_accesso();

    //poi deve avviare la partita
    while(partita_iniziata==0)
        gestione_start();

    //ora posso gestire tutto il resto
    while(partita_iniziata==1){
        read_fds=master;

        ret=select(fdmax+1, &read_fds, NULL, NULL, NULL);
        if(ret < 0){
			perror("Errore: ");
			exit(1);
		}
        for(i=0; i<=fdmax; i++){
            if(FD_ISSET(i, &read_fds)){
                if(i==listener)
                    gestione_listener(); //listener
                else
                    if(i==0)
                        gestione_comandi_partita(); //stdin
            }
        }
    }
    return 0;
}

void recv_msg(int sd, char* buffer){
    int len;
	uint16_t lmsg;
    ret=recv(sd, (void*)&lmsg, sizeof(uint16_t), 0);
	if(ret==-1){
                perror("Errore: ");
                exit(1);
    }
	len=ntohs(lmsg);
    ret=recv(sd, (void*)buffer, len, 0);
    if(ret==-1){
        perror("Errore: ");
        exit(1);
    }
}

void send_msg(int sd, char* buffer){
    int len;
    uint16_t lmsg;
	len=strlen(buffer)+1;
	lmsg=htons(len);

    ret=send(sd, (void*)&lmsg, sizeof(uint16_t), 0);
	if(ret==-1){
		perror("Errore: ");
		exit(1);
		}
    ret=send(sd, (void*)buffer, len, 0);
    if(ret==-1){
        perror("Errore: ");
        exit(1);
    }
}

void gestione_accesso(){
    char buffer[DIM_BUFFER];
    char username[100];
    char password[100];
    strcpy(username, "\0");
    strcpy(password, "\0");
    char cmd[DIM_CMD];
    printf("Digita <<login username password>> se sei già registrato.\nAltrimenti registrati con <<signup username password>>.\n");
    fgets(buffer, DIM_BUFFER, stdin);
    sscanf(buffer, "%s %s %s", cmd, username, password);
    if(strcmp(cmd, "login")==0 || strcmp(cmd, "signup")==0){
        if(strlen(username)==0 || strlen(password)==0){
            printf("Credenziali non inserite\n\n");
            return;
        }
        send_msg(socket_server, buffer);
    }
    else{
        printf("Comando non valido.\n\n");
        return;
    }
    //se sono arrivato a questo punto significa che l'input era valido e posso gestire la risposta del server
    memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
    recv_msg(socket_server, buffer);
    gestione_ack(buffer);
}

void gestione_start(){
    char buffer[DIM_BUFFER];
    char cmd[DIM_CMD];
    printf("Stanze disponibili:\n1-Il laboratorio di Laputa\n");
    printf("Digita <<start>> seguito dal numero di stanza che vuoi avviare.\n");
    fgets(buffer, DIM_BUFFER, stdin);
    sscanf(buffer, "%s", cmd);
    if(strcmp(cmd, "start")==0){
        send_msg(socket_server, buffer);
    }
    else{
        printf("Comando non valido.\n\n");
        return;
    }
    memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
    recv_msg(socket_server, buffer);
    gestione_ack(buffer);
}

void stampa_comandi_partita(){
    printf("Comandi validi:\n-look [oggetto|location]\n-take <oggetto>\n-use <oggetto>\n-getn <username di un altro utente>\n-objs\n-end\n");
}

//la funzione controlla che il comando inserito sia valido, lo invia al server, si mette in attesa della risposta e con la funzione gestione_ack() agisce di conseguenza
void gestione_comandi_partita(){
    char buffer[DIM_BUFFER];
    char cmd[DIM_CMD];
    fgets(buffer, DIM_BUFFER, stdin);
    sscanf(buffer, "%s", cmd);
    if(strcmp(cmd, "look")==0){
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    if(strcmp(cmd, "take")==0){
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    if(strcmp(cmd, "use")==0){
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    //la funzione getn può essere usata al massimo una volta per partita
    if(strcmp(cmd, "getn")==0){
        if(getn_usata==1){
            printf("La funzione getn può essere utilizzata soltanto una volta a partita\n");
            return;
        }
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    if(strcmp(cmd, "objs")==0){
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    if(strcmp(cmd, "drop")==0){
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    if(strcmp(cmd, "end")==0){
        send_msg(socket_server, buffer);
        memset(buffer, 0, DIM_BUFFER); //pulisco il buffer
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    //se arrivo a questo punto significa che il comando non era valido
    printf("Comando non valido.\n");
    stampa_comandi_partita();
}

void ricevi_info(){
    char buffer[DIM_BUFFER];
    time_t tempo_rimanente;
    int token, token_mancanti;
    int min, sec;
    recv_msg(socket_server, buffer);
    sscanf(buffer, "%d %d %lld", &token, &token_mancanti, (long long*)&tempo_rimanente);
    min=tempo_rimanente/60;
    sec=tempo_rimanente%60;
    printf("\nStato partita:\n");
    printf("Tempo rimanente %d minuti e %d secondi\nToken ottenuti %d\nToken mancanti %d\n\n", min, sec, token, token_mancanti);
}

void gestione_ack(char *ack){
    char buffer[DIM_BUFFER];
    //username non corretto nel login
    if(strcmp(ack, "NOUSR")==0){
        printf("\nUsername non trovato\n");
        return;
    }
    //password errata
    if(strcmp(ack, "ERPWD")==0){
        printf("\nPassword errata\n");
        return;
    }
    //login effettuato correttamente
    if(strcmp(ack, "OKUSR")==0){
        printf("\nLogin effettuato con successo\n");
        accesso_eseguito=1;
        return;
    }
    //l'utente prova a fare signup con un username già esistente
    if(strcmp(ack, "EXUSR")==0){
        printf("\nSignup fallita, username già esistente\n");
        return;
    }
    //signup corretto
    if(strcmp(ack, "CRUSR")==0){
        printf("\nAccount creato con successo\n");
        accesso_eseguito=1;
        return;
    }
    //start corretto
    if(strcmp(ack, "OKSTA")==0){
        partita_iniziata=1;
        printf("\nPartita avviata\n");
        //ricevo la descrizione generale della room
        recv_msg(socket_server, buffer);
        //prima faccio il parsing del numero relativo alla mia stanza e poi stampo la descrizione della partita
        sscanf(buffer, "%d", &mio_num);
        printf("\n%s\n", buffer+sizeof(int)); //dall'inizio del buffer ho un intero e poi la stringa
        stampa_comandi_partita();
        //ricevo le informazioni sulla partita
        ricevi_info();
        return;
    }
    //parametro di start incorretto
    if(strcmp(ack, "NOSTA")==0){
        printf("\nStanza selezionata non valida\n");
        return;
    }
    //look corretta, ricevo la descrizione
    if(strcmp(ack, "DESCR")==0){
        recv_msg(socket_server, buffer);
        printf("\n%s", buffer);
        ricevi_info();
        return;
    }
    //look incorretta
    if(strcmp(ack, "NOLOO")==0){
        printf("\nArgomento non valido: il comando look può essere inviato senza argomenti o seguito dal nome di un oggetto o una location della room\n");
        ricevi_info();
        return;
    }
    //enigma in arrivo
    if(strcmp(ack, "BLOCK")==0){
        int i;
        char tmp[DIM_BUFFER];
        recv_msg(socket_server, buffer);
        sscanf(buffer, "%d", &i);
        printf("\nDomanda:\n%s", buffer+2); //i primi due byte sono occupati dal numero di enigma e da uno spazio vuoto
        printf("Inserisci risposta: ");
        //utilizzo il buffer per inviare prima l'avviso che sto per inviare la risposta che nel frattempo memorizzo in un buffer temporaneo
        memset(buffer, 0, DIM_BUFFER);
        sprintf(tmp, "%d ", i);
        fgets(tmp+strlen(tmp), DIM_BUFFER, stdin);
        tmp[strlen(tmp)]='\0';
        strcpy(buffer, "ready");
        send_msg(socket_server, buffer);
        strcpy(buffer, tmp);
        send_msg(socket_server, buffer);
        //ricevo l'ack riguardante la risposta all'enigma e lo gestisco
        memset(buffer, 0, DIM_BUFFER);
        recv_msg(socket_server, buffer);
        gestione_ack(buffer);
        return;
    }
    //raccolta di un oggetto non valido
    if(strcmp(ack, "ERTAK")==0){
        printf("\nArgomento non valido: il comando take deve essere utilizzato con il nome di un oggetto valido\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "FULBG")==0){
        printf("\nZaino pieno, utilizza il comando drop per liberare spazio\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "PROBJ")==0){
        printf("\nOggetto già raccolto in precedenza\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "OKTAK")==0){
        printf("\nOggetto raccolto\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "NOTAK")==0){
        printf("\nRisposta sbagliata\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "ERUSE")==0){
        printf("\nArgomento non valido: il comando use deve essere utilizzato con il nome di uno o due oggetti validi\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "NOUSE")==0){
        printf("\nOggetto non raccolto o già usato\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "OKUSE")==0){
        printf("\nToken ottenuto\n");
        //se ho ricevuto OKUSE potrei aver ottenuto il terzo token e quindi sarebbe conclusa la partita
        check_win();
        //controllo che la check_win non abbia terminato la partita
        if(partita_iniziata==1)
            ricevi_info();
        return;
    }
    if(strcmp(ack, "USELS")==0){
        printf("\nE' impossibile utilizzare questo/i oggetto/i\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "NODRO")==0){
        printf("\nRilascio impossibile, assicurati che l'oggetto sia in tuo possesso e che esista nella room\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "OKDRO")==0){
        printf("\nOggetto rilasciato\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "OKOBJ")==0){
        recv_msg(socket_server, buffer);
        printf("\nOggetti raccolti:\n");
        printf("%s", buffer);
        ricevi_info();
        return;
    }
    if(strcmp(ack, "OFUSR")==0){
        printf("\nUtente offline o inesistente\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "SAMEU")==0){
        printf("\nNon puoi inserire il tuo stesso username\n");
        ricevi_info();
        return;
    }
    if(strcmp(ack, "GETN")==0){
        int sd, max, min, t;
        char ip_str[DIM_BUFFER];
        memset(&getn_addr, 0, sizeof(getn_addr)); //pulisco l'area di memoria dedicata a getn_addr
        recv_msg(socket_server, buffer);
        //parsing delle informazioni inviate dal server in risposta a un valido comando di getn
        sscanf(buffer, "%s %d", ip_str, (int*)&getn_addr.sin_port);
        //ultima parte di inizializzazione della struttura dell'host a cui collegarsi
        inet_pton(AF_INET, ip_str, (void*)&getn_addr.sin_addr);
        getn_addr.sin_port=htons(getn_addr.sin_port);
        getn_addr.sin_family=AF_INET;
        //connessione all'altro host client 
        sd=socket(AF_INET, SOCK_STREAM, 0);
        if(sd==-1){
            perror("Errore: ");
            exit(1);
        }
        ret=connect(sd, (struct sockaddr*)&getn_addr, sizeof(getn_addr));
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        //ricevo il numero relativo alla stanza dell'altro host e chiudo il socket
        recv_msg(sd, buffer);
        sscanf(buffer, "%d", &num_ricevuto);
        ret=close(sd);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        //ora mi occupo della logica della funzione che può far guadagnare un token
        if(mio_num>num_ricevuto){
            max=mio_num;
            min=num_ricevuto;
        }
        else{
            max=num_ricevuto;
            min=mio_num;
        }
        memset(buffer, 0, DIM_BUFFER); //pulizia del buffer
        printf("\nIl numero della tua stanza è %d\nIl numero della stanza dell'altro giocatore è %d\n", mio_num, num_ricevuto);
        printf("Qual è il resto della divisione intera tra il maggiore dei due e il minore?\n");
        scanf("%d", &t);
        if(t==(max%min)){
            printf("\nRisposta corretta, token ottenuto\n");
            getn_usata=1;
            strcpy(buffer, "ack");
            send_msg(socket_server, buffer);
            check_win();
            if(partita_iniziata==1)
                ricevi_info();
            return;
        }
        else{
            printf("\nRisposta sbagliata\n");
            strcpy(buffer, "nak");
            send_msg(socket_server, buffer);
            //in caso di risposta sbagliata non mi aspetto alcuna comunicazione su un'eventuale vittoria
        }
        ricevi_info();
        return;
    }
    if(strcmp(ack, "YUWIN")==0){
        printf("\nComplimenti, hai vinto la sfida\n");
        partita_iniziata=0;
        ret=close(socket_server);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        FD_CLR(socket_server, &master);
        return;
    }
    if(strcmp(ack, "EXTIM")==0){
        printf("\nTempo esaurito!\n");
        partita_iniziata=0;
        ret=close(socket_server);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        FD_CLR(socket_server, &master);
        return;
    }
    if(strcmp(ack, "OKEND")==0){
        ricevi_info();
        partita_iniziata=0;
        ret=close(socket_server);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        printf("\nPartita terminata\n");
        return;
    }
}

void gestione_listener(){
    int sd;
    struct sockaddr_in cl_addr;
    socklen_t addrlen;
    char buffer[DIM_BUFFER];

    addrlen=sizeof(cl_addr);

    sd=accept(listener, (struct sockaddr*)&cl_addr, &addrlen);
    if(sd<0){
        perror("Errore: ");
        exit(1);
    }
    //quando un client accetta una richiesta sul proprio listener significa che un altro client ha richiesto il numero relativo alla sua stanza
    //quindi dopo aver accettato la connessione invio il numero e chiudo il socket che non serve più
    sprintf(buffer, "%d", mio_num);
    send_msg(sd, buffer);
    ret=close(sd);
    if(ret==-1){
        perror("Errore: ");
        exit(1);
    }
}

void check_win(){
    char buffer[DIM_BUFFER];
    recv_msg(socket_server, buffer);
    //faccio qualcosa solo se ho ricevuto il messaggio di avvenuta vittoria
    if(strcmp(buffer, "YUWIN")==0)
        gestione_ack(buffer);
}