Si ringrazia per i contributi Alessandro Corsi e Luca Chiocchetti.
<h1>Domande Avvenuti</h1>
<ul>
<li>Com'è fatto lo schema di un device driver dal punto di vista del programma? Che azioni deve fare il device driver? 	Descrivere con precisione cosa succede dentro al device driver
<li>Descrivere un generico semaforo. Come si implementa un semaforo? Far vedere il codice 
<li>Come viene gestito un page fault in un sistema operativo? Dire precisamente l'ordine delle operazioni che vengono effettuati, gli eventi fondamentali del page fault (Avvenuti lo vuole passo per passo e nel dettaglio, come se stessimo descrivendo un algoritmo) 
<li>Come funziona la segmentazione nella memoria virtuale.
<li>Bell-LaPadula. Come risolve il cavallo di Troia, se può coesistere con la matrice degli accessi. Come si vede un file protetto nella matrice di accessi? Cioè cosa viene mostrato 
<li>Algoritmo del banchiere, stato sicuro. A cosa serve, descrizione, quando viene chiamato, come funziona, cosa fa.
<li>Algoritmo dell'orologio/second-chance.
<li>Simulazione di scheduling per far vedere che differenza c'è tra un algoritmo di scheduling a priorità statica e uno a priorità dinamica.
<li>Apertura del file in Unix, che strutture dati sono coinvolte dalla open.
<li>Tecniche di allocazione del file su disco. Realizzazione dell'accesso diretto e costo.
<li>Trasferimento nello spazio di I/O: interazione tra processo interno e processo esterno. Cos'è il processo esterno.
<li>Schedulabilità dei sistemi hard real time. Fattore di utilizzazione, definizione e cosa comporta. Minimo comune multiplo dei periodi, come si ottiene e cosa significa nel sistema. Rate monotonic: condizione sufficiente per la schedulabilità, definizione e quanto vale. Condizione necessarie per EDF, è migliore EDF o RM? Può succedere che un algoritmo sia schedulabile con EDF e non RM? Cosa vuol dire che un algoritmo è ottimo? 
<li>Produttore/consumatore con l'utilizzo dei semafori.
<li>Soluzione non corretta al problema dei 5 filosofi. Soluzione corretta col monitor.  
</ul>


<h1>Domande Minici</h1>
<ul>
<li>System call per la gestione del ciclo di vita dei processi. (fork exit wait exec).
<li>Spiegare la terminazione di un processo
<li>System call alarm e sleep
<li>Sincronizzazione basata sui segnali. Come possiamo usare un handler definito dall'utente? 
<li>Thread in Linux, cosa condividono. Perché si chiamano processi leggeri, cosa condividono e come si creano. Perché pthread_t è un tipo opaco.
  Funzioni join ed exit, cosa comporta l'utilizzo o meno della exit.
<li>Produttore/Consumatore usando la libreria pthread.h
<li>Bit di protezione in Unix, rappresentazione ottale e simbolica. Bit SUID e SGID.
<li>Priorità dei processi in Linux. Job Control.
<li>Comunicazione mediante scambio di messaggi (pipe), sintassi della open. Previsto un naming nello scambio del messaggio? Con che ordine vengono letti i messaggi?  Quali sono i processi che possono comunicare tramite una pipe? 
Come fanno per permettere la comunicazione tramite pipe? Necessario preoccuparsi di fare sincronizzazione sulla pipe? Bisogna scrivere il codice pensando alla sincronizzazione? 
Come si scrive all'interno della pipe? Cosa ritornano le funzioni per usare le pipe?   
<li>Permessi in Unix. chmod in base ottale (ricordarsi che il bit di SUID e SGID è in prima posizione nella rappresentazione in base ottale). Differenza dei permessi tra file e cartelle. Come vengono definiti i permessi speciali? Comandi per cambiare i permessi .
<li>Thread, cos'è un thread in Unix/Linux. Funzioni sui thread. Necessario includere una libreria per usare i thread? Esiste il concetto nativo di thread in linux? Oppure è il programmatore a doverlo fare? Perché usiamo la libreria pthread invece del concetto nativo di thread di linux? Come vengono identificati i thread usando la libreria?
Come si crea un thread usando pthread? Come si termina il thread? 
<li>System call per la gestione dei segnali: signal e kill. 
 </ul>


  

