L'ordine con cui mi sono trovato bene io a fare il progetto:

1) Leggete la traccia e distinguete le informazioni su cosa sarà parte dell'ER/tabelle, informazioni
   su alcune operazioni che tendono a essere descritte nella traccia (anche se c'è scritto che vanno implementate
   in realtà non è così, si hanno 8 operazioni da fare e si può scegliere di fare quelle; è solo necessario che
   il vostro ER renda possibile implementarle), e infine le informazioni sul nulla, le ciance insomma.

2) Fate l'ER   (cosniglio di pensare ad un ER privo di ridondanze e che renda il modello logico già pronto in BCNF)
3) Ristrutturatelo
4) Glossario (fatelo dopo gli ER)
5) Tavola dei volumelli, ipotizzando alcuni volumi e derivandone altri dalle cardinalità delle relazioni + eventuali ipotesi
6) Sceliete le operazioni: possono essere sia quelle "suggerite" nella traccia che altre a caso scelte da voi. Non fate cose
   iper complesse, la cosa non vi frutterà. Se non avete ancora ridondanze pensate a 2 operazioni ad hoc che vi permettano
   di giustificare l'aggiunta di una ridondanza ciascuno
7) Modello logico, lista dei vincoli di integ. referen., normalizzazione BCNF; se l'ER è fatto ad hoc vi risparmiate un dolore
8) Elencate vincoli generici, qualsiasi cosa vi venga in mente (implementatene una manciata, non tutti)
9) Scrivete il codice; consiglio la divisione in più file: creazione tabelle | popolamento | operazioni | data analytics (ultima cosa da fare)
10)Data analytics: fatele solo alla fine e dedicategli qualche pagina di documentazione sulla relazione. Vi troverete a creare qualche tabella
   aggiuntiva, solitamente sono fatte ad hoc nella traccia per non sconvolgere il vostro ER pur dovendo aggiungere tabelle, quantomeno la prima
   data analytics. Per la seconda non vi posso dire nulla, ho fatto il progetto da solo e ho solo la prima.

Valutazione 29/30 (IGN)

