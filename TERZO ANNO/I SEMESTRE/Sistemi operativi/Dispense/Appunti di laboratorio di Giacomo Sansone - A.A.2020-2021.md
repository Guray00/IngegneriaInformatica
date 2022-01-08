<h1>Appunti laboratorio Sistemi Operativi</h1>
<p>
Ciao! Ho preso questi appunti seguendo le lezioni di Minici dell'A.A. 2020-21. Per quanto il programma non sia cambiato negli ultimi anni, consiglio ASSOLUTAMENTE di seguire le lezioni, e di usare questi appunti giusto come punto di riferimento (tenendo pure conto che ci potrebbero essere degli errori!!!). Buono studio! 
</p>

<h2>Lezione 1: Introduzione a Linux</h2>

<p>
UNIX nasce nel 1969 nei laboratorio di AT&T. L'idea è quella di ottenere un sistema portatile, che potesse funzionare su più architetture hardware. La prima realizzazione affidabile arriva nel 1970, scritta in Assembler e sviluppata poi in C nel 1973. Nel 1984, la Fondazione per il Software Libero inizia il progetto GNU, un progetto che la comunità potesse liberamente modificare e ricaricare, in modo da raggiungere un sistema completo. Con lo sviluppo di un nuovo kernel, si raggiunge GNU/Linux nel 1994. Le differenze tra le diverse distribuzioni sono tante, ma il punto comune resta il kernel e le varie librerie di C utilizzate. 
</p>

<p>
Il sistema GNU si può pensare con uno schema a livelli. Il kernel è un mezzo di comunicazione tra le applicazioni utente e l'hardware. Le applicazioni usano le system call per effettuale tali operazioni.
</p>

<p>
Linux viene usato da un utente normale che è il suo utilizzatore ma con privilegi limitati. C'è poi un utente che può fare qualunque operazione, l'utente <code>root</code>
</p>

<p>
Il file system ha una struttura ad albero: qualunque cosa su Linux è un file, anche i dispositivi removibili. La struttura ad albero fa sì che si abbia una radice, la directory radice indicata con <code>/</code>. Ogni utente ha la sua home directory in cui ha alcuni privilegi per fare certe operazioni. Al di sopra di questa directory, non tutto è permesso. Nel momento in cui si inserisce un supporto removibile, viene rappresentato nella directory <code>/dev</code>, e per accedere alle varie directory serve usare la sua sottodirectory <code>/dev/media</code>. In linea di massima, il supporto removibile ha un suo file system. 
</p>

<p>
Per descrivere un file, si possono usare due approcci: uno prevede l'uso del path assoluto, per indicare la posizione del file a partire dalla radice <code>/</code>; l'altro prevede di navigare ad un livello sottostante rispetto al punto in cui siamo, e si parla di percorso relativo. Per usarlo basta non iniziare il percorso con <code>./</code>. Con <code>~</code> abbiamo la home directory, <code>.</code> indica la directory in cui ci troviamo, <code>..</code> è la directory padre rispetto a quella in cui ci troviamo.
</p> 

<p>
Per comunicare con il sistema, o si usa una shell grafica, facile da usare ma con utilizzi limitati, o una shell testuale, che ci permette di fare qualunque cosa avendone i privilegi. Una shell testuale mostra un prompt, e ripetutamente legge un comando nella shell e lo esegue, verificando la correttezza sintattica di quanto inserito.
</p>

<code>

    alice@studio:~/Documents$
</code>

<p>
In questo modo vediamo la cartella in cui siamo, il tipo di utente e un cursore. 
</p>

<h3>Lista di alcuni comandi di base</h3>
<ul>

<li><code class="red">cd</code>: permette di navigare nel file system del sistema.</li>
<li><code class="red">pwd</code>: mostra il percorso assoluto della directory nella quale ci si trova. </li>
<li><code class="red">ls</code>: serve ad elencare il contenuto della directory in cui ci si trova o di cui si è passato il percorso. Ci sono alcune opzioni che si possono usare e che sono cumulabili: <code>-l</code> mostra alcune informazioni in più; <code>-a</code> mostra i file e le directory nascoste, i cui nomi iniziano con il punto.</li>
<li><code class="red">metacaratteri</code>: alcuni caratteri si usano per considerare più file contemporaneamente: <code>*</code> permette di sostituire uno o più caratteri; <code>?</code> sostituisce un carattere; <code>[]</code> permette di indicare un set di caratteri da cercare in sostituzione, sia elencando i singoli caratteri con una virgola, sia un range di caratteri con un meno. Poniamo di avere i file <code>aa.c abc.c a.c a.h axc.c</code>. Se vogliamo tutti i file con estensione <code>.c</code>, possiamo usare <code>*.c</code>. Se vogliamo i file con estensione <code>.c</code> il cui nome inizia con <code>a</code>, si usa <code>a*.c</code>. Se vogliamo i file con il formato di un solo carattere e il nome di un solo carattere, usiamo <code>?.?</code>. <code>a[4,f,x]c.c</code>: con una sintassi del genere, otteniamo <code>axc.c</code>.</li>
<li><code class="red">man</code>: ci da la possibilità di aprire il manuale di utilizzo di Linux. In questo modo possiamo ottenere informazioni su qualunque comando.</li>
<li><code class="red">mkdir</code>: permette di creare una directory, anche in un altra parte del file system indicando il path. </li>
<li><code class="red">rmdir</code>: permette di rimuovere una direcotry nel solo caso in cui essa sia vuota. </li>
<li><code class="red">cp</code>: permette di copiare un file sorgente ad una destinazione. Specificando il path, si copia in una cartella differente, e l'ultima cosa che si va a scrivere è il suo novo nome. Se gli argomenti sono più di due, i primi argomenti sono considerati sorgenti, l'ultimo è la destinazione.</li>
<li><code class="red">mv</code>: si usa per spostare i file, ma ha senso sopratuttoto per rinominare i file: muovendo un file nella stessa cartella ma con nome diverso, si ottiene una rinominazione. Il funzionamento, sotto questo punto di vista, è molto simile a <code>cp</code>.</li>
<li><code class="red">touch</code>: serve ad aggiornare il timestamp e l'ultima modifica di un file. Si usa per creare dei file. </li>
<li><code class="red">cat</code>: concatena il contenuto di uno o più file e lo mostra nello standard output. </li>
<li><code class="red">rm</code>: serve a rimuovere file o direcotry. Se non uso nessuna opzione, e passo il nome di una directory non vuota, non otterrò alcun risultato. Per eliminare anche il suo contenuto, si usa il comando <code>-r</code> (recursive).</li>
<li><code class="red">less</code>: mostra il contenuto di un file un po' alla volta, con la possibilità di muoversi nel file in modo interattivo. </li>
<li><code class="red">head/tail</code>: permettono di mostrare la prima parte e l'ultima parte di un file.</li>
<li><code class="red">redirezione dell'I/O</code>: si può stampare il contenuto di un comando anche su un file, a seconda dello stream che usa. Con <code>></code> si invia lo standard output dentro un file; <code>2></code> si reindirizza lo standard error; <code>&></code> reindirizza entrambi i canali all'interno dello stesso file. Se il file non esiste allora viene creato, altrimenti sovrascritto. Per aggiungere le informazioni in coda con l'append, si usa il simbolo <code>>></code>. Per reindirizzare l'input si usa <code><</code>. </li>
<li><code class="red">pipeline</code>: collega l'output di un comando all'input di un successivo. Ad esempio, <code>ls -l mydir | less</code> peremtte di mostrare un po' alla volta il risultato dell'istruzione precedente.</li>
<li><code class="red">su/sudo</code>: con su usiamo temporanemente il terminale di un altro utente; con sudo non solo cambiamo il terminale ma eseguiamo anche un'operazione. </li>
</ul>

<hr>

<h2>Lezione 2: Utenti e Gruppi, parte 1</h2>

<p>
Su Linux, ogni utente è l'utilizzatore del sistema. Ogni utente è identificato da uno username e un user ID, un identificativo numerico usato per gli accessi nella distinzione con altri utenti. Gli utenti possono essere raggruppati in uno o più gruppi, identificati da una stringa, <em>group name</em>, e un identificatore numerico, <em>group ID</em>. Ogni utente deve appartenere ad almeno un gruppo, il primary group. Al momento della creazione dell'utente, se non viene specificato diversamente, viene creato anche un gruppo omonimo dello username, che diventerà il suo primary group. <code class="red">passwd</code> serve per la modifica della password dell'utente. Con il comando <code class="red">id [username]</code> possiamo vedere l'id relativo ad un certo username; lo stesso con <code class="red">groups [username]</code>, che ci mostra i gruppi dell'utente specificato. Con <code class="red">adduser username</code> creiamo un utente. Se non specifichiamo nessun gruppo, ne verrà creato uno al quale verrà assegnato. Per rimuovere un utente, si usa <code class="red">deluser username</code>, che richiede i privilegi di sistema per essere utilizzato. Per fare queste operazione si possono usare i due comandi <code class="red">su</code> o <code class="red">sudo</code>. Con <code>su</code> possiamo dire a quale utente switchare, eventualmente l'utente di root; con <code>sudo</code> non si fa lo switch completo dell'utente, ma si esegue solo l'operazione con un altro utente: se non si aggiunge nulla si passa al root, altrimenti si può specificare con <code>-u username</code>. Per poter fare questa cosa, l'utente che lancia il comando dove appartenere ad un gruppo specifico. 
</p>

<p>
Per ogni file c'è un utente proprietario e un gruppo proprietario, a cui appartengono un sottoinsieme di utenti. Per ogni file, avremo un utente proprietario, la classe degli utenti che appartengono al gruppo proprietario del file, e la classe di tutti gli altri utenti. Quando si usa un file, si controlla se l'utente appartiene ad una di queste tre classi. Sulla base della classe, si guardano i permessi che gli sono concessi. Ad ogni classe, viene assegnato un permesso attraverso una rappresentazione simbolica con un carattere: lettura, <code>r</code>, scrittura, <code>w</code>, esecuzione, <code>x</code>. Questi tre caratteri indicano la possibilità di eseguire una determinata operazione a seconda della classe a cui si appartiene. Se ci riferiamo ad un file, <code>r</code> consiste nella lettura, <code>w</code> nella modifica, <code>x</code> per l'esecuzione; il permesso di scrittura non ci consente di cancellarlo: un file sta all'interno di un file di tipo directory, quindi per poterlo eliminare bisogna poter modificare la directory nella quale si trova. Se ci riferiamo ad un tipo directory, <code>r</code> ci permette di vedere la lista dei file (comando ls), <code>w</code> ci permette di modifica il contenuto (anche creare, rinominare e cancellare file), <code>x</code> ci permette di attraversa la cartella con il comando <code>cd</code>. 
</p>

<p>
Per visualizzare i permessi, possiamo usare il comando <code>ls -l</code>. Esistono due rappresentazioni, quella simbolica e quella ottale; con il comando di cui sopra, otteniamo la rappresentazione simbolica. Il primo carattere indica il tipo di file (file normale o directory), poi ci sono tre triplette di caratteri, quella associata ad owner, quella associata al group owner e quella riferita agli altri utenti. avendo <code>drwxr-xr-x</code>, solo l'owner può modificare la cartella, tutto il resto è concesso. Nell'output dell'istruzione c'è anche il nome del proprietario del file, il nome del gruppo proprietario (in linea di massimo, se non ci sono gruppi specifici, allora si usa il gruppo omonimo dell'utente). 
</p>

<p>
Possiamo rappresentare i permessi in modo numerico. Per ogni classe abbiamo una cifra in base 8, e andiamo a sommare uno di questi valori fino ad ottenere il risultato: 4 se vogliamo il permesso in lettura, 2 per il permesso in modifica, 1 per il permesso in esecuzione. La rappresentazione <code>777</code> ci dice che ad ogni classe utente è permesso tutto quanto (4+2+1). <code>750</code> ci dice che l'owner dei file può fare tutto, quelli del group owner non potranno modificare il file, mentre gli altri non hanno permessi. 
</p>

<p>
Per modificare i permessi, si usa il comando <code class="red">chmod permessi file</code>. Con <code>-R</code> si dice che la modifica viene fatta in modo ricorsivo nei file e sottodirectory. Il comando vuole la rappresentazione ottale dei permessi da assegnare al file. La sintassi può essere più estesa, anche usando la rappresentazione simbolica. <code class="red">chmod [who] [how] [which] fileName</code>: con <code>who</code> indichiamo la classe di utente per cui devono essere modificati i permessi, usando <code>ugo</code>; con <code>how</code> indichiamo se aggiungere <code>+</code>, togliere <code>-</code> o assegnare <code>=</code> permessi. <code>chmod go -rwx file</code>: stiamo togliendo tutti i permessi alle classi group owner e others.
</p>

<p>
Oltre ai permessi in lettura, scrittura ed esecuzione, esistono dei permessi aggiuntivi, che sono <code>SUID</code> (set user identification) e <code>SGID</code> (set group identification). Nel momento in cui si esegue un comando, esso viene eseguito con il permesso dell'utente in uso; si possono usare questi permessi per dire che durante l'esecuzione si abbiano i privilegi, rispettivamente, dell'utente proprietario o del group owner. Per attivare <code>SUID</code>, si guarda se l'attributo di esecuzione dell'owner è <code>s</code> invece che <code>x</code>. con <code>SGID</code>, si cerca la <code>s</code> nella seconda tripletta. Per la rappresentazione ottale di questi permessi, oltre alla tre cifre si aggiunge una quarta cifra posta all'inizio, che si ottiene sommando 4 se vogliamo attivare <code>SUID</code>, 2 se vogliamo <code>SGID</code>. Volendo <code>rwsr-sr--</code>, si ottiene in ottale <code>6754</code>. 
</p>

<p>
Usando <code>ls -l /usr/bin/passwd</code>, troviamo <code>-rwsr-xr-x</code>: quando modifichiamo il file delle password con quel comando, ci assumiamo momentaneamente il ruolo di owner del file, in modo che si possa modificare con il comando visto prima senza essere proprietari (giustamente, il singolo utente deve poter modificare la propria password). 
</p>

<p>
Alcuni comandi ci permetto di modificare il proprietario e il gruppo proprietario di un file. <code class="red">chown username file</code> può essere usato solo dal root; <code class="red">chgrp groupname file</code> permette di modificare il gruppo proprietario; per farlo, l'utente deve appartenere al gruppo proprietario. 
</p>

<p>
L'editor <code>vi</code> ci permette di modificare file di testo. Ci sono due modalità, quella comandi, per eseguire determinate operazioni sul file, e quella di editing, per modificare del testo. Per tornare alla modalità comandi si usa <code>ESC</code>, per arrivare alla modalità testo si usa <code>i</code>. 
</p>

<hr>
<h2>Lezione 3: Utenti e Gruppi, parte 2</h2>

<p>
Ci sono alcuni file per la configurazione degli utenti: uno in <code class="red">/etc/passwd</code>, dove ci sono tutte le informazioni pubbliche, uno in <code class="red">/etc/shadow</code>, dove troviamo le informazioni sensibili. Il primo file è spiegato nella sezione 5 del manuale di <code>passwd</code>; per modificarlo, si può usare il comando <code>vipw</code>, che richiede i privilegi di root. Ogni stringa contiene: username; password (che nel file passwd non viene mostrato); UID; GID; generiche informazioni aggiuntive; il path assoluto della home dell'utente; la shell predefinita per quell'utente. Spesso, rispetto allo standard, ci sono delle diciture diverse per mostrare la shell standard, come <code>/sbin/nologin</code>, che indica che un utente non può fare il login da terminale. Questi utenti sono stati creati per eseguire determinati processi. Il file <code>/etc/shadow</code> mostra, per ogni utente: username; hashing algorithm; salt, hash (salt+password); ultima modiifca; altre informazioni. Il salt è fondamentale per evitare l'attacco rainbow. Per attaccare una password, si procede prendendo dei dizionari di password standard hashate secondo un certo algoritmo: se l'utente ha usato una password standard, sarà facile ritrovare il suo hash nel dizionario. 
</p>

<p>
<code class="red">addgroup gruppo</code> e <code class="red">delgroup gruppo</code> permettono rispettivamente di creare e rimuovere gruppi; entrambi i comandi richiedono i privilegi di root. Il comando <code class="red">gpasswd</code> può fare varie operazioni a seconda del comando; se voglio aggiungere un utente al gruppo, <code class="red">gpasswd -a utente gruppo</code>; per rimuovere un utente da un gruppo, <code class="red">gpasswd -d utente gruppo</code>; per definire i membri di un gruppo, <code class="red">gpasswd -M utente1, utente2, ... gruppo</code>; per definire gli amministratori del gruppo, <code class="red">gpasswd -A utente1, utente2, ... gruppo</code>. Solo gli amministratori del gruppo possono effettuare le prime operazioni. Solo il root può modificare gli amministratori. Con <code class="red">gpasswd gruppo</code>, si puà impostare/cambiare la password del gruppo; con l'opzione <code class="red">-r</code> si può rimuovere la password del gruppo. Se non esiste una password, solo i membri del gruppo possono usufruire dei privilegi del gruppo (per esempio, il fatto di avere dei permessi per un file). Se c'è una password, altri utenti possono acquisire temporaneamente i privilegi del gruppo mediante il comando <code class="red">newgrp nomegruppo</code>. In questo modo, associa questo gruppo come il suo gruppo primario. Il 'temporaneamente' dura fino al logout dal sistema. Le informazioni sui gruppi stanno in <code>/etc/group</code>, mentre quelle sensibili in <code>/etc/shadow</code>. Nel primo file, per ogni gruppo c'è anche la lista degli utenti che vi appartengono. In <code>gshadow</code> sono comprese anche la password cifrata e gli amministratori. 
</p>

<hr>
<h2>Lezione 4: sistemi per la gestione dei file</h2>

<p>
Il comando <code class="red">find</code> ha una sintassi piuttosto complessa, con la quale si può cercare un file sulla base delle sue proprietà. I requisiti non sono quindi sul contenuto, ma sulle sue proprietà. Una volta reperito questo sottoinsieme dei file, è possibile eseguirvi sopra delle operazioni. Vediamo alcune sintassi: <code>find [path1 path2...] [espressione]</code>. Invece di effettuare la ricerca in tutto il sistema, la limitiamo ad una o più percorsi. L'espressione definisce gli elementi con i quali proseguire la ricerca, o eventualmente eseguirvi le operazioni. Un'espressione ha diversi elementi: <code>Test</code> è la valutazione delle proprietà di un file, e può dare come risultato True o False; <code>Azioni</code> indica quali azioni vi si vogliono eseguire sopra, che possono essere collegate anche con operatori logici di tipo OR, <code>-o</code> AND, <code>-a</code> o NOT, <code>!</code>; ci sono le <code>opzioni globali</code> che vanno ad influenzare le azioni o i test; le <code>opzioni posizionali</code> influenzano solo l'esecuzione dei test o azioni che vanno a seguire. 
</p>

<p>
Le keyword per la ricerca che si possono usare solo, per esempio, <code>-name pattern</code>, che verifica che il nome sia conforme ad un pattern che, per esempio, sfrutta i metacaratteri <code>?</code> e <code>*</code>. Per scrivere i pattern, si devono inserire negli apici altrimenti, quando la shell fa il parsing, potrebbe espandere un particolare carattere, non arrivando a quanto ci si aspetta. 
</p>

<p>
Un altro test è quello sul tipo di file, attraverso la keyword <code>-type [dfl]</code>. Si possono usare d, per indicare una directory, una f per indicare un file, una l per indicare un collegamento, tipico dei sistemi Windows. Con <code>-size [+-]n[ckMG]</code> possiamo specificare la dimensione del file che deve essere maggiore/minore di n byte, kilobyte, megabyte o Gigabyte. con <code>-user</code> e <code>-group</code> specifichiamo il proprietario o gruppo proprietario del file; si possono usare sia i nomi che gli ID/GID. Un'alternativa è usare i permessi con <code>-perm [-/]mode</code>, sia in modalità ottale che simbolica. Se non usiamo simboli, i permessi devono essere esattamente quelli specificati; se usiamo il simbolo <code>-</code>, accettiamo i file con permessi anche maggiori; se usiamo il simbolo <code>/</code> almeno uno dei permessi indicati deve essere presente. 
</p>

<p>
Sempre <code>find</code> possiamo eseguire delle azioni sui file. Un esempio è la cancellazione dei file, con <code>-delete</code>. L'idea è quella di eliminare tutti i file che sono scelti dai test che li precedono. Per specificare direttamente dei comandi, si può usare <code>-exec comandi ;</code>. Il punto e virgola delimita l'area delle azioni da usare. 
</p>

<p>
<code>find path -name 'prova*' ! -type d</code> : Trova quei file il cui nome inizi con prova e che non siano directory. 
</p>

<p>
<code>find path ! -name '*.csv' -size +50M -execdir ls -l {} \;</code> : Sul risultato della ricerca dei primi due elementi (collegati in and), si applica il comando che segue; nelle cartelle dei file che si sono trovati, si applica il comando <code>ls -l</code>, e con le parentesi graffe si indicano i file che stiamo attualmente processando. La prima ricerca cerca i file che non abbiano tipo <code>.csv</code> e che abbiamo una dimensione maggiore di 50 Megabyte. 
</p>

<p>
Il comando <code class="red">locate</code> non va a cercare nel file system, ma in un database periodicamente aggiornato dal sistema. 
</p>

<p>
Per cercare del testo dentro un file, si usa il comando <code class="red">grep</code> (regular expression print). Il risultato sono le linee che contengono il modello che abbiamo indicato nel comando grep. Se utilizziamo più di un modello, è necessario che ciascuno sia preceduto dal comando da <code>-e</code>.  Ci sono alcuni caratteri utili per costruire delle espressioni regolari. Ad esempio, con <code>^</code> vogliamo che l'espressione si trovi all'inizio della riga; con <td>$</td> vogliamo le righe che terminino in quel modo. Con le parentesi quadre si può indicare un set di caratteri, sia listandoli tutti che definendo un intervallo di caratteri (sia numerici che alfabetici). 
</p>

<p>
L'archiviazione indica la raccolta di più file all'interno di uno solo. Si può usare il comando <code class="red">tar modalità[opzioni] [file1 file2...]</code>. Le opzioni specificano l'operazione da eseguire, comprensivo anche di eventuale compressione dello stesso. Se non è stata effettuata compressione, che non è normalmente prevista, si ha il tipo <code>.tar</code>, altrimenti <code>.tar.gz</code> se si usa la modalità di compressione gzip. Con <code>A</code> si concatenano più archivi; <code>c</code> crea un nuovo archivio; <code>--delete</code> cancella un file dall'archivio; <code>r</code> aggiunge un file all'archivio; <code>t</code> elenca i file dell'archivio; <code>x</code> estrae file dall'archivio. Con <code>z</code> si comprime con gzip, oltre che archiviare; <code>f</code> va inserita sempre, e serve per specificare il nome dell'archivio da estrarre o creare. L'uso di tar senza l'opzione f risulta piuttosto complesso.
</p>

<p>
La compressione può essere fatta anche in modo esplicito, per comprimere file o archivi preesistenti. Si usano i comandi <code>gzip/gunzip</code> e <code>bzip2/bunzip2</code>, a seconda della modalità di compressione
</p>

<hr>
<h2>Lezione 5: i processi e le system call</h2>

<p>
Nella prima lezione abbiamo visto una visione sommaria di come i programmi utenti entrano in contatto con il sistema operativo, ovvero le system call. L'esistenza del sistema operativo fa sì che il programmatore non debba rapportarsi con l'hardware stesso.
</p>

<p>
Unix si basa sui processi, ed è un sistema multi programmato: nel sistema ci sono contemporaneamente più processi che vogliono portare a termine il proprio task; essendoci un solo processore, un solo processo alla volta può essere eseguito, e quindi serve una gestione dei processi. Ogni processo ha uno spazio di indirizzamento dati privato, e si sfrutta una comunicazione tramite scambio di messaggi per potersi scambiare informazioni. E' invece condivisibile lo spazio di indirizzamento relativo al codice: un codice è detto rientrante se una singola copia del codice in memoria può essere letta da più processi, ed è questo il caso. Più processi sono in vita nella stesso momento, e la politica che viene adottata nei sistemi UNIX è a divisione di tempo. All’entrata in esecuzione di un processo parte un timer; se termina prima, lo scheduler assegna la CPU ad un altro processo, ma l'esecuzione viene interrotta anche se il timer scade, e la risorsa CPU viene assegnata ad un altro. Gli stati che vengono attraversati sono quelli di pagina 257 del libro di testo.
</p>

<p>
Nello stato init, il processo è appena stato creato, ed è pronto per essere eseguito. Andrà allora nello stato pronto, affinché possa essere messo in esecuzione; in questo stato, al processo è assegnata la risorsa CPU. Se lo scheduler gli toglie la risorsa, tornerà nello stato pronto, una coda di processi che lo scheduler usa per scegliere a chi assegnare la CPU. Un processo può anche doversi bloccare, in attesa di una risorsa (un'informazione dall'IO, o un segnale da un altro processo...). Abbiamo così una transizione verso lo stato sleep/bloccato, dove vi rimarrà finché non arriva la risorsa richiesta. Lo stato swapped riguarda il momento in cui le risorse dati di un processo passano dalla memoria principale alla memoria secondaria (si veda la gestione della memoria nei sistemi UNIX e il processo <code>pagedaemon</code>). Se un processo termina, potrebbe passare nello stato zombie prima del terminato. Questo accade se l'immagine del processo che sta terminando è ancora necessario per qualche altro processo, presumibilmente il processo padre. Magari il processo figlio ha generato un informazione necessaria al padre, che prima o poi la leggerà; a quel punto, il figlio potrà terminare. 
</p>

<p>
Un processo nel sistema UNIX è descritto da un PCB, suddiviso in due strutture dati distinte: una, la <em>process structure</em>, sempre residente in memoria, contenente le informazioni fondamentali per il processo, anche nel caso in cui sia swapped; la seconda, la <em>user structure</em>, serve solo quando le risorse di un processo sono in memoria primaria. Quando il processo è nello stato swapped, questa struttura viene anch'essa spostata in memoria secondaria. A pagina 259 è possibile vedere alcuni degli elementi presenti nelle due diverse strutture per ciascun processo. Nella US ci sono alcune informazioni che, appunto, servono solo se il processo sta in memoria primaria. Nella process structure c'è un riferimento indiretto al codice, in particolare, un riferimento ad un record della text table, nel quale c'è un riferimento diretto al codice. Quindi, il riferimento che sta nella PS è un riferimento al record di questa table. 
</p>

<p>
Vedremo le system call necessarie per la creazione, terminazione, sospensione di processi, e una per la sostituzione di codice e dati (il processo figlio condivide codice e dati con il padre, ma sarà necessario modificare in qualche modo il codice da eseguire). Tramite <code class="red">fork</code> un processo può generare dinamicamente altri processi, creando una gerarchia ad albero. A livello sintattico, si usa <code class="red">pid_t fork (void)</code>: restituisce un valore che è il process id del figlio appena creato. L'implementazione del <code>process id</code> cambia da sistema a sistema; in linea di massima, si usano dei tipi opachi come il <code>pid_t</code> che ci permette di gestire tutto con una visione dall'alto. La funzione restituisce 0 al figlio, il PID del figlio al padre. Questa struttura permette di differenziare il codice di padre e figlio. Al momento della creazione, il processo figlio condivide il codice con il padre, ed eredita alcune informazioni del padre, come la US, lo stack, lo heap e il program counter: la prima istruzione che dovrà eseguire il processo figlio sarà l'istruzione che è attualmente puntata dal program counter del padre. Se il figlio non è creato, il pid assumerà valore negativo. 
</p>

<code>

    pid_t pid;
    pid = fork();
    prinf(''%d\n'',pid);
</code>


<p>
Per ottenere il process id proprio o del padre, si possono usare le funzioni <code class="red">getpid</code> e <code class="red">getppid</code>. Un altro momento è quello della terminazione, che può avvenire sia in modo involontario (accede in modo non legittimo ad un'area di memoria, riceve un segnale da un altro processo...) che volontario (esegue un'ultima istruzione, chiama la system call <code >exit</code>). Con la system call <code class="red">void exit(int status)</code> il figlio può mandare uno stato di terminazione al padre; essendo l'ultima funzione eseguita, non ha senso il valore di ritorno. Il padre, per rimanere in attesa di informazioni del processo figlio, userà <code class="red">pid_t wait(int* status)</code>, che vuole come parametro l'indirizzo della variabile nel quale vogliamo inserire il valore di ritorno. Se il padre chiama <code>wait</code>, il padre aspetta che uno dei figli termina, andando nello stato bloccato. Se un figlio aveva già chiamato <code>exit</code>, riceve immediatamente un valore senza entrare nello stato bloccato. Questo è il caso in cui un processo figlio entra nello stato zombie. Anche nel caso della wait, ipotizziamo che lo stato sia un intero, ma non è scontato. Se il byte meno significato di status è 0, allora il processo ha terminato volontariamente, e l'informazione sta in quello più significativo; se il byte meno significativo è diverso da 0, allora l'altro byte contiene il motivo della terminazione non volontaria. Per astrarre dai byte, si usano le macro <code>WIFEXITED(status)</code> e <code>WEXITSTATUS(status)</code>. La prima ritorna vero se la terminazione è stata volontaria, la seconda lo stato della terminazione. Si trovano in <code>< sys/wait.h></code>.
</p>

<p>
Le system call <code class="red">exec</code> servono per sostituire il codice di un processo, comprensivo di dati. In questa lezione vedremo soprattutto <code class="red">int execl(char* path, char* arg0,..., char* argN, (char*)0)</code>. Esegue una certa funzione, di cui si conosce il <code>path</code> e il nome in <code>arg0</code>; gli altri sono i paramenti da usare per il programma. La lista termina con il puntatore nullo, per indicare che i parametri sono terminati. Al termine della funzione, il processo viene terminato. Una chiamata ad <code>execl</code> è senza ritorno se ha successo. In questo caso, per eseguire altro, si possono inserire delle porzioni di codice successive: se tutto va a buon fine, non saranno eseguite. Per far eseguire <code>ls -l path</code>, si può scrivere:
</p>
<code>

    execl("/bin/ls", "ls", "-l", argument, NULL);
</code>

<hr>
<h2>Lezione 6: interazione tra processi</h2>

<p>
Ci occuperemo della sincronizzazione e della comunicazione tra processi. I processi mantengono uno spazio di indirizzamento dati privato, senza una vera e propria condivisione di variabili accessibili. L'unico meccanismo per interagire è quindi la cooperazione: imporre vincoli temporali nell'esecuzione (sincronizzazione) e lo scambio di messaggi (comunicazione). Queste due operazioni hanno a che fare con delle syscall offerte dal kernel.
</p>

<p>
Nel momento in cui un processo vuole intervenire sull'esecuzione di un altro processo, può scatenare un evento attraverso un segnale. Parliamo di eventi asincroni: nel momento il cui il segnale è scatenato, indipendentemente da quello che stava facendo l'altro, questo ne subisce le conseguenze nella sua esecuzione. Spesso l'esecuzione dell'altro processo è interrotta e gestita tramite una routine che, se non termina il processo, ne consente la prosecuzione dal punto in cui era rimasta prima dell'arrivo del segnale. Il meccanismo è simile a quello degli interrupt, visto che il processo mittente invia il segnale e continua le sue operazioni, il processo destinatario modifica la sua esecuzione di conseguenza. Si può parlare dei segnali come degli "interrupt software". Ci sono diversi tipi di segnali: parlando di segnali che possono essere gestiti, o il programmatore definisce un handler per la gestione del segnale, o si usa una routine di default predefinita dal sistema operativo, o il segnale viene ignorato. Nei primi due casi l'esecuzione del processo viene interrotta, viene gestito l'handler e l'esecuzione torna al punto in cui si trovava. In Linux sono definiti 32 diversi tipi di segnali, nel file <code>signal.h</code>. 
</p>

<p>
Alcuni segnali sono di tipo standard. Il 9 è <code>SIGKILL</code>, che comporta la terminazione immediata del processo; non può essere ignorato. Un segnale simile che prevede anche l'eventuale gestione da parte dell'utente è il 15, il <code>SIGTERM</code>. Il primo quindi non può essere catturato da una routine personalizzata, il secondo sì. Entrambi comunque terminano il processo destinatario. <code>SIGINT</code> e <code>SIGQUIT</code> interrompono il processo, ma hanno delle routine che prevendono delle elaborazioni prima della terminazione (per esempio, la generazione di un core dump). Alcuni segnali sono lasciati liberi all'utente, come <code>SIGUSR1</code> e <code>SIGUSR2</code>. Di default, entrambi provocano la terminazione del processo. <code>SIGUP</code> si ha quando viene chiuso il terminale, e si può usare per esempio per recuperare una connessione in caso di errore. <code>SIGALARM</code> indica lo scadere di un timer. <code>SIGCHLD</code> viene inviato alla terminazione di un processo figlio (in generale, al suo cambiamento di stato); <code>SIGSTOP</code> ferma temporaneamente il processo; <code>SIGCONT</code> rappresenta la prosecuzione del processo a seguito di interruzione. 
</p>

<p>
La <code>signal</code> è una syscall per associare un handler ad un tipo di segnale. <code class="red">sighandler_t signal(int sig, sighandler_t handler)</code>: prende come parametri l'intero relativo al segnale da gestire e un puntatore a funzione per l'handler. <code class="red">sighandler_t</code> è un puntatore a funzione che rappresenta l'handler con ritorno void e come parametro un intero. Nel codice possiamo definire un'associazione tra un handler e un segnale; un alternativa è passare come secondo parametro un valore tra <code>SIG_IGN</code> e <code>SIG_DFL</code>: nel primo caso si ignora il segnale, nel secondo si ripristina la routine default prevista dal sistema operativo. La funzione <code>signal</code> restituisce il puntatore al precedente handler del segnale. Se sto usando la signal per la prima volta nel codice, restituisce il puntatore nullo; se l'avevo già definito, restituisce il puntatore all'handler precedente; se ci sono stati degli errori, restituisce <code>SIG_ERR</code>. 
</p>

<p>
Abbiamo già visto la primitiva <code>fork</code> per la gestione di un processo figlio; il figlio avrà un'area dati privata, quindi non ci potrà essere comunicazione di questo tipo con il padre (sarà solo una copia di quello del padre). Se il padre aveva gestito i segnali in un certo modo, allora il figlio ne eredita tutte le associazioni. Se dopo fa delle modifiche, queste non coinvolgono il padre. Parlando di <code>execl</code>, abbiamo visto come il codice può essere sostituito con quello di un altro programma. In questo contesto, le associazioni con i segnali non vengono mantenute: infatti viene perso il codice precedente, comprensivo di handler. Vengono ripristinati gli handler predefiniti del sistema operativo. Se avevo usato <code>SIG_IGN</code>, l'associazione viene mantenuta, perché non c'è una porzione di codice-handler da dover portarsi dietro. 
</p>

<p>
Per l'invio dei segnali, il mittente usa la syscall <code class="red">int kill(pid_t pid, int sig)</code>. Se <code>pid > 0</code>, allora il segnale viene inviato al processo con quel pid; se <code>pid == 0</code>, allora il segnale viene inviato a tutti i processo dello stesso process group del chiamante; se <code>pid == -1</code>, il segnale viene inviato a tutti i processi a cui il chiamante può inviare segnali; se <code>pid < -1</code>, il segnale viene inviato ai processi il cui process group è -pid. Ogni processo ha un utente proprietario. Il processo può inviare segnali solo a processi dello stesso utente; un processo che ha come proprietario root può inviare segnali ad ogni processo. L'aspetto dei process group sarà ripreso più avanti. 
</p>

<p>
<code class="red">unsigned int sleep(unsigned int seconds)</code> si usa per mettere un processo nello stato sleep. Esso si risveglia o dopo <code>seconds</code> secondi, o dopo che il processo ha ricevuto un segnale che non può essere ignorato. Se è passato il tempo previsto, la funzione restituisce 0, altrimenti il tempo rimasto allo scadere. 
</p>

<p>
<code class="red">unsigned int alarm(unsigned int seconds)</code> si sua per ricevere un segnale <code>SIGALARM</code> dopo i secondi indicati. Il timer non blocca il processo, e allo scadere del tempo l'alarm può essere definito in modo arbitrario. Se avevo già definito un alarm e lo voglio cancellare, posso dare come parametro <code>0</code>. Ovviamente, si può usare un solo <code>alarm</code> alla volta. 
</p>

<p>
Vediamo ora il meccanismo delle pipe, ossia una comunicazione indiretta. Non esiste un destinatario vero e proprio, ma è un meccanismo molti a moliti. Si tratta di una mailbox di tipo FIFO monodirezionale. E' un tubo con due estremi, da una parte si inviano messaggi, dall'altra si ricevono. Il funzionamento è assimilabile a quello della gestione dei file; da una parte c'è un file descriptor per la scrittura dei messaggi, dall'altra un file descriptor per la lettura dei messaggi. A ciascun estremo è associato un file descriptor. I problemi di sincronizzazione sono gestiti in maniera implicita da read e write: se la coda è piena ma voglio scrivere, la primitiva <code>write</code> mette in attesa il processo finché qualcuno non legge e la coda si libera; lo stesso, in modo speculare, per la <code>read</code> quando la mailbox è vuota. Un processo figlio eredita gli stessi file descriptor del padre: per questo le pipe consentono la comunicazione nella gerarchia di processi. Si possono scambiare messaggi tra tutti i processi che partono dalla radice. Per comunicare fuori dalla gerarchia, si usano i socket.
</p>

<p>
Lo scambio dei segnali si può fare anche da terminale. Per inviare segnali, si usa <code class="red">kill [options] pid [pid2...]</code>. Se non si mettono opzioni, di default si considera il comando <code>SIGTERM</code>, segnale di terminazione che può essere catturato. Per vedere i segnali che posso inviare, si usa <code>kill -l</code>: dopo di ché, la sintassi è <code>kill -SEGNAL pid</code>. Un utente può inviare segnali solo ai processi di cui è proprietario.
</p>

<p>
Con <code>ps</code> è possibile visualizzare i processi in esecuzione in quel momento. Senza opzioni mostra solo quelli dell'utente; altrimenti, si può usare l'opzione <code>a</code>.
</p>

<hr>
<h2>Lezione 7: Altri aspetti dei processi in Linux</h2>

<p>
I sistemi UNIX prevedono un <code>init system</code>, un insieme di processi e programmi che preparano il sistema all'esecuzione. Il processo init ha PID=1, e a partire da questo si va a generare un albero di processi configurando il sistema per l'utilizzo da parte dell'utente. Da <code>init system</code> si chiamano altri processi tramite le <code>fork</code>, dopo di che si usa <code>exec</code> per sostituire il codice. Nella macchina DEBIAN che si usa, il processo in questione prende il nome di <code class="red">systemd</code>. Per visualizzare l'albero dei processi, si può usare il comando <code class="red">pstree</code>. Gli identificativi di un processo sono il PID (identificativo univoco del processo) e PPID (identificativo del processo padre); ad essi aggiungiamo il PGID, di cui parleremo più avanti, e le due coppie RUID/RGID e EUID/EGID. I primi due stanno per real: rappresentano l'utente che ha effettivamente messo in esecuzione il processo. Gli altri due stanno per effective: senza particolari parametri corrispondono a RUID e RGID, ma se il bit SUID o SGID sono attivati (il programma entra in esecuzione come se ad eseguirlo fosse stato il proprietario/gruppo proprietario) allora hanno il valore dell'utente proprietario/gruppo proprietario. Questo meccanismo viene utilizzato per i privilegi di accesso alle risorse. Un processo utente può inviare segnali solo a processi dello stesso utente: usando EUID e EGID, allora il processo può inviare anche segnali ai processi creati dal proprietario del file. In generale, <em>un processo utente può inviare segnali solo ad un processo che ha RUID coincidente con RUID o EUID del mittente</em>. Se un processo mittente ha un EUID diverso da RUID grazie al bit SUID, allora può inviare messaggi anche a processi che hanno il RUID del proprietario. Con i privilegi di root, si può anche modificare il proprio EUID. Tutto questo vale sia per l'UID che per il GID. 
</p>

<p>
Immaginiamo che un utente con UID=Giovanni e GID=biomedici voglia mettere in esecuzione ls, che ha come permessi <code>-rwx--x--x</code>. Una volta messo in esecuzione il processo, abbiamo RUID=EUID=Giovanni e RGID=EGID=biomedici. Nel casso in cui voglia mettere in esecuzione passwd, con permessi <code>-rws--x--x</code>, avremo RUID=Giovanni EUID=root RGID=EGID=biomedici. Questo fa sì che il suo effective user id sia diverso da quello presente, con la possibilità di mandare segnali ad altri processi root. 
</p>

<p>
Ci sono alcune funzioni per ottenere questi id. Sono <code class="red">getpid()</code>, <code class="red">getppid()</code>, <code class="red">getpgrp()</code>, <code class="red">getuid()</code>, <code class="red">getgid()</code>, <code class="red">geteuid()</code>, <code class="red">getegid()</code>. 
</p>

<p>
I processi, quando vanno in esecuzione, hanno assegnato un gruppo. Se un processo viene messo in esecuzione da terminale, vi si assegna un nuovo gruppo; se un processo genera un figlio, questo eredita quello del padre, in modo che l'intero sottoalbero faccia parte dello stesso gruppo. Il gruppo viene preservato anche attraverso la famiglia delle <code>exec</code>. I gruppi danno la possibilità di inviare segnali a processi della stessa gerarchia, e sono alla base del job-control. Job è il nome che la shell da ad un gruppo di processi. 
</p>

<p>
Parliamo adesso della priorità. Lo scheduler di Linux assegna la CPU tenendo conto anche della priorità dei processi. La priorità dei processi normali può essere controllata tramite il concetto della <em>niceness</em>, che sta per gentilezza. Stiamo facendo in modo che il processo dia più o meno tempo agli altri processi. Essa è un valore che sta nell'intervallo [-20,19], con valori che in genere sono 0 o maggiori di 0 (i processi root in genere sono gli unici con valori negativi). Più è alto il valore di niceness, più da spazio agli altri processi nell'utilizzo della CPU. Un processo entra in esecuzione con un valore di niceness pari a 0: un utente normale può solo aumentare tale valore, solo un utente root può diminuirlo. 
</p>

<p>
Vediamo com'è possibile gestire in parallelo più processi, attraverso il job control. Nel momento in cui un processo entra in esecuzione, esso viene associato ad un gruppo di processi, aventi un job id. Tutti i processi che sono entrati in esecuzione con quella shell sono inseriti in una tabella, che si può visualizzare con il comando <code>jobs</code>. Se la shell viene interrotta, a tutti i job viene inviato il segnale <code>SIGUP</code>. Anche quando si collega l'output di un programma con l'input di un successivo, si considera un solo job (<code>cat file | grep 'text'</code>). Un job può essere in esecuzione in foreground (avrà il controllo del terminale, di standard input, standard output e standard error, e avremo il controllo della shell solo quando il programma termina) o in background. Utilizzando la & al termine del comando, il processo viene avviato in background. In questo caso, non avrà più accesso a stdin e stdout, e l'utente avrà di nuovo il controllo del programma. Un processo attivo in foreground può essere interrotto con <code>SIGSTP</code>. Si può poi riattivare la sua esecuzione o in background o in foreground: con <code>jobs</code> ottengo l'identificativo del job, e scelgo come attivare il job con uno dei due comandi <code>bg</code> o <code>fg</code>. Con <code>kill</code> si può anche inviare un segnale ai processi facenti parte di un job: si usa <code>kill %JOB_ID</code> oppure <code>kill -n SIG %JOB_ID</code>. 
</p>

<p>
Quando si manda un processo in esecuzione dalla shell, se il terminale si chiude il processo richiede <code>SIGUP</code> e in genere termina. E' possibile fare in modo che <code>SIGUP</code> non interrompa i processi mandati in esecuzione con due comandi: <code>nohup</code> entra in gioco prima dell'esecuzione del comando, e lo rende immune al SIGUP. Usando questo meccanismo, il job non ha accesso allo stdin (in linea di massimo si suppone che un programma del genere non abbia bisogno di leggere) e allo stdout. Quanto sarebbe stato qui viene appeso al termine di <code>nohup.out</code>. Per rendere immune il comando alla terminazione sella shell si può usare <code>disown %JOB_ID</code>. Con questo comando si rimuove il job dalla tabella dei job, in modo che il segnale di <code>SIGUP</code> non venga ricevuto. In questo caso, è reindirizzare l'output su un altro file. 
</p>

<p>
Per modificare la niceness di un processo, esistono due comandi. Con <code>nice -n valore_nice comando</code> si può eseguire un comando con un valore di niceness prestabilito; se il processo è già in esecuzione, si può aumentare il valore di niceness con <code>renice valore_nice PID</code>. 
</p>

<p>
Con il comando <code>top</code> si può visualizzare un informativa live e interattiva dei processi attivi. Con una serie di comandi si può modificare il delay di aggiornamento, si possono inviare segnali, si può modificare il numero di processi da visualizzare o modificare il valore di niceness. 
</p>

<hr>
<h2>Lezione 8: Thread POSIX nel sistema Linux</h2>

<p>
I thread sono nativamente presenti in Linux, ma per gestirli è bene usare le funzioni della libreria pthread, in modo che il codice che si scrive sia portabile. Il thread è un flusso di esecuzione indipendente all'interno di un processo. I thread possono condividere le risorse e lo spazio di indirizzamento con altri thread dello stesso processo. Sono detti processi leggeri: la loro gestione è meno onerosa di quello di processo, compreso il content switch. La possibilità di condividere risorse è un vantaggio importante, diminuendo l'overhead. Allo stesso tempo, dobbiamo far sì che il comportamento dei thread sia corretto, con un accesso concorrente alle risorse tramite la mutua esclusione; le routine devono essere rientranti; non si usano variabili globali che vuol dire perdita di informazioni... La semplicità quindi porta una difficoltà maggiore nella programmazione. 
</p>

<p>
Linux supporta il thread dal kernel stesso; anzi, ad andare in esecuzione è il thread, non il processo. Eseguire una <code>fork</code> significa creare un thread che non condivide risorse con altri thread. E' quello che va in esecuzione, essendo l'unità di scheduling di base. Se noi utilizziamo le funzioni native di Linux per i thread, scriviamo qualcosa Linux-specific: non si può eseguire lo stesso programma su altri sistemi, che magari non hanno il thread previsto a livello di kernel. Per questo ci viene incontro la libreria pthread, definita nello standard POSIX. 
</p>

<p>
Per usare pthread, va inclusa <code>phtread.h</code>, e nel compilatore gcc si deve aggiungere l'opzione <code>-lpthread</code>; nel caso di Debian, bisogna anche aggiungere <code>-std=c99</code>, per dire che si sta usando un altro standard rispetto a quello usato da gcc. I thread vengono identificati attraverso un tipo <code class="red">pthread_t</code>, di tipo opaco. Si parla di tipo opaco perché non siamo interessati alla sua implementazione, visto che lo usiamo solo tramite le sue funzioni. Non ha senso stamparlo a video, perché non sappiamo com'è implementato. Per conoscere l'id del thread corrente, usiamo <code class="red">pthread_t pthread_self(void)</code>. Con <code class="red">pthread_equals(tid1,tid2)</code>, si possono confrontare due identificatori di thread. Essendo i thread previsti nativi in Linux, ci sono anche delle funzioni per la loro gestione, come <code>gettid()</code>. 
</p>

<p>
Per creare un thread, possiamo usare la funzione <code class="red">int pthread_create()</code>, figli del thread che esegue <code>main</code>. La struttura è affine alla gerarchia di processi di cui abbiamo già parlato. Gli argomenti che si passano sono:
<ul>
<li>un puntatore alla variabile che conserva l'identificatore del thread che stiamo creando; 
<li> un puntatore ad una struttura dati che contiene gli attributi che servono per inizializzare il thread (noi passeremo NULL, ma questo per esempio è il campo in cui si può inserire la priorità del thread); 
<li> il puntatore alla funzione in cui troviamo il codice che andrà in esecuzione;
<li> un puntatore agli argomenti che vogliamo passare alla routine;
<li> il valore di ritorno è 0 in assenza di errore, diverso da 0 altrimenti. 
</ul>
</p>

<p>
Un thread può terminare la sua esecuzione con <code class="red">pthread_exit(void* retval)</code>. Altri casi sono quelli del lancio di <code>exit</code> o alla fine delle istruzioni della funzione. Come valore alla funzione viene passato il puntatore alla variabile che contiene le informazioni di terminazione. Al momento della <code>pthread_exit</code>, il sistema libera le risorse allocate durante l'esecuzione. Se supponiamo che il padre termina prima dei figli, se ha usato <code>pthread_exit</code>, allora i figli continuano la loro esecuzione, altrimenti i figli terminano insieme al padre. 
</p>

<p>
Può avvenire che un thread si blocchi in attesa della terminazione di un altro thread. Si fa con <code class="red">int pthread_join(pthread_t thread, void** retval)</code>. Essendo macchinoso il meccanismo del valore di ritorno, conviene passare NULL sia alla join sia alla exit. In particolare, noi siamo interessati soprattutto al fatto che la terminazione del thread che si aspetta è avvenuta con successo o meno, cosa che viene mostrata dal valore di ritorno della join. La funzione <code class="red">pthread_join</code> ritorna 0 in caso di successo, un valore diverso che indica il codice di errore se c'è stato un errore. Un esempio di errore di terminazione è il caso in cui i thread si mettono reciprocamente in join (si crea un deadlock). 
</p>


<code>

    #include < pthread.h>
    #include < stdio.h>
    #include < stdlib.h>

    void* tr_code(void* arg){
        printf("Hello, my arg is %d\n", *(int*)arg);
        free(arg);
        pthread_exit(NULL);
    }

    int main(){
        pthread_t tr1, t2;
        int* arg1 = (int*)malloc(sizeof(int));
        int* arg2 = (int*)malloc(sizeof(int));
        *arg1 = 1;
        *arg2 = 2;
        int ret;
        ret = pthread_create(&tr1, NULL, tr_code, arg1);
        if(ret){
            //ERRORE
            exit(-1);
        }
        ret = pthread_create(&tr2, NULL, tr_code, arg2);
        if(ret){
            //ERRORE
            exit(-1);
        }
        // non si interrompono gli altri due
        pthread_exit(NULL);
    }
</code>

<p>
I thread possono condividere delle risorse, ed intervenirvi sopra. Perché questo avvenga in maniera corretta e consistente è importante che l'accesso avvenga in mutua esclusione. L'astrazione offerta è quella del mutex, analogo al semaforo binario: possiamo usare la variabile di tipo mutex al posto giusto per far sì che l'accesso ad una risorsa condivisa avvenga in modo corretta. La variabile mutex è di tipo <code class="red">pthread_mutex_t</code>, che contiene sia lo stato del mutex (libero o occupato), sia la coda in cui verranno sospesi i thread che vogliono accedere ad una risorsa.
</p>

<p>
Per definire una variabile mutex, si usa il tipo <code>pthread_mutex_t</code>; si usa <code class="red">int pthread_mutex_init(&M,NULL)</code> per inizializzarlo, a cui si passa il mutex e una struttura dati con cui inizializzare il mutex in un certo modo. Possiamo anche passare NULL, nel caso in cui la variabile sia inizializzata con gli attributi di default, nello stato libero. L'astrazione mutex è analoga a quella del semaforo binario: <code>int pthread_mutex_lock(pthread_mutex_t* M)</code> e <code>int pthread_mutex_unlock(pthread_mutex_t* M)</code>; le funzioni torneranno 0 nel caso di successo, un valore diverso da 0 nel caso di errore.
</p>

<p>
Per usare un mutex, definiamo e inizializziamo la variabile; dopo di che usiamo le funzioni di lock e unlock per accedere e rilasciare una risorsa condivisa. Alla prima chiamata di lock, se il mutex è libero, diventa occupato e gli altri si fermeranno in coda. Servirà un unlock affiche un altro thread prosegua l'esecuzione, occupando la sezione critica. Si parla di <em>sezione critica</em>. Nel momento in cui un thread lascia la risorsa e non ce ne sono altri in coda, il mutex diventa libero.  
</p>

<hr>
<h2>Lezione 9: ancora sui thread in Linux</h2>

<p>
Riprendendo il discorso su <code>pthread</code>, ci siamo occupati della creazione, distruzione e sincronizzazione tra thread, con riferimento allo strumento mutex offerto dalla libreria. Un altro elemento presente nella libreria pthread è quello delle variabili condizione (<code>condition variables</code>). In particolare, servono per la sincronizzazione diretta, politiche di gestione di risorse comuni. Un thread si può bloccare in attesa che si verifichi una certa condizione per quella variabile, ma consentono anche di realizzare politiche di comunicazioni più avanzate. Le variabili condizioni sono di tipo <code class="red">pthread_cond_t</code>, rappresentando una coda nella quale più thread si fermano in attesa che una certa condizione si verifichi, oltre la quale l'esecuzione può riprendere in modo sicuro. E' prevista una primitiva per inizializzare la variabile condizione, <code class="red">int pthread_cond_init(pthread_cond_t* C, NULL)</code>. Il secondo parametro contiene gli attributi per inizializzare la variabile condizione, che noi considereremo NULL.
</p>

<p>
Un thread può verificare una condizione logica su quella condition variable. Nel caso la condizione non sia verificata, allora si pone in attesa nella coda. Il risveglio avviene o attraverso una <code>signal</code> (un altro thread sveglia esplicitamente un altro thread in coda associata ad una variabile condizione) o una <code>broadcast</code>. Quest'ultima notifica il risveglio di tutti i thread, lasciando il compito al programmatore di verificare che l'accesso alla sezione critica avvenga in maniera sicura. 
</p>

<p>
La prima operazione che si può fare su una condition variabile è la <code>wait</code>. Un esempio è quello del produttore-consumatore. Il produttore inserisce un elemento in un buffer condiviso, un consumatore ne prende informazioni. Se un thread produttore verifica che il buffer è pieno, non può inserire altre informazioni; se un consumatore ha già prelevato il dato presente nel buffer, allora deve aspettare che ce ne sia una nuova. Lo schema generale potrebbe essere

</p>
<code>

    while (condizione logica)
        wait(condition_variable);
</code>
<p>

Il thread produttore verifica se il buffer è pieno; in caso negativo, va avanti, altrimenti si blocca sulla condition 'pieno', in attesa che il thread consumatore lo risvegli. Serve un while perché la <code>signal</code> non comporta anche la schedulazione immediata del thread: altri thread potrebbero aver occupato la risorsa, quindi è necessario verificare nuovamente se è disponibile o meno nel momento del riavvio. Per questo motivo, il wait deve essere all'interno di un ciclo while. La condizione logica presente nel while è basata su una risorsa condivisa, che può essere modificata da più thread. La verifica deve quindi avvenire in mutua esclusione. Prima di arrivare a fare il controllo nel ciclo while, va fatto un lock secondo un particolare schema con il mutex. Il wait da la possibilità di associare una variabile mutex associata alla variabile condizione. In questo modo, la gestione è fatta dalla wait senza dover gestire lock e unlock. Quindi l'eventuale sospensione del thread potrebbe dipendere anche dal lock del mutex. La sintassi del wait è <code class="red">int pthread_cond_wait (phtread_cond_t* C, pthread_mutex_t* M)</code>. Il thread viene sospeso nella coda associata a C, gestendo in automatico il lock e unlock di M.
</p>

<p>
La primitiva signal ha come sintassi <code class="red">int pthread_cond_signal(phtread_cond_t* C)</code>. Se c'è un thread in attesa della condition variabile, almeno un thread viene risvegliato. Si dice 'almeno uno', perché dipende dalla singola implementazione del kernel su cui ci si basa. Nel Debian 8.0 che si usa, c'è solo un thread che si sveglia; ovviamente, se sono un thread è sospeso sulla coda. La signal è di tipo signal&continue: quello che ha chiamato la primitiva non perde l'esecuzione, e mantiene anche il lock sulla risorsa condivisa, fino al suo esplicito rilascio. E' quindi necessario che il thread che si è risvegliato verifichi nuovamente la possibilità di usare la risorsa. 
</p>

<p>
Vediamo un esempio sul produttore/consumatore. Nell'esempio generale, ci sarà un numero variabile di produttori e consumatori. I thread devono accedere ad una risorsa condivisa, un ring buffer nel quale i consumatori leggono informazioni, quelli produttori inseriscono valori. I vincoli sono quelli per cui un produttore non può inserire in un buffer pieno, un consumatore non può prelevare da un buffer vuoto. Da lato consumatore avremo una variabile condizione 'vuoto', da quello produttore 'pieno'.
</p>
<code>

    typedef struct{

        int buffer[BUFFER_SIZE];
        int readInd, writeInd;
        int cont;

        phtread_mutex_t M; //gestisce l'accesso in mututa escl.

        pthread_cond_t FULL;
        phtread_cond_t EMPTY;

    } risorsa;

    risorsa r;

    int main(){
    
        pthread_mutex_init(&r.M,NULL);
        phtread_cond_init(&r.FULL,NULL);
        phtread_cond_init(&r.EMPTY,NULL);

    }

    //consumatore
        int val;
        phtread_mutex_lock(&r.M);
        while(r.cont==0)                       //caso in cui il buffer è vuoto 
            pthread_cond_wait(&r.EMPTY, &r.M); //gestisce auotm. lock e unlock
        
        //preleva il dato e aggiorna lo stato del ring buffer

        val = r.buffer[r.readInd];
        r.cont--;
        r.readInd = (r.readInd+1) % BUFFER_SIZE;

        phtread_cond_signal(&r.FULL);
        phtread_mutex_unlock(&r.M);

    //produttore
        int val;
        phtread_mutex_lock(&r.M);
        while(r.cont==BUFFER_SIZE)                       //caso in cui il buffer è vuoto 
            pthread_cond_wait(&r.FULL, &r.M); //gestisce auotm. lock e unlock
        
        r.buffer[r.writeInd] = val;
        r.writeInd = (r.writeInd+1) % BUFFER_SIZE;
        r.cont++;

        phtread_cond_signal(&r.EMPTY);
        phtread_mutex_unlock(&r.M);

</code>

<p>
Il produttore si occupa di cose diverse, ma il codice è pressoché speculare. Per esempio, il produttore cerca di fare la lock sul mutex. Se è libero, può andare avanti e verificare se il buffer ha posti liberi. Farà il controllo all'interno di quel ciclo while: se il buffer è pieno, il produttore si deve bloccare sulla variabile condizione <code>r.FULL</code>. Nel momento in cui si sospenda, si fa un unlock implicito; quando si risveglia, si fa un lock implicito sul mutex. Dopo di che, si gestisce in modo naturale l'indice. L'unlock deve essere implicito, altrimenti il thread si sospende tenendo il lock.
</p>

<p>
Si possono usare le variabili condizione anche per realizzare politiche più avanzate. Supponiamo che una risorsa possa essere realizzata da un numero massimo di thread alla volta <code>MAX_T</code>, con <code>NTHREADS > MAX_T</code>. Questo può essere fatto tramite una condition variabile con la condizione <code>numero di thread che usano la risorsa > MAX_T</code>. 
</p>
<code>

    #define MAX_T 10

    int n_users = 0;        //numero di thread che stanno usando la risorsa
    pthread_cond_t FULL;    //condition var per il limite di utilizzo
    pthread_mutex_t M;      //mutex per l'accesso esclusivo a n_users

    ...

    phtread_mutex_lock(&M);
    while(n_users==MAX_T)
        pthread_cond_wait(&FULL, &M);
    n_users++;
    phtread_mutex_unlock(&M);
    
    // uso della risorsa

    phtread_mutex_lock(&M);
    n_users--;
    phtread_cond_signal(&FULL);
    phtread_mutex_unlock(&M);
    ...


</code>


<hr>
<h2>Lezione 10: accesso ai file e comunicazione tra processi mediante pipe</h2>

<p>
Una volta visto come usare i file nel sistema UNIX, useremo tali concetti per implementare le pipe, una nozione omonima a quelle dell'accesso ai file. L'accesso ai file sfrutta un meccanismo di tipo sequenziale: ci sarà un puntatore (IO pointer) che punta ad un punto del file, e le operazioni di lettura e scrittura lo faranno avanzare. Otterremo quindi un flusso di informazioni di tipo sequenziale. Una volta aperto un file, verrà creato un elemento nella tabella dei file aperti dal processo, tabella presente nella user structure del processo. Ogni elemento della tabella è un file descriptor, un puntatore ad una struttura dati che contiene i file aperti del sistemi. Questa ulteriore tabella è propria dello spazio del kernel, e contiene tanti elementi quanti sono i file aperti da ogni processi. Se due processi aprono lo stesso file, nella struttura dati globali ci saranno due elementi diversi, uno per ciascun file (magari perché le posizioni in cui si fa rw sono diversi). I due processi faranno riferimento a due elementi diversi. Questi puntatori nella tabella mantengono le informazioni al punto del file in cui operare, sia un riferimento alla tabella dei file attivi, detto <code>i-node</code>. Ogni i-node è un riferimento alla posizione sul disco del file (indirizzo fisico). Infatti se due processi aprono lo stesso file, avranno due user structure diversi, due tabelle dei file aperti differenti, che puntano a due elementi della tabella dei file aperti di sistema diversi, ma i due elementi avranno due IO pointer diversi per lo stesso i-node. La combinazione di i-node e IO pointer mi dice in che punto del disco devo leggere o scrivere. 
</p>

<p>
Al momento dell'invocazione del main, ci sono già tre riferimenti nella tabella dei file aperti di sistema: quelli di <code>stdin</code>, <code>stdout</code> e <code>stderr</code>. Se reindirizziamo l'<code>stdout</code> ad un file di testo, forziamo il file descriptor contenuto nella tabella dei file aperti di processo al momento dell'invocazione del main.
</p>

<p>
Parlando di fork, abbiamo visto che la user structure del figlio è una copia di quella del padre. Questo significa che la tabella dei file aperti di processo sarà la stessa, con gli stessi riferimenti alla tabella dei file aperti di sistema. Avendo lo stesso file descriptor, c'è lo stesso IO pointer, e quindi il figlio può operare sullo stesso file descriptor aperto dal padre. 
</p>

<p>
Per aprire un file, si usa la primitiva <code>int open(const char* path, int flags)</code>. Il primo parametro è il path del percorso, il secondo rappresenta il modo con cui si vuole aprire il file. In genere, per rappresentare queste flags, si usano delle macro, come <code>O_RDONLY</code> o <code>O_WRONLY</code>. Il valore di ritorno è un file descriptor che sarà dato come argomento alle primitive di read e write. Le macro possono essere messe anche in or tra loro, per esempio dicendo che si vuole scrivere dalla fine, e non si vuole sovrascrivere dai primi byte presenti. 
</p>

<p>
La lettura da file si fa con <code>ssize_t read(int fd, void* buf, size_t count)</code>, che vuole come primo parametro il file descriptor di open, il buffer nel quale si vuole inserire il contenuto della lettura e il numero di elementi da leggere. Le informazioni si spostano quindi dal file al buffer. Ritorna il numero di byte letti. Anche in questo caso abbiamo a che fare con tipi opachi, per premiare la portabilità del nostro codice. Se il numero di byte letti non è uguale a count, allora abbiamo raggiunto l'EOF. Se il valore di ritorno è minore di 0, c'è stato un errore nella lettura. 
</p>

<p>
La stessa cosa si ha con la scrittura, con la primitiva <code>ssize_t write(int fd, const void* buf, size_t count)</code>. Una volta scritte queste informazioni, l'IO pointer si sposterà nel byte immediatamente successivo all'ultimo scritto. Anche in questo caso viene restituito il numero di byte scritti, minore di count se si è raggiunti l'EOF. La close è la primitiva contraria alla open: aggiorna le strutture dati nel nostro sistema, togliendo il file descriptor dalla tabella del processo e il riferimento alla tabella dei file aperti globale. L'i-node viene eliminato solo se quello era l'unico riferimento al file. 
</p>

<code>

    #include <fcntl.h>
    #include <stdlib.h>
    #include <stdio.h>
    #define BUF_SIZE 64

    int main(int argc, char** argv){
        if(argc < 2){
            printf("Usage: %s FILENAME\n", argv[0]);
            exit(-1);
        }
        int fd = open(argv[1],O_READONLY);
        if(fd < 0){
            perror("ERRORE NELLA OPEN\n");
            exit(-1);
        }
        char buffer[BUFFER_SIZE];
        ssize_t nread;

        //leggiamo 63 byte, all'ultimo mettiamo \0 in modo che la
        //printf stampi l'intera stringa e si fermi a tale carattere.
        //Ogni volta si sovrascrive il buffer, si stampa e si ripete
        //finché incontriamo elementi nel file.

        while(nread=read(fd,buffer,BUF_SIZE-1) > 0){
            buffer[nread] = '\0';
            printf("%s",buffer); 
        }
        close(fd);
        if(nread<0){
            perror("ERRORE NELLA READ\n");
        }
        exit(0);
    }
</code>

<p>
Quanto detto è alla base del meccanismo delle pipe, fondamentale per la comunicazione indiretta da processo. Si tratta di una mailbox: il processo non manda il messaggio ad un processo, ma si inserisce il messaggio in una mailbox gestita secondo un meccanismo FIFO. Chi legge quindi leggerà il primo messaggio inserito, svuotando volta volta la pipe. Lo possiamo immaginare come un tubo monodirezionale: da una parte si inserisce un messaggio, dall'altra parte si prende il messaggio. Ai due estremi infatti è presente un file descriptor. Si realizza come un vettore di due interi, che sono i due file descriptor per la lettura e per la scrittura. Se un processo va a leggere un messaggio e la pipe è vuota, questo si sospende in attesa di un messaggio; lo stesso nel caso in cui un mittente si trova la pipe piena. Il meccanismo non va gestito dal programmatore, ma funziona grazie alle chiamate read e write. La pipe funziona tra processi che appartengono alla stessa gerarchia, non tra processi esterni alla propria gerarchia. La pipe crea due file descriptor che vengono salvati nella user structure del processo; poiché questo si copia nella gerarchia, tramite la primitiva fork, allora anche i figli potranno accedere ai file descriptor della pipe, che potrà utilizzare. 
</p>

<p>
Per creare una pipe, si usa <code class="red">int pipe(int fd[2])</code>. Nel vettore si hanno due elementi, uno per la lettura, all'indice 0, e uno per la scrittura, all'indice 1. I due file descriptor sono gli estremi della nostra pipe. Da questo momento in poi si può usare read e write con, rispettivamente, <code>fd[0]</code> e <code>fd[1]</code>. La funzione ritorna -1 nel caso in cui qualcosa sia andato storto. Ricordarsi di usare la close anche sui due file aperti per la gestione della pipe!
</p>

