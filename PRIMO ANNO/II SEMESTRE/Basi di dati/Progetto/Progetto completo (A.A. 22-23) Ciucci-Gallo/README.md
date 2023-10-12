-------------------------------------------------

                  FilmSphere

-------------------------------------------------
Il progetto si articola nella maniera seguente: esistono due file in pdf, ovvero Documentazione.pdf
e ER.pdf, che contengono, rispettivamente, la Documentazione del progetto e i due ER (quello non
ristrutturato e quello ristrutturato) e alcune directory contenenti file utili all'implementazione
o popolamento del database.

Implementazione contiene tutti i file .sql che servono ad implementare il database, in particolare
abbiamo avuto cura di dividerli per aree tematiche ed, infine, di aggiunge un unico file Bundle.sql
contenente l'implementazione dell'intero db assieme alle operazioni e funzionalità (aree Streaming e Analytics) richieste.

Popolamento contiene un file che assolve alla funzione di popolamento, in parte aleatorio, della
base di dati. Alcune tabelle vengono popolate in maniera casuale; dunque, due esecuzioni distinte
del file porteranno a delle basi di dati leggermente differenti.

Analytics contiene le tre funzionalità dell'area Analytics assieme alla sezione riguardante sia
i diversi Rating che la Raccomandazione dei Contenuti.

Streaming, invece, contiene le funzionalità riguardanti l'area Streaming.

Operazioni raccoglie le varie implementazioni delle otto operazioni.

Script contiene alcuni frammenti di codice utilizzate per generare parte dei file .sql di 
popolamento 

Test contiene al suo interno tutti i file adibiti a testare sia le operazioni che le funzionalità


Come Implementare e Popolare il Database?
> Eseguire prima 'Implementazione/Bundle.sql' e poi 'Popolamento/PopolamentoFittizio.sql'
L'esecuzione di PopolamentoFittizio potrebbe impiegare un tempo attorno a poco meno di un minuto per completare. 
Questo è dovuto al fatto che il popolamento in questione comprende circa 50 000 IPRange realmente esistenti.


Come testare le varie Funzionalità e Operazioni?
> Eseguire gli script
    'Test/Operazioni.sql', 'Test/Custom.sql', 
    'Test/Classifica.sql', 'Test/BilanciamentoCarico.sql', 
    'Test/RaccomandazioneContenuti.sql', 'Test/CachingPrevisionale.sql',
    'Test/IndividuazioneServer.sql', 'Test/RibilanciamentoCarico.sql'


- Ciucci Riccardo <r.ciucci3@studenti.unipi.it>
- Gallo Simone <s.gallo24@studenti.unipi.it>
