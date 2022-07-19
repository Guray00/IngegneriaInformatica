# Domande orali sistemi operativi 18/07/2022

## Studente 1

- Schema di traduzione degli indirizzi per la memoria segmentata
    - Perché si controlla che il numero di segmento generato dalla CPU sia minore del numero di segmenti presenti nella tabella dei segmenti?
    - Cosa cambia se si fa segmentazione a domanda?
        - Cosa c'è nella tabella dei segmenti nel caso in cui il bit di presenza sia zero?
    - Quali sono i campi all'interno di una riga della tabella dei segmenti? (Vuole sapere esattamente cosa si intende per "indice", non si capisce dove vuole andare a parare, spiega poi che voleva sapere la differenza tra indice e indirizzo, dicendo che l'indice è "l'indirizzo" di un blocco)

## Studente 2

- Come si scrive il device driver di un timer?
    - Lo studente parla di alarm e sleep e il prof chiede di implementare il driver nell'ottica di dover realizzare la sleep
    - Dove stanno scritti gli indirizzi dei registri della periferica? (Descrittore della periferica)
    - Dove sono implementati fisicamente i registri di controllo di stato ecc? (Il prof vuole risposte secche a queste domande senza girarci intorno)
    - Quali sono gli altri campi necessari da mettere nel descrittore? (Lo studente fa riferimento alla soluzione di calcolatori ma al prof non va bene)
    - Come vanno inizializzati i semafori del descrittore del timer?

## Studente 3

- Come funziona la gestione di un page fault?
    - Lo studente lo dice a parole ma il prof vuole anche il disegno
    - A cosa serve la tabella delle pagine? (Chi diceva che è pignolo ha ragione)
    - Cosa c'è scritto nel descrittore del frame?

## Studente 4

- Come si rileva una situazione di stallo (deadlock detection)?
    - Lo studente disegna un grafo con risorse e processi (non mi ricordo il nome) con un ciclo e il prof vuole sapere che codice può aver portato a questo grafo
    - In quale caso ci si pone il problema di usare signal-and-wait o signal-and-continue? (nei monitor)
    - Cos'è un monitor e com'è fatto(senza far riferimento ai 5 filosofi)? (Sta saltando di palo in frasca per qualche motivo)
    - Cos'è una variabile condiction?

## Studente 5

- Quali sono le strutture date UNIX per gestire i file?
    - Perché abbiamo la tabella dei file attivi? (Fa da cache degli i-node)
    - Perché se due processi aprono lo stesso file abbiamo due diverse entrate nella TFAS?
    - Come si trova l'indice dell'i-node?
    - Come si arriva da un i-node al blocco giusto in memoria secondaria?

## Studente 6

- Come si schedula un sistema hard-real-time?
    - Il prof si impunta sul perché sull'asse orizzontale del grafico della temporizzazione c'è una freccia che punta verso destra. Continua a delirare con domande filosofiche sul perché su un'asse temporale una cosa a sinistra è precedente a una più a destra

## Studente 7

- Come si può prevenire il deadlock in un sistema in cui devo garantire la mutua esclusione?
    - Cosa si intende per stato sicuro?
    - Condizioni necessarie per il deadlock e quando diventano anche sufficienti
        - Riferito alla condizione che dice che non ci deve essere preemption: di che tipo di preemption si tratta? (Sulle risorse, non sulla schedulazione)
    - Cosa si deve essere verificato (a livello di semafori) perché nel grafo si abbia una freccia da una risorsa a un processo? (Vuole vedere il codice)
    - Fare un esempio di un algoritmo del banchiere con risorse a singola istanza (gli va bene anche un algoritmo un po' abbozzato fatto sul grafo)
        - Cosa si intende per stato sicuro? (Prima non aveva risposto)

## Studente 8

- Gestione della memoria virtuale in UNIX (in sostanza vuole sapere la paginazione su domanda nello specifico di UNIX ovvero page deamon, swapper ecc)
    - Perché si hanno 3 variabili (des_free, lots_free e min_free), non si poteva fare con due sole?
    - Cosa fa pagedeamon nel caso in cui non ci sono abbastanza frame liberi? (Algoritmo dell'orologio)
        - Perché si chiama second chance
        - Che algoritmo si approssima con l'orologio (LRU)
        - Perché si usa questo algoritmo invece di LRU vero e proprio? (LRU ha grandi costi sia di memoria che di tempo)