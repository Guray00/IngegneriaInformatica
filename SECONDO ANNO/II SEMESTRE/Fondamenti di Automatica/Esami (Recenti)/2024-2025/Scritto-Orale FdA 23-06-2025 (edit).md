# Scritto / Orale FdA - $23/06/2025$

> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).
 
> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

> Nota bene: molte delle tracce sono simili o uguali a quelle uscite nel primo appello. La parte "variabile" dell'esame comprende le domande dell'orale o le tracce successive alla prima

## 1 - Risposta libera e forzata

### Esercizio 1.1
Calcola la **risposta libera** della funzione di trasferimento
 

   $$G(s) = \frac{s + 3}{s(s + 5)^2}$$

   con condizioni iniziali:
   
   $$y(0) = 0,\quad \dot y(0) = -1,\quad \ddot y(0) = -1$$
   
 - Il sistema è **BIBO-stabile**? Perché?
> #### Domande Orale
> * Tracciare il diagramma di Bode della precedente f.d.t.

#### Variante 1.1.1

Stesso esercizio ma con funzione di trasferimento:

   $$G(s) = \frac{s + 9}{s(s + 5)^2}$$

e con condizioni iniziali:

   $$y(0) = 0,\quad \dot y(0) = -2,\quad \ddot y(0) = -1$$
> #### Domande Orale
> * Progettare un controllore con margine di fase $\ge50°$ e tempo di assestamento $<3$ secondi.

### Esercizio 1.2
Calcola la risposta forzata al gradino di:

$$G(s)=\cfrac{(s+1)(s+5)}{s(s+2)^2}$$

## 2 - Progettazione del controllore

### Esercizio 2.1
Un impianto ha f.d.t.:

$$G(s)=50\cfrac{s-20}{(s+10)(s+5)^2}$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="868" height="240" alt="image" src="https://github.com/user-attachments/assets/11e4e871-914a-445c-ac4c-5bdebd5d254b" />


soddisfi le seguenti specifiche:
* Errore nullo a regime in risposta al gradino
* Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.1$ rad/s
* Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge50$ rad/s
* Margine di fase di almeno 45°

### Esercizio 2.2

Un impianto ha f.d.t.:

  $$G(s)=\cfrac{s+1}{s(s+2)(s^2+s+25)}$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="868" height="240" alt="image" src="https://github.com/user-attachments/assets/f700dd79-a53a-4ef2-a974-9b634af169ea" />


soddisfi le seguenti specifiche:
* Errore in risposta al gradino $<10\%$
* Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.2$ rad/s
* Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge30$ rad/s
* Margine di fase di almeno 60°

> #### Domande Orale
> Ho avuto l'assistente all'orale e mi ha fatto commentare il ragionamento delle scelte di progetto (fortunatamente erano fatte bene), mi ha chiesto la definizione di BIBO stabilità e come si trova con i poli e poi mi ha fatto fare un esercizio con una matrice da studiarne osservabilità e raggiungibilità.

## 3 - Bode e Nyquist

> Nessuna traccia condivisa per questa tipologia

## 4 - Modello in variabili di stato

### Esercizio 4.1

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
    3&1&0\\
    -2&0&0\\
    0&0&3
\end{bmatrix}
x +
\begin{bmatrix}
    0\\
    1\\
    0
\end{bmatrix}
u
\\\,\\
y =
\begin{bmatrix}
    1&0&0
\end{bmatrix}
x
\end{cases}$$  


1. Si discuta la raggiungibilità, l'osservabilità e la stabilità interna del sistema
2. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema
3. Il sistema è BIBO stabile?

### Esercizio 4.2

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
    0&-1&0&0\\
    1&0&0&0\\
    0&0&-2&0\\
    0&0&0&3
\end{bmatrix}
x +
\begin{bmatrix}
    0\\
    1\\
    0\\
    1
\end{bmatrix}
u
\\\,\\
y =
\begin{bmatrix}
    1&0&1&0
\end{bmatrix}
x
\end{cases}$$  

1. Si discuta la raggiungibilità, l'osservabilità e la stabilità interna del sistema
2. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema
3. Il sistema è BIBO stabile?

# Esame svolto

Calcola la **risposta libera** della funzione di trasferimento  

   $$G(s) = \frac{s + 7}{s(s + 3)^2}$$
   
   con condizioni iniziali:

   $$y(0) = 0,\quad \dot y(0) = -1,\quad \ddot y(0) = 1$$
   
-  Il sistema è **BIBO-stabile**? Perché?

L'esame riportato di seguito (*visualizzabile solo nella versione pdf di questo file*) è stato fatto da me e comprendeva tre tracce più un'orale di 15 minuti. Ecco una breve spiegazione per poter replicare:
* La prima traccia (foto 1) è il classico esercizio sulla risposta libera
* La seconda traccia chiedeva di tracciare luogo delle radici e diagramma di Nyquist della f.d.t. Ho svolto questa traccia, disegnando prima il luogo delle radici e poi ricavando Nyquist dal diagramma di Bode
* La terza traccia chiedeva di progettare un controllore che portasse la banda passante sopra i 3 rad/s, mantenendo un margine di fase di almeno 45°. Questa richiesta non è molto chiara nello scritto in quanto il tempo era poco e il prof chiedeva un'idea di soluzione. Ho proposto un controllore della forma $C(s)=K\cfrac{(\frac s3+1)^2}{(\frac s{10}+1)^2}$ (avevo invertito per sbaglio n e d) e insieme al prof (Munafò) abbiamo visto all'orale che tracciando Bode funzionava perfettamente.
* All'orale oltre a una discussione sullo svolgimento dello scritto e della progettazione fatta, mi sono state fatte alcune domande sul luogo delle radici e su Nyquist, e mi è stata chiesta quale era la relazione tra le regioni delineate da Nyquist e le soluzioni del luogo delle radici.  

L'unico errore fatto allo scritto (che mi potevo facilmente evitare) era un'errore sul luogo delle radici per K positivo, sul tracciamento dei rami che vanno a infinito. Per questo errore il prof mi ha tolto 3 punti.
