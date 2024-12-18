# Guida all'installazione dell'Ambiente di Sviluppo

## Introduzione

Questa guida fornisce istruzioni dettagliate sull'installazione dell'ambiente di sviluppo per il corso di Reti Logiche su un sistema operativo Windows.

## Prerequisiti

Prima di iniziare occorre:

- assicurarsi di avere il sistema operativo aggiornato o comunque di non avere aggiornamenti in sospeso che partiranno al riavvio
- aver scaricato la cartella [ambiente lab studenti](http://docenti.ing.unipi.it/~a080368/Teaching/RetiLogiche/pdf/Ambienti/ambiente%20lab%20studenti.zip)
- opzionale: aver già installato una versione di [VSCode](https://code.visualstudio.com/download)

## Installazione e Settaggio

1. **Virtualizzazione Abilitata**

   - controllare che la virtualizzazione sia attiva in Gestione Attività > Prestazioni > Virtualizzazione: Abilitato
   - nel caso sia disabilitato occorre attivarlo dal bios, ecco un [link](https://www.aranzulla.it/come-attivare-la-virtualizzazione-nel-bios-1231556.html) che può essere utile

2. **Installazione WSL**

   - aprire powershell come amministratore ed eseguire

   ```powershell
   wsl --install
   ```

   - riavviare il computer

3. **Installazione Ubuntu**
   - se al riavvio non parte autamaticamente l'installazione di Ubuntu, aprire powershell come amministratore ed eseguire
   ```powershell
   wsl --install -d ubuntu
   ```
   - alla fine dell'installazione configurare l'account:
     - utente: studenti
     - password: studenti
4. **Controllo Versione WSL**
   - occorre avere la versione 2 di wsl
   ```powershell
    wsl --list -v
   ```
   - se fosse installata la versione 1 occorre eseguire
   ```powershell
   wsl --set-version ubuntu 2
   wsl --list -v
   ```
5. **Pacchetti Necessari per Assembler**
   - aprire terminale Ubuntu ed eseguire uno alla volta i comandi
   ```bash
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y build-essential gcc-multilib musl-dev gdb
    sudo ip link set eth0 up
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/powershell-lts_7.2.0-1.deb_amd64.deb
    sudo dpkg -i powershell-lts_7.2.0-1.deb_amd64.deb
    sudo apt-get install -f
   ```
   - dopo questi comandi, WSL potrebbe riempire la RAM, occorre in tal caso chiudere la finestra di wsl, aprire powershell come amministratore ed eseguire
   ```powershell
   wsl --shutdown
   ```
6. **Installare Verilog**
   - Eseguire iverilog-v11-20201123-x64_setup.exe
   - spuntare la casella PATH
   - Assicurarsi che il PATH sia stato aggiunto per l'account studenti, e non solo per quello amministratore eseguendo da wsl eseguendo il comando sotto da un terminale dell'account studenti
   ```bash
    iverilog
   ```
7. **Installare VSCode**
   - Se si usa VSCode per altri scopi, prima di procedere è sempre bene avere un account github collegato per salvare le estensioni e i settings preesistenti.
   - Eseguire VSCodeSetup-x64-1.63.0.exe
   - E' indispensabile l'associazione file con \*.code-workspace
8. **Installare Estensioni VSCode**
   - nel terminale powershell integrato in VSCode eseguire uno alla volta
   ```powershell
    code --install-extension mshr-h.veriloghdl
    code --install-extension basdp.language-gas-x86
    code --install-extension tomoki1207.pdf
    code --install-extension ms-vscode-remote.remote-wsl
   ```
   - a volte le installazioni da terminale falliscono, ecco un elenco in ordine con i link alle estensioni sul marketplace:
     - [Verilog-HDL](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL)
     - [GNU Assembler](https://marketplace.visualstudio.com/items?itemName=basdp.language-gas-x86)
     - [vscode-pdf](https://marketplace.visualstudio.com/items?itemName=tomoki1207.pdf)
     - [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)
9. Copiare Files Ambiente

   - a questo punto sono stati creati i workspaces nella cartella reti_logiche
   - copiare la cartelle reti_logiche in C:\

10. Test Ambiente Assembler

    - aprire C:\reti_logiche\assembler.code-workspace
    - aprire terminale integrato
    - eseguire i comandi:

      ```powershell
      ./assemble.ps1 ./test-ambiente.s
      ./test-ambiente
      ```

- dovrebbe stampare Ok

1.  Test Ambiente Verilog
    - aprire C:\reti_logiche\verilog.code-workspace
    - aprire terminale integrato
    - eseguire i comandi:
      ```powershell
      iverilog -o test ./test-ambiente.v
      vvp ./test
      ```
    - Dovrebbe stampare Ok

#### Autore: Orlando Lucii
