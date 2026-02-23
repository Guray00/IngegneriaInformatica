# Orali di Calcolatori Elettronici

Di seguito trovate un elenco ordinato per argomenti riportante le domande per l'esame di Calcolatori Elettronici, con docente prof. Lettieri e ing. Leonardi (2022). <br>

> ⚠️ **ATTENZIONE**: *Le risposte riportate non sono esaustive e non è detto che siano corrette, per tale motivo si invita i lettori a proporre delle versioni ampliate e revisionate delle stesse. Si evidenzia in particolare come le risposte dovrebbero essere in molti casi molto più esaustive, e sono da prendersi dunque solo come linee guida.*

---


## Ram

- A cosa serve e come funzionano i byte enabler
  > I byte enabler sono dei collegamenti (dunque dei fili) che troviamo all'interno delle nostre memorie che consentono di selezionare quali bit sono di interesse che devono rispondere a un determinato indirizzo.

- com'è organizzata la memoria per i byte enabler (con disegno)

---

## Cache

- Come funziona e come è fatta la cache
- Scomposizione della cache (Memorie interne e fili)
- Sincronizzazione
- Perché se si usa la cache siamo più veloci
- Nella cache associativa a insiemi, si pone il problema di quale via rimpiazzare quando c'è una miss. Come si fa?
  > Si applica l'algoritmo LRU

- Con 4 vie ci vogliono quanti bit? 
  > Dipende dalla politica approssimante

- La politica pseudo LRU va sempre bene?
  > Funziona in generale bene, ma non è detto che sia la migliore (anzi in alcuni casi risulta la peggiore)

- vantaggi della cache a indirizzamento diretto?
  > La rapidità e la semplicità della funzione che consente di allocare la cacheline. Il grande svantaggio è invece il poter mantenere solo una cacheline per ogni indice

- Perchè l'offset è su 3 bit?
	> Perchè ogni cacheline è grande 64 byte, che sono 8 quadword, raggiungibili con un offset di 3 bit

- Parlare della cache (con disegno)

- Se usiamo delle cache line più grandi come cambia la RAM delle etichette?
  > Se faccio le cacheline più grandi essa diminuisce, al contrario aumentana

- Principi di località e a cosa servono

---

## Primitive

- A cosa servono
  > Le primitive, anche denominate "chiamate di sistema", sono delle funzioni che consentono all'utente di accedere ad alcuni funzionamenti del nucleo in modo "limitato" e protetto. Sono routine che vanno in esecuzione tramite una _int_ (compaiono dunque nella IDT), hanno una parte sviluppata in assembly mentre il cuore del funzionamento è sviluppato in c++

- Perche si passa per forza da assembler?
  > L'assembly risulta necessario per permettere il funzionamento multiprogrammato e multiprocesso del sistema. Quando si vuole porre una primitiva in esecuzione, questa sarà correlata a un processo che dovrà essere posto in esecuzione. Cio è possibile eseguendo le funzione di "salva stato" e "carica stato", che si assicurano che il contesto del processo venga posto al sicuro. Il motivo principale è però la necessità di utilizzare _iretq_ (che non ha un corrispettivo c++) per eseguire il pop delle 5 parole lunghe (XXX, SRSP, CPL, RFLAGS, RIP)

- Corpo generico di una primitiva _(CODICE)_
  ```asm
  # manda l'interruzione per far risponedere
  # la primitiva
  primitiva_x:
	INT $tipo_primitiva
	RET
  ```
  ```asm
  # salva e carica lo stato, ma soprattutto
  # sfrutta iretq (non implementabile in C++)
  a_primitiva_x:
  	CALL salva_stato
  	CALL c_primitiva_x	
  	CALL caricato_stato
  	IRETQ
  ```
  ```cpp
  // Realizzazione c++ della primitiva
  extern "C" void c_primitiva_x(arg1, arg2 ...){

	// valore di ritorno in contesto[I_RAX]
  } 
  ```

- in quali gate della IDT abbiamo DPL sistema?
	> Eccezzioni, Interruzioni esterne e più in generale tutte le primitive che non vogliamo possano essere richiamate liberamente dall'utente (si pensi agli handler per l'I/O).

- Come faccio a capire se la iretq ha tutte le informazioni che le servono?

- In che modo è necessario dichiarare una variabile in modo che il processore non la ignori?
  > volatile

---

## Interruzioni

- Precedenza su piu interruzioni contemporanee
  > La precedenza è data sempre dall'interruzione avente la priorità maggiore (4 bit più significativi del tipo) mediante l'annidamento delle interruzioni.

- perchè Priorità > e non >=
  > Per garantire il caso limite in cui uno stesso piedino manda più volte la stessa richiesta.

- Differenza tra interrupt su fronte e su livello
  > Nel caso di riconoscimento sul livello l’APIC si comporta diversamente solo per quanto riguarda il riconoscimento di una nuova richiesta sul piedino: se il bitt di IRR è a zero e c’è un fronte su i, l’APIC registra una nuova richiesta; da questo punto in poi l’APIC smette di osservare il piedino i; lo osserverà di nuovo solo all’arrivo del prossimo EOI: se in quel momento lo ritrova ancora (o di nuovo) attivo, registra una nuova richiesta.

- È possibile che si perdano interruzioni? Se sì quando non viene vista? Ad esempio col timer c'è la possibilità di perdere un'interruzione se...?
  > Se, ad esempio, è in corso una routine con il riconoscimento sul livello dovuta a un'interruzione del timer che non è stata svolta "sufficientemente velocemente", per cui abbiamo che il livello viene mantenuto da una nuova richiesta ma non siamo in grado di capirlo per cui questa verrà persa.

- Come gestire più richieste sullo stesso piedino apic
  > Annidamento delle interruzioni con l'utilizzo dei due registri ISR IRR.

- Cosa comporta programmare con le interruzioni attive
  > Perdere l'atomicità, in quanto un'operazione in corso potrebbe non essere portata a termine in quanto un'interruzione di priorità superiore potrebbe "scavalcarla".

- Quando si traduce una funzione in c++ sono ripristinati tutti i registri?
  > No, solamente i registri scratch vengono ripristinati.

- Quali sono le istruzioni che ci permettono di usare le interruzioni?
  > (???) CLI e STI.

- Quando si accodano le richieste di interruzione su IRR?

- Perchè quando si attraversa il gate viene salvato il registro del flag?

- Come gestiamo le periferiche che agiscono sullo stesso piedino dell'apic?

- Quanti piedini ha l'APIC?
  > 24

- Chi configura i registri dell'APIC e la IDT?
  > Il programmatore con le apposite funzioni della libce (tipo apic_set_VECT)

- Chi stabilisce le classi di priorità nelle interruzioni e come si riconoscono?
  > Sono stabilite in base ai 4 bit più significativi del tipo e, per quanto detto sopra, sono stabiliti dal programmatore.

- Registri ISR e IRR dell'APIC.

- Cosa sono le interruzioni e a cosa servono?
---


## Processo

- Avvio: quali strutture vengono create e come vengono inizializzate
- Cambio di processo
- Perché punt_nucleo punta alla base?
  > Perchè la pila sistema deve essere generalmente considerata vuota, in quanto si riempe quando si entra in modalità sistema e si svuota qunado se ne esce 

- Come si passa il parametro alla activate_p?
  > La activate_p è una funzione utilizzata per l'attivazione di un processo e prende come parametri 4 elementi: un puntatore alla funzione che deve essere eseguita (mioproc, di tipo void (int)), un parametro per tale funzione int, la priorità e infine il livello (utente, sistema). Il parametro viene passato inserendo tale valore all'interno del registro RDI presente nel contesto del processo appena creato (in modo analogo a quanto visto in assembly).

- Chi è che usa punt_nucleo? 
  > Il processore quando passa da utente a sistema

- perchè usiamo una pila sistema diversa per ogni processo?	
  > se ci fosse solo il modulo sistema non sarebbe necessario, in quanto verrebbe pulito ogni volta che avviene il cambio di processo senza compromettere nulla in quanto gira in modo atomico. Nel caso invece del nostro nucleo, essendo presente anche il modulo I/O con le interruzioni abilitate perdiamo l'atomicità e dunque necessitiamo di salvare le informazioni relative ad ogni processo in un "luogo sicuro" dove l'utente non possa comprometterle

- cosa è la preemption

- Cosa fa, dove e come si salta dopo carica_stato
  > La carica_stato si preoccupa di caricare nei vari registri tutto ciò che è contenuto in quel momento all'interno del descrittore di processo che è attualmente in "esecuzione". Il salto vero e proprio però sarà eseguito per opera della IRETQ, che si preoccuperà anche di abbassare (ove necessario) anche il livello di privilegio.

---

## Protezione

- Perche e come si fa il cambio di pila
  > Il cambio di pila avviene quando si esegue il cambio di livello all'interno di un processo dovuto alla chiamata di una primitiva di sistema. IL cambio di livello avviene inserendo 5 parole quadruple all'interno della pila sistema, puntata da punt_nucleo, che rappresentano: xxx, RFLAGS, RSP (pila utente), CPL, RIP. Questo viene fatto in modo che quando richiamata la iretq (che può solo abbassare il privilegio) questa estragga le 5 parole lunghe e consenta il ritorno alla pila precendete.

- Perche e come si fa il cambio di livello
  > Risposta sopra (?)

- a cosa servono i semafori e in che modo risolvono i problemi (quali)?
  > Strutture dati volte a risolvere i problemi di mutua esclusione e sincronizzazione
  
- la iretq deve obbligatoriamente passare dalla modalità utente o può rimanere in modalità sistema?
  > L'importante è che non alzi mai, per cui può rimanere a livello sistema nel caso in cui fosse stata chiamata a sua volta da un processo sistema.
---

## MMU

- Quando una tabella di livello 4 punta a se stessa
  > Traduzione identità, all'interno dell'indirizzamento riservato al sistema.

- Che problemi dà la mmu attiva mentre è in atto un trasferimento di una periferica?
- Cosa fa la mmu con i bit R/W nell'albero di traduzione. Quando li controlla e perché?
  > I bit r/w nell'albero di traduzione specificano se il sottoalbero a cui si fa riferimento ha i permessi di lettura e scrittura. Questi si trovano in ogni tabella in modo da evitare anticipatamente di scorrere tutto l'albero se la richiesta non è soddisfatta.

- Come la mmu traduce gli indirizzi
  > Gli indirizzi sono tradotti attraverso una struttura dati denominata bitwise trie. Quest'ultima mappa ogni chiave (stringa) all'interno di ogni nodo in modo da utilizzare le “porzioni di indirizzo” passate per accedere alle varie tabelle. In particolare avremo che i primi 9 bit andranno ad evidenziare quale tabella di livello tre si vorrà accedere scorrendo quella di livello quattro, i 9 bit successivi invece nella tabella precedente quale sarà il nuovo ingresso e così via fino a raggiungere le foglie.

- Posso tradurre qualunque indirizzo virtuale in indirizzo fisico?
- A cosa può servire avere il bit U/S in ogni tabella?
  > L'inserimento in ogni tabella consente un'uscita anticipata se la richiesta non è soddisfabile, senza dover arrivare fino alle foglie.

- Nel caso ci fosse un solo processo non servirebbe avere il bit U/S in ogni tabella, perché?
- Traduzione dell'indirizzo 4096 da virtuale a fisico avendo a disposizione una memoria con 8 frame liberi
- Perchè 12 bit di offset, imposto o scelto?
  > Dipende dall'architettura, è quando trova scritto il programmatore di sistema all'interno del manuale dell'architettura che sta sviluppando. Nel nostro caso appunto 12 bit.

- Se avessimo voluto un offset maggiore, sarebbe cambiato qualcosa?

- Finestra di sistema

- MMU e TLB nella parte di I/O dedicati alle periferiche

- Perché al software può interessare accedere alle tabelle di traduzione?
  > Per esempio per crearle o distruggerle con la trasforma nel modulo I/O

- Cosa succede step per step e quali sono le cose **minime** da allocare se ci troviamo alla fine della parte C++ di una primitiva che ha creato un processo (che si trova adesso nella variabile esecuzione) che possiede nel contesto l'indirizzo della tabella di livello 4 ma che è completamente vuota (cioè tutti i bit P a 0). Sia nel caso in cui il processo creato sia livello utente che sistema

- Cosa succede se si ha nella tabella di livello 4 un'entrata (o più) che puntano a se stesse e quali sono le differenze col sistema che usiamo noi?
  > Supponiamo che l'entrata che punta a se stessa sia la i-esima nella tabella di livello 4 e che stiamo traducendo l'indirizzo virtuale i cui 9 bit del 1° blocco usato per navigare nell'albero di traduzione corrispondono ad i. La MMU navigherà nell'albero e senza saperlo tornerà alla tabella di livello 4 (dovrebbe essere alla 3). Procederà a navigare l'albero sfruttando gli altri 3 blocchi arrivando così alla tabella di livello 2, anziché a quella di livello 1 come usuale. A questo punto la MMU assumerà che quella sia la traduzione (ovvero quell'indirizzo virtuale punterà al frame contenente le entrate della tabella di livello 1). Questo metodo permette di accedere alle tabelle di livello 1 ma non permette di accedere a tutti i frame della memoria fisica (almeno 512GiB non saranno raggiungibili), cosa invece il nostro metodo permette di fare con la finestra sistema.
---

## Memoria virtuale

- Trasforma (non il codice), quando e perché viene utilizzata
  > Trasforma è una funzione che consente di trasformare un indirizzo virtuale in fisico scorrendo l'albero di traduzione del processo. in particolare tale albero si troverà all'interno del registro CR3; percorrendo l'albero si giungerà fino alle foglie, in particolare scorrendo quattro tabelle (4, 3, 2, 1), ove sarà scritto il l'indirizzo fisico del frame in cui si trova il dato.

- Dato un esempio di indirizzo virtuale e fisico con offset diverso, dire se sia possibile una traduzione del genere. 	
  > no, perchè l'offset rimane invariato da virtuale a fisico, almeno gli ultimi 12 bit

- Cosa c'è nel descrittore di frame e a cosa serve ogni campo
- perché si fa la Union per il descrittore di frame?
  > Viene utilizzata la union in quanto i  dati presenti all'interno del descrittore di frame non sono significati allo stesso momento (dipendono dal contenuto), per cui la union consente di risparmiare lo spazio senza tenerne non allocato.

- Come si implementa una finestra di memoria fisica, dove la memoria fisica era costituita da 8 frame (senza bit PS) nei quali dovevano risiedere anche le tabelle?
  > L'implementazione della memoria fisica avviene al momento di avvio del sistema (quando la MMU è disabilitata) e consiste nel mappare tutti gli indirizzi della memoria fisica in se stessi, in modo da potervi accedere liberamente simulando una disattivazione della MMU.

- Cosa e' la "finestra sulla memoria fisica"
  > Sopra
- Vantaggi della paginazione
- Vantaggi e svantaggi di pagine piu piccole o piu grandi di 4Kib
  > Vantaggio: meno traduzioni necessarie per mappare ampie zone di memoria. Svantaggio: molto spreco.

- che problema ho se ricarico un processo dopo che era stato swappato?

- Supponiamo di non volere la finestra sulla memoria nella memoria virtuale di ogni processo, ma alcune strutture dati devono poter essere accessibili, quali sono queste strutture dati?
> Le strutture dati che devo avere necessariamente mappate sono:idt, la gdt->tss, la pila sistema, strutture dati, della ruotine di sistema mi serve solo quanto basta per cambiare la tabella di traduzione

- Traduzione indirizzi virtuali in fisici

- Trasforma

---

## TLB
- A cosa serve il tlb e come funziona
  > Cache degli indirizzi fisici, contiene tutte le traduzione per non costringere a leggere ogni volta tutto l'albero di traduzione (...)

- A cosa serve il bit D e come viene gestito
  > Implementato per la paginazione su domanda, indica se la pagina è stata modificataò

- Miss TLB: caso peggiore dire il numero di accessi
  > Nel caso peggiore l'architettura fa un accesso nel TLB (che darà una miss), 4 accessi nell'albero di traduzione per individuare l'indirizzo fisico e un ulteriore accesso a tale indirizzo per recuperarlo.

- Controlli sui bit di accesso (bit A)
  > Se il software lo cambia, è compito suo invalidare le entrate del tlb in modo che il valore venga aggiornato anche nel tlb

- TLB, descrittore di lv 1 e uso del bit D nella routine di PF (page fault?)
  
- Perchè non serve invalidare il tlb dopo aver eseguito una unmap?
  > Perchè se un'indirizzo non è più mappato, questo non potrà essere richiamato dal processore. Dunque l'entrata TLB verrà in seguito sostituita comunque con qualche traduzione più recente.

- Parli del TLB
- Cosa sono PCD e PWT?
- Nel caso peggiore quanti accessi in memoria fa la MMU?

---


## I/O

- Perché vogliamo che la cache sia disabilitata per gli indirizzi che corrispondono ai registri delle periferiche?
  > Il meccanismo della cache non ha alcun senso per le operazioni di I/O, in quanto queste operazioni hanno effetti collaterali che non devono essere cancellati: se un programma vuole leggere il prossimo carattere battuto sulla tastiera è necessario interpellare la tastiera. Non avrebbe alcun senso re-inviare al processore sempre lo stesso carattere conservato in cache. Il controllore cache, dunque, farà passare inalterate tutte le operazioni di lettura e scrittura nello spazio di I/O.

- Esempio di tastiera, come faccio a leggere un dato da una tastiera e perché la cache deve essere disabilitata in questo caso.
  > in parte risposto sopra
  
- Schema generale CPU, cache, periferiche
- Esempio di una periferica
- Cosa comporta iopl sistema? 
  > Iopl non controlla solo le operazioni di I/O ma anche altre operazioni come CLI e STI quindi se dessimo IOPL utente a qualcuno gli daremmo la possibilità di disabilitare le interruzioni)

- Quali sono i problemi di avere delle periferiche che fanno DMA con gli indirizzi virtuali?

---

## Handler e Driver

- Come funziona un driver e un handler
- Corpo generico di un driver _(CODICE)_
  ```asm
  CALL	salva_stato
  MOV 	$i, %RDI
  CALL 	c_driver
  CALL	apic_send_EOI
  CALL 	carica_stato
  ```

- Corpo generico di un handler _(CODICE)_
  ```asm
  handler_i:
  CALL 	salva_stato
  CALL 	inspronti
  MOV 	$i, %RCX
  MOV 	a_p(, %RCX, 8), %RAX
  MOV 	%RAX, esecuzione
  CALL 	carica_stato
  IRETQ
  ```
  
- l'handler gira a interruzioni abilitate?
  > (???) No, in quanto è inserito all'interno del modulo sistema. Questo è inserito all'interno del modulo sistema in quanto deve poter chiamare salva_stato e carica_stato.

- quale comportamento dell'apic ci garantisce che l'handler di un tipo non rivada in esecuzione?
  > Lo garantisce il fatto che la politca con cui l'apic accetta le interruzioni si base sull'accettarne unicamente con priorità strettamente maggiore (e dunque non uguale!). Ciò implica che richiamando un'interruzione sullo stesso tipo, la priorità (4 bit più significativi) sarà la medesima e non verrà accettata nell'immediato.

- Codice di un handler e perché siamo sicuri che si riparta sempre dalla fine del ciclo infinito del processo
- Spiegare a cosa serve un processo esterno, il funzionamento e perché si usa
- Perché si usa l'handler e non il driver?
- Parlare della read_n (anche codice)
- Perché ci sono 2 if
- Com'è fatto un handler e cosa deve fare
- Quando parte l'handler
- Cosa fa la wfi rispetto al processo esterno?
- che stato è salvato nella pila sistema del processo esterno? dove salterà la iretq?

---

## DMA
- Cosa è il DMA?

- Accorgimenti sul buffer
  > Verificare il cavallo di Troia mediante la primitiva access

- Quali accorgimenti cambiano con il processo esterno?

- Quando abbiamo bisogno di operare in DMA?

- problemi che si possono verificare con il DMA

- Lettura e Scrittura di cacheline durante il DMA

- Se viene inviato EOI e non fosse presente wfi nel modulo i/o, cosa bisogna fare?
  > (non sono sicuro) Bisognerebbe implementare un meccanismo (direttamente dall'assembler) per eseguire salva_stato, EOI, schedulatore, carica_stato in modo da poter inviare la richiesta di fine interruzione, inserire il processo con priorità maggiore in esecuzione ma soprattutto salvare lo stato del processo esterno in modo che possa continuare da dove questo si è interrotto. Altrimenti bisognerebbe considerare l'eventualità in cui il processo esterno non possa fermarsi "in un punto specifico" ma che ogni volta che questo va in esecuzione tutta la funzione dovrà essere svolta (senza saltare la parte inziale).

- Trasfermimento tra periferiche: è necessario che il buffer si trovi all'interno della memoria condivisa? nel dma?

- Bus mastering: come capisco che un trasferimento è terminato? Che problemi ci sono?
  > Per capire se un trasferimento è terminato, in seguito alla ricezione da parte dell'apic dell'interruzione, la cpu esegue una lettura in uno dei registri della periferica in modo che tale richiesta venga aggiunta alle richieste del ponte PCI. Essendo che tale gestione avviene mediante una politica fifo, abbiamo la sicurezza che quando avremo eseguito la lettura il dato è stato correttamente copiato.

- Ci sono problemi di sincronizzazione tra un dispositivo e il ponte ospite/PCI?
  > Stessa domanda di sopra

- Bus mastering: come capisco che un trasferimento è terminato mediante una soluzione puramente hardware?

- Bus mastering e cache: quali problemi abbiamo?

- Quale è la soluzione hardware per il trasferimento dell'ultimo byte dal dispositivo alla memoria?

---

## PCI

- Spiegare cos'è lo spazio di configurazione del bus PCI
- A cosa servono i BAR
  > I BAR (base address register) sono dei registri (uno per ogni funzione presente all'interno della periferica) che consentono di realizzare una maschera per attivare la funzione stessa.

- Chi è che inizializza la configurazione delle periferiche?
  > Il sistema: questo verifica quali dispositivi sono connessi

- Perché le periferiche non si scelgono gli indirizzi
	> perchè potremmo avere due dispositivi che rispondono agli stessi indirizzi

- È possibile avere la stessa periferica al solito indirizzo?
  > No. Se una periferica scegliesse gli indirizzi, ci potrebbero essere più periferiche al solito indirizzo non avremmo dunque un accesso mirato

- Come facciamo ad accedere via software allo spazio di configurazione delle periferiche?
  > Attraverso il ponte ospite PCI (detto anche north bridge)

- Che coordinate bisogna passare al CAP? 
  > bus + numero di periferica + numero dispositivo (DEVICEID) + il numero della funzione  + offset del registro

- Quali vantaggi porta il bus pci?
  > La possibilità di aggiungere periferiche in un secondo momento realizzate da altri produttori

- Bus PCI e interazione con la cache
---

## Semafori

- Come facciamo nel nostro nucleo a creare un modo per far sì che i processi partono e dopo un tot. di tempo vadano in fondo a coda pronti?
  > La risposta probabilmente è creare una routine speciale legata al timer che fa salva stato, call c_primitiva, carica_stato, iretq, e nella funzione si fa inserimento forzato in fondo a coda pronti.
- E se il processo si sospende su un semaforo?
  > Si deve salvare in des_proc da quanto tempo era partito il processo prima di sospendersi

- Parli in generale dei semafori, a cosa servono, codice della struct, primitive semaforiche...

- Problema della mutua esclusione

---

## Pipeline

- Quali sono le dipendenze sui dati e sui nomi
- Esecuzione speculativa e out of order con disegni
- Parli delle pipeline

---

## Esecuzione speculativa

- Parli dell'esecuzione speculativa
