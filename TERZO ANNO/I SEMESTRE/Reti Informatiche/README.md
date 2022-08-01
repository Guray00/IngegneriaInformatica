# Macchina virtuale
Note sulla preparazione della macchina virtuale per l'esame di Reti Informatiche. 


## Premessa
Per far funzionare correttamente la macchina virtuale è necessario prima compiere due operazioni dall impostazioni della macchina (su virtualbox):
- video > abilitare l'accelarazione video
- USB > selezionare usb 1.1

Una volta fatto ciò la macchina dovrebbe partire senza troppe difficoltà

---

## VS Code
Per installare vscode è necessario seguire [questa](http://docenti.ing.unipi.it/f.pistolesi/reti/guidavisualstudio.pdf) guida scaricando il .deb di vscode relativo ad ottobre 2020 reperibile [qui](https://update.code.visualstudio.com/1.51.1/linux-deb-x64/stable)

---

## Risoluzione personalizzata
Per impostare una risoluzione custom all'interno della macchina virtuale è sufficiente eseguire i seguenti comandi sostituendo 1920 e 1080 con i valori desiderati (attenzione, dove è richiesto di inserire l'output ricevuto copiare quello):

### step 1
```bash
studenti@studenti:~$ cvt 1920 1080
```

Che restituisce:
> `1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync`


### Step 2
A noi interessa il contenuto dopo modeline, copiarlo e inserirlo come segue (il vostro output):

```bash
studenti@studenti:~$ xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```

### Step 3
Adesso aggiungere la configurazione al sistema:
```bash
studenti@studenti:~$ xrandr --addmode Virtual1 "1920x1080_60.00"
```
Ora, dopo aver chiuso e riaperto le impostazioni, la nuova modalità dovrebbe essere cliccabile.

### Step 4
Per renderla persistente ai prossimi riavvi inserire i comandi di step2 e step3 in `~/.profile:`

```bash
studenti@studenti:~$ sudo gedit ~/.profile
```

---

## Errori

### Assenza di virtualbox extension pack
```text
Implementation of the USB 2.0 controller not found!
Because the USB 2.0 controller state is part of the saved VM state, 
the VM cannot be started. To fix this problem, either install 
the 'Oracle VM VirtualBox Extension Pack' or disable USB 2.0 
support in the VM settings.
Note! This error could also mean that an incompatible 
version of the 'Oracle VM VirtualBox Extension Pack' is installed (VERR_NOT_FOUND).
```

Per risolvere questo problema è sufficiente scaricare "Oracle VM VirtualBox Extension Pack"


### Kernel Panic
```text
Kernel Panic - not syncing: Attempted to kill the idle task!
```

Pare essere un problema che non riguarda tutti gli utenti, navigando su internet è stata trovata la [seguente](https://forums.virtualbox.org/viewtopic.php?f=6&t=106069) soluzione:
- impostare la memoria a 2048MB RAM
- in processore, impostare 2 core
- in schermo, impostare 128MB ram per la memoria grafica e selezionare "VMSVGA graphics controller".


### `/dev/sda1` contains a file system with errors, check forced.

```bash
/dev/sda1 contains a file system with errors, check forced.
Inodes that were part of a corrupted orphan linked list found.

/dev/sda1: UNEXPECTED INCONSISTENCY: RUN fsck MANUALLY.
         (i.e., without -a or -p options)
fsck exited with status code 4
The root filesystem on /dev/sda1 requires a manual fsck

BusyBox v1.22.1 (Ubuntu 1:1.22.0-19ubuntuu2) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)_
```

Per risolvere è sufficiente digitare nel prompt initramfs:

```bash
fsck -f /dev/sda1 
```

per riparare il filysistem file system. [Source](https://askubuntu.com/questions/955467/dev-sda1-contains-a-file-system-with-errors-check-forced)

