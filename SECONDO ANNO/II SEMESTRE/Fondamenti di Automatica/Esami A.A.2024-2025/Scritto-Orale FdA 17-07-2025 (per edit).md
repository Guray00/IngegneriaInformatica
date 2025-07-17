
# Scritto / Orale FdA - $17/07/2025$
  
> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).

> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

> Nota bene: molte delle tracce sono simili o uguali a quelle uscite nel primo appello. La parte "variabile" dell'esame comprende le domande dell'orale o le tracce successive alla prima

  

## 1 - Risposta libera e forzata

  

### Esercizio 1.1

Si consideri un sistema descritto dalla equazione differenziale ingresso uscita:

$$G(s) = \frac{s + 4}{s(s + 2)^2}
$$

con condizioni iniziali:

$$
y(0) = 0,\quad  \dot y(0) = 1,\quad  \ddot y(0) = -1
$$

1. Calcola la risposta libera della funzione di trasferimento
2. Il sistema è BIBO-stabile? Perché?

  

#### Domande Orale
Progettare un controllore rispetto alla G(s) sopra, utilizzando Bode, che aveva le seguenti specifiche :

- Errore a gradino nullo

- Reiezione disturbi di carico a 20dB a $\omega  \le  0.1\ \mathrm{rad/s}$

- Reiezione disturbi di misura a 20dB a $\omega > 10^3\ \mathrm{rad/s}$

  

Infine mi ha portato un esame con un sistema lineare, tipo questo:

$$
\dot x = \begin{bmatrix}
-7 & 0 & 0 & 0\\
0 & 0 & -2 & 0\\
0 & 2 & 0 & 0\\
0 & 0 & 0 & -8
\end{bmatrix}
\qquad
x + \begin{bmatrix}
0\\
1\\
0\\
1
\end{bmatrix} u
\qquad  $$
$$
y = \begin{bmatrix}
1 & 0 & 1 &0
\end{bmatrix} x
$$

Mi ha chiesto di dire la stabilità del sistema, se completamente raggiungibile, se è completamente osservabile e il lemma PBH applicato a un singolo autovalore.
  
### Esercizio 1.2

Si consideri un sistema descritto dalla equazione differenziale ingresso-uscita:

$$
\ddot y + 4\dot y + 4y \;=\; \ddot u + 4\dot u + 5u
$$

1. Calcola la risposta forzata al gradino del sistema
2. Qual è la funzione di trasferimento del sistema
3. Il sitema è BIBO stabile? Perchè?
4. Si tracci il Diagramma di Bode e si progetti un regolatore che rispetti:
- $M_{\phi}\ge45^\circ$
- $e_{s}\le3\%$

### Esercizio 1.3
Si consideri un sistema descritto dalla equazione differenziale ingresso uscita:

$$G(s) = \frac{s + 9}{s(s + 5)^2}
$$

con condizioni iniziali:

$$y(0) = 0,\quad  \dot y(0) = -2,\quad  \ddot y(0) = -1
$$

1. Calcola la risposta libera della funzione di trasferimento.
2. Il sistema è BIBO-stabile? Perché?
3. Disegnare diagramma di Bode della fdt.
4. Progettare controllore che deve rispettare le seguenti caratteristiche
- $M_{\phi}\ge45^\circ$
- Errore di stato stazionario in risposta al gradino pari a zero.
- Reiezione dei disturbi di carico 20db a $\omega  \le  10\ \mathrm{rad/s}$

#### Domande Orale
Mi ha fatto domande sul controllore perché non tornava qualcosa.
Infine esercizio sulla matrice e dovevo studiare osservabilità, raggiungibilità e stabilità.

### Esercizio 1.4
Si consideri un sistema descritto dalla equazione differenziale ingresso uscita:

$$G(s) = \frac{s + 3}{s(s + 5)^2}
$$

con condizioni iniziali:

$$y(0) = 0,\quad  \dot y(0) = -1,\quad  \ddot y(0) = -1
$$

1. Calcola la risposta libera della funzione di trasferimento.
2. Il sistema è BIBO-stabile? Perché?
#### Domande Orale
 Discussione sul mio esercizio, mi ha chiesto di tracciare luogo delle radici ed esercizio identico al 2.3.

## 2 - Progettazione del controllore

### Esercizio 2.1

Un impianto ha f.d.t.:

$$G(s)=\cfrac{s+9}{s(s+5)^2}
$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso, che
soddisfi le seguenti specifiche:

- Errore nullo a regime in risposta al gradino
- Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.1$ rad/s
- Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge50$ rad/s
- $M_{\phi}\ge45^\circ$

 #### Domande Orale
Mi ha dato un esercizio sulla matrice e dovevo studiare osservabilità, raggiungibilità e stabilità. 

### Esercizio 2.2
Un impianto ha f.d.t. :

$$G(s)=\cfrac{s+9}{s(s^2+s+25)}
$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="813" height="272" alt="image" src="https://github.com/user-attachments/assets/6d8e2411-acd5-46dd-ac58-97312c3540c9" />


soddisfi le seguenti specifiche:
- Errore in risposta al gradino $<10\%$
-  Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.2$ rad/s
- Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge20$ rad/s
-  $M_{\phi}\ge60^\circ$

### Esercizio 2.3
Un impianto ha f.d.t. :

$$G(s)=\cfrac{s+3}{(s+5)^2}
$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="813" height="272" alt="image" src="https://github.com/user-attachments/assets/a901d84e-d52b-4bdb-9df6-64920d921189" />


soddisfi le seguenti specifiche:
- Errore alla rampa nullo
- Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.1$ rad/s
- Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge40$ rad/s
-  $M_{\phi}\ge45^\circ$

## 3 - Bode e Nyquist
### Esercizio 3.1
Sia la funzione di trasferimento

$$G(s)=\cfrac{10}{s(1+s)}
$$

Disegnare spiegando ogni passaggio il diagramma di Bode e di Nyquist.

### Esercizio 3.2
Sia la funzione di trasferimento

$$G(s)=\cfrac{s+8}{s(1+s)}
$$

Disegnare spiegando ogni passaggio il diagramma di Bode e di Nyquist.

## 4 - Modello in variabili di stato
### Esercizio 4.1
Si consideri il sistema descritto dalle equazioni di stato:

$$\dot x = \begin{bmatrix}
3 & 0 & 1 \\
0 & 1 & -2\\
0 & 0 & 3 
\end{bmatrix}
\qquad
x + \begin{bmatrix}
0\\
0\\
1
\end{bmatrix} u
\qquad  $$
$$
y = \begin{bmatrix}
0 & 1 &0 
\end{bmatrix} x$$

1. Il sistema è completamente stabile?
2. Il sistema è completamente raggiungibile?
3. Il sistema è completamente osservabile?
4. Calcolare i modi.

## Spunti di soluzione Esercizio 1.1

1. Partiamo con
 
 $$\frac{Y(s)}{U(s)} = \frac{s+4}{(s+2)^2} \implies Y(s) \cdot (s(s+2)^2) = U(s) \cdot (s+4)$$

  con *U(s) = 0* in risposta libera

$$Y(s) \cdot (s^3 + 4s^2 + 4s) = 0$$


Ricordando che:

$$
\mathcal{L} \left( \frac{d^3y(t)}{dt^3} \right) = s^3 Y(s) - s^3 y(0) - s \dot{y}(0) - \ddot{y}(0)
$$

$$
\mathcal{L} \left( \frac{d^2y(t)}{dt^2} \right) = s^2 Y(s) - s y(0) - \dot{y}(0)
$$


 Riscriviamo:
$$s^3 Y(s) - s^2 y(0) - s \dot{y}(0) - \ddot{y}(0) + 4s^2 Y(s) - 4s y(0) - 4 \dot{y}(0) + 4s Y(s) - 4y(0) = 0$$

Successivamente scrivo la nuova *Y(s)* , scompongo in fratti semplici, calcolo i coefficienti e procedo con l'antitrasformata.

2. **BIBO stabile** se e solo se tutti i poli della funzione di trasferimento hanno parte reale negativa _(in questo caso ho un polo nell'origine che esclude la stabilità)._

3. **Progettazione del regolatore**
   1. Per avere errore nullo a regime con ingresso un gradino, basta che ci sia un termine integratore in catena diretta _(in questo caso c'è già)._
   2. Una volta soddisfatte le altre specifiche, posso sistemare il margine di fase traslando verticalmente il diagramma di modulo con un controllore proporzionale.
   3. Usiamo un filtro passa basso, con uno zero poco prima della frequenza di interesse per la reiezione dei disturbi ed un polo ad alta frequenza. Verificare queste specifiche tramite le barriere sul diagramma di Bode.
