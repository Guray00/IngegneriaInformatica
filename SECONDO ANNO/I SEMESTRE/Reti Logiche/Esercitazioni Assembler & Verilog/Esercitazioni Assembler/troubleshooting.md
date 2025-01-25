# Troubleshooting

## 1. Ho trovato un ambiente assembler per Mac su Github, ma ho problemi ad usarlo

Non abbiamo fatto noi quell'ambiente, non sappiamo come funziona e non offriamo supporto su come usarlo.

## 2. Ho trovato un ambiente basato su DOS, usato precedentemente all'esame, ma ho problemi ad usarlo

Ha probabilmente incontrato uno dei tanti motivi per cui l'ambiente basato su DOS è stato abbandonato.
Questi problemi sono al più _aggirabili_, non _risolvibili_.

## 3. Se premo *Run* su VS Code non viene lanciato il programma

Non è così che si usa l'ambiente di questo corso. 
Si deve usare un terminale, assemblare con `./assemble.ps1 programma.s` e lanciare con `./programma`.

## 4. Provando a lanciare `./assemble.ps1 programma.s` ricevo un errore del tipo `./assemble.ps1: line 1: syntax error near unexpected token`

State usando la shell da terminale sbagliata, `bash` invece che `pwsh`. Aprire un terminale Powershell da VS Code o utilizzare il comando `pwsh`.

## 5. Provando ad assemblare ricevo un warning del tipo `warning: creating DT_TEXTREL in a PIE`. Cosa devo fare?

Sostituire il file `assemble.ps1` con quello contenuto nel pacchetto più recente tra i file del corso.
Oppure modificare manualmente il file, alla riga 29, da
```
gcc -m32 -o ...
```
a
```
gcc -m32 -no-pie -o ...
```

Riprovare quindi a riassemblare. Se il warning non sparisce, scrivermi. Allegando il sorgente.

## 6. Lanciando il file `assemble.code-workspace`, mi appere un messaggio del tipo `Unknown distro: Ubuntu`

Il file `assemble.code-workspace` cerca di lanciare via WSL la distro chiamata `Ubuntu`, senza alcuna specifica di versione.
Nel caso la vostra installazione sia diversa, andrà modificato il file.
Da un terminale Windows, lanciare `wsl --list -v`, dovreste ottenere una stampa del tipo
```
PS C:\Users\raffa> wsl --list -v
  NAME                   STATE           VERSION
* Ubuntu                 Stopped         2
  Ubuntu-22.04           Stopped         2
```
La parte importante è la colonna `NAME` dell'immagine che vogliamo usare per l'ambiente assembler.
Modificare il file `assemble.code-workspace` con un editor di testo (notepad o VS Code stesso, stando attenti ad aprirlo come file di testo e non come workspace) sostituendo tutte le occorrenze di `wsl+ubuntu` con `wsl+NOME-DELLA-DISTRO`.
Per esempio, se volessi utilizzare l'immagine `Ubuntu-22.04`, sostituirei con `wsl+Ubuntu-22.04`.

## 7. Sto utilizzando una sistema Linux desktop, come uso l'ambiente senza virtualizzazione?

Il file `assemble.code-workspace` fa tre cose
- Aprire VS Code nella macchina virtuale WSL
- Aprire la cartella `assembler` in tale ambiente
- Impostare `pwsh` come terminale default

È possibile fare manualmente gli step 2 e 3, o modificare `assemble.code-workspace` per non fare lo step 1.
Per seguire questa seconda opzione, eliminare la riga con `"remoteAuthority":`, 
e modificare il percorso dopo `"uri":` perché sia semplicemente un percorso sul proprio disco, per esempio `"uri": "/home/raff/reti_logiche/assembler"`.

## 8. Sto utilizzando una versione di Powershell diversa, ma non funziona

La versione testata è quella indicata nelle istruzioni.
Altre versioni possono avere cambiamenti o nuovi bug.
La strada più semplice è disintallare la versione attuale e installare la versione indicata nelle istruzioni.

Sono comunque interessato a sapere cosa non va, se avete il tempo di segnalarmelo.

