# Note

Se dovete fare lo stesso progetto di quest'anno, vi consigliamo di non affidarvi  fin dall'inizio sul nostro e rischiare di copiare e basta. Magari guardatelo quando siete già a metà strada. Fatevi prima qualche idea con i progetti degli anni scorsi.  
Noi abbiamo fatto l'esame con Pistolesi.


Gli errori sollevati:

* Tavola degli accessi, nello specifico nell'operazione 1 non era necessario 
accedere a 'Interazione' in quanto non servivano gli attrubiti di tale entità.
* Le relazioni tra Porta e Stanza sono ridondanti, si poteva fare solo un'unica relazione 1,N - 1,N .
* L'attributo 'energiaRimanente' su Batteria era ridondante. 
* Lo schema E-R deve essere tutto collegato, tutto. Non ci possono essere pezzi scollegati, deve essere tutto raggiungibile partendo da qualsiasi punto, attraveso i 'cammini di join'.


Di seguito dei consigli:

* Leggere attentamente e piu' volte le specifiche del progetto in modo da capire ogni singola parte, (il pistolesi è attento e non si fa scappare piccoli dettagli).
* Abbozzare man mano il diagramma E-R di ogni singola parte e infine cercare una relazione tra di essi.
* Non essere vaghi nella documentazione riguardo al diagramma E-R. Ovviamente più siete chiari nella documentazione, più sarà apprezzato.
* Spesso ci si ritrova a fare delle scelte progettuali, l'importante è restare coerenti.
* Le operazioni scegliete quelli con complessità bassa e frequenza alta oppure complessità media-alta e frequenza bassa, non fate cose troppo complicate.
* Per il popolamento del database non serve esagerare, basta il necessario per testare le funzioni.


Voto progetto 29
