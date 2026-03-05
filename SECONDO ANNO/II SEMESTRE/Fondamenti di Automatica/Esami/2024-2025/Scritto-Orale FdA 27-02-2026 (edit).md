# Scritto / Orale FdA - 27/02/2026

> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).

> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

---


### Esercizio 1 - Modello in variabili di stato

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
-1&0&0\\
0&-2&1\\
0&0&-3&1
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
    0&0&1
\end{bmatrix}
x
\end{cases}$$

1. Si discuta la raggiungibilità, l'osservabilità e la stabilità interna del sistema.
2. Il sistema è BIBO stabile?
3. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema $G(s)$

---
### Esercizio 2 - Progettazione Controllore e Bode

Data la seguente funzione di trasferimento:

$$G(s) = 100 \cdot \frac{s -5}{(s^2+20s+125)}$$

1. Disegnare il diagramma di Bode.
2. Progettare un regolatore $C(s)$ in moodo tale che rispetti le seguenti specifiche:
   - Errore nullo a regime con un ingresso di tipo gradino
   - Attenuazione dei disturbi di carico di almeno $45dB$ per $\omega \leq 0.1\ \text{rad/s}$
   -  Reiezione dei rumori di misura di almeno $40dB$ per $\omega \geq 1000\ \text{rad/s}$
3. Margine di fase > $45°$
4. Disegnare il diagramma di Bode di $C(s)G(s)$
5. Disegnare il diagramma di Nyquist di $C(s)G(s)$

