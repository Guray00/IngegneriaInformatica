# Raccolta di domande per scritto e orale dell'esame di Sistemi Operativi

> Questa è una raccolta di domande riunite da me (Giuseppe Vaglica) e riprese dal gruppo Whatsapp di Sistemi Operativi. Non avendo mai seguito il corso (attualmente) non mi faccio carico di errori dovuti a una scorretta organizzazione logica delle domande o di altro tipo. La raccolta pertanto potrebbe risultare confusionaria e ridondante e perciò invito, qualora qualche studente avesse voglia, a riorganizzarla e ricondividermi il file per aggiornarlo.

- [Raccolta di domande per scritto e orale dell'esame di Sistemi Operativi](#raccolta-di-domande-per-scritto-e-orale-dellesame-di-sistemi-operativi)
  - [Domande orali](#domande-orali)
    - [07/01/2026](#07012026)
    - [26/01/2026](#26012026)
    - [27/01/2026](#27012026)
    - [28/01/2026](#28012026)
    - [16/02/2026](#16022026)
    - [17/02/2026](#17022026)
  - [Domande scritto](#domande-scritto)
    - [26/01/2026](#26012026-1)


## Domande orali

### 07/01/2026

---

* Traduzione indirizzi memoria a segmentazione
* Segmentazione paginata: traduzione
* Scheduling preemptive senza priorità
* Comunicazione / sincronizzazione: modelli architetturali (e come avviene con thread e processi)
* Problema sincronizzazione: come risolverlo generalmente
* Sincronizzazione interna/esterna
* Sistema sicurezza multilivello
* Page fault
* Produttore-consumatore
* Problema 5 filosofi
* Cosa succede quando si apre un file
* Gestione caricamento pagina: rimpiazzamento (+ cosa succede in Unix)
* Deadlock detection
* Deadlock avoidance
* Schedulazione real time (nello specifico hard)
* Implementazione monitor

---

* Problema dei 5 filosofi
* Cosa succede quando si apre un file in unix? 
* Strutture dati dei file descriptor
* Rimpiazzamento pagine
* Deadlock detection
* Sistemi in tempo reale
* Cosa fare se il sistema non è schedulabile con EDF
* Implementazione monitor con semafori

---

### 26/01/2026

---

* A me ha chiesto l'algoritmo EDF, la condizione di schedulabilità, il fattore di utilizzazione della cpu e di simulare EDF su un insieme di processi che mi sono scelto

---

* A me problema dei Reader e dei writer

---

* ha chiesto la primitiva open e poi l architettura con i-node etc

---

### 27/01/2026

---

* A me ha chiesto la segmentazione paginata. Mi ha chiesto anche i vantaggi di utilizzare una segmentazione basata su soli 3 segmenti (codice, stack e dati) e il TLB

---

* A me ha chiesto la deadlock detection

---

* A me ha chiesto la Tassonomia di Flynn poi in generale spazio globale e locale di memoria

    * In che senso spazio globale/locale di memoria? Cosa voleva sentirsi dire?
      - Che in uno spazio globale   tutti i processi hanno accesso a tutta la memoria mentre in uno spazio locale il processo è l'unico ad avere accesso allo spazio di memoria in cui si trova

---

* A me ha chiesto il problema dei 5 filosofi e di implementarlo direttamente con la soluzione con monitor

---

### 28/01/2026

---

* stati di un processo, e discutine, poi chiede degli stati swapped.
* round robin, simulazione e tempo di attesa
* com’è fatto un device driver generico a livello di pseudo codice.poi chiede del buffering
* problema produttore consumatore
* algoritmo edf.
* i-node e open 
* metodi di allocazione file
* semafori
* algoritmo del banchiere.
* gestione page falut
* confronto di due algoritmi di scheduling su base prioritaria
* bell lapadula
* esempio in cui in una sezione critica si creano delle situazioni in incongruenza.
* tassonomia di flynn
* filosofi
* segmentazione paginata
* deadlock detection

---

* device driver del timer
* modalità di accesso ad un file
* modalità allocazione file su disco
* paginazione 
* coda multi-level feedback

---

* A me ha chiesto la soluzione della mutua esclusione con  primitive  lock ed unlock

---

### 16/02/2026

---

* segmentazione
* problema del produttore-consumatore (con singolo buffer produttore e consumatore, con singolo produttore e consumatore e buffer circolare, con n produttori, k consumatori e buffer circolare)
* page-fault 
* in particolare poi a me del Page fault (ovviamente oltre al disegno e la spiegazione dei passaggi) ha chiesto di disegnare un ipotetico schema di esecuzione dei processi durante il pg_fault e come diminuire al minimo il numero di cambi contesto

---

* EDF e sistemi real time
* Descrizione e implementazione semafori
* Rimpiazzamento e algoritmi
* Deadlock Avoidance
* Apertura di un file

---

* Come funziona la traduzione degli indirizzi con segmentazione?
    * Disegno della traduzione con n_segmenti > 3.
* Quante tabelle dei segmenti ci sono? Dove stanno? Come viene stabilito il contenuto di STLR e STBR?
	* Una tabella dei segmenti per ogni processo.
	* Le tabelle stanno in memoria Centrale.
	* La tabella è nel descrittore di processo.
* Il meccanismo di traduzione dove avviene?
	* Nella MMU. (Avvenuti è rimasto su questa question per 20 minuti minimo)

---

* come viene gestito un page fault?

---

* Descriva il problema dei produttori e consumatori.
	* Lo studente prova a spiegare il comportamento degli agenti, il professore vuole che esponga fino in fondo il problema di sincronizzazione.
* Questo problema fa riferimento a quale modello di ambiente, locale o globale?
	* Modello ad ambiente globale.
* Estendendo la capacità del buffer, cosa ottengo?
	* Parallelismo. Produzione e consumo (potenzialmente) non bloccante. DISACCOPPIAMENTO TEMPORALE.
* Come cambiano le regole di sincronizzazione?
	* Il produttore non può inserire se il buffer è pieno, il consumatore non può prelevare se il buffer è vuoto.
* Ora elenchiamo le regole di sincronizzazione se abbiamo più produttori e più consumatori.
	* Solo uno scrittore alla volta. Più lettori alla volta.
* LE SEZIONI CRITICHE DEVONO ESSERE ATOMICHE, i semafori per esempio solo uno strumento per renderle atomiche.

---

### 17/02/2026

---

* Deadlock detection
* Bell La Padula
* SRTF vs SJF
* Sincronizzazione tra proc interno ed esterno
* A me ha chiesto (in maniera abbastanza indiretta) di scrivere tutto il codice eseguito da una generica (device independent) read() da parte di un processo applicativo

---

## Domande scritto

### 26/01/2026

comunque allo scritto oggi ha chiesto 
- come un utente può modificare la priorità di un processo
- cosa succede ai job se si chiude il terminale e differenze tra nohup e dispwn
- sintassi e comportamento di open read e write
- un esercizio su utlizzo dei thread diviso in due fasi, il main crea 5 thread che generano un numero da inserire in un vettore nella prima posizione libera, l'ultimo sveglia il main che si era fermato ad aspettare che finiscano tutti. i thread si dovevano fermare per aspettare lxinizio della seconda fase e poi inizia la seconda fase in cui dovevano fare la stessa cosa senza fermarsi alla fine
il testo dell'ultimo esercizio era lungo ho scritto più p meno come mi ricordavo
