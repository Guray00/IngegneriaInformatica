Basato su DOS - Script da eseguire da terminale di Mac OS che aprono finestre di DOSBox.

Utilizzo:
Posizionarsi con il terminale nella root della cartella
di lavoro (quella con i files assemble, debug, run).

Comandi (da terminale di Mac OS):

ASSEMBLAGGIO "./assemble ./path_to/source.s"
DEBUGGING "./debug ./path_to/executable.exe"
AVViARE L'ESEGUIBILE "./run ./path_to/executable.exe"
Ogni volta, viene aperta una finestra di DOSBox per compiere
l'azione. Al termine di ogni azione (assemblaggio, etc),
DOSBox chiedera' di premere un pulsante qualsiasi per chiudere
la finestra di terminale.

NB: Durante la fase di assemblaggio, l'assemblatore
sovrascrive il file sorgente. Don't worry! Dopo aver chiuso
la finestra di DOSBox verra' ripristinato da una copia
di backup.