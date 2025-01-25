# Progetto di Reti Informatiche - Giulio Zingrillo - Voto finale 29
Ho presentato il progetto al primo appello della sessione invernale. 
La prof. Righetti è stata molto scrupolosa, aveva letto attentamente il codice e lo aveva sottoposto a molti test. 
Nel mio caso aveva trovato due errori, che sono stati corretti nella versione caricata qui e che riporto di seguito:
- Il primo, più serio, riguardava l'invio della lunghezza del messaggio, che, nella fretta, avevo gestito male: infatti io non facevo né la conversione del valore tra host e network, né utilizzavo i tipi "certificati" uint;
- Il secondo riguardava la gestione dell'input utente per le risposte al quiz: avevo gestito il caso in cui l'utente inseriva più caratteri della lunghezza del buffer, ma non quello in cui si limitava a premere invio senza aver scritto nulla.

La professoressa è stata comunque molto comprensiva: mi ha chiesto, in sede di orale, come avrei corretto gli errori e mi ha fatto modificare il codice. 

I principali punti di forza del progetto, che sono giustificati sinteticamente nella documentazione, sono l'impiego degli alberi binari di ricerca - che garantiscono ottime prestazioni nell'inserimento, eliminazione e stampa ordinata di nodi -, e dei thread, che abbattono l'overhead dovuto ai cambi di contesto. 
Un thread, in particolare, è dedicato alla gestione del pannello di controllo, che si aggiorna ogni 3 secondi (ma il parametro è configurabile) e termina automaticamente se l'utente preme q e dà invio. Per capire quando il socket è stato chiuso in fase di invio del messaggio (e, quindi, lato client) ho gestito il segnale SIGPIPE. 
Inoltre, ho implementato un formato .quiz basato su caratteri delimitatori e un file di indice. Il parsing dei quiz, effettuato all'avvio del server, è improntato alla flessibilità: aggiungendo file nella cartella quiz e modificando l'indice si possono aggiungere domande e risposte. 

In merito alle scelte di rete, ho inserito nella documentazione un diagramma del progetto come macchina a stati per dimostrare che, sotto opportune condizioni, definire un tipo di messaggio era superfluo: in ogni momento client e server sapevano a priori quale messaggio aspettarsi. 

Eventuali ampliamenti del progetto, che non sono riuscito a implementare per mancanza di tempo, sono l'aggiunta di scambi di messaggi tramite protocolli binari (ad esempio, l'invio della classifica o dei temi) e la gestione della terminazione con Ctrl-C lato client e lato server. 

Il mio consiglio, comunque, è di prestare sempre un occhio al tempo nella realizzazione del progetto: fare un progetto che funziona è fondamentale per accedere all'esame, e farlo bene dà una certa soddisfazione personale, ma dal momento che questa parte è valutata solo 4 punti è opportuno non distrarsi troppo dalla preparazione dell'orale, che ha invece un peso molto maggiore.