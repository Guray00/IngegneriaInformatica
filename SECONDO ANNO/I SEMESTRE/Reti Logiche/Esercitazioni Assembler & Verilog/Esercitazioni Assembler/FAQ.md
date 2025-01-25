# Frequently Asked Questions

## 1. Come si installa su [sistema X]?

Di base, non lo so. 

L'ambiente fornito, con istruzioni step by step, è preparato e testato per le macchine del laboratorio, e gli stessi strumenti che troverete lì sono mostrati a lezione.

In <b>Note Assembler.pdf</b> si trovano 1) indicazioni fornitemi da studenti degli anni precedenti, che hanno provato l'ambiente su altri sistemi e 2) dettagli sul pacchetto software in generale, che dovrebbe darvi abbastanza opzioni per adattarlo al sistema che usate.

## 2. Come si installa su Mac?

Leggere la domanda 1.

## 3. Fornite una macchina virtuale già pronta?

No.

## 4. Per le esercitazioni a casa intendo usare un ambiente diverso, con altri meccanismi per assemblare e debuggare. Avrò problemi all'esame?

Da parte nostra, no. Durante l'esame rispondiamo senza problemi a domande sull'editor e sull'ambiente, come i comandi da eseguire per assemblare e avviare il debugger.
Non rispondiamo invece a domande sulle istruzioni assembler e comandi di gdb.

Chiedendo perderete tempo però, che *durante l'esame* è prezioso.

## 5. Per le esercitazioni a casa intendo usare un editor diverso da VS Code. Avrò problemi all'esame?

Leggere la domanda 4.

## 6. Non intendo fare esercitazioni a casa. Avrò problemi all'esame?

Da parte nostra, no. Dall'evidenza statistica, molti.

## 7. Provando ad assemblare ricevo un warning strano, del tipo `warning: creating DT_TEXTREL in a PIE`. Cosa devo fare?

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

## 8. Mi piacciono gli argomenti trattati nel corso, si possono approfondire per una tesi triennale?

Certo.
