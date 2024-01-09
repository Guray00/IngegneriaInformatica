#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#define N_OBJ 7
#define N_LOC 4
#define N_EN 2
#define DIM_BUFFER 1024
#define DIM_CMD 10

struct oggetto{
	char nome[20];
	char descrizione[DIM_BUFFER];
	char descrizione_bloccato[DIM_BUFFER];
	int bloccato;
	int enigma_associato;
	int usato;
};

struct enigma{
	char domanda[DIM_BUFFER];
	char risposta[DIM_BUFFER];
};

struct location{
	char nome[20];
	char descrizione[DIM_BUFFER];
};

struct partita{
	char user[100];
	int token;
    struct oggetto obj[N_OBJ];
    time_t ora_fine; //inizializzo quando il client invia lo start come time(NULL)+1800
    int zaino[5];
    int socket_associato;
	struct sockaddr_in addr;
	struct partita* next;
};

//variabile che tiene conto di quante stanze sono attive per gestire la chiusura del server
int stanze_attive=0; 
//variabile per controllare se il server è già stato avviato
int server_started=0; 
int listener, fdmax, ret; 
fd_set master, read_fds;

struct partita* partite_in_corso=NULL;
//vettore che memorizza i nomi degli oggetti, necessario per alcune funzioni di utilità
char *ogg[N_OBJ];
//a differenza degli oggetti le locations sono comuni e immutabili per ogni processo quindi non è necessario istanziarne di nuove alla creazione di una nuova partita
struct location locs[N_LOC];
//memorizzo in un vettore ogni enigma con la relativa risposta corretta
struct enigma ens[N_EN];

void strutture();
void gestione_stdin_server();
void gestione_start();
void gestione_stop();
void inizializza_oggetti(struct oggetto* objs);
int is_obj(char *n);
int is_loc(char *n);
void recv_msg(int sd, char* buffer);
void send_msg(int sd, char* buffer);
void output_server_comandi();
void gestione_client(int sd);
void gestione_login(char* username, char* password, int sd);
void crea_partita(struct sockaddr_in addr, int sd);
void gestione_signup(char* username, char* password, int sd);
struct partita* cerca_partita(int sd);
struct partita* cerca_partita_username(char *username);
void gestione_start_client(char* arg, int sd);
void gestione_look(char* arg, int sd);
int zaino_pieno(int *z);
void verifica_risposta(int sd);
void gestione_take(char *arg, int sd);
void gestione_use(char *arg1, char *arg2, int sd);
void gestione_drop(char *arg, int sd);
void gestione_objs(int sd);
void gestione_getn1(char *user, int sd);
void gestione_getn2(int sd);
void gestione_getn3(int sd);
void rimozione_partita(struct partita *p);
int gestione_timer(int sd);
void gestione_end(int sd);
void gestione_listener();
void invia_info(int sd);



int main(int argc, char* argv[]){
	int i, port, time_expired;
	struct sockaddr_in sv_addr;

	//gestione della porta su cui il server riceve le richieste
	if(argc>1)
		port=atoi(argv[1]);
	else port=4242;
	
	listener=socket(AF_INET, SOCK_STREAM, 0);
	memset(&sv_addr, 0, sizeof(sv_addr));
	sv_addr.sin_family=AF_INET;
	sv_addr.sin_port=htons(port);
	sv_addr.sin_addr.s_addr=INADDR_ANY;

	ret=bind(listener, (struct sockaddr*) &sv_addr, sizeof(sv_addr));
	if(ret==-1){
		perror("Error: ");
		exit(1);
		}
	ret=listen(listener, 5);
        if(ret==-1){
            perror("Error: ");
            exit(1);
        }

	//Inizializzazione dei set di file descriptor e della variabile fdmax per la funzione select
 	FD_ZERO(&master);
 	FD_ZERO(&read_fds);
 	FD_SET(0, &master); //standard input ha FD 0
 	FD_SET(listener, &master);
 	fdmax = listener;

	strutture();
	output_server_comandi();

	while(server_started==0){
		gestione_stdin_server();
	}

	while(server_started==1){
		read_fds = master;
		//a ogni ciclo, prima di procedere con la select, si controlla se ci sono partite che devono essere eliminate
		//if(stanze_attive!=0)
		//	gestione_timer();

		ret = select(fdmax+1, &read_fds, NULL, NULL, NULL);
	
		if(ret < 0){
			perror("Error: ");
			exit(1);
		}
			
 		for(i = 0; i <= fdmax; i++) {
 			if(FD_ISSET(i, &read_fds)) {
 				if(i == 0) // standard input ha FD 0
 					gestione_stdin_server();
 				else{ 
                    if(i == listener) // Socket di ascolto
 					    gestione_listener();
 				    else{                   // Socket di comunicazione
                        time_expired=gestione_timer(i); //prima di eseguire il comando inviato da un giocatore controllo che non abbia esaurito il tempo
                        if(!time_expired){   
                            gestione_client(i);
                            //check_win(i);
                        }
                    }
                }
			}
		}
	}
	return 0;
}

void strutture(){
	ogg[0]="fogli";
	ogg[1]="idrogeno";
	ogg[2]="azoto";
	ogg[3]="carbonio";
	ogg[4]="sodio";
	ogg[5]="cloro";
	ogg[6]="cassaforte";

	//inizializzazione della location di partenza
	strcpy(locs[0].nome, "");
	strcpy(locs[0].descrizione, "Davanti a te c'è una ++scrivania++ molto disordinata. In un angolo del laboratorio si trova un ++quadro++ che raffigura un'isola volante. La porta di uscita si trova in fondo al corridoio alla tua destra ma è bloccata, servono tre token per aprirla.\n");

	//inizializzazione della location "scrivania"
	strcpy(locs[1].nome, "scrivania");
	strcpy(locs[1].descrizione, "Sulla scrivania si trovano dei **fogli** e un ++portaprovette++.\n");

	//inizializzazione della location "portaprovette"
	strcpy(locs[2].nome, "portaprovette");
	strcpy(locs[2].descrizione, "Vi sono inserite provette contenenti diversi elementi: **idrogeno**, **azoto**, **carbonio**, **sodio**, **cloro**.\n");

	//inizializzazione della location "quadro"
	strcpy(locs[3].nome, "quadro");
	strcpy(locs[3].descrizione, "Rappresenta un'isola volante. Dietro al ++quadro++ si èuò notare una **cassaforte**.\n");


	//enigma per sbloccare gli appunti
	strcpy(ens[0].domanda, "Qual è la formula dell'acqua? A)H2O2 B)CO2 C)H2O D)CO\n");
	strcpy(ens[0].risposta, "C");

	//enigma codice cassaforte
	strcpy(ens[1].domanda, "La prima cifra del codice è data dal numero di atomi di ossigeno in una molecola di clorofilla, la seconda sono gli atomi di carbonio nell'acido citrico, la terza sono gli atomi di potassio nel dicloruro di potassio, la quarta è la parte intera del numero di Avogadro scritto in notazione scientifica.\n");
	strcpy(ens[1].risposta, "5616");
}

void gestione_stdin_server(){
    char buffer[DIM_BUFFER];
    char cmd[DIM_CMD];

    fgets(buffer, DIM_CMD, stdin);
    sscanf(buffer, "%s", cmd);

    if(strcmp(cmd, "stop")==0){
        gestione_stop();
        return;
    }
    if(strcmp(cmd, "start")==0){
        gestione_start();
        return;
    }
    printf("Comando inserito non valido\n");    
}

void gestione_start(){
    //se il server non è ancora stato avviato, lo avvio e lo metto in ascolto
    if(server_started==0){
        server_started=1;
        
        printf("Server avviato!\n");
        return;
    }
    printf("Il server è già stato avviato in precedenza.\n");
}

void gestione_stop(){
    struct partita *p, *q;
    p=partite_in_corso;
    if(server_started==1){
        if(stanze_attive>0){
            printf("Partite ancora in corso, impossibile disconnettere il server.\n");
            return;
        }
        //elimino eventuali partite create ma non ancora iniziate
        while(p!=NULL){
            q=p;
            p=p->next;
            free(q);
        }

        ret=close(listener);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        server_started=0;
		printf("Server disconnesso\n");
    }
	else
		printf("server non in funzione\n");
	
}

//funzione per inizializzare gli oggetti in una sessione di gioco, è necessario in quanto gli oggetti si possono trovare in stati diversi in diverse sessioni 
void inizializza_oggetti(struct oggetto* objs){

	//inizializzazione dell'oggetto "fogli"
	strcpy(objs[0].nome, "fogli");
	strcpy(objs[0].descrizione, "Sembrano appunti scritti in fretta e furia. Ci sono degli scarabocchi rappresentanti strutture molecolari con le relative formule. Un paragrafo recita: <<Esistono diverse famiglie di idrocarburi, quelle maggiormente presenti in natura sono gli alcani, come il metano e il propano, aventi formula CnH2n+2; poi ci sono gli alchini come l'etilene, aventi formula CnH2n>>. Più sotto è presente un paragrafo evidenziato contenente alcune formule molecolari:<<Clorofilla C55H72O5N4Mg, Acido citrico C6H8O7, Dicloruro di potassio KCl2, Ossido di azoto N2>>. A pie' di pagina c'è scritto:<<Se vuoi sperare di  salvarti prova a comporre il più semplice degli alcani>>.\n");
	strcpy(objs[0].descrizione_bloccato, "Sembrano appunti cifrati, risolvi l'enigma per decifrarli.\n");
	objs[0].bloccato=1;
	objs[0].enigma_associato=0;
	objs[0].usato=0;

	//inizializzazione degli oggetti "idrogeno", "azoto", "carbonio", "sodio", "cloro"
	strcpy(objs[1].nome, "idrogeno");
	strcpy(objs[1].descrizione, "La provetta contiene 4 moli di idrogeno.\n");
	strcpy(objs[1].descrizione_bloccato, "");
	objs[1].bloccato=0;
	objs[1].enigma_associato=-1;
	objs[1].usato=0;

	strcpy(objs[2].nome, "azoto");
    strcpy(objs[2].descrizione, "La provetta contiene 2 moli di azoto.\n");
    strcpy(objs[2].descrizione_bloccato, "");
    objs[2].bloccato=0;
    objs[2].enigma_associato=-1;
	objs[2].usato=0;

	strcpy(objs[3].nome, "carbonio");
    strcpy(objs[3].descrizione, "La provetta contiene 1 mole di carbonio.\n");
    strcpy(objs[3].descrizione_bloccato, "");
    objs[3].bloccato=0;
    objs[3].enigma_associato=-1;
	objs[3].usato=0;

	strcpy(objs[4].nome, "sodio");
    strcpy(objs[4].descrizione, "La provetta contiene 3 moli di sodio.\n");
    strcpy(objs[4].descrizione_bloccato, "");
    objs[4].bloccato=0;
    objs[4].enigma_associato=-1;
	objs[4].usato=0;

	strcpy(objs[5].nome, "cloro");
    strcpy(objs[5].descrizione, "La provetta contiene 3 moli di cloro.\n");
    strcpy(objs[5].descrizione_bloccato, "");
    objs[5].bloccato=0;
    objs[5].enigma_associato=-1;
	objs[5].usato=0;

	//inizializzazione dell'oggetto "cassaforte"
	strcpy(objs[6].nome, "cassaforte");
	strcpy(objs[6].descrizione, "La cassaforte è aperta, usala per prelevare il token al suo interno.\n");
	strcpy(objs[6].descrizione_bloccato, "E' richiesto un codice per aprire la cassaforte.\n");
	objs[6].bloccato=1;
	objs[6].enigma_associato=1;
	objs[6].usato=0;
}

//funzione che, data una stringa, verifica se è un oggetto della room e ne restituisce l'indice nel vettore in cui è memorizzato
int is_obj(char *n){
	int i;
	for(i=0; i<N_OBJ; i++)
		if(strcmp(n, ogg[i])==0)
			return i;
	return -1;
}

//omologo della precedente per le locations
int is_loc(char *n){
	int i;
	for(i=0; i<N_LOC; i++)
		if(strcmp(n, locs[i].nome)==0)
			return i;
	return -1;
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

void output_server_comandi(){
	printf("***************************** SERVER STARTED *********************************\n");
	printf("Digita un comando:\n\n");
	printf("1) start\n");
	printf("2) stop\n");
}

//in base al comando ricevuto viene scelta la funzione da eseguire
void gestione_client(int sd){
    char buffer[DIM_BUFFER];
    char cmd[DIM_CMD];
    char arg1[100];
    char arg2[100];
    strcpy(arg1, "\0");
    strcpy(arg2, "\0");
    recv_msg(sd, buffer);
    sscanf(buffer, "%s %s %s", cmd, arg1, arg2);
    if(strcmp(cmd, "login")==0)
        gestione_login(arg1, arg2, sd);
    if(strcmp(cmd, "signup")==0)
        gestione_signup(arg1, arg2, sd);
    if(strcmp(cmd, "start")==0)
        gestione_start_client(arg1, sd);
    if(strcmp(cmd, "look")==0)
        gestione_look(arg1, sd);
    if(strcmp(cmd, "take")==0)
        gestione_take(arg1, sd);
    if(strcmp(cmd, "ready")==0)
        verifica_risposta(sd);
    if(strcmp(cmd, "drop")==0)
        gestione_drop(arg1, sd);
    if(strcmp(cmd, "objs")==0)
        gestione_objs(sd);
    if(strcmp(cmd, "use")==0)
        gestione_use(arg1, arg2, sd);
    if(strcmp(cmd, "getn")==0)
        gestione_getn1(arg1, sd);
	if(strcmp(cmd, "ack")==0)
        gestione_getn2(sd);
	if(strcmp(cmd, "nak")==0)
        gestione_getn3(sd);
    if(strcmp(cmd, "end")==0)
        gestione_end(sd);
}

void gestione_login(char* username, char* password, int sd){
    char buffer[DIM_BUFFER];
    FILE* fd;
    int trovato=0;
    char u[100], p[100];
    fd=fopen("utenti.txt", "r");
    while(trovato==0 && fscanf(fd, "%s %s", u, p)==2){
        if(strcmp(u, username)==0)
            trovato=1;
    }
    fclose(fd);
    if(trovato==0){
        strcpy(buffer, "NOUSR");
        send_msg(sd, buffer);
		printf("Login fallito, utente inesistente\n");
    }
    else{
        if(strcmp(p, password)!=0){
            strcpy(buffer, "ERPWD");
            send_msg(sd, buffer);
			printf("Login fallito, password errata\n");
            }
            else{
                struct partita *p=cerca_partita(sd);
                strcpy(p->user, username);
                strcpy(buffer, "OKUSR");
                send_msg(sd, buffer);
				printf("Login effettuato da %s\n", username);
                }
    }
}

//la partita viene creata al momento della connessione, le altre informazioni vengono aggiunte in seguito
void crea_partita(struct sockaddr_in listener_client, int sd){
    struct partita *p;
    p=(struct partita*)malloc(sizeof(struct partita));
    p->addr=listener_client;
    p->socket_associato=sd;
    memset(&(p->ora_fine), 0, sizeof(time_t)); //metto a 0 l'orafine delle partite create ma non ancora iniziate per riconoscerle quando scorro la lista per gestire il timer
    p->next=partite_in_corso;
    partite_in_corso=p;
}

void gestione_signup(char* username, char* password, int sd){
    char buffer[DIM_BUFFER];
    FILE* fd;
    int trovato=0;
    char u[100], p[100];
    fd=fopen("utenti.txt", "r+");
	//il while continua a ciclare finché sul file la fscanf riesce a leggere coppie utente-password
    while(trovato==0 && fscanf(fd, "%s %s", u, p)==2){
        if(strcmp(u, username)==0)
            trovato=1;
    }
    if(trovato==1){
        strcpy(buffer, "EXUSR");
        send_msg(sd, buffer);
        fclose(fd);
		printf("Signup fallito, utente già esistente\n");
    }
    else{
        fprintf(fd, "%s\n%s\n", username, password);
        fclose(fd);
        struct partita *p=cerca_partita(sd);
        strcpy(p->user, username);
        strcpy(buffer, "CRUSR");
        send_msg(sd, buffer);
		printf("Signup eseguito\n");
    }
}

//funzione che permette al server di trovare una partita tra quelle in corso a partire dal socket associato ad essa
//la funzione è chiamata solo in casi in cui il server riceve un comando da una delle partite in corso quindi non è 
//necessario gestire il caso di oggetto non trovato
struct partita* cerca_partita(int sd){
    struct partita *p=partite_in_corso;
    struct partita *q;
    int trovato=0;
    while(p!=NULL && !trovato){
        if(p->socket_associato==sd)
            trovato=1;
        q=p;
        p=p->next;
    }
    return q;
}

//funzione che, a partire dall'username, restituisce la partita
struct partita* cerca_partita_username(char *username){
    struct partita *p=partite_in_corso;
    struct partita *q;
    int trovato=0;
    while(p!=NULL && !trovato){
        if(strcmp(username, p->user)==0)
            trovato=1;
        q=p;
        p=p->next;
    }
    if(trovato)
        return q;
    return NULL;
}

void gestione_start_client(char* arg, int sd){
    char buffer[DIM_BUFFER];
    int n, i, num;
    struct partita *p=cerca_partita(sd);
	srand(time(NULL));
	//faccio il parsing dell'argomento della start non direttamente dal buffer di ricezione ma dalla stringa di appoggio arg che passo alla funzione
    sscanf(arg, "%d", &n);
    if(n==1){
        num=rand()%901+100; //numero generato randomicamente necessario per la funzione a piacere
        p->token=0;
        for(i=0; i<5; i++)
            p->zaino[i]=-1;
        inizializza_oggetti(p->obj);
		//inizializzo l'ora della fine della partita al tempo attuale più 30 minuti
        time(&(p->ora_fine));
        p->ora_fine+=1800;
        stanze_attive++;
        //invio la conferma della creazione della stanza e successivamente il numero generato randomicamente e il contesto del gioco
        strcpy(buffer, "OKSTA");
        send_msg(sd, buffer);
        sprintf(buffer, "%d\nBenvenuto nel laboratorio di chimica di Laputa. Il sistema di sicurezza ci ha informati che è in corso una fuoriuscita di materiale tossico. Hai 30 minuti per trovare il modo di uscire dalla stanza prima che questa venga distrutta per evitare ulteriori danni.", num);
        send_msg(sd, buffer);
		invia_info(sd);
		printf("Room avviata dall'utente %s\n", p->user);
    }
    else{
        strcpy(buffer, "NOSTA");
        send_msg(sd, buffer);
		printf("Scelta room non valida dall'utente %s\n", p->user);
    }
}

void gestione_look(char *arg, int sd){
    char buffer[DIM_BUFFER];
    struct partita *p=cerca_partita(sd);
    int i=is_loc(arg);
    int j=is_obj(arg);
	printf("Gestione del comando look dell'utente %s\n", p->user);
	//caso senza argomenti
	if(strlen(arg)==0){
		strcpy(buffer, "DESCR");
    	send_msg(sd, buffer);
    	memset(buffer, 0, DIM_BUFFER);
		strcpy(buffer, locs[0].descrizione);
    	send_msg(sd, buffer);
		invia_info(sd);
		return;
	}
    //controllo che l'argomento sia una location o un oggetto
    if(i==-1 && j==-1){
        strcpy(buffer, "NOLOO");
        send_msg(sd, buffer);
		invia_info(sd);
        return;
    }
    //avviso il client che sta arrivando una descrizione
    strcpy(buffer, "DESCR");
    send_msg(sd, buffer);
    memset(buffer, 0, DIM_BUFFER);
    //se è un oggetto invio la sua descrizione o, eventualmente, la sua descrizione da bloccato
    if(i==-1){
        if(p->obj[j].bloccato==1)
            strcpy(buffer, p->obj[j].descrizione_bloccato);
        else
            strcpy(buffer, p->obj[j].descrizione);
        send_msg(sd, buffer); 
		invia_info(sd);   
        return;    
    }
    //se arrivo a questo punto è per forza una location
    strcpy(buffer, locs[i].descrizione);
    send_msg(sd, buffer);
	invia_info(sd);
}

//funzione di utilità che controlla se lo zaino è pieno
int zaino_pieno(int *z){
    int c=0, i;
    for(i=0; i<5; i++)
        if(z[i]!=-1)
            c++;
    if(c==5)
        return 1;
    return 0;
}


//funzione che sottopone un enigma al giocatore e verifica la risposta
void verifica_risposta(int sd){
    char buffer[DIM_BUFFER];
    char ans[DIM_BUFFER];
    int i, k;
    struct partita *p=cerca_partita(sd);
    //se sto eseguendo questa funzione significa che ho ricevuto la comunicazione che è in arrivo la risposta a un enigma da parte del client
    recv_msg(sd, buffer);
    //parsing
    sscanf(buffer, "%d %s", &i, ans);
    printf("%s\n", ans);
    //risposta corretta
    if(strcmp(ans, ens[i].risposta)==0){
        //se è l'enigma 0 allora è associato all'oggetto fogli, quindi lo sblocco e lo aggiungo allo zaino
        if(i==0){
            p->obj[0].bloccato=0;
            for(k=0; k<5; k++){
                if(p->zaino[k]==-1){
                    p->zaino[k]=0;
                    break;
                }
            }
        }
        //se i non è 0 è per forza 1 ed è associato all'oggetto cassaforte che sblocco e raccolgo
        else{
            p->obj[6].bloccato=0;
            for(k=0; k<5; k++){
                if(p->zaino[k]==-1){
                    p->zaino[k]=6;
                    break;
                }
            }
        }
        strcpy(buffer, "OKTAK");
        send_msg(sd, buffer);
    }
    //risposta errata
    else{
        strcpy(buffer, "NOTAK");
        send_msg(sd, buffer);
    }
    invia_info(sd);
}

void gestione_take(char *arg, int sd){
    char buffer[DIM_BUFFER];
    struct partita *p=cerca_partita(sd);
	int k;
    int i=is_obj(arg);
    int j=0, trovato=0;
	printf("Gestione del comando take dell'utente %s\n", p->user);
    //controllo che l'input sia valido
    if(i==-1){
        strcpy(buffer, "ERTAK");
        send_msg(sd, buffer);
		invia_info(sd);
        return;
    }
    if(zaino_pieno(p->zaino)){
        strcpy(buffer, "FULBG");
        send_msg(sd, buffer);
		invia_info(sd);
        return;
    }
    //controllo che l'oggetto non sia già stato raccolto
    for(k=0; k<5 && !trovato; k++)
        if(p->zaino[k]==i)
            trovato=1;
    if(trovato){
        strcpy(buffer, "PROBJ");
        send_msg(sd, buffer);
		invia_info(sd);
        return;
    }
    //oggetto valido bloccato, invio l'enigma
    if(p->obj[i].bloccato==1){
        strcpy(buffer, "BLOCK");
        send_msg(sd, buffer);
        memset(buffer, 0, DIM_BUFFER);
        sprintf(buffer, "%d %s", p->obj[i].enigma_associato, ens[p->obj[i].enigma_associato].domanda); //invio la domanda e il numero di enigma così il client lo potrà mandare al server che lo utilizzerà per controllare la risposta
        send_msg(sd, buffer);
    }
    //oggetto valido non bloccato
    else{
        while(p->zaino[j]!=-1)
            j++;
        p->zaino[j]=i;
        strcpy(buffer, "OKTAK");
        send_msg(sd, buffer);
        invia_info(sd);
    }
}

void gestione_use(char *arg1, char *arg2, int sd){
    char buffer[DIM_BUFFER];
    struct partita *p=cerca_partita(sd);
	int k;
    int i=is_obj(arg1);
    int j=is_obj(arg2);
    int trovato=0;
	printf("Gestione del comando use dell'utente %s\n", p->user);
    //oggetti non validi
    if(i==-1 && j==-1){
        strcpy(buffer, "ERUSE");
        send_msg(sd, buffer);
    }
    else{
        //un solo oggetto valido
        if(j==-1){
            for(k=0; k<5 && !trovato; k++)
                if(p->zaino[k]==i)
                    trovato=1;
            //oggetto non precedentemente raccolto o già usato
            if(!trovato || p->obj[i].usato==1){
                strcpy(buffer, "NOUSE");
                send_msg(sd, buffer);
            }
            else{
                //uso della cassaforte, la cassaforte è l'unico oggetto che può essere usato singolarmente
                if(i==6){
                    p->token++;
                    p->obj[i].usato=1;
                    //rilascio l'oggetto usato
                    for(k=0; k<5; k++)
                        if(p->zaino[k]==i)
                            p->zaino[k]=-1;
                    strcpy(buffer, "OKUSE");
                    send_msg(sd, buffer);
                    if(p->token==3){
                        printf("L'utente %s ha vinto\n", p->user);
                        strcpy(buffer, "YUWIN");
                        send_msg(sd, buffer);
                        rimozione_partita(p);
                        stanze_attive--;
                        FD_CLR(sd, &master);
                        ret=close(sd);
                        if(ret==-1){
                            perror("Errore: ");
                            exit(1);
                        }
                        return;
                    }
                    else{
                    strcpy(buffer, "NOWIN");
                    send_msg(sd, buffer);
                    }
                }
                else{
                    strcpy(buffer, "USELS");
                    send_msg(sd, buffer);
                }
            }
        }
        //due oggetti validi, l'uso è corretto solo se sono carbonio e idrogeno
        else{
            for(k=0; k<5; k++)
                if(p->zaino[k]==i || p->zaino[k]==j)
                    trovato++;
            //oggetto non raccolto o già usato
            if(trovato!=2 || (p->obj[i].usato==1 || p->obj[j].usato==1)){
                strcpy(buffer, "NOUSE");
                send_msg(sd, buffer);
            }
            //gli unici oggetti che possono essere usati in coppia sono carbonio e idrogeno
            if((i==1 && j==3) || (i==3 && j==1)){
                p->token++;
                p->obj[i].usato=1;
                p->obj[j].usato=1;
                //rilascio gli oggetti dopo l'utilizzo
                for(k=0; k<5; k++)
                    if(p->zaino[k]==i || p->zaino[k]==j)
                        p->zaino[k]=-1;
                //faccio sapere all'utente che il comando use è andato a buon fine
                strcpy(buffer, "OKUSE");
                send_msg(sd, buffer);
                if(p->token==3){
                    printf("L'utente %s ha vinto\n", p->user);
                    strcpy(buffer, "YUWIN");
                    send_msg(sd, buffer);
                    rimozione_partita(p);
                    stanze_attive--;
                    FD_CLR(sd, &master);
                    ret=close(sd);
                    if(ret==-1){
                        perror("Errore: ");
                        exit(1);
                    }
                    return;
                }
                else{
                    strcpy(buffer, "NOWIN");
                    send_msg(sd, buffer);
                }
            }
            else{
                strcpy(buffer, "USELS");
                send_msg(sd, buffer);
            }
        }
    }
    invia_info(sd);
}

void gestione_drop(char *arg, int sd){
    struct partita *p=cerca_partita(sd);
    char buffer[DIM_BUFFER];
	int j;
    int i=is_obj(arg);
    int trovato=0;
	printf("Gestione del comando drop dell'utente %s\n", p->user);
    if(i!=-1){
        for(j=0; j<5 && !trovato; j++)
            if(p->zaino[j]==i){
                trovato=1;
                p->zaino[j]=-1;
            }
        if(trovato){
            strcpy(buffer, "OKDRO");
            send_msg(sd, buffer);
        }
        else{
            strcpy(buffer, "NODRO");
            send_msg(sd, buffer);
        }
    }
    else{
        strcpy(buffer, "NODRO");
        send_msg(sd, buffer);
    }
	invia_info(sd);
}

void gestione_objs(int sd){
    char buffer[DIM_BUFFER];
	int i;
    struct partita* p=cerca_partita(sd);
	printf("Gestione del comando objs dell'utente %s\n", p->user);
    strcpy(buffer, "OKOBJ");
    send_msg(sd, buffer);
    memset(buffer, 0, DIM_BUFFER);
    for(i=0; i<5; i++){
        if(p->zaino[i]!=-1){
            sprintf(buffer+strlen(buffer), "%s\n", p->obj[p->zaino[i]].nome);
        }
    }
    send_msg(sd, buffer);
	invia_info(sd);
}

void gestione_getn1(char *user, int sd){
    char buffer[DIM_BUFFER];
    struct partita *p=cerca_partita_username(user);
    struct partita *q=cerca_partita(sd);
	printf("Gestione del comando getn dell'utente %s\n", q->user);
    //utente inesistente o offline, faccio il controllo su ora_fine perché è una variabile a cui viene assegnato un valore diverso da 0 solo dopo lo start
    if(p==NULL || p->ora_fine==0){
        strcpy(buffer, "OFUSR");
        send_msg(sd, buffer);
        invia_info(sd);
        return;
    }
    if(strcmp(user, q->user)==0){
        strcpy(buffer, "SAMEU");
        send_msg(sd, buffer);
        invia_info(sd);
        return;
    }

    //comunico al client che sta arrivando l'indirizzo dell'host che ha richiesto
    strcpy(buffer, "GETN");
    send_msg(sd, buffer);

    memset(buffer, 0, DIM_BUFFER);

    //stampo nel buffer l'indirizzo e la porta del client di cui si vogliono conoscere le informazioni, oltre al numero relativo alla propria stanza e le invio al client che le ha richieste
    inet_ntop(AF_INET, (void*)&(p->addr.sin_addr), buffer, INET_ADDRSTRLEN);
    sprintf(buffer + strlen(buffer), " %d", ntohs(p->addr.sin_port));
	send_msg(sd, buffer);
}

void gestione_getn2(int sd){
    char buffer[DIM_BUFFER];
	struct partita *p=cerca_partita(sd);
	printf("L'utente %s ha portato a termine l'enigma della funzione getn\n", p->user);
    p->token++;
    if(p->token==3){
        printf("L'utente %s ha vinto\n", p->user);
        strcpy(buffer, "YUWIN");
        send_msg(sd, buffer);
        rimozione_partita(p);
        stanze_attive--;
        FD_CLR(sd, &master);
        ret=close(sd);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
        return;
    }
    else{
        strcpy(buffer, "NOWIN");
        send_msg(sd, buffer);
    }
	invia_info(sd); 
}

void gestione_getn3(int sd){
	struct partita *p=cerca_partita(sd);
	printf("L'utente %s non ha portato a termine l'enigma della funzione getn\n", p->user);
	invia_info(sd);
}

void rimozione_partita(struct partita *p){
    struct partita *q=NULL, *r;
    r=partite_in_corso;
    while(r!=p){
        q=r;
        r=r->next;
    }
    if(q!=NULL){
        q->next=r->next;
    }
    else{
        partite_in_corso=r->next;
    }
    free(p);
}

int gestione_timer(int sd){
    char buffer[DIM_BUFFER];
    struct partita *p=cerca_partita(sd);
    //ora_fine è inizializzato a 0 nelle partite create ma non ancora avviate
    if(p->ora_fine!=0){
        //se la condizione è vera significa che l'utente ha esaurito il tempo
        if((p->ora_fine-time(NULL))<0){
            printf("L'utente %s ha esaurito il tempo\n", p->user);
            //prima di chiudere il socket ricevo il messaggio che aveva inviato il client che ignorerò
            recv_msg(sd, buffer);
            memset(buffer, 0, DIM_BUFFER);
            //invio il segnale di tempo esaurito
            strcpy(buffer, "EXTIM");
            send_msg(p->socket_associato, buffer);
    		ret=close(p->socket_associato);
            if(ret==-1){
                perror("Errore: ");
                exit(1);
            }
            rimozione_partita(p);
            FD_CLR(p->socket_associato, &master);
            stanze_attive--;
            return 1;
        }
        return 0;
    }
    return 0;
}

void gestione_end(int sd){
    char buffer[DIM_BUFFER];
    struct partita *p=cerca_partita(sd);
	printf("L'utente %s ha terminato la partita\n", p->user);
    strcpy(buffer, "OKEND");
    send_msg(sd, buffer);
    invia_info(sd);
    ret=close(sd);
        if(ret==-1){
            perror("Errore: ");
            exit(1);
        }
    rimozione_partita(p);
    FD_CLR(sd, &master);
    stanze_attive--;
}

void gestione_listener(){
    struct sockaddr_in cl_addr, listener_client;
	socklen_t addrlen;
	int newfd; 
    char buffer[DIM_BUFFER];
    char ip_str[DIM_BUFFER];
	
	addrlen = sizeof(cl_addr);
    //il server accetta le richieste solo se è stato avviato
    if(server_started==1){
	    newfd = accept(listener, (struct sockaddr *)&cl_addr, &addrlen);
	    if(newfd < 0){
            perror("Errore: ");
            exit(1);
        }
        FD_SET(newfd, &master); 

	    if(newfd > fdmax){ 
	    	fdmax = newfd; 
	    } 
        //al momento della connessione il client invia le informazioni del proprio listener socket che il server invierà ad altri client che ne possono fare richiesta
        recv_msg(newfd, buffer);
        sscanf(buffer, "%s %d", ip_str, (int*)&listener_client.sin_port);
        inet_pton(AF_INET, ip_str, (void*)&listener_client.sin_addr);
        listener_client.sin_port=htons(listener_client.sin_port);
        listener_client.sin_family=AF_INET;
	    //la partita viene creata al momento della connessione 
	    crea_partita(listener_client, newfd);
	    printf("Nuovo client connesso, socket %d\n", newfd);
    }
}
			
//funzione per inviare le informazioni al client dopo l'esecuzione di un comando
void invia_info(int sd){
	char buffer[DIM_BUFFER];
	struct partita *p=cerca_partita(sd);

	sprintf(buffer, "%d %d %lld", p->token, 3-(p->token), (long long)((p->ora_fine)-time(NULL)));
	send_msg(sd, buffer);
}

