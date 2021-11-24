La cartella Zip è composta da diversi file Sql:mysmarthome_compact contiene TUTTO il codice scritto, gli altri contengono solo parti dello script che sono utili alla comprensione



AVVERTENZE:
-gli script sono abbastanza pesanti e l'esecuzione può durare fino a 1 min 
-C'è un errore di calcolo nella documentazione per quanto riguarda le ridondanze su impCondiz. Tale errore farebbe sì che le ridondanze non possano essere inserite
-C'è un errore nel capitolo sulla normalizzazione per quanto riguarda come la Vaglini vorrebbe che si scrivesse quella parte. 
 Lei vuole che vengano giustificate anche le ipotetiche dipendenze che non valgono, non solo quelle di chiave: CodFiscale->Nome,Cognome,DataNascita va bene ma bisogna scrivere anche
 che Nome,Cognome->DataNascita non può esistere poichè ci nipote e nonno potrebbero avere stesso nome e cognome (va scritto esplicitamente e formalmente). 
 Ha detto che questo è un errore comune nelle documentazioni e che di solito va a guardare. Quindi trovate tutte le possibili dipendeze e spiegate perchè non contano nella normalizzazione 
 (se invece contano e non sono eliminabili, dovete decomporre in BCNF)
-Il resto è tutto corretto



insta:@nilofabiano
Se l'analytic 1 te l'ha svoltata allora offrimi una Birra in Vetto

Prof Vaglini
Voto 30

Nilo Fabiano 
Giorgio Charles Sorrentini


