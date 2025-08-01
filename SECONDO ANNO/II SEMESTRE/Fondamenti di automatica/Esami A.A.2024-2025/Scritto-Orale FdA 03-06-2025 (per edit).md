# Scritto / Orale FdA - $03/06/2025$

> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).
 
> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

## 1 - Risposta libera e forzata

### Esercizio 1.1
1. Calcola la **risposta libera** della funzione di trasferimento  

  $$G(s) = \frac{s + 4}{s(s + 2)^2}$$

con condizioni iniziali:

 $$y(0) = 0,\quad \dot y(0) = -1,\quad \ddot y(0) = 1$$
   
   *(Nota: le condizioni iniziali potrebbero non essere esattamente queste)*
3. Il sistema è **BIBO-stabile**? Perché?

#### Variante 1.1.1

Stesso esercizio ma con funzione di trasferimento:

 $$G(s) = \frac{s + 9}{s(s + 5)^2}$$

e con condizioni iniziali:

$$y(0) = 0,\quad \dot y(0) = -2,\quad \ddot y(0) = -1$$

#### Variante 1.1.2

1. Stesso esercizio ma con funzione di trasferimento:

 $$G(s) = \frac{s + 2}{s(s + 2)^2}$$

   e con condizioni iniziali:
    
   $$y(0) = 1,\quad \dot y(0) = -1,\quad \ddot y(0) = 1$$
    
3. Calcola la realizzazione minima e scrivine il modello a variabili di stato associato 
4. Discuti la stabilità interna e la BIBO-stabilità?

> #### Domande Orale
> Ho avuto Munafò all'orale e mi ha chiesto:
> * Analisi modale
> * Luogo delle radici
> * Matrice canonica e forme di osservabilità e raggiungibilità

### Esercizio 1.2
Si consideri un sistema descritto dall'equazione differenziale ingresso-uscita:
$$\ddot y+3\dot y+2y=\dot u+4u$$

1. Si determini la **risposta forzata** al gradino del sistema
2. Qual è la funzione di trasferimento del sistema?
3. Il sistema è **BIBO-stabile**? Perché?

#### Variante 1.2.1

Stesso esercizio ma con equazione differenziale:
$$y^{(3)}+20\ddot y=\dot u+12u$$

## 2 - Progettazione del controllore

### Esercizio 2.1
Un impianto ha f.d.t.:

$$G(s)=50\cfrac{s-20}{(s+10)(s+5)^2}$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="813" height="272" alt="image" src="https://github.com/user-attachments/assets/27db5840-a261-46e7-97b1-29061838bd26" />


soddisfi le seguenti specifiche:
* Errore nullo a regime in risposta al gradino
* Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.1$ rad/s
* Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge50$ rad/s
* Margine di fase di almeno 45°

#### Variante 2.1.1
Stesso esercizio, ma con:

$$G(s)=\cfrac{20000}{s(s+10)(s+2)^3}$$

### Esercizio 2.2

Un impianto ha f.d.t.:

$$G(s)=150\cfrac{1}{s(s+8)^3}$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="813" height="272" alt="image" src="https://github.com/user-attachments/assets/9a90e7f5-0ca1-4fc7-a523-cb0628768386" />

soddisfi le seguenti specifiche:
* Abbia errore nullo a regime
* Tempo di assestamento al 95% < 1 s
* Overshot del 2%

> #### Domande Orale
> Ho avuto Munafò all'orale e a me ha fatto solo domande sul mio scritto e sulle cose che avevo sbagliato. In particolare: mi ha chiesto come risolvere il problema in bode (avevo risolto con luogo delle radici), il resto erano domande sul luogo delle radici.

### Esercizio 2.3
Data la seguente

$$G(s) = 10\cfrac{20-s}{(2+s)(25+s)^2}$$

Progettare un controllore che permetta di rispettare le seguenti specifiche:
* Errore a gradino < 3%;
* Reiezione rumore di carico di almeno 20dB per ω <= 0.1 rad/s;
* Reiezione rumore di misura di almeno 20dB per ω >= 75 rad/s;
* Margine di Fase di almeno 45°;

> #### Domande orale
> * Alcune domande sull'esercizio svolto, tipo con che logica ho scelto poli e zeri della rete ridardatrice;
> * Mi ha dato la seguente matrice e mi ha chiesto di calcolargli i modi e dire se era stabile:
>
> $$ A = \begin{bmatrix}
> -7&0&0\\
> 0&3&1\\
> 0&-1&3\end{bmatrix}$$

## 3 - Bode e Nyquist

### Esercizio 3.1
Tracciare il diagramma di Bode e  di Nyquist di:

$$G(s) = \cfrac{(s+1)^2}{s(s+100)^2}$$

#### Variante 3.1.1
Stesso esercizio ma con f.d.t.:

$$G(s) = \cfrac{10}{s(1+s)}$$

## Raccolta di domande per l'orale

Una serie di domande sparse condivise dagli studenti:

### Domanda 1
Dimostrare tramite i diagrammi di Bode, che la seguente $G(s)$ è stabile:

$$G(s)=\cfrac{1}{s(s+1)(s+2)}$$

*(Nota: è stato sufficiente dimostrare che il margine di guadagno era maggiore di 4/6 dB e il margine di fase maggiore di 75°)*

### Domanda 2
A me è uscito allo scritto il classico esercizio sul modello in variabili di stato, dovevo studiare stabilità interna, osservabilità e raggiungibilità, calcolare la G(s) e dire se era bibo stabile, ma non ricordo i numeri. Poi l'assistente mi ha chiesto definizione di stabilità interna, raggiungibilità, osservabilità, Bibo-stabilità e di applicare il Lemma PBH allo stesso esercizio. Alle domande segue un esercizio (vedi: *Variante 2.1.1*)

### Domanda 3
Il mio scritto era letteralmente il [5] domanda 2.jpeg che si trova su GitHub nella cartella Esami (da A.A.2022-2023). Unica domanda rilevante il perché alcuni autovalori nella matrice A non si vedevano poi nella G(s). L'orale mi ha chiesto di fare Bode di 

$$G(s) = \cfrac{10}{(s+5)(s+50)}$$

In particolar modo mi ha chiesto a cosa servono i margini di Fase e Guadagno, e poi mi ha fatto tracciare Nyquist  sempre della solita funzione chiedendo anche qui di identificare i margini di fase e guadagno.
