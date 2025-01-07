# Fondamenti di automatica

Per l'esame è consigliato di stampare il file `laplace_table.pdf` e di portarlo con voi. Contiene le trasformate di Laplace sufficienti per l'esame (non necessarie, perchè è una tabella più che esaustiva).

## Visualizzazione del diagramma di Nyquist

`nyquist.py`<br>

Questo script Python permette di visualizzare il diagramma di Nyquist di un sistema di controllo a partire dalla sua funzione di trasferimento `G(s)`.

Per utilizzarlo è necessario installare `numpy, sympy e matplotlib`. La funzione di trasferimento può essere modificata nel metodo `_get_symbolic_tf()`. Dopo l'esecuzione (`python nyquist.py`), usare i controlli in basso per gestire l'animazione e la sua velocità.
<br><br>
Sviluppato da Andrea Covelli sotto licenza GNU Affero General Public License v3.0.