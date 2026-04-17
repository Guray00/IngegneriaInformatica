# Scritto / Orale FdA - 17/04/2026

> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).

> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

---

### Traccia 4

### Esercizio 1 - Modello in variabili di stato

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
-1 & 0 & 0 \\
0 & -2 & 1 \\
0 & -1 & -3
\end{bmatrix}
x +
\begin{bmatrix}
1 \\ 0 \\ 0
\end{bmatrix}
u
\\\,\\
y =
\begin{bmatrix}
1 & 0 & 1
\end{bmatrix}
x
\end{cases}$$

1. Si discuta la raggiungibilità e l'osservabilità del sistema.
2. Si discuta la stabilità interna del sistema.
3. Si definisca il concetto di stabilità BIBO e si discuta se il sistema è BIBO stabile.
4. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema $G(s)$.

---

### Esercizio 2 - Progettazione Controllore e Bode

Data la seguente funzione di trasferimento:

$$G(s) = \frac{100(s-5)}{s^2 + 20s + 125}$$

1. Disegnare il diagramma di Bode di $G(s)$.
2. Progettare un regolatore $C(s)$ **utilizzando il diagramma di Bode** tale per cui il sistema a circuito chiuso rispetti le seguenti specifiche:
   - Margine di fase $> 45°$
   - Errore nullo a regime con un ingresso di tipo gradino
   - Reiezione dei disturbi di carico di almeno $40\ \text{dB}$ per $\omega \leq 0.1\ \text{rad/s}$
   - Reiezione dei disturbi di misura di almeno $40\ \text{dB}$ per $\omega \geq 1000\ \text{rad/s}$
3. Disegnare il diagramma di Bode del sistema in anello aperto $C(s)G(s)$.
4. Disegnare il diagramma di Nyquist del sistema in anello aperto $C(s)G(s)$.


---

### Traccia 5

### Esercizio 1 - Modello in variabili di stato

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
1 & 0 & 1 \\
0 & 1 & -2 \\
0 & 2 & -1
\end{bmatrix}
x +
\begin{bmatrix}
0 \\ 1 \\ 0
\end{bmatrix}
u
\\\,\\
y =
\begin{bmatrix}
0 & 1 & 0
\end{bmatrix}
x
\end{cases}$$

1. Si discuta la raggiungibilità del sistema.
2. Si discuta l'osservabilità del sistema.
3. Si definisca il concetto di stabilità BIBO e si discuta se il sistema è BIBO stabile.
4. Si definisca il concetto di stabilità interna e si discuta se il sistema è stabile internamente.
5. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema $G(s)$.

---

### Esercizio 2 - Progettazione Controllore e Bode

Data la seguente funzione di trasferimento:

$$G(s) = \frac{10}{s(s^2 + 5s + 8)}$$

1. Progettare un regolatore $C(s)$ **utilizzando il diagramma di Bode** tale per cui il sistema a circuito chiuso rispetti le seguenti specifiche:
   - Errore nullo a regime con un ingresso di tipo gradino
   - Reiezione dei disturbi di carico di almeno $20\ \text{dB}$ per $\omega \leq 5\ \text{rad/s}$
   - Reiezione dei rumori di misura di almeno $20\ \text{dB}$ per $\omega \geq 1000\ \text{rad/s}$
   - Margine di fase $> 45°$
2. Disegnare il diagramma di Bode del sistema in anello aperto $C(s)G(s)$.
3. Disegnare il diagramma di Nyquist del sistema in anello aperto $C(s)G(s)$.

---

### Domande Orali

- **Lemma di PBH** (*Popov-Belevitch-Hautus*): enunciato e utilizzo per la verifica di raggiungibilità e osservabilità.
- **Tipi di stabilità**: definizione e confronto tra stabilità interna (degli autovalori), stabilità BIBO e stabilità asintotica.
- **Analisi modale**: decomposizione della risposta libera in modi naturali, relazione con gli autovalori e gli autovettori della matrice $A$.
- **Criterio di Nyquist**: enunciato, procedura di applicazione e interpretazione del diagramma per la valutazione della stabilità del sistema in anello chiuso.