# Visual Studio Code Assembler Setup (**WINDOWS/LINUX**)

Semplice guida per programmare/debuggare facilmente del codice Assembler su Visual Studio Code.

**I file usati sono esattamente quelli forniti dai professori.**

Su Windows viene fatto uso di [WSL](https://docs.microsoft.com/it-it/windows/wsl/) (Sottosistema di Windows per Linux) e ovviamente di [Visual Studio Code](https://code.visualstudio.com/)

Alla fine di questa guida potrai fare questo:

<img alt="VSCode Setup" src="./docs/vscode-setup.png" width="700">

## Guida per **WINDOWS/LINUX**
> Per i possessori di un sistema operativo linux possono saltare direttamente al punto [4]().

### 1. Installazione di WSL
Aprire un Windows prompt dei comandi e immettere questo comando:
```cmd
wsl --install
```
_Una guida più dettagliata può essere trovata [qui](https://docs.microsoft.com/it-it/windows/wsl/install), ma per quello che ci serve basta solo questo._

### 2. Installazione e configurazione dell'estensione per il WSL

<img align="right" alt="WSL Button" src="./docs/wsl.png" width="200">

Per usare VS Code nel WSL è necessario installare l'estenzione [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)

Per accedere al Subsystem Linux basta solo premere il pulsante blu con le doppie freccie in basso a sinistra. Dopodichè apparirà una lista di selezione, dovrai premere `New WSL Window`.

### 4. Setup Linux environment

Aprire un terminale **_bash_** su VS Code (`CTRL`+`ò`)