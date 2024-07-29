# Appunti di Reti Informatica
<div align="center">
Appunti presi durante il corso di reti informatiche nell'anno 2021/2022. La stesura non è completa e non è stata revisionata da alcun docente. Per qualsiasi miglioria o correzione provvedete pure a eseguire una richiesta di modifica.<br>
<b>Nota bene</b>: non completa, vuol dire non completa.

<b>aggiornato al:</b> <i>02/11/2022</i>

</div>
<details>
  <summary>Credits</summary>
  <i>Hanno contribuito:<br>
  	 <ul> 
	 	<li>M. Lampis</li>
	 </ul>
  </i>
</details>

<details>
  <summary>Indice</summary>

  * [Laboratorio 1](#laboratorio-1)
    + [Informazioni sul progetto](#informazioni-sul-progetto)
    + [Utenti](#utenti)
    + [File system](#file-system)
    + [Path](#path)
    + [Shell](#shell)
    + [Login](#login)
    + [Arresto e riavvio](#arresto-e-riavvio)
    + [Change directory](#change-directory)
    + [Manuale](#manuale)
  * [Laboratorio 2](#laboratorio-2)
    + [Distinzioni utenti](#distinzioni-utenti)
    + [Comandi su file e directory](#comandi-su-file-e-directory)
      - [touch](#touch)
      - [cat](#cat)
      - [remove](#remove)
    + [Hard e soft link](#hard-e-soft-link)
    + [Lettura di file](#lettura-di-file)
    + [redirezione I/O](#redirezione-i-o)
    + [su e sudo](#su-e-sudo)
    + [Must have per connessioni in rete](#must-have-per-connessioni-in-rete)
      - [Indirizzo IP](#indirizzo-ip)
      - [Maschera di rete](#maschera-di-rete)
    + [Comando IP](#comando-ip)
  * [Laboratorio 3](#laboratorio-3)
    + [File di configurazione](#file-di-configurazione)
    + [Comandi ifup e ifdown](#comandi-ifup-e-ifdown)
    + [Invio di pacchetti](#invio-di-pacchetti)
    + [Configurazione del gateway](#configurazione-del-gateway)
    + [Risoluzione dei nomi](#risoluzione-dei-nomi)
      - [File /etc/hosts](#file--etc-hosts)
      - [DNS](#dns)
      - [File /etc/resolv.conf](#file--etc-resolvconf)
    + [Name service switch](#name-service-switch)
  * [Laboratorio 4](#laboratorio-4)
    + [DHCP](#dhcp)
      - [Client dhcp](#client-dhcp)
    + [Internet control Message Protocol](#internet-control-message-protocol)
    + [ping](#ping)
  * [Laboratorio 5](#laboratorio-5)
    + [traceroute](#traceroute)
    + [Differenza C](#differenza-c)
  * [laboratorio 6](#laboratorio-6)
    + [socket](#socket)
    + [creazione di un socket](#creazione-di-un-socket)
    + [Processo server](#processo-server)
    + [Strutture per gli indirizzi](#strutture-per-gli-indirizzi)
    + [Endianness in reti e host](#endianness-in-reti-e-host)
    + [Formato degli indirizzi](#formato-degli-indirizzi)
    + [creazione e inizializzazione di un socket](#creazione-e-inizializzazione-di-un-socket)
    + [Programmazione distribuita](#programmazione-distribuita)
      - [Primitiva Bind](#primitiva-bind)
      - [Primitiva listen()](#primitiva-listen--)
  * [Laboratorio 7](#laboratorio-7)
    + [Dopo Listen](#dopo-listen)
    + [Accept](#accept)
    + [Realizzazione nel processo server](#realizzazione-nel-processo-server)
    + [Realizzazione nel processo client](#realizzazione-nel-processo-client)
    + [Primitiva connect](#primitiva-connect)
      - [Send e Receive](#send-e-receive)

</details>

## Laboratorio 1
###  Informazioni sul progetto
- si consegna 72 ore prima dell'esame 
- sulla pagina elearn
- Le domande di pistolesi saranno sulla parte teorica e pratica del laboratorio
  - Problemi in tempo reale
  - Nozioni teoriche
- non ci sono pretest, svolto tutto nello stesso giorno


### Utenti
L'utente principale è il root, il quale ha accesso completo. L'utente normale usa il sistema ma non può eseguire alcune configurazioni (come quella del firwall).

### File system
Si occupa di gestire i file all'interno del sistema operativo. Questo ha in realtà una grande rilevanza in quanto in unix tutto è un file! 
Tutti i dischi vengono resi accessibili tramite un unico file siystem principale.

Percorso | Funzione
---------|--------------------------------------------------|
`/`		 | directory principale
`/home`	 | home directory degli utenti
`/sbin`	 | System binaries, contiene i programmi di sistema
`/etc`	 |contiene i file di configurazione degli utenti
`/media` | rende accessibile i file rimovibili

Ogni documento, cartella, dispositivo, interfaccia di rete, stream di byte ecc è un file!

### Path
E' un percorso del file system, può essere assoluto o relativo.
- assoluto: si esprime l'intero percorso partendo dalla radice
- relativo: percorso espresso a partire dalla cartella in cui ci si trova

alcuni caratteri speciali specificano alcuni funzionamenti:
- `~`: indica la **nostra** directory (dunque quella dell'utente)
- `.`: indica la directory **corrente**
- `..`: indica la directory **padre**
  

### Shell 
Consente all'utente di richiedere informazioni e servizi al sistema operativo.
- Shell grafica: più facile
- Shell testuale: veloce e potente, anche se brutta

Una shell testuale mostra ripetutamente:
- un prompt
- legge un comando digitato,  terminato con invio/enter/return

Esistono vari tipi di shell, anche se il funzionamento è pressochè sempre il medesimo.


### Login
L'accesso viene fatto mediante `studente` `studente` per l'utente non privilegiato, mentre `root` `studente` per quello privilegiato.
Per uscire dalla sessione si può usare il comando `logout` o la scorciatoia `ctrl+D`


### Arresto e riavvio
- `shutdown -h now` per spegnere subito
- `shutdown -r now` riavvia

### Change directory
Il comando `cd` consente di muoversi all'interno del nostro filesystem mediante path (assoluti, partendo da `/` o relativi partendo dalla cartella corrente)


### Manuale
Il comando `man` permette di accedere al manuale di un comando, navigando anche tra le varie sezioni

`man comando num_sezione` permette di vedere alla sezion num_sezione del comando

---

 
## Laboratorio 2
### Distinzioni utenti
- `#`: root
- `$`: utente normale

### Comandi su file e directory

#### touch
`touch nome_file`
aggiorna il timestamp di accesso e modifica di un file, se il file non esiste lo crea

#### cat
`cat file1 file2`
concatena il contenuto di due file e li stampa nello stesso standard output, può essere utile per visualizzare velocemente file brevi

#### remove
`rm file1 file2`
rimuove uno o più file.
nota: `-r` per rimuovere una cartellla

### Hard e soft link
`ln target nome_link`
Crea un hard link a file o directory, per creare invece un symbolic link si usa `-r`. 

### Lettura di file
`less`: visualizza un po' alla volta il file interattivamente

`head/tail`: per visualizzare la prima o l'ultima parte di un file, si può specificare il numero di byte da mostrare con `-c` o il numero di righe con `-n`

### redirezione I/O

Comando | Funzione 															|
--------|-------------------------------------------------------------------|
`>`  	| invia stdout un file
`2>` 	| invia lo stderr
`&>` 	| invia entrambi
`>>` 	| scrive in append
`<`  	| recupera l'input da un file
`|`  	| pipeline, collega l'output di un comando all'input del successivo

*Si possono concatenare, la precedenza va in ordine di come sono digitati*


### su e sudo
- `su`: serve per accere come altro utente (se non specificato si accede a root)
- `sudo`: esegue un'operazione "come se fossi un'altro utente", overo fa il cambio di utente, esegue l'operazione e riporta all'utente precedente. Viene richiesta la password dell'utente corrente (per eseguire l'utente deve fare parte del gruppo sudoers)


### Must have per connessioni in rete

1. Indirizzo IP
2. Maschera di rete
3. indirizzo del gateway
4. Indirizzo del server DNS

#### Indirizzo IP
Indirizzo che indentifica l'host di una rete (un dispositivo). E' sempre vera come risposta? Si.
E' composto da una sequenza di 32 bit, che suddiviamo in gruppi da 8 distinti mediante il punto.
E' diviso in 2 parti: 
- una identifica la rete
- una identifica l'host

Non serve suddividere in base agli ottetti (vecchia usanza molto sconveniente), si utilizza piuttosto i primi k bit più a sinistra (più significativi) per identificare la rete e i 32-k bit per l'host di quella rete.

#### Maschera di rete
Sequenza di 32bit che viene utilizzata per identificare i bit che si occupano di inviduare la rete (il numero di bit destinati alla rete non è fisso in termini assoluti), motivo per cui è una sequenza avente tanti bit a 1 quanti sono i bit che identificano la rete (e i rimanenti a 0).

Esiste anche una notazione compatta che permette di mostrare subito la maschera: `\x`, dove `x` è il numero di bit a 1.

Permette così a trovare rapidamente l'indirizzo di rete e l'indirizzo di broadcast.

- **Indirizzo di rete**: Si ricava mediante un and bit a bit tra ip e netmask.
- **Indirizzo di broadcast**: Indirizzo che permette di inviare un pacchetto a tutti, si ricava mediante un or bit a bit tra ip e netmask negata.


### Comando IP
Visualizza e manipola le impostazioni di rete

- `ip addr show`: mostrami tutte le interfaccie
- `ip addr show up`: mostrami solo quelle accese
- `ip addr eth0`: mostrami solo l'interfaccia eth0
- `ip addr flush eth0`: cancella le impostazioni per eth0

Per leggere l'output la prima stringa specifica il nome. `lo` è l'interfaccia di loopback, tornano a me e serve solitamente per test.

Comando 	| Funzione 														|
------------|---------------------------------------------------------------|
`UP`		| scheda abilitata
`LOWER_UP`	| cavo collegato
`mtu`		| maximum transimission unit, dimensione massima (in byte) del pacchetto ip
`qdisc`		| queue discipiline, stabilisce il prossimo pacchetto da inoltrare
`state`		| scheda abilitata (UP) o disabilitata (DOWN)
`qlen`		| transimission queue lenght, lunghezza della coda di trasmissione
`link/ether`| significa porotocollo data link è ethernet e l'indirizzo fisico (mac) della scheda è xx:...:xx
`brd` 		| significa broadcast, ed è seguito dall'indirizzo yy:...:yy impostato dall'interfaccia come destination mac quando invia un broadcast
`inet` 		| si sta usanso il protocollo internet a livello network

La configurazione può essere fatta in modo statico o dinamico:
- statico: fatto in casa, ad opera di un'utente
- dinamico: mediante dhcp, configurazione dinamica che si occupa di assegnare gli indirizzi ip alle macchine non appena queste si connettono alla rete

si può abilitare o disabilitare un'interfaccia, specificando quali devono essere attive all'avvio.
```bash
root@studenti:	ip link set eth0 {up | down}
```

per impostare un'ip a un'intefaccia (configurazione manuale):
```bash
root@studenti:	ip addr add 192.168.1.42/24 broadcast 192.168.1.255 dev eth0
```

Attenzione: la configurazione mediante il comando ip è annullata al riavvio della macchina. Per renderla persistente si modifica il file di configurazione in /etc/network/interfaces



---

## Laboratorio 3

### File di configurazione 

```bash
auto lo

iface lo inet loopback

iface eth0 inet static
	address 192.168.1.2
	netmask 255.255.255.0
	broadcast 192.168.1.255
	gateway 192.168.1.1
```

- `auto lo`: all'avvio configura l'interfaccia di loopback. Se volessi anche etho sarebbe sufficiente fare `auto lo etho`.
- `gateway 192.168.1.1`: specifica quale gateway utilizzare.

### Comandi ifup e ifdown
`ifup eth0`: abilità l'interfaccia eth0 con la configurazione descritta in /etc/inetwork/interfaces
`ifup eth0`: disabilita l'interfaccia eth0
`ifup -a`: abilita tutte le interfacce della sezione auto nel file di configurazione, nello stesso ordine. è eseguito all'avvio.

### Invio di pacchetti
Se un host deve inviare un pacchetto a un altro host:

```bash
dest_subnet := my_netmask & dest_addr;

if (dest_subnet == my_subnet) then
	deliver to dest_addr;
else
	forward to default_gateway; # router della nostra rete
end if
```
se il destinatario è nella stessa sotto rete, viene consegnato direttamente. Viene ottimizzata la distanza tra i nodi (tramite dijstra) e aggiustando in base al traffico.

### Configurazione del gateway

Comando 	| Funzione 														|
------------|---------------------------------------------------------------|
`root@studenti:	ip route show`| mostrami la rotta dei pacchetti, ovvero la tabella di routing.
`root@studenti:	ip route add 192.168.1.0/24 dev eth0`| aggiunta di una rotta.
`root@studenti:	ip route add default via 192.168.1.1`| default gateway.
`root@studenti:	ip route get 70.143.3.67`| mostra la rotta usata.

### Risoluzione dei nomi
Per semplificare l'uso quotidiano della rete si associa un nome all'indirizzo ip. L'host deve essere in grado di ricavare l'indirizzo ip a partire dal nome (risoluzione del nome).
- Informazione statica nel file `/etc/hosts`
- sistema dei nomi di dominio dns

#### File /etc/hosts

```bash
127.0.0.1 localhost
127.0.1.1 studenti

151.101.37.140 	www.reddit.com
131.114.21.5 	www.unipi.it
```

#### DNS
database distribuito e gerarchico su più server DNS. Il client essegue una richiesta a un server dns, che rispodne con l'indirizzo ip.

#### File /etc/resolv.conf
Abbiamo gli indirizzi per il server dns da contattare. Per effettuare una richiesta l'host deve conoscere l'ip di almeno un server DNS.

```bash
nslookup nome_dominio
```

Può essere utile per vedere se il dns è configurato correttamente, da come risultato l'ip del dominio. All'esame può essere chiesto di verificare se una configurazione è corretta, e per esserne sicuri è fondamentale verificare anche la configurazione del dns.

### Name service switch 
Meccanismo che usa i file per andare a specificare l'ordine delle fonti da usare per tradurre un indirizzo simbolico. 

Il file `/etc/nsswitch.conf` specifica le fonti da usare e l'ordine in cui usarle.

Prima si passa da hosts, se non c'è niente andiamo a chiedere al dns.

---

## Laboratorio 4

### DHCP
Processo server che si occupa della configurazione automatica e dinamica dei parametri tcp/ip degli host mediante i parametri di: indirizzo ip, maschera di rete, indirizzo del gateway, indirizzo del server DNS.

All0interno delle reti possono esserci più dhcp, in generale è un server che è sempre in ascolto per la configurazione dei parametri di rete degli host.

Per fare in modo che un nuovo dispositivo si configuri correttamente, dobbiamo impostare la configurazione non alla nuova macchina ma bensì configurando il server dhcp.

L'host manda una richiesta sulla porta `68`,  in particolare a `0.0.0.0, 68` dove il primo è un indirizzo "finto", destinato al `255.255.255.255, 67` con `67` riservato per il server dhcp. Da notare come destinatario è il broadcast, di fatto il client sta mandandando un "grido disperato" aspettando che qualcuno sia in grado di rispondergli.

--- (slide 10 mancante) ---

#### Client dhcp
nel file `/etc/network/interfaces`

```bash
auto lo eth0

iface lo inet loopback

iface eth0 inet dhcp
```

Invece di `static`, si mette `dhcp`.


### Internet control Message Protocol

Protocollo di servizio che rileva malfunzionamenti, e scambia informazioni di controllo e messaggio di errore. E' incapsulato nel protocollo ip.

### ping
Testa la connetività tra host che lo esegue e un host remoto. Iterativamente, invia un messagio `ICMP echo request`, attende un messaggio `ICMP echo reply` e misura il tempo (in ms) che ha impiegato a raggiungere l'host destinatario e a ritornare indietro.

Si può osservare che tra le richieste il tempo di risposta cambia, ovviamente ciò è dovuto al traffico che varia.

Può succedere che il server non risponda in tempo o per qualche motivo non voglia rispondere. Un motivo potrebbe essere anche semplicemente una scarsa qualità della rete.


---


## Laboratorio 5

### traceroute

Mostra il percorso che un pacchetto ip effettua per raggiungere un host destinatario.

- `hope`: numero di salti che vengono fatti in termini di gateway attraversati.

il default gateway è il primo incotrato. 

La rete è formata da tanti router che instradano i pacchetti lungo il percorso. E' un cammino che cambia temporalmente dipendentemente dai criteri di ottimizzazione. 

- `ttl`:Time to live, numero di hope che è possibile fare per raggiungere la destinazione. Se ad esempio ttl = 20, allora al 21 salto butterei il pacchetto (ogni router diminusce di 1 ttl).

Tiene traccia degli indirizzi ip che all'interno dei messaggi ICMP time exceeded ricevuti finchè l'ultimo pacchetto della serie raggiunge l'host destinatario. Il destinatario, quando raggiunto,  non mada icmp time exceeded, ma un icmp destination unreachable.

Udp ha bisogno di una porta, i pacchetti verso il distinatario necessitano di una porta in ascolto. Scegliendone una alla cieca, è improbabile beccarne una in ascolto, ecco perchè l'host invia destination unreachable.

Mandiamo 3 cose e non una in modo da poter calcolare una media (ed avere dei valori più veritieri).


### Differenza C
- variabili definitie tutte insieme
- struct anche quando si definisce
- malloc() e free()
- attenzione ai caratteri di fine stringa

---

## laboratorio 6

### socket
un socket è un' estremità di un canale di comunicazione fra due processi (programmi) in esecuzione su macchine connesse in rete. E' un' astrazione implementata dal sistema operativo di cui sono fornite le primitive per:
- creare un socket
- assegnargli un indirizzo
- connettersi a un'altro socket
- accettare una connessione
- inviare e ricevere dati attraverso i socket

La **creazione** avviene nel seguente modo:
```c
// signature
int socket(int domain, int type, int protocol);
```

- **Domain**: famiglia di protocolli da utilizzare
  - `AF_LOCAL`: comunicazione locale
  - `AF_INE`T: protocollo IPv4, TCP e UDP
- **type**: tipologia di socket
  - `SOCK_STREAM`: Connessione affidabile, biderezionale (TCP)
  - `SOCK_DGRAM`: connectionless, invio di pacchetti UDP
- **protocol**: sempre a `0` (non approfondiremo)

La `socket()` restituisce un descrittore di file (`-1` in caso di errore) cioè un numero che rappresenta un file, una pipe, o un socket aperto dal processo e sul quale può fare operazioni.

**Attenzione**: dopo la chiamata a `socket()`, il socket non è associato nè a un indirizzo ip nè a una porta.

Il motivo per cui si preferisce, a volte, UDP (inaffidabile) è per avere una maggiore velocità di trasmissione in quanto si è esenti da tutto il controllo sull'affidabilità mediante il TCP.


### Processo server
E' un programma in esecuzione sulla macchina server (strato applicazione). Offre uno o più servizi e fa uso di system call per utilizzare i socket.

### Strutture per gli indirizzi

```c
struct sockaddr_in {
	sa_family_t sin family;  /* address family: AF_INET 		 */
	in_port_t sin_port; 	 /* Port (espresso in network order) */
	struct in_addr sin_addr; /* Address							 */
}

struct in_addr {
	uint32_t s_addr; /*Adress (espresso in network order)*/
}
```

- `_t` significa che indipendentemente dall'architettura del calcolatore, sono certificati occupare 32 bit (si può pensare a `_t` come un timbro di garanzia). Questi sono detti **tipi opachi**.


### Endianness in reti e host
Il formato usato in rete (network order) è big endian, quello dell'host (host order) dipende dall'host.

Esistono funzioni di conversione (dette molto volgarmente, le _"funzioni ninja"_) che permettono la conversione:
```c
// converts the unsigned integer hostlong from host byte order to network byte order
uint32_t htonl (uint32_t hostlong);

// converts the unsigned short integer hostshort from host byte order to network byte order
uint32_t htons (uint16_t hostshort);

// converts the unsigned integer netlong from network byte order to host byte order
uint32_t ntohl (uint32_t netlong);

// converts the unsigned short integer netshort from network byte order to host byte order
uint32_t ntohs (uint16_t netshort);
```

**Attenzione**: sono senza segno

### Formato degli indirizzi
- **Formato numerico**: 32 bit usato dal computer
- **formato presentazione**: stringa in notazione decimale puntata

La inet_pton converte la stringa di caratteri src in un indirizzo di rete nel af address family, dopo copia l'indirizzo di rete nella struttura del destinatario. Significa "inet presentation to numeric".

```c
// signature
int inet_pton(int af, const char* src, void* dst);
```

- `af`: famiglia (`AF_INET`)
- `src`: stringa del tipo `"ddd.ddd.ddd.ddd"`
- `dst`: puntatore a un'istanza di struttura `in_addr`

```c
const char* inet_ntop (int af, const void* src, char* dst, socklen_t size);
```
- af: famiglia (`AF_INET`)
- src: puntatore a un'istanza di struttura `in_addr`
- dst: puntatore a un buffer di caratteri di lunghezza size
- size: deve valere almeno `INET_ADDRSTRLEN` (16 byte)

### creazione e inizializzazione di un socket

```c
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main () {
	/* Creazione socket */
	int sd = socket(AF_INET, SOCK_STREAM, 0);

	/* Creazione indirizzo del socket */
	struct sockaddr_in indirizzo;
	memset(&indirizzo, 0, sizeof(indirizzo)); // Pulizia

	// Address family (IPv4)
	indirizzo.sin_family = AF_INET;
	
	// Port inizializzata a 4242, in network order
	indirizzo.sin_port = htons(4242);
	
	// IP address “192.168.4.5”, convertito in numeric format
	// e salvato in indirizzo.sin_addr
	inet_pton(AF_INET, "192.168.4.5", &indirizzo.sin_addr);
	
	// to be continued...
```

### Programmazione distribuita

#### Primitiva `bind()`
assegna un indirizzo (`sockaddr`) a un socket
- specifica ip e porta dove il server riceve richieste di connessione
- il client non ha di solito bisogno di eseguire la bind()

```c
signature
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

- **sockfd**: descrittore del socket
- **addr**: puntatore a struttura di tipo `sockaddr`. N.B.: usiamo `sockaddr_in`, occorre quindi un cast del puntatore
- **addrlen**: dimensione di addr
- La primitiva bind() restituisce `0` se ha successo, `-1` se si verifica un errore

dunque **l'intero restituito da solo informazioni sull'esito**, in quanto il socket è già stato creato.


```c
// esempio di utilizzo
ret = bind(int sd, (struck sockaddr*) &my_addr, sizeof(my_addr));
```


#### Primitiva `listen()`

specifica che il socket è usato per ricevere richieste di connessione (detto socket **passivo** o di ascolto). Si possono mettere in attesa solo i socket `SOCK_STREAM`.

```c
// signature
int listen(int sockfd, int backlog);
```

- `sockfd`: descrittore del socket
- `backlog`: dimensione della coda, numero massimo di richieste che possono essere messe in attesa
- la funzione restituisce `0` se ha successo, `-1` su errore

```c
// esempio di utilizzo
ret = listen(sd, 10);
```

L'importante è che la velocità del server sia ben calibrata con il numero delle richieste che arrivano (cercando di evitare in ogni modo il traboccamento).

**ATTENZIONE**: La listen NON è bloccante.

---

## Laboratorio 7

### Dopo listen

Il concetto di pacchetto è astratto, assume un nome differente a seconda del livello in cui stiamo parlando _(applicazione, fisico ecc...)_. 

Il socket, dopo aver chiamato la primativa, si mette in ascolto (motivo per cui lo definiamo come passivo, iin quanto si pone in attesa).

I socket bloccanti sono tali in quanto ci sono dei momenti in cui l'applicazione (sia client che server) si fermano. Questi saranno sbloccati da degli eventi (si potrebbe pensare come un meccanismo di sincronizzazione).

Immediatamente dopo la primitiva listen viene chiamata la primitiva accept.

### Primitiva `accept()`
```c
// signature
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
```

- `sockfd`: descrittore del socket
- `addr`: puntatore a una struttura *vuota* di tipo struct sockaddr dove viene salvato l'indirizzo del client
- `addrlen`: dimensione di addr
- Primitiva **bloccante**. Il programma si ferma in attesa di una richiesta di connessione.

**Attenzione**: il socket di default è bloccante.

La accept restituisce il descrittore di un nuovo socket: il socket che ascolta non è quello che verrà restituito.

```c
struct sockaddr_in cl_addr;
int len = sizeof(cl_addr);
new_sd = accept(sd, (struct sockaddr*)&cl_addr, &len);
```

Se ci sono due richieste in attesa, significa che la linea è occupata. In questo caso si parla di server iterativo, ovvero gestite una alla volta (ne esistono anche di concorrenti).

### Realizzazione nel processo server
```c
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main () {
	int ret, sd, new_sd, len;
	struct sockaddr_in my_addr, client_addr; // Strutture per gli IP

	/* Creazione socket */
	sd = socket(AF_INET, SOCK_STREAM, 0);
	
	/* Creazione indirizzo socket*/
	memset(&my_addr, 0, sizeof(my_addr)); // Pulizia
	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(4242);

	// "192.168.4.5" è l'ip della nostra macchina
	inet_pton(AF_INET, "192.168.4.5", &my_addr.sin_addr); 
	// In alternativa: my_addr.sin_addr.s_addr = INADDR_ANY;
	
	ret = bind(sd, (struct sockaddr*)&my_addr, sizeof(my_addr));
	ret = listen(sd, 10);
	len = sizeof(client_addr);
	new_sd = accept(sd, (struct sockaddr*)&client_addr, &len);
	//...
}
```

### Realizzazione nel processo client

**Attenzione**: il client non farà ne bind ne listen perchè non deve agganciare nessun indirizzo e non deve ascoltare nessuna richiesta. In particolare la bind non è necessaria perchè se ne occupa direttamente il sistema operativo utilizzando delle porte effiminere (porte tra quelle non riservate che vengono associate al processo client).

### Primitiva connect
Permette a un socket locale di inviare una richiesta di connessione a un socket remoto

```c
// signature
int connect(int sockfd, const struct sockaddr* addr, socklen_t addrlen);
```

- `sockfd`: descrittore del socket locale
- `addr`: puntatore alla struttura contenente l'indirizzo del socket remoto
- `addrlen`: dimensione di addr
- la primitiva restituisce `0` se ha successo, `-1` in caso di errore
- la primitiva è **bloccante**: il programma si ferma in attesa che la richiesta di connessione sia accettata

```c
// esempio di utilizzo
ret = connect(sd, (struct sockaddr*)&sv_addr, sizeof(sv_addr));
```

Se la coda è vuota il flusso scivola giù e non c'è alcun blocco.


#### Send e Receive
Il programmatore sa solo che sta versando dei dati verso il modello di trasporto tramite un protocollo affidabile che trasferirà i dati (ma non che verrà inviato tutto in una volta, perchè non è detto, dipende dal buffer di trasmissione associato al socket).

Se i  dati che mando non entrano nel buffer di trasferimento dati del socket.

#### Primitiva `send()`
Invia un messaggio attraverso un socket connesso. Attenzione: socket è un termine generico.

```c
ssize_t send(int sockefd, const void* buf, size_t len, int flags);
```

- `sockfd`: descritttore del socket
- `buf`: puntatore al buffer contenente il messaggio da inviare
- `len`: dimensione del messaggio (in byte)
- `flags`: per settare le opzioni (per adesso 0)
- la funzione resituisce il numero di byte inviati, `-1` se errore.
- **La funzione è bloccante**: il programma si ferma finchè non ha scritto tutto il messaggio

```c
int ret, sd, len;
char buffer[1024];

//…

strcpy(buffer, "Hello Server!");
len = strlen(buffer);

// invio
ret = send(sd, (void*)buffer, len, 0);

// se il messaggio non è entrato tutto
if (ret < len) {
	// Gestione errore
}
```

N.B.: Inviare significa inviare dal buffer dell'applicazione al buffer del kernel!


#### primitiva recv()
Riceve un messaggio da un socket connesso

```c
ssize_t recv(int sockfd, const void* buf, size_t len, int flags);
```

- `sockfd`: descrittore del socket
- `buf`: puntatore al buffer in cui salvare il messaggio
- `len`: dimensione in byte del messaggio desiderato
- `flags`: per settare le opzioni
- La funzione restituisce il numero di byte ricevuti, `-1` su errore, `0` se il socket remoto si è chiuso (vedi più avanti)
- **La funzione è bloccante**: il programma si ferma finché non ha letto qualcosa, dove con qualcosa si fa riferimento a **un byte**

```c
int ret, sd, bytes_needed;
char buffer[1024];

//…

bytes_needed = 20;

// ricezione
ret = recv(sd, (void*)buffer, bytes_needed, 0);

// Adesso 0 < ret <= bytes_needed
if (ret < bytes_needed) {
	// Gestione errore
}

ret = recv(sd, (void*)buffer, bytes_needed, MSG_WAITALL);
// Adesso ret == bytes_needed
```

#### Primitiva close
Chiude un socket, non può essere usato per inviare o ricevere dati.

```c
#include <unistd.h>

int close(int fd);
```

- fd: descrittore del socket
- la funzione restituisce `0` se ha successo, `-1` su errore
- l'host remoto riceverà `0` dalla `recv()`
  


#### gestione degli errori
Le primitivie restituiscono -1 quando c'è un errore, in più settano una variabile errno, che può esseee letta per scoprire il motivo dell'errore. Nel manuale di ogni funzione  c'è l'elenco degli errori possibili.

```c
#include <errno.h>

//…

ret = bind(sd, (struct sockaddr*)&my_addr, sizeof(my_addr));

if (ret == -1) {
	if (errno == EADDRINUSE) {/* Gestisci errore */}
	if (errno == EINVAL) {/* Gestisci errore */}
	//…
}
```

a volte vogliamo solo sapere l'errore e uscire
- perror() legge errno e stampa l'errore su schermo in forma leggibile.

```c
#include <stdio.h>

//…

ret = bind(sd, (struct sockaddr*)&my_addr, sizeof(my_addr));
if (ret == -1) {
	perror("Error: ");
	exit(1);
}
//…
```

---

## Laboratorio 8

### Server concorrenti
Precedentemente abbiamo parlato di server iterativi, che avevano la limitazione per cui se un server sta gestendo una richiesta non è in grado di gestire anche altre richieste. 

- **server iterativo**: Per ogni richiesta il processo le elabora e le richieste che sopraggiungono
- **Server concorrente**: serve più richieste alla volta e ogni richiesta accettata (mediante accept()) il processo server crea un processo che elabora (detto processo figlio)


#### Primitiva fork()
- clona il processo, il processo clone (figlio) esegue lo stesso codice del chiamante (padre)


```c
#include <unistd.h>
pid_t fork(void); // pid_t int con segno
```

- nel processo padre, fork() restituisce il process identifier (PID) del processo figlio creato. *(Il padre si mette in attesa)*
- nel processo figlio restituisce 0 *(il figlio gestisce la richiesta)*
- restituisce -1 in caso di errore

Dopo la chiamata di fork succede che il padre creerà il processo clone, mentre il figlio deve gestire la richiesta iniziando a scambiare i dati. Abbiamo, se guardiamo attentamente, una inutile complicazione. Il padre non ha bisogno del socket di comunicazione mentre il figlio non necessità del socket di ascolto, motivo per cui entrambi possono essere chiusi.

```c
pid_t pid;

//…

while(1){
	new_sd = accept(sd, …);
	pid = fork();

	// se pid vale 0 siamo nel FIGLIO
	if (pid == 0){
		// chiusura del socket sd (il figlio non lo usa) FIGLIO
		close(sd);

		// elaborazione della richiesta (usando il socket new_sd)
		// chiusura del socket new_sd
		close(new_sd);
		
		// il figlio termina
		exit(0);
	}

	// qui pid≠0, quindi siamo nel PADRE
	// chiusura del socket new_sd (il padre non lo usa)
	close(new_sd);

	// e fu sera e fu mattina...
	// ci blocchiamo su nuove richieste oppure ripartiamo
}
```

Esempio di server multiprocesso
```c
#include …
	int main () {
	int ret, sd, new_sd, len;
	struct sockaddr_in my_addr, cl_addr;

	//...
	
	pid_t pid;
	sd = socket(AF_INET, SOCK_STREAM, 0);
	
	/* Creazione indirizzo */
	ret = bind(sd, (struct sockaddr*)&my_addr, sizeof(my_addr));
	ret = listen(sd, 10);
	len = sizeof(cl_addr);
	
	while(1) {
		new_sd = accept(sd, (struct sockaddr*)&cl_addr, &len);
		pid = fork();
		if (pid == -1) {/* Gestione errore */}
		if (pid == 0) { /* Sono nel processo figlio */
		close(sd);
		/* Gestione richiesta (send, recv, …) */
		close(new_sd);
		exit(0);
	}

	// Sono nel processo padre
	close(new_sd);
}
```

### Modelli di I/O
Di default un socket è bloccante
- `connect()` blocca il processo finchè non è connesso
- `accept()` bloca il processo fincheè non arriva una richiesta di connessione
- `send()` blocca il processo finchè il messaggio non è stato inviato (il buffer di invio potrebbe essere pieno)
- `recv()` vlocca il processo fichè non ci sono stati dati disponibili o finchè tutto il messaggio richiesto non è disponibile (flag MSG_WAITALL)


> domanda esame: come sono collagati i momenti di attesa e dove?

Un socket può essere reso non bloccante inserendo `SOCK_NONBLOCK`, significa che le primitive che le primitive che sarebbero bloccanti non lo sono più.

```c
socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
```

- `connectt()`, se non può connettersi, restituisce `-1` e imposta `errno` a `EINPROGRESS`
- `accept()`, se non ci sono richieste, restituisce `-1` e imposta `errno` a `EWOULDBLOCK`
- `send()`, se non può inviare il messaggio (il buffer è pieno), restituisce `-1` e imposta `errno` a `EWOULDBLOCK`
- `recv()`, senon ci sono messaggi, restituisce -1 e imposta errno a `EWOULDBLOCK`

Attesa limitata all'unica lettura che ha successo, permettendo di fare altre cose nel nostro codice.

### Multiplexing I/O sincrono
Se faccio operazioni su un socket bloccante, non posso controllarne altri. La soluzione è controllare più descrittori/socket allo stesso tempo. Multiplexing con la primitiva select(): esamina più socket, il primo che è pronto viene usato.

Il primo che è pronto siginfiica che:
- un socket è pronto in lettura se
  - c'è almeno un byte da leggere
  - è stato chiuso
  - è in ascolto e ci sono connessioni effettuate
  - c'è un errore

- un socket è pronto in scrittura se
  - c'è spazion nel buffer per scrivere
  - c'è un errore (write() restituirà -1, se il socket è chiuso errno vale EPIPE)

### Insiemi di descrittori
- un descrittore è un int da 0 a FD_SETSIZE (solitamente 1024)
- un insieme di descrittori (detto set) si rappresenta con una variabile di tipo fd_set e si manipola con delle macro

```c
/* Aggiungere un descrittore “fd” all’insieme “set” */
void FD_SET(int fd, fd_set* set);

/* Controllare se un descrittore “fd” è nell’insieme “set” */
int FD_ISSET(int fd, fd_set* set);

/* Rimuovere un descrittore “fd” dall’insieme “set” */
void FD_CLR(int fd, fd_set* set);

/* Svuotare l’insieme “set” */
void FD_ZERO(fd_set* set);
```


### Primitiva select
Controlla più socket rilevando quelli pronti

```c
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
int select(int nfds, fd_set* readfds, fd_set* writefds, fd_set* exceptfds, struct timeval* timeout);
```

- nfds: numero del descrittore più altro da controllare, +1
- readfds/writefds: lista di descrittori da controllare per la lettura/scrittura
- exeptfds: lista di descrittori da controllare per le ecceazioni (non ci interessa)
- timeout: intervallo di timeout
- restituisce il numero di descrittori pronti (-1 in caso di errore)
- è bloccante: si blocca finchè uno dei descrittori controllati non è pronto, oppure finchè non scade il timeout

### Struttura per il timeout

```c
#include <sys/socket.h>
#include <netinet/in.h>

struct timeval {
	long tv_sec;	/* seconds */
	long tv_usec; 	/* microseconds */
};
```

- `timeout = NULL`, attesa indefinita fino a quando il descrittore è pronto
- `timeout = {10;5;}`, attesa massima di 10 secondi e 5 microsecondi
- `timeout = {0;0;}`, attesa nulla, controlla i descrittori ed esce immediatamente (polling)

### Comportamento di `select()`

select modifica gli insieme di descrittori:
- prima di chiamare `select()`, occorre inserire i descrittori da monitorare nei set di lettura e scrittura
- dopo l'esecuzione di `select()`, i set di lettura e scrittura contengono i descrittori pronti (rimangono solo loro)

```c
// lato server
int main(int argc, char* argv[]){
	fd_set master; 	 /* Set principale gestito dal programmatore con le macro */
	fd_set read_fds; /* Set di lettura gestito dallaselect */
	
	int fdmax; // Numero max di descrittori
	
	struct sockaddr_in sv_addr; // Indirizzo server
	struct sockaddr_in cl_addr; // Indirizzo client
	int listener; // Socket per l'ascolto
	
	int newfd; // Socket di comunicazione
	char buf[1024]; // Buffer di applicazione
	int nbytes;
	int addrlen;
	int i;

	/* Azzero i set */
	FD_ZERO(&master);
	FD_ZERO(&read_fds);
	
	listener = socket(AF_INET, SOCK_STREAM, 0);

	sv_addr.sin_family = AF_INET;

	// INADDR_ANY mette il server in ascolto su tutte le
	// interfacce (indirizzi IP) disponibili sul server
	sv_addr.sin_addr.s_addr = INADDR_ANY;
	sv_addr.sin_port = htons(20000);
	bind(listener, (struct sockaddr*)& sv_addr, sizeof(sv_addr));
	listen(listener, 10);

	// Aggiungo il listener al set dei socket monitorati
	FD_SET(listener, &master);
	
	// Tengo traccia del maggiore (ora è il listener)
	fdmax = listener;
	for(;;){
		read_fds = master; // read_fds sarà modificato dalla select
		select(fdmax + 1, &read_fds, NULL, NULL, NULL);
		for(i=0; i<=fdmax; i++) { // f1) Scorro il set

			if(FD_ISSET(i, &read_fds)) { // i1) Trovato desc. pronto

				if(i == listener) { // i2) È il listener
					addrlen = sizeof(cl_addr);
					newfd = accept(listener,(struct sockaddr *)&cl_addr, &addrlen);

					FD_SET(newfd, &master); // Aggiungo il nuovo socket
					if(newfd > fdmax){ fdmax = newfd; } // Aggiorno fdmax
				}
				else { // Il socket connesso è pronto
					nbytes = recv(i, buf, sizeof(buf));
					//… Uso i dati
					// Chiudo il socket connesso, non mi serve più
					close(i);

					// Tolgo il descrittore del socket connesso dal
					// set dei monitorati
					FD_CLR(i, &master);
				}

			} // Fine if i1	
		} // Fine for f1
	} // Fine for(;;)
	
	return 0;
}
```

---

## Laboratorio 10

### Socket UDP

A differenza del TCP (affidabile, sicurezza che i dati arrivino corretti) non siamo sicuri sull'effettiva correttezza dei dati.

Un socket UDP è connectionless, non usa operazioni preliminari per instaurare una connessione.

UDP non crea connessione, si utilizzano le primitive sendto() e recvfrom() devono ogni volta specificare l'indirizzo del socket remoto con cui vogliono comunicare (attenzione, non c'è un socket di ascolto e comunicazione perchè non c'è connessione).

#### Primitiva `sendto()`
Manda un messaggio attraverso un socket all'indirizzo specificato

```c
ssize_t sendto(int sockfd, const void* buf, size_t len,
int flags, const struct sockaddr* dest_addr,
socklen_t addrlen);
```

- `sockfd`: descrittore del socket
- `buf`: puntatore al buffer contenente il messaggio da inviare
- `len`: dimensione in byte del messaggio
- `flags`: per settare le opzioni (lasciamolo a 0)
- `dest_addr`: puntatore alla struttura contenente l'indirizzo del destinatario
- `addrlen`: lunghezza di dest_addr
- Restituisce il numero di byte inviati (o -1 in caso di errore)
- **È bloccante**: il programma si ferma finché non ha scritto tutto il messaggio

Cosa significa inviare? Spostare i dati dal buffer dell'applicazione al buffer del kernel.



#### Primitiva `recvfrom()`

Riceve un messaggio attraverso un socket.

```c
ssize_t recvfrom(int sockfd, const void* buf, size_t len,
int flags, struct sockaddr* src_addr,
socklen_t addrlen);
```

- `sockfd`: descrittore del socket
- `buf`: puntatore al buffer contenente il messaggio da ricevere
- `len`: dimensione in byte del messaggio
- `flags`: per settare le opzioni
- `src_addr`: puntatore a una struttura vuota per salvare l'indirizzo del mittente
- `addrlen`: lunghezza di dest_addr
- Restituisce il numero di byte ricevuti, -1 in caso di errore, oppure 0 se il socket remoto si è chiuso
- È bloccante: il programma si ferma finché non ha letto qualcosa (un byte)

#### Codice del server

```c
int main () {
	int ret, sd, len;
	char buf[BUFLEN];
	struct sockaddr_in my_addr, cl_addr;
	int addrlen = sizeof(cl_addr);

	/* Creazione socket UDP */
	sd = socket(AF_INET, SOCK_DGRAM, 0);
	
	/* Creazione indirizzo */
	memset(&my_addr, 0, sizeof(my_addr); // Pulizia
	my_addr.sin_family = AF_INET ;
	my_addr.sin_port = htons(4242);
	my_addr.sin_addr.s_addr = INADDR_ANY;
	ret = bind(sd, (struct sockaddr*)&my_addr, sizeof(my_addr));
	
	while(1) {
		len = recvfrom(sd, buf, BUFLEN, 0,(struct sockaddr*)&cl_addr, &addrlen);
		//fai cose ...
	}
```
N.B.: non c'è ne liste ne accept.


#### codice del client

```c
int main () {
	int ret, sd, len;
	char buf[BUFLEN];
	struct sockaddr_in sv_addr; // Struttura per il server
	
	/* Creazione socket */
	sd = socket(AF_INET, SOCK_DGRAM, 0);
	
	/* Creazione indirizzo del server */
	memset(&sv_addr, 0, sizeof(sv_addr); // Pulizia
	sv_addr.sin_family = AF_INET ;
	sv_addr.sin_port = htons(4242);
	inet_pton(AF_INET, "192.168.4.5", &sv_addr.sin_addr);
	
	while(1) {
		len = sendto(sd, buf, BUFLEN, 0, (struct sockaddr*)&sv_addr, sizeof(sv_addr));
		// ...
	}

	// ...
```

#### Socket UDP "connesso"

Attenzione, è udp e non è "con connessione" (?)

La differenza rispetto a prima è che nella parte del server si fa la bind e poi direttamente a recive. Il client non fa sendto ma chiama prima connect. Semplicemente dice al sistema operativo che userà quel socket per la comunicazione (in modo da non dover inserire più volte l'indirizzo). Possiamo quindi ora usare send() e recv(), ma rimaniamo comunque senza connessione diretta e sfruttiamo sempre UDP.

Per associare un socket UDP a un indirizzo (remoto) si può usare connect()
- il socket riceverà/invierà pacchetti solo da/a quell'indirizzo
- si possono usare send() e recv() senza specificare ogni volta l'indirizzo
- Non è una connessione, nel livello di trasporto c'è ancora UDP!

### Protocolli Text and Binary

Molti protocolli a livello applicativo inviano messaggi in formato testo (text protocols) mentre altri inviano le strutture dati (binary protocols). Per il testo si usa solitamente la codifica ASCII.

- Text protocols
  - **svantaggio**: overhead nella politica di decodifica, sono oggetto di attacchi di sniffing
  - **vantaggio**: sono semplici
- Binary protocols
  - **svantaggio**: incoerente con la struttura dati che si sta utilizzando ed è necessaria la serializzazione.
  - **vantaggio**: sono compatti, un testo equivalente potrebbe occupare più memoria (es trasmissioni di interi).

// ... non ancora riportato

---

## Laboratorio 11

### Firewall

Meccanismo di sicurezza che porta limitazioni al fine di sicurezza. E' possibile programmare delle regole. Le reti e i computer connessi a internet vanno protetti daa accessi indesiderati e malware.

Si definisce fiewall un sistema hardware o software che controlle le connessioni in ingresso e uscita e applica delle regole. Opera a livello di rete (network firewall) o a livello di macchina (host-based firewall).

#### Tipi di firewall
- **network layer** (packet filter): operano a livello di tcp/ip, analizzando gli header ip,tcp e udp
- **application layer**: operano a livello applicazione facendo deep packet inspection.
  - analizzano tutto il pacchetto (header e payload) e forniscono un controllo fino al livello 7 (vedere uutto il traffico che proviene da un host, ricostruire una pagina web, una conversazione email)
  - più efficaci, ma usano maggiori risorse computazionali (efficaci contro malware, vulnerabilità note, coportamenti dannosi delle applicazioni, ecc)
  
#### Packet filtering
Esistono due tipologie:
- stateless: ogni pacchetto viene analizzato in base a campi statici come indirizzi di sorgente e destinazione
- stateful: tiene traccia delle connessioni TCP e degli scambi UDP in corso, e discrimina le connessioni legittime da quelle sospette
  - più efficace, ma complesso e pesante rispetto al filtraggio stateless

#### Funzionamento
IL firwall contiene una tabella di regole, ogni regola contiene caratteristiche di pacchetto (criteria) e azioni da intraprendere (target) dove scarta (drop) o accetta (accept)

Ogni regola si trova su una riga.

Per ogni pacchetto scorre le regole (in ordine crescente di indice) e quando ne trova una i cui criteria corrispondono ai criteria del pacchetto, applica quella sola regola e passa ai pacchetti successivi. Dunque viene eseguita solo una regola.

Se butto via ho un firewall inclusivo, se faccio passare ho un firewall esclusivo.

Attenzione all'ordine delle regole!

Almeno una regola viene eseguita (l'ultima)

#### Regola di default
A seconda della regola di default (l'ultima) il firwall può essere:
- **inclusivo**: l'ultima regola blocca tutto, sicuro ama scomodo in quanto senza definire regole non si può accedere a nulla
- **Esclusivo**: l'ultima regola consente tutto, comodo ma insicuro in quanto devo prevedere e inserire manualmente tutte le regole che ritengo utili.


#### Netfilter e iptables

netfilter è il componente del kernel linux che offre le funzionalità  di:
- stateless/stateful packet filtering
- NA[P]T
- paclet mangling (manipolazione generica)

Iptables è il programma (linea di comando) per configurare le tabelle delle regole

#### Iptables
Lavora su più tabelle (table), ognuna dedicata a una funzionalità. Noi in particolare vedremo le tabelle di filter e nat

Iptable da anche la possiibilità di firewall, ma non sono la stessa cosa.

Ogni tabella contiene iiverse catene (chain). Ogni catena contiene una lista di regole da applicare a una categoria di pacchetti.

##### Tabella filter

Ha 3 chain:
- input
- output
- forward: pacchetti in transito, ovvero da inoltrare ad altri host

##### Utilizzo
Per visualizzare le rogole
```bash
iptables [-t table] -L [chain]
```

- sella tabella non è specificata viene selezionata filter
- se la catena non è specificata, vengono elencate tutte le catene

Per aggiungere una regola in fondo alla catena:
```bash
iptables [-t table] -A chain rule-specification
```

per aggiungere una regola in una posizione specifica:
```bash
iptables [-t table] -I chain [num] rule-specification
```

Se num non specificato mette in posizione 1.

Per rimuovere una regola:
```bash
iptables [-t table] -D chain rule-specification
```

Per rimuovere tutte le regole da una o più catene:
```bash
iptables [-t table] -F chain
```

Per cambiare la regola di default (policy) DROP/ACCEPT:
```bash
iptables [-t table] -p target
```

Formato delle regole:
Opzione | Descrizione |
--------|-------------|
`-p <protocollo>` 	| protocollo (TCP, UDP, ICMP, …)
`-s <address>` 		| indirizzo IP sorgente
`-d <address>`	 	| indirizzo IP destinazione
`--sport <port>`	| porta sorgente
`--dport <port>` 	| porta destinazione
`-i <interface>` 	| interfaccia di ingresso
`-o <interface>` 	| interfaccia di uscita
`-j <target>` 		| azione (DROP/ACCEPT)


con iptables -L si può rivedere le regole inserite.

Le regole non vengono salvate, ed è perciò necessario reimpostarle all'avvio.

Per salvare le regole:
```bash
iptables-save > file
```

Per caricare le regole:
```bash
iptables-restore < file
```


### NAT e PAT/NAPT
Gli indirizzi IP sono scarsi (un ISP  potrebbe avere indirizzi /16 capaci di gestire 65534 host, abbiamo problemi se abbiamo più dispositivi).

Per risparmiare si utilizzano varie tecniche come:
- assegnamento e recupero dinamico degli indirizzi
- NAT

Quello che fa il NAT è convertire tutti gli ip del client in un'unico IP.

#### Uscita (source NAT)
Le connessioni effettuate da un host sono alterate per mostrare lll'esterno un IP diverso da quello originale. CHi riceve le connesioni le vede provenire da un IP diverso da quello utilizzato da chi lle genera.

#### Ingresso (destination NAT)
Le connessioni effettuate da uno o più host sono alterate in modo da essere redirette verso indirizzi IP diversi da quelli originali. Chi effettua le connessioni alla fine si collega in realtà ad un'indirizzo diverso da quello che seleziona.

#### Port Address Traslation (PAT)
Estensione di Nat: mappa più host della lan in un solo IP. Con Pat un pacchetto entrante avente una porta di destinazione (dettapporta esterna) è dradotto in un pacchetto avente una porta differente (porta interna).

L'isp assegna un indirizzo IP al router; quando un host della rete si connette a internet, il router assegna a questo host un numero di porta che viene abbianto all'ip interno, dando quindi all'host un ip unic. (attenzione: il numero di porta serve a indentifccare un host, accezione diversa dal olito dove il numero di porta identifica un processo/servizio).


---

## Laboratorio 12

### iptables e na[p]t

iptables gestisce il na[p]t nella tabella nat

La tabella nat ha 3 catene:
- PREROUTING: fa destination NAT (D-NAT), cioè altera indirizzo/porta di destinazione dii pacchetti in arrivo (non verso l'esterno)
- OUTPUT: fa destination NAT (D-NAT) dei pacchetti in uscita dai processi localli, prima del routing
- POSTROUTING: fa source NAT (S-NAT), cioè altera indirizzo/porta sorgente dei pacchetti in uscita

### S-NAT (pacchetti in uscita)

```bash
iptables -t nat -A POSTROUTING -s 192.168.0.2 -j SNAT  --to-source 151.162.50.2
```

Per tutti i pacchetti in uscita proveniente dalla sorgente 192.168.0.2 fai S-NAT  impostando IP  a 151.162.50.2. Aggiungi alla chain di postrouting questa regola al firewall nella tabella nat

```bash
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source 151.162.50.1:4001-4100
```

4001-4100 è il range di porte riservate per riuscire a identificare gli host connessi. 

### D-NAT (pacchetti in ingresso)
```bash
iptables -t nat -A PREROUTING -d 151.162.50.2 -j DNAT --to 192.168.0.2
```

questa regola a quale pacchetti si applica? tutti, su tutte le porte.

(slide 48)



---

## Laboratorio 13

### HTTP
Protocollo per la condivisione di oggetti, ovvero file attraverso il web.


### Apache 
Non si può invocare direttamente, si usa il comando:
- `apache2ctl <comando>`: comando che permette di fare varie operazioni
	- start, stop, restart, status, configtest

In alternativa è possibile utilizzare service:
- service apache2 <comando>
    - start, stop, reload ...

Quando in esecuzione si può aprire un browser e accedere al sito: http://localhost

la pagina mostrata è /var/www/html/index.html

*come faresti a vedere se il server apache2 è attivo?* Posso fare apache2ctl status, oppure semplicemente andare a vedere all'indirizzo.

Apache2 può accettare e servire più richieste contemporaneamente.

#### File di configurazione
- La directory principale è `/etc/apache2/`
- il file di configurazione principale è: `/etc/apache2/apache2.conf`
- La configurazione si fa tramite direttive, eventualmente raggruppate in direttive contenitore (che sono rappresentati tramite parentesi angolari)

Su debian apache è un sistema modulare: il file di configurazione principale recupera le fvarie parti di configurazione da altri file, con la direttiva include (esempio ports.conf che specifica le porte da usare).

conf avaiable ha le configurazioni che sono disponibili, ma non è detto che siano attive. In particolare si trovano in /etc/apache2/conf-avaiable/*.conf

Per abilitare una configurazione si può utilizzare:
```bash
a2enconf <nome_file>
```
 
Il comando crea un soft link nella directory /etc/apache2/conf-enabled. Il file di configurazione principale è impostato per includere tutti i file in conf-enabled. 
 
**Attenzione**: Bisogna riavviare il server per ricaricare la configurazione ( a differenza del firewall, ad esempio, le cui regole sono subito valide).

#### Moduli
Anche questi si dividono in enabled e avaiable, e si trovano dentro:
```bash
mods-avaiable
mods-enabled
```

Si attivano mediante
```bash
a2enmod <nome_file>
```

si disattivano tramite
```bash
a2dismod <nome_file>
```

#### Direttive globali
specificano opzioni globali, ovvero valide per l'intero server. 

##### ServerRoot 
Specifica la directory principale dei file di configurazione di apache (i path relativi specificati nelle altre direttive sono risolti partendo da questa directory).

ServerRoot /etc/apache2/

Su debian è configurata automaticamente all'avvio del servizio del comando apache2ctl, in apache2.conf è infatti commentata e dovrebbe essere cambiata modificando il file per alterarla.

##### KeepAlive e KeepAliveTimeout
 KeepAlive on
 KeepAliveTimeout 5

KeepAlive specifica se offrire o meno connessioni persistenti di HTTP 1.1

KeepAliveTimeout specifica quanti secondi attendere la successiva richeista dal client, su una stessa connessione, prima di chiuderla.

 anche nella documentazione del progetto se mettiamo un numero dobbiamo mettere un numero specifico e spiegarlo. IN questo esempiio valori troppo elevati potrebbero bloccare inutilmente un processo che sta servendo un client lento o dsconnesso.

##### Direttiva listen
```bash
Listen 80
Listen 8080
```

Listen specifica le porte su cui Apache si mette in ascolto di connessioni, è obbligatoria se la direttiva non c'è il server non parte.

SU debian questa direttiva è presente in /etc/apache2/ports.conf

##### errorLog
ErrorLog /var/log/apache2/error.log

Tutti gli errori generati sono salvati in questo file, il formato degli errori può essere specificato tramite ErrorLogFormat e LogLevel

#### VirtualHost
Un virtualhost è un sito web hostato ssu una macchina con in esecuzione apache2. Grazie a questo siamo in grado di configurare più siti sullo stesso server web, sulla stessa macchina, con lo stesso indirizzo IP.

Il server discrimina le richieste dei client in base al campo host della richiesta HTTP.

Come accade per aprti di configurazioni e moduli, i siti sono in una directory dedicata:

```bash
/etc/apache2/sites-avaialable
```

per abilitare un sito:
```bash
a2ensite <nome_file>
```

Per disabilitare un sito:
```bash
a2dissite <nome_file>
```

Un sito abilitato ha un soft link in sites-enabled. Bisogna riavviare il server per ricaricare la configurazione.

Apache ha un default virtual host abilitato in /etc/apache2/sites-available/000-default.coonf

```bash
<VirtualHost*:80>

</VirtualHost>
```

VirtualHost serve per definire un virtual host (è una direttiva contenitore). Come valore necessita di un indirizzo ip e porta reaali, possiamo lasciare *:80.

```bash
<VirtualHost*:80>
	ServerName: ...
</VirtualHost>
```

ServerName è il nome simbolico del sito. Il documentRoot invece e la directory dei file del sito (messi a disposizione dei client).

Attento alla diffrenza tra serverRoot e DocumentRoot.


### Multi processing Modules

Moduli che permettono di gestire le risorse riduciendo i tempi di attesa.

Apache accetta e serve più richieste contemporaneamente.

Lo fa tramite moduli multi processing module (MPM):
- gestione dei socket
- binding di porte
- processazionedelle richieste usando processi figli e thread
  
Su unix si può scegliere tra gli MPM:
- prefork
- worker 
- event

#### Prefork

Non usa i thread. All'avvio un processo padre lancia un certo numero di processi figli (preforking):
- i figli (worker o server) restano in ascolto, accettano connessioni e le servono.
- Dopo aver servito una connessione, il worker torna disponiible.
- Il padre gestisce il pool dei figli, cercando di natene MPrne sempre alcuni disponibili.. 

IL proforking all'avvio e il riuso dei vari worker evitano l'overhad della fork() a ogni connessione.

### MPM prefork

Ogni fglio viene riciclato per MaxConnectionPerChild connessioni poi viene terminato, per vevitare memory leak accidentali.

vantaggi:
- massima compatibilità
- massima stabiità, un processo che crasha  interrompe solo una connessione
  
svantaggi:
- occupazione di memoria
- complessità di tuning


### MPM worker
Server multi processo e multi thread
- il processo padre genera un certo numeo di processi figli
  - ogni processo figlio genera
    - un thread listener che accetta/smista le connessioni 
    - un certo numero di thread worker che servono le richieste
- overhead ridotto grazie al preforking e risparmio di memoria grazie ai thread


### MPM event
default e migliorato di worker

Oltre ad accettare le connessioni, il listener gestisce le connessioni temporanemanete inattive. 

Es1: Si risolve il problema di attesa di worker quando si ha ritardo nella risposta. Invece di attendere, restituisce il controllo del socket al listenr e passa a servire un altro client. Quando il primo client invierà la richiesta, il listener la assegnerà a un altro worker libero.

Es2: un worker sta servendo un client con una connessionelenta e il buffer di invio sel socket si rimepie. Invece di attendere, restituisce il controllo del socket al listener che lo assegnerà a un altro worker e non appena sarà di nuovo scrivibile.

Dunque si eliminano i tempi morti.

### Limiti globali

...



---

## Laboratorio 15

### OSPF

- open: disponibile pubblicamente
- usa il link state algorithm
  - ls paclet dissemination
  - mappa topologica per ogni nodo
  - route computation attraverso l'algoritmo di dijkstra 
- OSPF ha una entry per ogni vicino

ROuting gerarchico: questo avviene attraverso varie "famiglie"

boundary router: router di uscita

dividendo i router i 3 aree più piccole il file è più piccolo. 

I router backbone utilizzano OSPF.

### algoritmo BGP
intra AS: smistare il traffico all'interno dello stesso otonimo ... system
inter AS: smistare all'interno di reti differenti (si esce)

BGP sta per border gateway protocol, che è il protocollo di routing tra domini (la colla di internet)

Fornisce a ogni AS:
- eBGP: si preoccupa di capire quali autonimus system vicino portano quali prefissi di rete (esterni)
- iBGP: si preoccupa di propagare l'informazione all'interno dei router interni
- determinare una buona rotta in base alla raggiungibilità delle informazioni

consente a una subnet di avvertire della sua esistenza al resto dell'internet.


### Protocolli per gateway esterni

Si occupano di aspetti anche politici, un AS aziendale potrebbe non essere disposto a trasportare pacchetti da un AS estraneo verso un AS estraneo anche se sul percorso più corto. Potrebbe essere disposto a farlo dietro pagamento.

Criteri possono essere:
- nessun traffico comerciale su reti di ricerca
- non usare AT&AT in australia perchè ha basse prestazioni
- il traffico da/verso apple non deve passare attraverso google

### Politiche di routing
- proprietarie e individuali
- decidono quale traffico può fluire su qualli linee fra AS
- politica comune: un cliente di un ISP paga un altro ISP  per consegnare pacchetti a qualunque altra destinazione di internet e ricevere pacchetti inviati da qualunque altra destinazione (isp cliente compra servizio di transito da isp fornitore)

### BGP basic
- BGP session: 2 bgp routers scambiano messaggi bgp
  - path vector protocol

