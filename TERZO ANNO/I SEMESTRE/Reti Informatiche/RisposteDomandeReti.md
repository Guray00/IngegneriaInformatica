# Applicazioni di Rete
## DNS
E un protocollo di **risoluzione** di indirizzi che opera con UDP, per garantire **reattività**, che opera sulla porta 53. Permette la **traduzione di indirizzi simbolici** [es. google.it] nel loro indirizzo IP corrispondente [es. 64.233.167.99]. Per richiedere la registrazione di un indirizzo ci si rivolge ad un _register_, che aggiungerà i record necessari al suo database. Tra gli altri servizi, il DNS offer tra gli altri:
* **traduzione** da hostname ad indirizzo IP;
* **host aliasing**, ovver la traduzione da un _hostname_ ad uno _canonico_;
* **mail server aliasing**, che traduce gli indirizzi mail negli hostname relativi a quell'indirizzo;
* **Distribuzione di carico**: che permette il dirottamente di alcune richieste ad un indirizzo ad un suo _mirror_, ovvero un host in tutto e per tutto identico ad un altro, gestito dalla stessa organizzazione, ma su un indirizzo diverso, per non congestionare un solo server. Per far ciò ruota semplicemente la lista di indirizzi IP che corrispondono al nome simbolico cercato, in modo da distribuire le richieste;

Ovviamente non esiste un solo server DNS, che risulterebbe essere un _single point of failure_ per l'intera rete mondiali, ma ne sono presenti 13, detti _root server_, che a loro volta hanno dei server 'regionali' per servire meglio le richiesta da una o l'altra parte del mondo. Esistono inoltre i **TLD server**, ovvero i Top-Level-Domain server, che gestiscono tutti i domini di primo livello [.com, .org etc] e quelli relativi ai paesi [.it, .uk etc]. Abbiamo poi gli **Authoritative server**, che si occupano di risolvere tutti i sottodomini di un dominio, e sono comuni all'interno di organizzazioni e server provider.
Nella realtà i client contattano i **local DNS server**, i quali risolvono la richiesta contattando altri server DNS agendo come proxy e implementando un sistema di cache. La risoluzione può avvenire in due modi: iterativamente o ricorsivamente.
##### Risoluzione Iterativa
In ordine accade ciò:
1. Il client chiede la local server DNS la risoluzione di un indirizzo
2. Il local DNS server contatta il root DNS per ottenere l'indirizzo del TLD Server responsabile del dominio richiesto
3. Il local DNS contatta il TLD server che risponde con l'IP dell'authoritative server che gestice l'indirizzo
4. Contatta quest'utlimo server che risolve infine l'indirizzo richiesto dal client

##### Risoluzione ricorsiva
In questo metodo le singole richieste non vengono effettuate tutte dal local DNS, ma dal server contattato che a sua volta restituisce il risultato a chi ha fatto richiesta, fino a tornare al client, proprio come un algoritmo ricorsivo. Si noti che in questo modo il carico sui server intermedi, che generalmente sono abbstaza liberi, aumenta.

##### Cache  e Record di un server DNS
Ogni server, compreso l'host stesso, ha la propria cache, la cui vita utile è generalmente di 2 giorni. In particolare, i TLD sono cachati nei locale DNS perchè sono tutte le richieste verso lo stesso TLD DNS server. 
La struttura di un record DNS è del tipo:
        _<name, value, type, ttl>_
Il campo _ttl_ è il Time-To-live, cioè il tempo per il quale la entry è valida. 
Il campo _type_ assume diversi valori con diversi significati:
* **tipo A**: in questo caso il campo _name_ contiene l'hostname, mentre _value_ contiene l'indirizzo IP;
* **tipo CNAME**: _name_ contiene l'alias, mentre _value_ il nome canonico;
* **tipo NS**: _name_ contiene il dominio, _value_ l'hostname dell'Authoritative Server per quel dominio;
* **tipo MX**: MX sta per Mail eXchange, _name_ contiene il dominio, _value_ il nome canonico del mailserver associato al dominio 

## HTTP
E' il protocollo usato per  la navigazione sul web. Una pagina web è formata da alcuni elementi, che viene scaricata quando richiesta, e al suo interno avrà dei collegamenti, detti URL, per accedere ad altre risorse presenti nel server contattato. Ha un **approccio Client-Server**, dove il client è il browser di un utente, che comunica attraverso la porta 80 via TCP. Il protocollo è _stateless_, dunque ogni richiesta è a sè stante, rendendo incorrelabili tra loro richieste al server fatto dallo stesso client: in tal modo il protocollo è più semplice, ma lascia dello spazio di azione per implementare politiche di _riconciliazione_ tra client e server.
Può essere **persistente** quando permette lo scambio di più oggetti sulla stessa connessione, di contro sarà **non persistente** quando al massimo un solo oggetto viene scambiato durante la connessione.

#### Formnato del messaggio HTTP
Il messaggio HTTP è composto da una riga di intestazione, che contiene informazioni sul messaggio stesso, e da un corpo, che contiene il messaggio vero e proprio. Il formato è il seguente:
         _< metodo > < URL > < versione HTTP >_
        _< intestazione >_
        _< corpo >_
Il metodo può essere uno dei seguenti:
* **GET**: richiesta di un oggetto;
* **POST**: invio di un oggetto;

Attraverso gli header è possibile trasmettere eventuali errori tramite il codice di stato, [ad esempio 200->OK, 404->Not Found, 500->Internal Server Error, ecc.]

#### Cookie
Sono un metodo utilizzato per rendere _stateful_ il protocollo HTTP. Il server può inviare un cookie al client, che lo memorizza e lo invia al server con ogni richiesta. Il cookie si compone di:
* **header** della risposta;
* **header** della richiesta;
* **file** sul client che mantiene i cookie in memoria;
* **database** sul server che mantiene i cookie in memoria.

Il meccanismo è il seguente:
1. Il client esegue una normale richiesta HTTP;
2. Il server risponde con un header di tipo Set-Cookie, che contiene nome e valore del cookie;
3. Alla richiesta successiva, il client invia un header di tipo Cookie, che contiene il nome e il valore del cookie.
4. Il server risponde normalmente.

I cookie possono contenere, tra le altre cose, informazioni di autenticazione, preferenze dell'utente, informazioni di sessione, ecc.

## Web cache - Proxy
Un proxy è un server, solitamente installato dagli ISP, che si mette tra il client e il server, e che memorizza le risorse scaricate, in modo da poterle servire in caso di richieste future. Questo permette di **ridurre il carico** sul server, e di velocizzare la navigazione. Il proxy server si comporta dunque in realtà **sia come client**, quando chiede al server se le sue risorse sono aggiornate, **sia come server**, quando serve le risorse ai client. 

## Paradigmi Client-Server e Peer2Peer
#### Principali differenze, pro e contro di ognuno
Il **paradigma Client-Server** si serve di una macchina nel quale gira il processo Server, detta anch'essa Server, che fornisce i servizi ai dispositivi che li richiedono, detti client. Il servizio dunque viene erogato fintanto che il server è raggiungibile.
Il **paradigma Peer to Peer** invece fa affidamento ad una rete in cui i dispositivi possono fungere sia da client che da server, all'evenienza, detti appunto peer, che comunicano tra loro senza bisogno di un server centrale.
Le principali differenze emergono in diversi aspetti:
* **Scalabilità**: un'architettura P2P è più facilemente scalabile, poichè sarebbe sufficiente aggiungere dei peer alla rete, che sono di fatto dispositivi da normali prestazioni, mentre nell'altro caso aumentare la potenza di calcolo, la memoria di un server o addirittura aggiungerne di nuovi può essere economicamente impegnativo.
* **Gestione**: i peer non garantiscono la loro presenza costante, una velocità di connessione adeguata e generalmente non implementano misure di sicurezza molto robuste, al contrario dei server che invece sono macchine performanti, sempre online e con importanti misure di sicurezza [firewall, autenticazione...]
### Caso di invio/trasmissione di file in entrambe le architetture
Poniamo il caso di dover inviare un file di dimensione F ad N dispositivi. Poniamo alcuni dati:
* $U_{s}$, velocità di upload del **server**
* $U_{i}$, veolcità di upload del **peer**
* $D_{i}$, velocità di download del **peer i-esimo**

Il tempo impiegato dal server per inviare a tutti i client è pari a $\frac{NF}{U_{s}}$, mentre il tempo necessario per ricevere il file è$\frac{F}{D_{i}}$.
Di conseguenza il tempo necessario per la distribuzione del file ad N client è pari a $$max {\frac{NF}{U_{s}}, \frac{F}{D_{i}}}$$ 

che, per N->∞, è lineare. 
Nel caso P2P abbiamo invece:
*  $\frac{F}{U_{s}}$, tempo per la prima copia
* $\frac{F}{min{D_{i}}}$, tempo per caricare il file nel nodo con velocità minore
* $\frac{N F}{(U_{s} +Ʃ U_{i})}$, tempo per scaricare N copie usando upload massimo. Si noti che il denominatore può essere assunto come $(U_{s} + N \cdot U_{medio})$


Dunque il tempo necessario del file sotto le medesime condizioni è: $$max {\frac{F}{U_{s}}, \frac{F}{min(D_{i})}, \frac{NF}{(U_{s} + N \cdot U_{medio})}}$$ che, per N->∞, è pari a 
$$\frac {F}{U_{medio}}$$.
Se ne deduce che **asintoticamente** il paradigma P2P è migliore in fase di invio di file.

### Databse P2P per la ricerca e l'individuazione di risorse
La filosofia del paradigma P2P è la **struttura decentralizzata**, che potrebbe incontrare delle difficoltà in fase di individuazione delle risorse da reperire. L'idea è quella di creare un database contenente delle tuple _<chiave, valore>_ dove la chiave rappresenta il contenuto messo a disposizione o da individuare, mentre il valore rappresenta l'indirizzo IP del nodo che possiede tale risorsa, in modo che i peer possano consultare questo database e richiedere direttamente la risorsa. Non essendoci però un server centrale, perlomeno nella versione 'pura' del P2P, anche questo metodo potrebbe essere di difficile implementazione.

#### Centralized Index
Questo approccio si allontana da un'architettura P2P pura, in quanto prevede l'esistenza di un **server centrale** che possiede tale database e risponda alle query dei peer per la localizzazione delle risorse, mentre lo scambio avviene tra i due Peer. Sono presenti alcune criticità:
* come qualunque servizio centralizzato, il server costituisce un _single point of failuer_ per il servizio di ricerca della risorsa;
* performance del server, che potrebbero essere ridotte dato che deve rispondere da solo a tutte le richieste dei perr;
* responsabilità legali del gestore del server, in caso di problemi di copyright e simili, come nel caso Napster

#### Query flooding
Contrariamente al precedente, questo approccio è completamente **decentralizzato**: in sostanza l'indice è distribuito su tutti i nodi, che sono connessi tra di loro a formare un grafo. La richiesta viene quindi forgiata ed **inviata da un nodo ai suoi adiacenti**, che **a loro volta la invieranno** ai loro adiacenti, per poi tornare indietro una volta che la risorsa viene individuata. Il termine _flooding_ deriva proprio dal fatto che il numero di richieste all'interno della rete è molto elevato; per evitare problemi di prestazioni in caso di reti molto grandi si può fare ricorso alle _limited-scope query_. Questo metodo fa in modo che la richiesta venga propagata un numero limitato di volte, introducendo però di contro la possibilità di incorrere in falsi negtivi. Un'implementazione di questa tecnica era quella presente in **GNUtella**, che faceva uso di una lista di utenti più attivi o di un track server con tutti gli indirizzi dei peer. Per entrare nella rete, un nuovo peer recuperava un piccolo insieme di tali indirizzi, in modo da formare la sua lista di nodi adiacenti stabilendo con loro una connessione TCP. Viene dunque inviato loro un _ping_ settato ad un certo valore, che decresce ogni volta che il messaggio viene propagato; ogni peer che riceve questo ping risponderà a sua volta con un _pong_ con le  informazioni necessarie per instaurare una connessione TCP

#### Ricerca gerarichica
Una soluzione che è un ibrido tra il **query flooding** e il **centralized index**: sono presenti dei _supernodi_, ovvero dei peer con elevata banda e lunghi tempi di permanenza online, che formano una seconda rete tra di loro. Ogni supernodo possiede inoltre una porzione dell'indice. Un peer può connettersi ad uno di questi supernodi per informarli del loro contenuto e per effettuare query di ricerca, che viene propagata eventualmente all'interno della sottorete. Una volta ricevuta risposta, viene instaurata una connessione P2P tra i due peer interessati

#### Distributed hash table
E' la tecnica usata su eMule: si assegna un identificatore di peer nel range [0,2^n-1^], così come le chiavi, che si ottengono passando la chiave di ricerca ad una funzione di hash. Le tuple formate sono associate ai peer in modo che ogni chiave sia associata al peer con l'ID immediatamente successivo, creando di fatto una lista circolare. L'intera lista può essere controllata con complessità O(N), che può scendere a O(logN). La persistenza della lista viene gestita attraverso dei ping che ogni nodo invia periodicamente al suo suo successore e al successore del successore, aggiustando la lista in caso di disconnessioni.

#### BitTorrent
Abbiamo dei compiti specifici che possono essere svolti da qualunque nodo della rete:
* **Torrent server**, mantiene in memoria i file .torrent e permette a chiunque di scaricarli;
* **Tracker**, server che traccia i peer che fanno parte della rete di distribuzione;
* **Seeder**, peer che ha terminato il download del file e continua a distribuirlo;
* **Leecher**, peer che deve ancora completare il download e che contemporaneamente carica i chunk in suo possesso;

I **chunk** sono 'blocchi' da 256KB nel quale la risorsa viene divisa, e sono le unità attraverso il quale il file viene inviato. 
I file **.torrent** sono file che contengono informazioni sulla rete, come l'IP del tracker e le informazioni sui chunk da cercare.
Il procedimento è dunque il seguente: all'inizio un peer contatta il tracker e si connette con alcuni peer che il tracker stesso gli indica. Una volta connessi, i due peer si scambiano la lista di chunk in loro possesso per decidere quali richiedere; è importante ricordare che **NON** è importante che i chunk vengano inviati in ordine, in quanto vengono eventualmente ordinati a posteriori. Tuttavia per la condivisione dei chunk si usa la metrica del _rarest_first_, ovvero vengono inviati prima i chunk meno comuni della rete, in modo da aumentarne la loro presenza. Ogni peer usa la tecninca del _tit-for-tat_: si hanno 4 connessioni simultanee con i peer a più alto rate di trasmissione. Ogni 10 secondi il gruppo viene rivalutato e ogni 30 si sceglie casualmente un altro peer per lo scambio dei chunk, secondo l'_optimisticallly unchoke_

# Data Link Layer
## PPP (Point-to-Point Protocols)
I **PPP** è un protocollo del tipo Data-link che permette la comunicazione tra due elementi, un mittente e un destinatario. Esso prevede:
* **Packet framing**: permette di incapsulare i datagrammi del livello di rete nel livello Data-link. In questo modo è possibile implementare tutti i protocolli del livello di rete;
* **Bit transparency**: è possibile inviare bit arbitrari, senza che questi vengano modificati o interpretati;
* **Error detection**, ma non la error correction(che può comunque essere implementata a livello di rete);
* **Connection liveness**: permette di verificare eventuali problemi di collegamento;
* **Network layer address negotiation**: gli endpoint possono accordarsi su un indirizzo di rete da utilizzare;

Si noti che il protocollo **NON** implementa:
* **Flow control**: non è possibile controllare la quantità di dati che possono essere inviati;
* **point-to-multipoint**: non è possibile inviare dati a più destinatari;
* **in-order delivery**: non è possibile garantire l'ordine di consegna dei dati;

### PPP Frame
Il **PPP Frame** è un datagramma che viene inviato dal livello di rete al livello Data-link. Il PPP Frame è composto, in ordine, da:
* **flag**: 8 bit [01111110] che segnalano l'inizio del frame;
* **address**: 8 bit [11111111], attualmente non utilizzati;
* **control**: 8 bit [00000011], attualmente non utilizzati ma disponibili per futuri sviluppi;
* **protocol**: 16 bit, contiene l'identificativo del protocollo di livello di rete. Ad esempio volendo implementare il protocollo IP, il campo protocol deve contenere il valore 8021 che corrisponde al protocollo IPCP [Ip Control Protocol];
* **info**: 0-1500 bit, contiene i dati del livello di rete;
* **checksum**: 8 o 16 bit, contiene il checksum del frame;
* **flag**: 8 bit [01111110] che segnalano la fine del frame;
  


### Byte stuffing
Il **byte stuffing** è una tecnica che permette di inserire nel frame dei bit di controllo, senza che questi vengano interpretati come tali. In particolare, il byte stuffing è implementato in questo modo:    
 **01111110** -> **01111110 01111101**
 In questo modo il destinatario, che riceve la sequenza **01111110 01111101**, può distinguere il primo byte di controllo, che rimuove, dal secondo, che mantiene.

## Slotted e Unslotted ALOHA
### Slotted ALOHA
Il **Slotted ALOHA** è un protocollo di accesso al mezzo che permette di gestire la collisione tra più trasmissioni. Per ipotesi supponiamo che i frame siano tutti della stessa dimensione, e che il mezzo sia in grado di trasmettere un frame alla volta. Di conseguenza possiamo immaginare di dividere il mezzo in slot temporali, in modo da poter trasmettere un frame per volta. Il protocollo è implementato nel seguente modo:
1. Il nodo che vuole trasmettere un frame lo fa al primo slot possibile;
2. Se due o più nodi trasmettono contemporaneamente, si verifica una collisione;
3. I nodi che hanno colliso scelgono se provare a reinviare subito il frame secondo una probabilità _p_, che viene calcolata finchè il frame non viene inviato con successo, e ciò per tutti i nodi;
I pro di questo protocollo sono:
* **Semplicità**: è molto semplice da implementare;
* **utilizzo del mezzo**: è possibile utilizzare il mezzo al massimo della sua capacità;
* **alta decentralizzazione**: le uniche informazioni da negoziare sono la durata dello slot e il suo inizio.

I contro di questo protocollo sono:
* **alto numero di collisioni**;
* **alcuni slot vengono sprecati**;
* **detection delle collisioni non immediata**;
* **sincronizzazione dei nodi**.

L'efficienza di questo protocollo è probabilistica, e dipende dalla probabilità che tutti i nodi inviino correttamente il frame. Questa è pari alla probabilità che un nodo invii correttamente il frame e che gli altri nodi non provino a reinviare il frame, cioè:
$$p_{eff} = p(1-p)^{n-1}$$
Asintooticamente, per N->∞, e per un p' che massimizzi tale probabilità, otteniamo che:
$$p_{eff} = \frac{1}{e}$$
e quindi:
$$p_{eff} \approx 0.37$$
che è pari ad un'efficienza del mezzo pari al 37%.  

### Unslotted ALOHA
Viene eliminata la sincronizzazione dei nodi,: ciò comporta una maggiore probabilità di collisione, in quanto un frame inviato all'istante t_0_ può collidere con i frame inviati nella finestra temporale [t_0_, t_0_ + T]. La sua efficenza è quindi:
$$p_{eff} = p  (1-p)^{2(N-1)}$$
e quindi:
$$p_{eff} =  \frac{1}{2e}$$
che è pari ad un'efficienza del mezzo pari al 18%.

## CSMA/CD
Il **CSMA/CD** è un protocollo di accesso al mezzo che permette di gestire la collisione tra più trasmissioni, derivato dal CSMA puro. Se infatti quest'ultimo invia tutto il frame se trova il canale libero, senza alcuna tecnica per la verifica del mezzo durante la trasmissione (che risulterebbe essere tempo sprecato), la sua evoluzione, il CSMA/CD, invece, invia un frame solo se il canale è libero per tutta la sua durata. Se una collisione si verifica, il canale viene liberato immediatamente in modo da non sprecare tempo. La detenzione della collisione può avvenire in vari modi:
* **misurazione della potenza del segnale** in caso di reti su cavo: se essa è maggiore della potenza che il nodo può generare, allora si può affermare che la collisione è avvenuta;
* in modo simile, **misurazione della potenza del segnale** in caso di reti wireless, anche se vanno tenute in conto anche le interferenze;

Quabdo ci si accorge di una collisione, si aumenta la potenza di trasmissione per rendere noto a tutti dell'avvenuta collisione: questa azione viene definita **jam signal**. Il CSMA/CD garantisce la _fullfilness_ del mezzo, così come la _fairness_ tra i nod, in quanto si estrae un tempo casuale da attendere prima della ritrasmissione, garantendo a tutti la possibilità di trasmettere.
E' completamente decentralizzato, ed è molto efficiente per bassi carichi di traffico, ma non per carichi elevati, in quanto la probabilità di collisione aumenta con il numero di nodi.

## Ethernet
L'**Ethernet** è un protocollo **connectionless** di livello 2, non affidabile, che permette di trasmettere frame tra nodi collegati tramite un cavo. Il frame è composto da:
* **Preamble**: è una sequenza di 8 byte, di cui i primi 7 sono 10101010, e l'ultimo è 10101011. Questa sequenza viene inviata per permettere ai nodi di sincronizzarsi;
* **indirizzo di destinazione**: è un indirizzo MAC, dunque grande 6 byte, che permette di identificare il nodo destinatario. Viene inviato subito dopo il preamble in modo che i nodi non interessati possano ignorare il frame;
* **indirizzo di sorgente**: è un indirizzo MAC, dunque grande 6 byte, che permette di identificare il nodo mittente;
* **tipo**: due byte che indicano il protocollo usato per il livello superiore;
* **dati**: i dati propri del protocollo di livello superiore, campo di lunghezza variabile che può essere di 46 byte al minimo e di 1500 byte al massimo;
* **CRC**, 4 byte per l'error detection, ma non la correction.
  
Si può quindi facilmente calcolare che la dimensione minima di un frame ethernet è di 64 byte, ovvero 512 bit, mentre la dimensione massima è di 1518 byte.

### CSMA/CD in Ethernet
Si compone dei seguenti passaggi:
1. La scheda di rete riceve i dati dal layer di rete, e forma il frame;
2. Se il canale è rilevato come libero per un tempo di 96 bit, allora inizia la trasmissione del frame. Se il canale è occupato, si aspetta che sia libero per 96 bit, e poi si ripete il passaggio 2;
3. Se il frame viene inviato interamente con successo, allora passo al frame successivo;
4. Se viene rilevata una collisione, si abortisce la trasmissione e si invia un jam signal, per un tempo di 48 bit.
5. Dopo aver interrotto una trasmissione, attendo per un _exponential backoff_: all'n-esima collisione si sceglie un K appartenente all'insieme {0, 1, ..., 2^m^ - 1}, con m = min {n, 10}, e si attende K * 512 bit[ovvero la grandezza minima di un frame ethernet] prima di tornare al punto 1.

L'**exponential backoff** è un metodo per adattarsi al carico di trasmissione del mezzo, in modo da evitare collisioni. Se infatti il carico è alto, allora si attende più tempo prima di riprovare a trasmettere, in modo da non avere collisioni. Se il carico è basso, allora si attende meno tempo, in modo da non perdere tempo. Dopo 17 collisioni tuttavia il frame viene scartato.


# Internetworking
## PROTOCOLLO DHCP
Il **protocollo DHCP** è un protocollo applicativo di livello 5 (applicazione) basato su UDP, che viene realizzato attraverso il _four-way-handshake_.
Anche se distribuiamo indirizzi IP, il protocollo **NON** è di livello 3.
Vengono infatti inviati in tutto 4 messaggi che sono rispettivamente:
  1. **DHCP DISCOVER**, inviato dal client dalla porta 68, avendo quindi come IP sorgente 0.0.0.0:68, in broadcast alla porta 67 255.255.255.255:67. Il messaggio contiene inoltre due campi yiaddr, posto a 0.0.0.0, e il Transaction ID, generato casualmente
  2. **DHCP OFFER**, inviato dal server DHCP, porta 67, in broadcast, porta 68 255.255.255.255:68. In questo modo anche il client che ha fatto richiesta, che ancora non possiede un indirizzo, è in grado di ricevere il messaggio monitorando tale porta. Stavolta il campo yiaddr contiene un indirizzo, che è quello che il server DHCP sta offrendo, mentre il Transaction ID è uguale al precedente. Un ulteriore campo, detto lifetime, contiene la durata temporale dell'associazione Host-IP
   3. **DHCP REQUEST**, inviato dal client, che avrà ancora 0.0.0.0:68 come IP sorgente e 255.255.255.255:67 come IP destinatario. Il campo yiaddr conterrà l'indirizzo che ha ricevuto e che sta accettando. Riporterà inoltre il campo Lifetime e il Transaction ID, incrementato di 1
   4. **DHCP ACK**, che è sostanzialmente uguale al DHCP OFFER, ma con il Transaction ID incrementato
   
Il campo **lifetime** viene utilizzato per permettere il recupero, e dunque il riutilizzo, degli indirizzi non più utilizzati. Difatti prima della scadenza un host può 'rinnovare' la propria presenza e mantenere l'assegnazione IP-Host. In caso contrario, tale indirizzo potrà nuovamente essere riassegnato, il tutto senza bisogno che il client avvisi il server della disconnessione.
Oltre all'indirizzo IP, il protocollo si occupa di configurare tutto il necessario per la connessione, come il server DNS, il gateway e la subnet mask.

## NAT
Il **NAT**, **Network Address Translation**, è un meccanismo implementato nei router che permette l'uso di un solo IP pubblico per un'intera sottorete, fungendo da intermediario tra una rete locale e Internet.
Immaginiamo di avere appunto una rete composta da alcuni dispositivi che posseggono tutti un proprio indirizzo privato, valido solo all'interno di tale rete. La comunicazione tra tali dispositivi non rappresenta un problema, facendo parte della stessa rete, mentre la situazione cambia quando devono comunicare con dispositivi al di fuori della sottorete: il router infatti rifiuta di instradare pacchetti con al loro interno degli indirizzi IP privati.
Il NAT in sostanza modifica l'indirizzo privato sorgente del dispositivo che vuole comunicare all'esterno con quello assegnato alla rete, ed eventualmente anche la porta, creando una entry in una speciale tabella di traduzione, a cui associa la tupla **_<source IP, porta sorgente>_** alla tupla **_<public IP, porta router>_**. In questo modo quando il router riceverà un pacchetto su una porta, potrà consultare la tabella, verificare se il pacchetto è destinato ad un host sulla rete privata, e modificherà eventualmente l'IP e la porta con quelle corrispondenti nella tabella di traduzione, per poi instradarlo nella rete locale
I principali vantaggi sono:
* **Economici**, infatti consente l'utilizzo di un solo indirizzo IP pubblico per una intera sottorete, rendendo necessaria l'acquisizione di solo uno di essi
* **Sicurezza**, poichè gli indirizzi privati vengono nascosti da quello pubblico condiviso dalla rete. Questo permette sia di non instradare pacchetti direttamente verso gli Host, e rende più difficile per eventuali attaccanti individuare e attaccare i dispositivi nella sottorete
* **Scalabilità**, in quanto l'aggiunta di nuovi dispositivi è semplice, non richiede sforzi onerosi e utilizza protocolli già eventualmente implementati, come ad esempio il DHCP che non NON va in conflitto con il NAT
  
Dall'altra parte, abbiamo anche degli svantaggi:
* **Difficoltà in connessioni P2P**, infatti potrebbe non essere presenti entry nella tabella di traduzione nel caso di connessioni "in entrata". Una soluzione potrebbe essere quella di creare manualmente una entry permanente nella tabella, o sfruttare un ibrido C-S/P2P come nel caso di Skype, dove il server fornisce ai client tutte le informazioni per instauare una connessione P2P
* **Numero di porte limitato**: esse sono poco più di 60.000, quindi in ogni caso non sarà possibile avere più di quel numero di connessioni simultanee 
* **Layer di lavoro**: di fatto il NAT lavora nel router, che è un dispositivo di livello 3, e va a modificare informazioni del layer di livello 4, violando la connessione end-to-end. Questo di fatto non è uno svantaggio,difatti non presenta potenziali problemi in fase di utilizzo, ma una controversia riguardante i vari Layer e la loro 'autonomia'. La soluzione a tale controversia sarebbe l'implementazione del protocollo IPV6
    

# Transport Layer
## TCP
Il **TCP**, **Transmission Control Protocol**, è un protocollo di comunicazione di livello 4 orientato alla connessione. Per stabilire la connessione tra due host sfrutta il _3-way handshake_, che risulta comunque del tutto trasparente al core della rete, interessando dunque solo gli host alle estremità della connessione. La connessione è full-duplex, e permette di trasferire dati in entrambe le direzioni, in modo indipendente. Il protocollo è stato progettato per garantire la **corretta consegna dei dati**, il corretto ordine della consegna degli stessi. Esiste anche un controllo di flusso per evitare che il buffer di ricezione si riempia, e quindi che i dati vengano persi.

### Frame TCP
Il frame TCP è composto da:
* **Source Port**: porta sorgente, 16 bit;
* **Destination Port**: porta destinazione, 16 bit;
* **Numero di sequenza**: usato per dare un ordine ai pacchetti, il valore iniziale è scelto all'apertura della connessione, è la posizione del primo byte del segmento di dati nello stream, 32 bit;
* **Numero di acknoledgement**: usato per confermare la ricezione dei pacchetti, ha senso solo quando il flag ACK è impostato ad 1, e indica il prossimo valore che assumerà il Numero di Sequenza, 32 bit;
* **Header Length**: lunghezza dell'header, 4 bit;
* **Reserved**: riservato per usi futuri, 4 bit a 0;
* **Flag**, tra i quali:
  * **URG**: urgente, 1 bit;
  * **ACK**: acknoledgement, 1 bit;
  * **PSH**: push, 1 bit;
  * **RST**: reset, 1 bit;
  * **SYN**: synchronize, 1 bit;
  * **FIN**: finish, 1 bit;
* **Receive Window**: dimensione della finestra di ricezione, 16 bit;
* **checksum**: controllo della valifità del segmento, 16 bit;
* **URG Pointer**: puntatore urgente, 16 bit;
* **Options**: lunghezza variabile, poco usato;
* **Payload**: dati da trasferire, lunghezza variabile da 20 a 60 byte.

### Allocazione della connessine TCP e 3-way handshake
Durante la fase di allocazione vengono create ed impostate tutte le strutture dati necessarie alla connessione TCP, usando ad esempio le primitive di sistema fornite dal sistema, con le impostazioni desiderate (se TCP o UDP, etc...).
Il _3-way handshake_ si compone delle seguenti fasi:
1. Il client invia un pacchetto TCP con il flag SYN impostato ad 1, e il numero di sequenza a caso. Non vengono inviati dati
2. Il server risponde con un pacchetto TCP con il flag SYN e ACK impostati ad 1, e il numero di sequenza a caso. Il campo ACK contiene il numero di sequenza del pacchetto ricevuto dal client più 1. In questa fase il server alloca i buffer, e non vengono inviati dati.
3. Il client riceve il segmento SYN-ACK e risponde con il solo ACK attivo, e il numero di ACK pari al numero di sequenza ricevuto dal server più 1. In questa fase potrebbero già essere stati inviati dati.

I numeri di seguenza vengono generati **casualmente** per evitare che il client connettendosi, chiudendo la connessione e riaprendola immediatamente, possa ritrovarsi dati di una connessione precedente nei buffer.

### Chiusura della connessione TCP
La chiusura della connessione TCP avviene in tali fasi:
1. Il client invia un pacchetto TCP con il flag FIN impostato ad 1, e il numero di sequenza a caso. Non vengono inviati dati
2. Il server risponde con ACK attivo ed eventualmente i dati che ancora deve inviare. Successivamente chiude la connessione e invia un pacchetto TCP con il flag FIN impostato ad 1.
3. Il client, ricevuto quest'ultimo pacchetto, risponde con ACK attivo, e chiude la connessione.

Se il FIN del server non riceve risposta, lo stesso provvede a rinviarlo: siaa il client che il server rimangono dunque in attessa della conferma della chiusura della connessione.

### Affidaibilità della connessione TCP
IL TCP crea un servizio affidabile usando uno schema ARQ: Acknowledgements, Retransmission e Timeout. Quest'ultimo elemento è il più complesso da considerare, perchè ovviamente non è possibile calcolarlo a priori, specialmente se esso dipende dai router intermedi che sono fuori dal controllo degli host. Ci si basa dunque su delle stime che considerano l'RTT degli ultimi pacchetti inviati, e l'ACK relativo agli stessi. Si usa, in sostanza, una media esponenziale mobile:
$$RTT_{n+1} = \alpha \cdot RTT_{n} + (1-\alpha) \cdot E RTT_{n}$$
dove:
* $RTT_{n}$ è il Round Trip Time **misurato** del pacchetto n;
* $E RTT_{n}$ è il Round Trip Time **stimato** del pacchetto n;

Tipicamente si usa $\alpha = 0.125$.
Trovata la stima, abbiamo diversi algoritmi per il calcolo del timeout:
* secondo l'algoritmo di **Karn-Partridge**, l'intervallo è pari a $2 \cdot ERTT$. I pacchetti trasferiti ma persi vengono esclusi dal calcolo;
* secondo l'algoritmo di **Van Jacobson**, l'intervallo è pari a $ ERTT + 4 \cdot DevRTT$, dove $DevRTT$ è pari a $Dev_RTT_{n+1} = (1-\beta) \cdot DevRTT_{n} + \beta \cdot |RTT_{n} - DevRTT| $. Tipicamente $\beta = 0.25$.

### TCP semplificato
Ignoriamo per un attimo la possibilità del TCP di poter controllare il flusso e gestire gli ACK duplicati per vedere una versione semplificata del protocollo. Il trasmittente deve essere in grado di:
* ricevere i dati dall'applicazione, e dunque creare un numero di sequenza opportuno, e far partire il timer quando il dato viene inviato;
* segnalare il timeout, e dunque rinvio del pacchetto;
* ricevere l'ACK, verificare a quale pacchetto fa riferimento e gestire timer e/o ritrasmissione di conseguenza.

Gli scenari di ritrasmissione sono i seguenti:
* l'ACK relativo ad un pacchetto non viene ricevuto;
* il timer viene impostato troppo presto, dunque scade prima di aver ricevuto l'ACK;
* ACK cumulativo: viene ricevuto l'ACK relativo ad un pacchetto successivo ma non quello precedente, perdendo l'ACK ad esso relativo.

Ogni volta che si effettua si raddoppia il timeout (risulta dunque essere esponenziale), che è in realtà una tecnica di controllo della congestione, in quanto aspettiamo a reinviare un pacchetto evitando di congestionare una rete che potenzialmente potrebbe esserlo.

#### Fast Retransmit
In caso di ricezione di ACK cumulativi in cui però uno è mancante, allora possiamo implementare una politica che ci permette di reinviare il pacchetto mancante, senza attendere il timeout. Questo avviene in particolare alla ricezione di 3 ACK duplicati (cioè 4 ACK dello stesso segmento). Si noti che TCP non è ne Go-Back-N ne Selective Repeat, ma un protocollo ibrido in quanto ritrasmette dal primo segmento senza ACK, e non N segmenti indietro, pur non prevedendo l'ACK dei singoli segmenti.

### Il ricevitore
Il ricevitore 'vede' i seguenti  eventi:
* arrivo di un segmento con un numero di segmento uguale a quello atteso, con tutti i segmenti precedenti ACKati. Attende 500ms per eventuali altri pacchetti in arrivo e inviare ACK cumulativo;
* arrivo di un segmento con un numero di segmento uguale a quello atteso, ma con segmenti precedenti non ACKati. Invia ACK cumulativo senza attendere i 500ms;
* arrivo di segmento _out-of-order_. Invia ACK duplicato indicando il sequence number atteso, senza attendere i 500ms;
* arrivo di un segmento che riempie un gap formato da un segmento del tipo precedente. Invia ACK cumulativo senza attendere i 500ms;

### Flow Control 
Il TCP fa uso di **buffer** per la ricezione dei dati, quindi bisognaa fare in modo che esso non venga sovrascritto da una trasmissione successiva, causando una perdita di dati. Il trasmettitore si occupa di monitorare il buffer, mantenendo in memoria:
* la dimensione del buffer;
* l'indice dell'ultimo byte ACkato (LastByteAcked);
* l'indice dell'ultimo byte inviato (LastByteSent).

Il ricevitore, invece, mantiene in memoria:
* la dimensione del buffer;
* l'indice dell'eventuale buco mancante in caso di ricezione _out-of-order_ (NextByteExpected);
* l'indice dell'ultimo byte ricevuto (LastByteReceived).

Il protocollo **NON** considera come spazio libero eventuali buchi causati dalla ricezione _out-of-order_ perchè tale buco sarà prima o poi colmato. La dimensione totale occupata sarà quindi pari a $LastByteReceived - NextByteExpected$, mentre la dimensione libera sarà pari a $BufferSize - (LastByteReceived - NextByteExpected)$.
Il ricevitore invia, ad ogni ACK, lo spazio libero rimanente nel suo buffer nek campo _Window Size_. Se esso vale 0, il trasmettitore smette di inviare dati e invia periodicamente un segmento di dimensione 1, finchè il ricevitore non ha spazio libero, in modo che il ricevitore possa aggiornarlo della situazione corrente. Se infatti il trasmettitore non gli inviasse tale messaggio, non potrebbe conoscere la situazione corrente e continuerebbe a trasmettere dati, causando una perdita degli stessi.

### Congestion Control
Abbiamo congestione quando troppe sorgenti inviano troppi dati troppo velocemente affinchè la rete riesca a gestire tutto ciò: abbiamo perdita di pacchetti, grandi delay e lunghe code. Questo avviene nei **router intermedi** che devono smistare il traffico. Esistono due approcci risolutivi:
* **Network assisted**: i router forniscono feedback al trasmettitore, che può quindi adattare la sua trasmissione;
* **End-to-end**: il trasmettitore adatta la sua trasmissione solo quando si hanno perdite di pacchetti e rallentamenti. Questo approccio conservativo è quello implementato da TCP.


#### End-to-end congestion control in TCP
L'obiettivo della tecnica è fare in modo che tutte le sorgenti inviino dati il più velocemente possibile, senza che la rete si congestioni.
Per limitare il rate di trasmissione possiamo diminuire il numero di byte inviati nella stessa finestra temporale, abbassando il numero di segmenti non ACKati ad un valore detto _cwnd_ (congestion window), tale che
$$LastByteSent - LastByteAcked ≤ cwnd$$
Il valore è in realtà il minimo tra la dimensione della _congestion window_ e la dimensione della _receiver window_. Possiamo dunque affermare che il _cwnd_ è un valore dinamico che cambia a seconda della congestione della rete.
Il TCP, per accorgersi della presenza di una congestione, fa uso di ACK e dei segmenti perduti: se ho ottenuto ACK allora non c'è congestione, e posso continuare ad inviare ad un ritmo sostenuto, provando anche ad aumentarlo; di contro se ci sono segmenti persi, si assume che ciò sia dovuto alla congestione della reted e quindi si abbassa il ritmo di trasmissione.
L'algoritmo di _congestion control_ ha come idea di fare _probing_ della bandwith:
* quando **ricevo** ACK incremento il rateo della trasmissione;
* quando invece **perdo** segmenti, abbasso il rateo della trasmissione.

L'intero protocollo si divide in 3 fasi:
* **Slow Start**: si inzia con $cwnd = Max Segment Size$ e $rate = \frac{MSS}{RTT}$. Il rate viene raddoppiato ad ogni ACk fino a superare un _threshold_ (valore soglia) o accorgersi della perdita di un pacchetto. Quando il rate supera tale soglia, si passa alla fase successiva, detta di _congestion avoidance_;
* **Congestion Avoidance**: si incrementa linearmente il _cwnd_ ad ogni ACK. Se abbiamo a che fare con 3 ACK duplicati impostiamo $threshold = \frac{cwnd}{2}$ e $cwnd = \frac {cwnd}{2} + 3 \cdot MSS$. Passiamo dunque alla fase successiva, detta di _fast recovery_;
* **Fast Recovery**: viene a questo punto dimezzato il valore attuale di _threshold_. A seconda della causa che hadeterminato l'entrata in questa fase, e dal tipo di TCP usato, vengono scelti dei valori diversi per il _cwnd_. Se la causa è la ricezione di 3 ACK duplicati, il valore di _cwnd_ viene impostato a $threshold + 3 \cdot MSS$ o ad un segmento. Se invece la causa è la perdita dedotta dal timeout, il valore di _cwnd_ viene impostato pari ad un segmento. In questo modo è possibile distinguere quando si è in _fast recovery_ per una perdita o per un _duplicate ACK_ e agire di conseguenza, senza abbassare il rate senza che ce ne sia effettivamente bisogno.


# Security
## MAC (Message Authentication Code)
Meccanismo usato per garantire l'integrità di un messaggio. Il MAC è un valore che viene aggiunto al messaggio e che viene calcolato in base al messaggio stesso, ad una chiave segreta ed una funzione hash. Il ricevente, per verificare l'integrità del messaggio, calcola il MAC del messaggio ricevuto e lo confronta con quello ricevuto. Se i due valori coincidono, allora il messaggio è integro, altrimenti è stato alterato. In questo modo, essendo il segreto condiviso da solo due persone, viene garantita anche l'autenticità del messaggio, in quanto siamo sicuri che il destinatario sia chi affermi di essere. Il messaggio **NON** viene però criptato, quindi non viene garantita la confidenzialità dei messaggi: è tuttavia possibile abbinare a questa soluzione un algoritmo a chiave simmetrica che permette di criptare il messaggio stesso, e risultare del tutto trasparente al meccanismo del MAC. Una sua applicazione è quella detta **HMAC** (Hash-based Message Authentication Code), che è un MAC basato su SHA-1 e MD5. Il MAC viene calcolato tramite i seguenti passaggi:
* concateno il messaggio con la chiave segreta;
* faccio l'hash del risultato ottenuto;
* concateno il risultato al messaggio;
* faccio l'hash della nuova combinazione.

### Prevenzione del record&playback attack con MAC
Il record&playback attack è un attacco che consiste nel registrare un messaggio e riprodurlo in seguito, per poi inviarlo al destinatario. Il problema è che il messaggio viene inviato con la stessa data e ora di quando è stato registrato, e quindi il destinatario non può capire se il messaggio è stato registrato e riprodotto o se è stato inviato in tempo reale. Per ovviare a questo problema, si può aggiungere al messaggio una data e ora di invio, che viene calcolata dal mittente e che viene aggiunta al messaggio prima di calcolare il MAC. In questo modo il destinatario può verificare se il messaggio è stato inviato in tempo reale (decidendo anche un'eventuale tolleranza) o se è stato registrato e riprodotto. In alternativa, si può aggiungere al messaggio un nonce, ovvero un numero casuale che viene generato dal mittente, sempre diverso per ogni messaggio, e che viene aggiunto al messaggio prima di calcolare il MAC. In questo modo non si possono utilizzare messaggi registrati in precedenza, poichè il nonce è diverso per ogni messaggio.

## Firma digitale
Si tratta del corrispondente digitale della firma cartacea. Deve necessariamente rispettare queste proprietaà:
* **verificabile**: chi riceve il messaggio deve poter verificare che sia stato firmato dal mittente;
* **non ripudiabilità**: il mittente non può negare di aver firmato il messaggio;
* **non forgiaibilità**: nessuno può firmare un messaggio al posto di un altro;
* **integrità del messaggio**: il messaggio non può essere alterato senza che la firma venga invalidata.

Il MAC **NON** può essere usato come meccanismo di firma digitale poichè il segreto è conosciuto da almeno due persone, e non si potrebbe accertare con certezza la paternità di una firma, in quanto più persone hanno a disposizione la chiave. Viene quindi usato un algoritmo a chiave pubblica, per permettere ai destinatari di verificare l'autore della firma, che ha ovviamente firmato con la sua chiave segreta che, essendo privata per definizione, appartiene a lui e a nessun altro ed è quindi **verificabile**. 
### Implementazione di un protocollo di firma digitale
Il protocollo di firma digitale è composto dalla parte di firma e dalla parte di verifica. La parte di firma è composta da:
* **generazione della chiave pubblica e privata**: la chiave pubblica viene inviata al mittente, mentre la chiave privata viene tenuta segreta;
* **generazione del messaggio**: il mittente genera il messaggio che vuole firmare;
* **generazione hash del messaggio**: il mittente calcola l'hash del messaggio;
* **firma dell'hash**: il mittente firma l'hash del messaggio con la sua chiave privata. Questo perchè sarebbe troppo dispendioso calcolare l'hash ddell'intero messaggio;
* **concatenazione**: il mittente concatena il messaggio con la firma.
  
La parte di verifica è composta da:
* **ricezione del messaggio**: il destinatario riceve il messaggio;
* **estrazione della firma**: il destinatario estrae la firma dal messaggio;
* **decrittazione della firma**: il destinatario decrittografa la firma con la chiave pubblica del mittente;
* **confronto**: il destinatario confronta l'hash del messaggio con quello ottenuto decrittografando la firma. Se i due valori coincidono, allora il messaggio è integro e il mittente è autentico.

Il protocollo è comunque sensibile agli attacchi _man-in-the-middle_, difatti un attaccante potrebbe sostituire la chiave pubblica del mittente con la sua, e quindi potrebbe firmare i messaggi con la sua chiave privata. Per ovviare a questo problema, si può usare un protocollo di firma digitale a chiave pubblica **con certificato**, che prevede che il mittente invii al destinatario il suo certificato, che contiene la sua chiave pubblica e la firma digitale del certificatore. Il certificatore è una **terza parte** che ha la responsabilità di certificare la validità di una chiave pubblica. Il certificato viene quindi inviato al destinatario, che può verificare la firma digitale del certificatore, e quindi accertare che la chiave pubblica sia autentica.

## Pretty Good Privacy (PGP)
Pretty Good Privacy (PGP) è un sistema di crittografia di dati utilizzato per garantire la sicurezza della comunicazione e dell'informazione. È stato sviluppato nel 1991 da Philip Zimmermann ed è diventato uno standard per la crittografia della posta elettronica e dei file.

PGP utilizza la crittografia a chiave pubblica, che si basa sulla creazione di una coppia di chiavi: una chiave pubblica e una chiave privata. La chiave pubblica viene utilizzata per crittografare i dati e la chiave privata viene utilizzata per decrittografare i dati. PGP genera una coppia di chiavi unica per ogni utente e la chiave pubblica può essere condivisa con altre persone mentre la chiave privata deve rimanere segreta.

Quando un utente vuole inviare un messaggio crittografato a qualcun altro, utilizza la chiave pubblica del destinatario per crittografare il messaggio. Solo il destinatario, che ha la corrispondente chiave privata, può decrittografare il messaggio e leggerne il contenuto. PGP è anche in grado di creare una firma digitale per verificare l'autenticità del mittente del messaggio e garantire che il messaggio non sia stato modificato durante la trasmissione.

Inoltre, PGP può essere utilizzato per crittografare interi dischi o partizioni, rendendo i dati inaccessibili senza la chiave privata corrispondente.

## Secure Socket Layer (SSL)
Secure Socket Layer (SSL) è un protocollo di sicurezza posto tra il livello di trasporto e il livello applicazione. Mette a disposizione delle API per fornire crittografia a livello applicazione, permettendo di concentrarsi sulla logica dell'applicazione. Viene garantita la confidenzialità, l'integrità dei dati e l'autenticazione degli endpoint.
Una sua versione semplificata è formata da:
1. **Handshake**: il client e il server usano i propri certificati per autenticarsi e scambiare una chiave condivisa;
2. **Key Derivation**: il client e il server usano la chiave condivisa per generare una chiave di sessione. In particolare vengono generate:
   * $K_{client}$: chiave per cifrare i messaggi dal client al server;
   * $M_{client}$: chiave per generare il MAC dal client al server;
   * $K_{server}$: chiave per cifrare i messaggi dal server al client;
   * $M_{server}$: chiave per generare il MAC dal server al client;
  3. **Data Transfer**: i messaggi vengono cdivisi in blocchi, detti _record_, alla quale viene concatenato un MAC e un campo _lenght_ per poter discernere tra MAC e record, e permettere record di dimensione diversa. In questa fase si inserisce inoltre un numero di sequenza usato per calcolare il MAC, in modo da proteggersi dagli attacchi _record&playback_. Per evitare inoltre _truncation attacks_, si usa un campo _type_ usato anch'esso per il calcolo del MAC. In sostanza il record sarà composto da:
     * $version$: versione del protocollo;
     * $type$: tipo di record;
     * $length$: lunghezza del record;
     * $data$: dati;
     * $MAC$: MAC($M_{client}$, $sequence$, $type$, $data$);

### SSL completo
Al protocollo semplificato mancano tuttavia delle funzionalità, come la negoziazione della **cypher suite**. Essa deve necessariamente avere:
* un algoritmo a chiave pubblica;
* un algoritmo a cifratura simmetrica;
* un algoritmo per il calcolo del MAC.

Da ciò ne consegue che nella fase di handshake dobbiamo prevedere:
* **l'autenticazione** del server;
* la **negoziazione** della cypher suite;
* lo stabilire le chiavi;
* autenticazione del client.

#### Negoziazione della cypher suite
Le suite più diffuse comprendono il DES, 3DES, AES, RC2, RC4, ed  RSA come algoritmo di cifratura a chiave pubblica.
La negoziazione si compone dei seguenti passi:
1. il client invia al server la lista di algoritmi da lui supportati, assieme ad un nonce;
2. il server sceglie alcuni algoritmi e li invia al client, assieme ad un nonce ed al proprio certificato;
3. Il client verifica il certificato del server, estrae la chiave pubblica, genera il _pre-master-secret_ (una sequenza di byte casuali), lo cifra con la chiave pubblica (ad esempio RSA) del server e glielo invia;
4. Client e server generano la chiave di sessione a partire dal _pre-maste-secret_ e la usano per cifrare i messaggi;
5. Il client invia al server MAC di tutto l'hanshake;
6. Il server invia al client MAC di tutto l'hanshake.

I passaggi 5 e 6 servono a **prevenire gli attacchi** _man-in-the-middle_, in quanto un attaccante potrebbe modificare la chyper suite eliminando gli algoritmi più forti e sostituirli con quelli più deboli. Inviando MAC di tutto l'handshake ciò ovviamente non è possibile.
I **nonce** sono utilizzati per evitare attacchi di tipo _reply_: cambiando il nonce cambieranno le chiavi crittografiche, ed essendo i nonce casuali e diversi per ogni sessione, non è possibile usare vecchi messaggi per instaurare una nuova sessione.

## IPSEC
IPSEC è un servizio di sicurezza che opera a livello di rete. Si basa su un insieme di protocolli che permettono di garantire la sicurezza dei pacchetti IP. Questi offrono autenticazione e integrità, mentre la confidenzialità dipende dallo specifico protocollo.
Prendiamo in analisi l'**ESP**(Encapsulating Security Protocol), che è un protocollo di sicurezza che si basa su un protocollo di autenticazione e cifratura, in un caso reale di utilizzo in una VPN.
Una VPN sfrutta l'internet pubblica per creare una rete privata tra alcuni nodi: la connessione tra due entità di questa rete è detta _Secure Association_. Se ci sono N nodi nella rete, ci saranno 2 + 2N _Secure Associations_. Ogni nodo, per far funzionare il meccanismo, mantiene in memoria, in particolare dentro il **SAD** [Security Association Database], queste informazioni:
*  **Security Parameter Index**, che individua la SA che l'host sta gestendo, 32 bit;
*  **IP dell'interfaccia di origine**
*  tipo di **cifratura utilizzata**;
*  **chiave di cifratura**;
*  tipo del **controllo di integrtà**, ad esempio HMAC-SHA1;
*  chiave di **autenticazione per il controllo di integrità**.

La VPN in sostanza implementa IPsec sui router e/o sui singoli host, rimpiazzando il payload del pacchetto IP con un pacchetto IPsec ed un nuovo header.
Il datagramma IPsec che utilizza il protocollo ESP sarà formato da:
* **new IP header**: di competenza del servizio di VPN; [NB: gli elementi in questo sotto-elenco sono **AUTENTICATI**]
  * **ESP header**: contiene il **SPI** e il **sequence number** [NB: gli elementi in questo sotto-elenco sono **ANCHE CRITTOGRAFATI**]; 
    * **original IP header**, l'header originale del pacchetto IP; 
    * **original IP payload**, il payload originale del pacchetto IP;
    * **ESP trailer**, contiene il padding, lunghezza del padding e il next header;
* **ESP authentication data**, contiene il MAC.

Così facendo abbiamo eseguito una encapsulazione del pacchetto IP originale, che è stato quindi crittografato e autenticato. Il nuovo pacchetto IP è quindi pronto per essere inviato sulla rete pubblica. Esso viene instradato tramitet un Security Police Database (SPD) che contiene le regole di routing per la VPN. Il pacchetto IPsec viene quindi decapsulato dal router di destinazione, e il pacchetto originale viene rilasciato verso il destinatario.

Il padding è aggiunto, se necessario, per permettere l'uso di algoritmi di cifratura che operano su blocchi di dati di dimensione fissa. Il padding è composto da byte casuali, e la lunghezza del padding è indicata nel trailer.


# Wireless and Mobile Networks

## Problema del nodo nascosto
Il nome deriva dal fatto di avere tre ricestrasmettitori (A, B, C), e che due di essi vogliano entrambi comunicare con il terzo. Supponiamo che A e C vogliamo dunque comunicare con B: quest'ultimo riceverà i segnali di A e C, che non vedranno la collisione. Solo B vedrà la collisione, e rende inutile anche l'operazione di _carrier sensing_ di coloro che trasmettono, e dunque non sarà possibile effettuare una sua mitigazione. Questo problema si presenta anche quando si ha un ostacolo che rende impossibile la comunicazione. La tecnica usata per risolvere questo problemaa è il **Virtual Carrier Sense** (VCS), contrapposto al _sensing fisico_.

## Virtual Carrier Sense
Viene eseguita una sorta di prenotazione del mezzo di comunicazione. Supponiamo che un nodo voglia trasmettere: andrà ad ascoltare il canale; nel caso in cui sia libero per un tempo _DIFS_, allora invierà un pacchetto _RTS_ (Request To Send)_, che viene ricevuto sia dalla stazione base che da quelle vicine. Tutti coloro che vedono tale pacchetto imposterà un timer, detto _NAV RTS_ (Network Allocation Vector RTS), per un tempo pari a quello contenuto nel campo _duration_ del pacchetto RTS. Dopo un tempo _SIFS_ la stazione base procederà a rispondere con un pacchetto _CTS_ (Clear To Send): anche questo pacchetto contiene un campo _duration_, minore del valore contenuto in _RTS_. Esso farà partire il timer _NAV CTS_, anche a coloro che non avevano sentito in precedenza il _NAV RTS_. Quando la sorgente recepisce il CTS, fa ACK della trasmissione, attende un tempo _SIFS_ e successivamente inizia a trasmettere il frame. Una volta terminata la trasmissione, attende un tempo _SIFS_ e fa ACK della ricezione. ITutti i nodi vedranno quindi il termine della trasmissione, attenderanno  un tempo _DIFS_ e successivamente un altro timer di backoff scelto randomicamente. 
E' importante notare come la collisione è ancora presente, nel caso specifico in cui due nodi inviano RTS nello stesso momento. Esso tuttavia è pensato per essere abbastanza piccolo da rendere minore possibile la probabilità di collisione e soprattutto, anche se dovesse accadere, verrebbe perso solo il tempo relativo a RTS, che è appunto abbastanza piccolo.
Tra i contro di questo protocollo c'è indubbiamente l'aumento di overhead in preparazione alla trasmissione vera e propria: per tale motivo questo non viene usato nel caso in cui la dimensione del frame sia paragonabile a quella del pacchetto RTS; verrà infatti inviato direttamente il frame.

## Protocollo CSMA/CA
Si parla in questo caso di _Collision Avoidance_, perchè il _Collision Detection_ non può essere usato in questo contesto. Infatti:
* il dispositivo WiFi che sta trasmettendo non può ascoltare il canale, perchè sta trasmettendo. E' infatti dotato di una sola antenna, una soluzione potrebbe essere quella di usare due antenne;
* il problema del nodo nascosto non viene risolto perchè non è possibile individuare collisioni quando accadono sul nodo intermedio, e non su quello che sta trasmettendo.
  
Il punto del protocllo _CSMA/CA_ è quello di **prevenire** le collissioni (che possono comunque avvenire), utilizzando uno schema **ARQ** (**A**utomatic **R**epeat re**Q**uest) con una divisione in piccoli slot, usati comunque solo per dare l'inizio alle operazioni. Queste, in ordine, sono:
1. la sorgente che vuole trasmettere ascolta il mezzo e verifica che esso sia libero per un tempo _DIFS_;
2. se ciò accade, allora inizia a trasmettere il frame;
3. subito dopo la ricezione del frame, il destinatario mute da ricezione a trasmissione, entro un tempo _SIFS_ (Switching time) tale che _SIFS_ < _DIFS_;
4. invia un ack al mittente.
  
_SIFS_ deve **necessariamente** essere minore di _DIFS_ altrimenti un nodo potrebbe rilevare il mezzo come libero, e potrebbe trasmettere un frame, mentre il mittente originale sta ancora aspettando l'ACK.
Inoltre il protocollo permette di evitare la collisione tra due frame che vengono inviati dopo aver osservato il mezzo libero per un tempo _DIFS_ grazie ad un backoff time scelto casualmente, da aggiungere al _DIFS_ di attesa del punto 1. Se infatti viene rilevato l'uso del mezzo durante il tempo di backoff, il timer viene congelato, e verrà risvegliato dopo la fine della trasmissione e l’ attesa del nuovo periodo DIFS. Come tempo di backoff si sceglie un numero random di slot da aspettare in [0, CW-1]. Inizialmente CW vale cwim (standard del protocollo), quando si ha un ACK mancante si raddoppia CW fino ad arrivare a CWmax. Questo protocollo tuttavia non ci risolve il problema del nodo nascosto: se i due nodi che vogliono comunicare non si vedono tra di loro ognuno vedrà il canale libero ed andrà a trasmettere causando una collisione in ricezione sull’access point.

## Mobile IP
Introduciamo il concetto di mobilità: un host è in grado di spostarsi nel mentre che esso è connesso ad una rete, ha le sue connessioni TCP con un server, etc...
Abbiamo, nello specifico, tre tipi di mobilità:
* nessuna: l'host cambia punto di accesso, ma rimane sempre all'interno della stessa sottorete. In questo caso non è necessario cambiare l'indirizzo IP;
* media: l'host cambia rete, e con essa anche l'indirizzo IP tramite DHCP. Si parla di mobilità senza continuità, ma non rappresenta un problema;
* alta: l'host cambia diverse reti in poco tempo tempo. La gestione di tale situazione diventa necessaria per un corretto funzionamento dell'host che vuole comunicare con altri host.
  
Nell'ultimo caso non possiamo pensare di gestire il tutto tramite una continua connessione/riconnessione, altrimenti avrei un servizio intermittente; pealtro questa possibilità non è nemmeno prevista dal protocollo IP. Esistono due soluzioni: _indirect routing_ e _direct routing_.

### Indirect routing
Definiamo alcuni elementi: 
* **home agent**: è il router che si occupa di gestire la mobilità dell'host mobile, e si trova nella home network;
* **home network**: è la rete in cui si trova inizialmente l'host mobile; **permanent address**: è l'indirizzo IP che l'home agent ha nella home network;
* **foreing agent**: è il router in cui si trova attualemnte l'host mobile, diversa dalla home network;

Partiamo dalle cose che **NON** possiamo fare: non possiamo annunciare attraverso i protocolli di routing lo spostamento dell'host, perchè il routing funziona sulla base della rete e non del singolo host. La situazione deve inevitabilmente essere gestita dall'home agent e dall'host. Quando l'host mobile si sposta nella _foreing network_, contatta il _foreing agent_ e gli dice di regitrarlo presso l'_home agent_. Il _foreing agent_ contatta quindi l'home agent, avvisandolo che se dovessero arrivare pacchetti diretti verso l'host mobile, essi dovranno essere reindirizzati verso la nuova rete. Tutti coloro che inviano all'host pacchetti non sono a conoscenza dello spostamento, e continuerà ad inviare i pacchetti allo stesso indirizzo; questa tecnica è quindi trasparente rispetto ai mittenti dei pacchetti verso l'host mobile. In caso di nuovo spostamento, c'è ovviamente bisogno di una nuova registrazione: il rischio è che se gli spostamenti sono molto frequenti, sarebbe più il tempo utilizzato per notificare lo spostamento rispetto a quello di permanenza nella rete stessa. Il lato negativo di questa strategia è che esiste la possibilità che il traffico venga triangolato anche quando ciò è inutile ed evitabile. Questo fenomeno è detto _triangolo di routing_. In conclusione, possiamo affermare che questa strategia è quella utilizzata di default da Mobile IP.

### Direct routing
Gli elementi in gioco sono gli stessi dell'_indirect routing_ ma, al contrario di quest'ultimo, riusciamo ad evitare la triangolazione dei dati, perchè il mittente invierà direttamente al dispositivo mobile i pacchetti. Vediamo come:
quando il dispositivo arriva in una nuova rete, farà in modo di notificare all'home agent del suo spostamento. Questo, quando vedrà arrivare un pacchetto destinato all'host mobile, avviserà il mittente che il destinatario non si trova più nella _home network_, e sarà lui stesso ad occuparsi di reinviare il pacchetto al nuovo indirizzo del dispositivo mobile. In caso di ulteriore spostamento, ci saarà una notifica. I principali problemi di questa strategia sono due, uno tecnico ed uno 'etico':
* tecnico: abbiamo un aumento di overhead per la notifica del nuovo indirizzo, per la notifica del nuovo spostamento, e il tempoo di reinvio del pacchetto;
* etico: possono sorgere problemi di privacy in quanto il mittente sarà a conoscenza di tutti i nostri spostamenti di rete in rete.

### Formato del pacchetto Mobile IP
Oltre ai classici campi del protocollo ICMP, abbiamo delle aggiunte specifiche per il protocollo Mobile IP. Il pacchetto completo sarà formato da questi campi:
* **Type**: 8 bit, indica il tipo di pacchetto. Per il mobile Ip il valore standard è 9;
* **Code**: 8 bit, indica il codice del pacchetto. Per il mobile IP il valore standard è 0;
* **Checksum**: 16 bit, è il checksum del pacchetto;
* **router address**: 32 bit, è l'indirizzo del router che ha ricevuto il pacchetto;
I nuovi campi sono:
* **type**: 8 bit, indica il tipo di pacchetto Mobile IP. Valore di default 16;
* **length**: 8 bit, indica la lunghezza del pacchetto;
* **sequence number**: 16 bit, è il numero di sequenza del pacchetto;
* **registration lifetime**: 16 bit, indica la durata della registrazione;
* **RBHFMGV bit**: 8 bit di informazioni aggiuntive. I bit sono:
  * **H/F**: indica se si tratta di foreing o home agent;
  * **R**: indica se è necessaria la registrazione;
* **care-of address**: 32 bit, è l'indirizzo del dispositivo mobile;

### Registrazione
Si tratta di una procedura in questi passi:
1. l'host mobile aspetta di ricevere un ICMP dall'agent discovery;
2. invia poi un pacchetto ICMP al router che si trova nella _foreing network_. Il pacchetto contiene questi campi:
    * **COA**: care-of address, ovvero l'indirizzo del dispositivo mobile scelto;
     * **HA**: home agent, ovvero l'indirizzo del router che si trova nella _home network_;
     * **MA**: mobile agent, ovvero l'indirizzo del router che si trova nella _foreing network_;
     * **lifetime**: durata della registrazione;
     * **sequence number**: numero di sequenza del pacchetto, in modo analogo al DHCP;
3. il _foreing agent_ riceve il pacchetto e lo inoltra all'home agent, aggiungendo una nota sul tipo di encapsulation da usare;
4. l'_home agent_ riceve il pacchetto, abbassa il lifetime richiesto, e risponde con un pacchetto identico, togliendo però il campo **COA**, come una sorta di 'acknowledgement';
5. il foreing agent riceve il pacchetto e lo inoltra al dispositivo mobile. Da questo momento in poi il mittente può inviare traffico, e questo verrà reindirizzato al dispositivo mobile.



RIGUARDA LEZIONI DAL 07/12/22 IN POI PER QUESTA PARTE