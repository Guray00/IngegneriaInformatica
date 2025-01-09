Il presente progetto è stato consegnato dal sottoscritto nell'appello straordinario di Aprile 20223. Ho presentato il programma dell'A.A.21-22 e quindi questo progetto.

Seguono alcune considerazione

- Il progetto non tiene minimamente conto degli aspetti della sicurezza (postilla per chi visita questa cartella e non è del nostro corso di laurea, il corso di Reti Informatiche non affronta questi aspetti e rimanda il tutto alla magistrale)

- Pistolesi ha tolto solo uno 0.5 perchè non ho tenuto conto che un utente potrebbe disconnettersi mentre la chat è aperta. Il mio codice prende atto della disconnessione solo se la persona chiude e riapre la chat. Risolvibile introducendo un ACK tra utenti (non ho implementato la cosa nel codice caricato):
> Utente X scrive ad utente Y e lancia la primitiva recv (attende la ricezione di un ACK)
> Utente Y riceve il messaggio e risponde inviando un ACK
> Utente X riceve l'ACK, oppure ci accorgiamo dalla primitiva recv che l'utente si è disconnesso.

- Mi scuso per lo spaghetti coding (La documentazione e i commenti dovrebbero agevolare la lettura del codice).