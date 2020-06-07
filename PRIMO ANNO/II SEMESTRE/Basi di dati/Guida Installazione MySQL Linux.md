# Guida installazione MySQL Server & Workbench

## Valida per le distro Debian-based

La seguente guida è una sintesi derivata dalla documentazione
ufficiale di MySQL, in caso di difficoltà si può consultare la documentazione
sul [sito ufficiale](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/). Il creatore della seguente guida non si
assume nessuna responsabilità sulle conseguenze che un uso della stessa può
causarne proseguendo con la lettura si accetta di proseguire a proprio rischio
in qualsiasi forma e si consiglia sempre di consultare la documentazione ufficiale.

### Aggiunta della repository

Come primo passo bisogna scaricare il file per aggiungere la repository di MySQL al seguente [indirizzo](https://dev.mysql.com/downloads/repo/apt/), cliccare sul riquadro blu [Download] e, nella nuova pagina, cliccare su “No thanks, just start my download” e si ricava un file .deb;

Andare nella cartella dove si trova il file ed aprire il terminale in quella cartella ed eseguire il seguente comando:

```shell
sudo dpkg –i nome_file.deb        
```

Nella schermata che apparirà muoversi con il tasto TAB e confermare la voce [OK] ed, una volta conclusi i processi eseguiti, eseguire il seguente comando di aggiornamenti:

```shell
sudo apt-get update
```

### Installazione MySQL Server

Usare il seguente comando per installare MySQL Server:

```shell
sudo apt-get install mysql-server
```

Per la gestione del server si possono utilizzare i seguente comandi:

```shell
sudo service mysql status //stato server
sudo service mysql start //inizializzazione server
sudo service mysql stop //sospensione server
```

Per sercurizzare il server bisogna utilizzare il seguente comando:

```shell
sudo mysql_secure_installation
```

La prima voce chiederà se si vuole validare la password du tre livelli per far sì che la password root (del server non del sistema Linux) accetti solo password con quella complessità. Si scelga il livello della propria password e re-inserirla. Poi confermare con [y] oppure [Y] le restanti voci che eseguiranno le seguenti azioni:

- Rimozione accesso utente anonimo;

- Rimozione dell'accesso root in remoto;

- Rimozione database di test ed accesso ad esso;

- Rimozione ricarica tabelle privilegi.

### Installare MySQL Workbench

Verifichiamo se ci sono aggiornamenti:

```shell
sudo apt-get update
```

Installiamo MySQL Workbench:

```shell
sudo apt-get install mysql-workbench-community
```

Aggiungiamo le librerie

```shell
sudo apt-get install libmysqlclient18
```

### Disintallare MySQL

Prima rimuoviamo il client:

```shell
sudo apt-get remove mysql-server
```

Rimuoviamo i file residui:

```shell
sudo apt-get autoremove
```

Rimuoviamo Workbench ed un ultimo autoremove:

```shell
sudo apt-get remove mysql-workbench-community
```

```shell
sudo apt-get autoremove
```
