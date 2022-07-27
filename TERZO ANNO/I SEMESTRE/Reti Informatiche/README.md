# Macchina virtuale
Note sulla preparazione della macchina virtuale per l'esame di Reti Informatiche. 


## Premessa
Per far funzionare correttamente la macchina virtuale è necessario prima compiere due operazioni dall impostazioni della macchina (su virtualbox):
- video > abilitare l'accelarazione video
- USB > selezionare usb 1.1

Una volta fatto ciò la macchina dovrebbe partire senza troppe difficoltà


## VS Code
Per installare vscode è necessario seguire [questa](http://docenti.ing.unipi.it/f.pistolesi/reti/guidavisualstudio.pdf) guida scaricando il .deb di vscode relativo ad ottobre 2020 reperibile [qui](https://update.code.visualstudio.com/1.51.1/linux-deb-x64/stable)

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
