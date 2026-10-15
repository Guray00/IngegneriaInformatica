# Domande orali Sistemi Operativi

Le seguenti domande sono riprese da quanto é stato chiesto durante l'orale di Sistemi Operativi nel corso degli anni. L'elenco non è completo ed è da considerarsi solo una linea guida per l'impostazione dell'esame.

## Domande Avvenuti

- Com'è fatto lo schema di un device driver dal punto di vista del programma? Che azioni deve fare il device driver? Descrivere con precisione cosa succede dentro al device driver
- Descrivere un generico semaforo. Come si implementa un semaforo? Far vedere il codice
- Come viene gestito un page fault in un sistema operativo? Dire precisamente l'ordine delle operazioni che vengono effettuati, gli eventi fondamentali del page fault (Avvenuti lo vuole passo per passo e nel dettaglio, come se stessimo descrivendo un algoritmo)
- Come funziona la segmentazione nella memoria virtuale.
- Bell-Lapadula. Come risolve il cavallo di Troia, se può coesistere con la matrice degli accessi. Come si vede un file protetto nella matrice di accessi? Cioè cosa viene mostrato
- Algoritmo del banchiere, stato sicuro. A cosa serve, descrizione, quando viene chiamato, come funziona, cosa fa.
- Algoritmo dell'orologio/second-chance.
- Simulazione di scheduling per far vedere che differenza c'è tra un algoritmo di scheduling a priorità statica e uno a priorità dinamica.
- Apertura del file in Unix, che strutture dati sono coinvolte dalla open.
- Tecniche di allocazione del file su disco. Realizzazione dell'accesso diretto e costo.
- Trasferimento nello spazio di I/O: interazione tra processo interno e processo esterno. Cos'è il processo esterno.
- Schedulabilità dei sistemi hard real time. Fattore di utilizzazione, definizione e cosa comporta. Minimo comune multiplo dei periodi, come si ottiene e cosa significa nel sistema. Rate monotonic: condizione sufficiente per la schedulabilità, definizione e quanto vale. Condizione necessarie per EDF, è migliore EDF o RM? Può succedere che un algoritmo sia schedulabile con EDF e non RM? Cosa vuol dire che un algoritmo è ottimo? 
- Produttore/consumatore con l'utilizzo dei semafori.
- Soluzione non corretta al problema dei 5 filosofi. Soluzione corretta col monitor.  
- Quali sono le tecniche per allocare un file in un disco virtuale, visto come un array di blocchi. Vediamo nel dettaglio le tecniche, partendo dalla prima
- Illustrare il funzionamento dell’algoritmo di second-chance. Spiegare qual è il senso del bit di uso
- Definire il problema produttore-consumatore e spiegare come si risolve
- Illustrare le 4 condizioni per lo stallo
- Come si fa l’allocazione di memoria, quali sono le tecniche? Paginazione su domanda, spiegare come si gestisce il page-fault
- Spiegare quali sono i due algoritmi per schedulare processi real-time

## Domande di laboratorio

### Appelli a distanza - Minici

- System call per la gestione del ciclo di vita dei processi. (fork exit wait exec).
- Spiegare la terminazione di un processo
- System call alarm e sleep
- Sincronizzazione basata sui segnali. Come possiamo usare un handler definito dall'utente? 
- Thread in Linux, cosa condividono. Perché si chiamano processi leggeri, cosa condividono e come si creano. Perché pthread_t è un tipo opaco.
  Funzioni join ed exit, cosa comporta l'utilizzo o meno della exit.
- Produttore/Consumatore usando la libreria pthread.h
- Bit di protezione in Unix, rappresentazione ottale e simbolica. Bit SUID e SGID.
- Priorità dei processi in Linux. Job Control.
- Comunicazione mediante scambio di messaggi (pipe), sintassi della open. Previsto un naming nello scambio del messaggio? Con che ordine vengono letti i messaggi?  Quali sono i processi che possono comunicare tramite una pipe? 
Come fanno per permettere la comunicazione tramite pipe? Necessario preoccuparsi di fare sincronizzazione sulla pipe? Bisogna scrivere il codice pensando alla sincronizzazione? 
Come si scrive all'interno della pipe? Cosa ritornano le funzioni per usare le pipe?
- Permessi in Unix. chmod in base ottale (ricordarsi che il bit di SUID e SGID è in prima posizione nella rappresentazione in base ottale). Differenza dei permessi tra file e cartelle. Come vengono definiti i permessi speciali? Comandi per cambiare i permessi .
- Thread, cos'è un thread in Unix/Linux. Funzioni sui thread. Necessario includere una libreria per usare i thread? Esiste il concetto nativo di thread in linux? Oppure è il programmatore a doverlo fare? Perché usiamo la libreria pthread invece del concetto nativo di thread di linux? Come vengono identificati i thread usando la libreria?
Come si crea un thread usando pthread? Come si termina il thread? 

### Domande Esame scritto

#### Sessione estiva 21/22

- System call per la gestione dei segnali: signal e kill.
- Primitiva Fork() : descrizione ed esempio di utilizzo
- Descrizione di Find e Locate e breve illustrazione delle loro differenze
- Significato dei bit rwx per file e cartelle. Comando per modificare i permessi ed esempio esaustivo sia in rappresentazione simbolica che ottale
- Es1.c del laboratorio 9 [A.A. 21/22], fare funzioni prelievo e deposito.
- Spiegare la Pipe
- Bit SUID e SGID, fare un esempio di utilizzo
- Funzioni per il Job Control
- Es2.c del laboratorio 9 [A.A. 21/22]
  
#### Sessione invernale 22/23

- primitiva fork, cosa fa e un esempio di utilizzo
- variabili condizione, cosa sono, a cosa servono e quali operazioni si possono fare su di esse
- quali classi di utenti sono definite sui file e a quali classi di utenti vengono applicati i permessi relativi ai file 
- Es3.c del laboratorio 9 [A.A. ]

#### Sessione estiva 22/23

- Cos'è un segnale, quale effetto ha la ricezione di un segnale da parte di un processo
- Utilizzare i comandi del `job control`, come far ripartire da terminale un job interrotto da terminale
- A cosa serve la primitiva `fork`, fare un esempio di utilizzo
- Esercizio del laboratorio 9 [A.A. 21/22], es3.c

### Domande orali sistemi operativi 18/07/2022

#### Studente 1

- Schema di traduzione degli indirizzi per la memoria segmentata
- Perché si controlla che il numero di segmento generato dalla CPU sia minore del numero di segmenti presenti nella tabella dei segmenti?
- Cosa cambia se si fa segmentazione a domanda?
- Cosa c'è nella tabella dei segmenti nel caso in cui il bit di presenza sia zero?
- Quali sono i campi all'interno di una riga della tabella dei segmenti? (Vuole sapere esattamente cosa si intende per "indice", non si capisce dove vuole andare a parare, spiega poi che voleva sapere la differenza tra indice e indirizzo, dicendo che l'indice è "l'indirizzo" di un blocco)

#### Studente 2

- Come si scrive il device driver di un timer?
- Lo studente parla di alarm e sleep e il prof chiede di implementare il driver nell'ottica di dover realizzare la sleep
- Dove stanno scritti gli indirizzi dei registri della periferica? (Descrittore della periferica)
- Dove sono implementati fisicamente i registri di controllo di stato ecc? (Il prof vuole risposte secche a queste domande senza girarci intorno)
- Quali sono gli altri campi necessari da mettere nel descrittore? (Lo studente fa riferimento alla soluzione di calcolatori ma al prof non va bene)
- Come vanno inizializzati i semafori del descrittore del timer?

#### Studente 3

- Come funziona la gestione di un page fault?
- Lo studente lo dice a parole ma il prof vuole anche il disegno
- A cosa serve la tabella delle pagine? (Chi diceva che è pignolo ha ragione)
- Cosa c'è scritto nel descrittore del frame?

#### Studente 4

- Come si rileva una situazione di stallo (deadlock detection)?
- Lo studente disegna un grafo con risorse e processi (resource allocation graph) con un ciclo e il prof vuole sapere che codice può aver portato a questo grafo
- In quale caso ci si pone il problema di usare signal-and-wait o signal-and-continue? (nei monitor)
- Cos'è un monitor e com'è fatto(senza far riferimento ai 5 filosofi)? (Sta saltando di palo in frasca per qualche motivo)
- Cos'è una variabile condition?

#### Studente 5

- Quali sono le strutture date UNIX per gestire i file?
- Perché abbiamo la tabella dei file attivi? (Fa da cache degli i-node)
- Perché se due processi aprono lo stesso file abbiamo due diverse entrate nella TFAS?
- Come si arriva da un i-node al blocco giusto in memoria secondaria?

#### Studente 6

- Come si schedula un sistema hard-real-time?
- Il prof si impunta sul perché sull'asse orizzontale del grafico della temporizzazione c'è una freccia che punta verso destra. Continua con domande filosofiche sul perché su un'asse temporale una cosa a sinistra è precedente a una più a destra

#### Studente 7

- Come si può prevenire il deadlock in un sistema in cui devo garantire la mutua esclusione?
- Cosa si intende per stato sicuro?
- Condizioni necessarie per il deadlock e quando diventano anche sufficienti
- Riferito alla condizione che dice che non ci deve essere preemption: di che tipo di preemption si tratta? (Sulle risorse, non sulla schedulazione)
- Cosa si deve essere verificato (a livello di semafori) perché nel grafo si abbia una freccia da una risorsa a un processo? (Vuole vedere il codice)
- Fare un esempio di un algoritmo del banchiere con risorse a singola istanza (gli va bene anche un algoritmo un po' abbozzato fatto sul grafo)
- Cosa si intende per stato sicuro? (Prima non aveva risposto)

#### Studente 8

- Gestione della memoria virtuale in UNIX (in sostanza vuole sapere la paginazione su domanda nello specifico di UNIX ovvero page deamon, swapper ecc)
- Perché si hanno 3 variabili (des_free, lots_free e min_free), non si poteva fare con due sole?
- Cosa fa pagedeamon nel caso in cui non ci sono abbastanza frame liberi? (Algoritmo dell'orologio)
- Perché si chiama second chance
- Che algoritmo si approssima con l'orologio (LRU)
- Perché si usa questo algoritmo invece di LRU vero e proprio? (LRU ha grandi costi sia di memoria che di tempo)
