# Scritto / Orale FdA - 24/01/2026 (Tracce 6-7)

> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).

> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

---

## Traccia 6

### Esercizio 1 - Modello in variabili di stato

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
1&0&1&0\\
-1&1&0&1\\
0&0&-1&-2\\
0&0&2&-1
\end{bmatrix}
 x +
\begin{bmatrix}
0\\
0\\
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

1. Si discuta la raggiungibilità e l'osservabilità
2. Si discuta la stabilità interna del sistema
3. Si definisca il concetto di stabilità BIBO e discutere se il sistema è stabile BIBO
4. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema $G(s)$

---

### Esercizio 2 - Progettazione Controllore (Bode)

Data la seguente funzione di trasferimento:

$$G(s) = \frac{s - 10}{s\,(s+1)(s+16)}$$

1. Disegnare il diagramma di Bode di $G(s)$
2. Progettare un regolatore $C(s)$ **utilizzando il diagramma di Bode** tale per cui il sistema a circuito chiuso rispetti le seguenti specifiche:
   - Margine di fase maggiore di $45°$
   - Errore nullo a regime con un ingresso di tipo gradino
   - Reiezione dei disturbi di carico di almeno $36\,\text{dB}$ per $\omega \leq 0.1\,\text{rad/s}$
   - Reiezione dei disturbi di misura di almeno $16\,\text{dB}$ per $\omega \geq 100\,\text{rad/s}$
3. Disegnare il diagramma di Bode del sistema in anello aperto $C(s)G(s)$
4. Disegnare il diagramma di Nyquist del sistema in anello aperto $C(s)G(s)$

---

## Traccia 7

### Esercizio 1 - Modello in variabili di stato

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
-1&0&1\\
0&0&0\\
0&0&-1
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

1. Si discuta la raggiungibilità e l'osservabilità
2. Si discuta la stabilità interna del sistema
3. Si definisca il concetto di stabilità BIBO e discutere se il sistema è stabile BIBO
4. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema $G(s)$

---

### Esercizio 2 - Progettazione Controllore (Root Locus)

Data la seguente funzione di trasferimento:

$$G(s) = 100 \cdot \frac{s + 3}{(s+1)^2}$$

1. Disegnare il luogo delle radici di $G(s)$
2. Progettare un regolatore $C(s)$ **utilizzando il luogo delle radici** tale per cui il sistema a circuito chiuso rispetti le seguenti specifiche:
   - Stabilità in anello chiuso
   - Margine di fase maggiore di $45°$
   - Errore nullo a regime con un ingresso di tipo gradino
3. Mostrare sul luogo delle radici dove si trovano i poli/zeri di $C(s)G(s)$
4. Disegnare il diagramma di Nyquist del sistema in anello aperto $C(s)G(s)$ e confrontare con il luogo delle radici al variare del guadagno del controllore
