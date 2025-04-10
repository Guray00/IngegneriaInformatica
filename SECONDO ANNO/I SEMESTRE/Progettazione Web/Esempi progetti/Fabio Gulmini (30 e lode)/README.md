# Guida per PWEB

## Il progetto
Il Conway's Game of Life è un giochino matematico. È basato su una griglia bidimensionale di celle, ciascuna delle quali può essere in uno stato attivo o inattivo. Le regole del gioco sono semplici, ma il comportamento delle celle risultante è quasi organico. Le regole esatte sono spiegate nella guida.

## Features
Questa è una lista molto dettagliata di funzionalità per rendere bene l'idea di quanto ci vuole per implementare un progetto di queste esatte dimensioni.
- creazione di una board con adeguati handler (click sulle celle, keypress vari, ecc) per gestire la simulazione (il gioco in sé)
- algoritmi ragionevolmente veloci per la simulazione (vedi sezione algoritmi)
- solo 4 endpoint nel backend (`login`, `signup`, `save`, `delete`)
- una barra di navigazione per la simulazione
- una barra che gestisce l'autenticazione (un form che chiama i 2 endpoint `login` e `signup`)
- una barra che si sostituisce alla precedente e mostra le board salvate (un piccolo pezzo di js che fa rendering delle board che arrivano dal db) e chiama gli altri 2 endpoint `save` e `delete`
- algoritmi di compressione e decompressione delle board (vedi sezione algoritmi)

## Algoritmi
### quadtree.js
Ogni cella è rappresentata come una stringa binaria di 32 bit. Ne risulta che la board ha in totale `2^32` celle, dunque è una griglia `2^16 * 2^16`.
La posizione di una cella è rappresentata come in un [quadtree](https://en.wikipedia.org/wiki/Quadtree). Ogni coppia di bit rappresenta il quadrante della mappa in cui si trova il punto, ricorsivamente.
Per trovare i vicini di una cella in rappresentazione a quadtree ho implementato l'algoritmo di [questo paper](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=b2f67e125189d6ab3d036aa1a4c3e0870ddeccee).

### compressor.js
Ho scelto la rappresentazione a quadtree perchè ha la proprietà di rappresentare celle che sono vicine tra loro con codifiche simili. La griglia è molto sparsa, quindi grandi porzioni della mappa non contengono alcuna cella.
Note: un quadtree è anche un albero binario, una lista di celle a 32 bit è una lista di foglie di questo albero binario di altezza massima 32.
Di seguito l'algoritmo di compressione implementato:
- parti dalla root dell'albero binario
- se ci sono celle nel sottoalbero sinistro, scrivi 1, altrimenti 0
- se ci sono celle nel sottoalbero destro, scrivi 1, altrimenti 0
- se ci sono celle nel sottoalbero sinistro, ricorri a sinistra
- se ci sono celle nel sottoalbero destro, ricorri a destra
- se sei a profondità 32, fermati, hai trovato una cella
Questo algoritmo restituisce una stringa binaria, che poi può essere salvata in database dopo una conversione in base 64.

L'algoritmo di decompressione è analogo, ma al contrario

# Cosa consiglio per l'esame

Lascio una lista di consigli sparsi: (source: ho ascoltato gli orali delle 10 persone prima di me)

### Il codice deve assolutamente essere corretto
Ne risulta scontato che più codice avete, più errori ci saranno. Praticamente nessuno ha presentato un progetto privo di errori (il mio aveva un potenziale xss, pure abbastanza evidente, ma non è stato notato, ora è fixato).

### State attenti alla sicurezza del codice, le vulnerabilità sono valutate MOLTO negativamente
- state attenti a sql injection (usate i prepared statements)
- state attenti a xss (sanificate sempre l'input dell'utente e seguitene il flusso)
- state attenti nel caso di chiamate autenticate (ne avrete di sicuro) a verificare effettivamente l'identità dell'utente (eventualmente controllando il session token se li usate): chatgpt si scorda di farlo

### Se puntate a un voto molto alto non fate dei gestionali
- la stragrande maggioranza dei progetti presentati sono dei gestionali, che lasciano in genere poco spazio per la creatività e l'inserimento di feature originali
- un gestionale sarà tendenzialmente molto grosso (quindi tanto spazio per errori)
- i progetti di più successo, spesso sono giochi
- se fate dei giochi, assicuratevi che siano facili da implementare
- se pensate di implementare gli scacchi, dovrete pensare a come gestire il doppio scacco di scoperta con en passant e pedone inchiodato: **pensateci bene!** (e seguite religiosamente [questo sito](https://www.chessprogramming.org/Main_Page))

### Non spendete troppo tempo sul progetto
- credo che 30-40 ore siano sufficienti per il progetto
- tenetevi 3-4 ore di imprecazioni per adeguare il codice all'ambiente di esecuzione scritto nella specifica (+ validatori e compagnia bella)
- tenetevi un paio d'ore prima di consegnare per testare, testare, testare.

## Cosa è stato apprezzato di questo progetto
- non sono stati trovati bug
- non sono state trovate vulnerabilità
- gli algoritmi erano molto fighi (con tanto di citazione del paper)
- il codice era ordinato
- (tocco di classe) ha apprezzato che ci fosse la licenza
