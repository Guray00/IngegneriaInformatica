# Troubleshooting - Calcolatori Elettronici
## 1 - Problemi legati al DEV CONTAINER
### 1.1 - ISTRUZIONI SU COME FAR PARTIRE IL COMANDO BOOT DA WINDOWS USANDO IL DEV CONTAINER DI GALATOLO
> #### Descrizione del problema
> Potrebbe capitare che boot non funzioni perché vs code non riesce a far comparire la finestra pop up dove si vedono i risultati.
#### Procedura
- Installa VcXsrv: Scarica e installa da [https://sourceforge.net/projects/vcxsrv/](https://sourceforge.net/projects/vcxsrv/).
- Avvia XLaunch: Esegui e seleziona "Disable access control".
- Apri il terminale nel dev container in VS Code.
- Imposta DISPLAY: Esegui export DISPLAY=host.docker.internal:0 (o prova con l'IP host).
- Esegui boot: Digita boot e premi Invio.
### Su Linux/macOS (se l'errore GTK persiste)
- Apri il terminale nel dev container in VS Code.
- Prova boot: Digita boot e premi Invio.
  - Se fallisce: Prova a installare le librerie GTK (sudo apt-get update && sudo apt-get install libgtk-3-dev libgtk-3-0).
  - Riprova boot: Digita boot e premi Invio.
#### Crediti
Si ringrazia l'autore: **D'Antonio Pia Eugenia**. 

