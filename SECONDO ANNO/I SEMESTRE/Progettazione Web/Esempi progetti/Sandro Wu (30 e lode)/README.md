# Progetto PWeb

Ciao, il progetto è stato valutato 30L con il prof. Vecchio.
Purtroppo nella fretta non avevo fatto tanti test, quindi è probabile che troviate bug 
[infatti ne ho trovati alcuni dopo la consegna, ma non sono venuti fuori durante la discussione ehehe 

## Caratteristiche

- E' un sito sul gioco del Go (se non lo conoscete andate al club di Go di Pisa il lunedì sera all'Orzo Bruno :D )
- E' fortemente incentrato sul JS, il gioco l'ho implementato tutto li, tutte le chiamate a php sono in ajax e il tutto viene gestito sempre lato js
- Il php l'ho usato solo per il sistema di accounting, generare i contenuti dinamici in caso di login, e le varie interazioni col database da chiamare via ajax
- Il gioco ha regole facili ma è un pochino difficile da implementare, non siate così pazzi a provare a capire il relativo codice.
- Ci sono degli screen del progetto, così vedete un po' senza stare a installare il tutto.

## Installazione
- Per poter riprodurre il progetto, dovete avere il caro Xampp.
- Dovete mettere la cartella del progetto nel path di xampp, come spiegato nel il corso, altrimenti non funzionano i file php (quindi in pratica tutto)
- Nel file /php/connectDB.php dovete mettere i dati giusti per l'accesso al db locale
- Create il db popolato dal file createDatabaseWu.sql
- A regola il sito funziona anche senza DB, solo che mancarebbero le relative funzionalità
- Fate partire apache, nel browser aprite la cartella del progetto, a regola siete ora nella pagina home del mio progetto.

## Considerazioni
- Ho imparato ad odiare php
- Ci sono passato tanto tempo, forse troppo. Avevo pure altre funzionalità in mente da implementare, menomale li ho lasciati stare
- Se ci sono problemi, non cercatemi lol, va beh scherzo.
- non mi viene altro

04 / 2022 
Sandro Wu
