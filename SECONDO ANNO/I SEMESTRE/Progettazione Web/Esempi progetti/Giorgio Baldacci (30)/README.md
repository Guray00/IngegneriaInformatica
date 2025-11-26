# Piattaforma Web per la Gestione di Ripetizioni
Questo progetto è un'applicazione web sviluppata per il corso di Progettazione Web. Il sistema permette di gestire l'incontro tra domanda e offerta per lezioni private, facilitando la prenotazione e la gestione dei pagamenti tra Studenti e Tutor.

## Descrizione
Il sito offre due tipologie di utenti, Studente e Tutor, accessibili tramite login unificato. L'applicazione è progettata come una Single Page Application (SPA) semplificata: la navigazione interna avviene dinamicamente tramite JavaScript senza ricaricare le pagine, interagendo con il server tramite API.

### Funzionalità per lo Studente
- **Prenotazione Lezioni**: Visualizzazione degli slot temporali resi disponibili dai tutor. E' possibile filtrare la lista per modalità (Online/Presenza) o ricercare un tutor specifico per nome.
- **Dettagli Tutor**: Consultazione delle informazioni del tutor (descrizione, materie insegnate, tariffe) prima di confermare una prenotazione.
- **Gestione Prenotazioni**: Visualizzazione delle lezioni future nella sezione "*Le mie prenotazioni*"". Lo studente può cancellare una lezione prenotata purché manchino più di 24 ore all'orario previsto.
- **Storico e Pagamenti**: Accesso allo storico delle lezioni passate. La sezione "Pagamenti" riepiloga gli importi dovuti a ciascun tutor per le lezioni già svolte ma non ancora saldate.

### Funzionalità per il Tutor
- **Gestione Slot**: Inserimento di nuove disponibilità specificando data, ora e modalità (Online, Presenza o Entrambe). Gli slot possono essere cancellati se non ancora prenotati.
- **Agenda**: Visualizzazione delle prossime lezioni confermate.
- **Gestione Pagamenti**: Pannello per monitorare i crediti. Il tutor può segnare come "pagata" una singola lezione o saldare in un'unica operazione tutte le lezioni in sospeso di uno specifico studente.
- **Configurazione Profilo**: Modifica delle informazioni personali, inclusa la descrizione, le tariffe orarie differenziate per modalità e la selezione delle materie insegnate.

## Architettura del Progetto
Il progetto separa la logica client (Frontend) dalla logica server (Backend).

### Frontend
- **Tecnologie**: HTML5, CSS3, JavaScript.
- **Logica**: I file JavaScript (`student.js`, `tutor.js`) gestiscono l'interfaccia utente, effettuando chiamate asincrone (Fetch API) agli endpoint PHP per ottenere dati in formato JSON e aggiornare il DOM.
- **Stile**: CSS personalizzato senza l'uso di framework esterni.

### Backend
- **Tecnologie**: PHP, MySQL.
- **API**: La cartella `api/` contiene script PHP che lavorano col database. Ricevono input JSON e restituiscono risposte JSON.
- **Sicurezza**: Gestione delle sessioni, controllo dei ruoli in ogni script API e utilizzo di Prepared Statements per le query al database.
- **Database**: Struttura relazionale con tabelle per utenti (student/tutor), materie, slot e prenotazioni.

## Struttura del Progetto
```
/
├── api/                # Endpoint PHP per la logica di backend (login, prenotazioni, slot, ecc.)
├── css/                # Fogli di stile (style.css)
├── html/               # Pagine delle dashboard e form di registrazione
├── js/                 # Logica Frontend (auth.js, common.js, student.js, tutor.js)
├── screenshots/        # Immagini per la documentazione
├── sql/                # Script SQL per la creazione e popolazione del database
├── index.html          # Pagina di Login principale
└── README.md           # Questo file
```

## Installazione e Configurazione
- **Requisiti**: Server Web (es. Apache), PHP, MySQL.
- **Database**: Importare il file `sql/baldacci_673006.sql` per creare il database, le tabelle e popolare i dati iniziali.
- **Configurazione**: Aprire il file `api/config.php` e configurare le credenziali di accesso al database locale (sono già quelle predefinite, quindi dovrebbe funzionare senza questo passaggio).
- **Avvio**: Posizionare la cartella del progetto nella root del server web e aprire il browser all'indirizzo `localhost` (o `127.0.0.1`).

## Autore
Progetto realizzato da Giorgio Baldacci.
