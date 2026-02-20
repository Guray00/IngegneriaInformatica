# Scritto + Orale FdA — 1 Dicembre 2023

---

## 🔵 PARTE A — Progettazione Controllore

### Variante A1

Data la funzione di trasferimento:

$$G(s) = 10 \cdot \frac{20 - s}{(s+1)(s+25)^2}$$

Schema a retroazione con controllore $K$ in serie a $G(s)$.

**Requisiti:**

1. Errore allo step input $< 3\%$ del valore a regime
2. Reiezione del disturbo di carico di almeno $20\,\text{dB}$ per $\omega < 0.1\,\text{rad/s}$
3. Reiezione del rumore di misura di almeno $-20\,\text{dB}$ per $\omega > 75\,\text{rad/s}$
4. Margine di fase $> 45°$

---

### Variante A2

Data la funzione di trasferimento:

$$G(s) = \frac{500 \cdot (20 - s)}{(s+4)(s+25)^2}$$

**Requisiti:**

1. Errore in risposta al gradino $\leq 3\%$ del valore a regime
2. Reiezione del disturbo di carico di almeno $20\,\text{dB}$ per $\omega \leq 0.2\,\text{rad/s}$
3. Reiezione del disturbo di misura di almeno $-20\,\text{dB}$ per $\omega \geq 75\,\text{rad/s}$
4. Margine di fase $> 45°$

---

### Variante A3

Data la funzione di trasferimento:

$$G(s) = 10 \cdot \frac{s + 15}{(s+10)(s+3)^2}$$

Schema a retroazione negativa con $R(s)$ e $G(s)$.

**Requisiti:**

1. Errore all'input a gradino nullo
2. Reiezione del disturbo di carico di almeno $20\,\text{dB}$ per $\omega < 0.1\,\text{rad/s}$
3. Reiezione del rumore di misura di almeno $-20\,\text{dB}$ per $\omega \geq 60\,\text{rad/s}$
4. Margine di fase $> 45°$

---

### Variante A4

Data la funzione di trasferimento:

$$G(s) = 2000 \cdot \frac{10}{s\,(s+10)(s+2)^3}$$

**Requisiti:**

1. Errore a regime nullo per ingresso a gradino
2. Reiezione di disturbi di carico di almeno $20\,\text{dB}$ per $\omega \leq 0.1\,\text{rad/s}$
3. Reiezione di disturbi di misura di almeno $-20\,\text{dB}$ per $\omega \geq 60\,\text{rad/s}$
4. Margine di fase $\phi_m > 60°$

---

## 🟣 PARTE B — Equazione Differenziale

### Variante B1

Si consideri il sistema descritto dalla seguente equazione differenziale ingresso-uscita:

$$\dddot{y} + 8\ddot{y} + 16\dot{y} = \dot{u} + 10u$$

1. Si determini la risposta forzata del sistema al gradino
2. Si determini la funzione di trasferimento del sistema
3. Si discuta riguardo la stabilità BIBO del sistema
4. Si tracci il luogo delle radici e il diagramma di Bode

---

### Variante B2

Si consideri il sistema descritto dalla seguente equazione differenziale ingresso-uscita:

$$\ddot{y} + 20\dot{y} = \dot{u} + 12u$$

1. Si determini la risposta forzata del sistema al gradino
2. Si determini la funzione di trasferimento del sistema
3. Si discuta riguardo la stabilità BIBO del sistema
4. Si tracci il luogo delle radici e il diagramma di Nyquist

---

### Variante B3

Si consideri il sistema descritto dalla seguente equazione differenziale ingresso-uscita:

$$\ddot{y} + 10\dot{y} = \dot{u} + 12u$$

> ⚠️ Variante di B2: coefficiente del termine $\dot{y}$ è **10** invece di 20.

1. Si determini la risposta forzata del sistema al gradino
2. Si determini la funzione di trasferimento del sistema
3. Si discuta riguardo la stabilità BIBO del sistema
4. Si tracci il luogo delle radici *(solo root locus)*

---

## 🟢 PARTE C — Risposta Libera e Stabilità BIBO

### Variante C1

Si consideri il sistema descritto dalla seguente funzione di trasferimento:

$$G(s) = \frac{s + 3}{s\,(s+1)^2}$$

- Si determini la risposta libera con condizioni iniziali:
$$y(0) = 0 \qquad \dot{y}(0) = -1 \qquad \ddot{y}(0) = -1$$
- Il sistema è BIBO stabile? Perché?

---

### Variante C2

Si consideri il sistema descritto dalla seguente funzione di trasferimento:

$$G(s) = \frac{s + 9}{s\,(s+5)^2}$$

- Si determini la risposta libera con condizioni iniziali:
$$y(0) = 0 \qquad \dot{y}(0) = -2 \qquad \ddot{y}(0) = -1$$
- Il sistema è BIBO stabile? Perché?

---

## 🔴 PARTE D — Equazioni di Stato

### Variante D1

Si consideri il sistema descritto dalle equazioni di stato:

$$\dot{x} = \begin{bmatrix} -1 & 0 & 0 & 0 \\ 0 & 0 & -3 & 0 \\ 0 & 3 & 0 & 0 \\ 0 & 0 & 0 & -4 \end{bmatrix} x + \begin{bmatrix} 1 \\ 0 \\ 0 \\ 1 \end{bmatrix} u \qquad y = \begin{bmatrix} 1 & 1 & 0 & 0 \end{bmatrix} x$$

1. Si discuta la raggiungibilità, l'osservabilità e la stabilità interna del sistema
2. Si determini la funzione di trasferimento del sistema
3. Il sistema è BIBO-stabile?

---

### Variante D2

Si consideri il sistema descritto dalle equazioni di stato:

$$\dot{x} = \begin{bmatrix} -7 & 0 & 0 & 0 \\ 0 & 0 & -2 & 0 \\ 0 & 2 & 0 & 0 \\ 0 & 0 & 0 & -8 \end{bmatrix} x + \begin{bmatrix} 0 \\ 1 \\ 0 \\ 1 \end{bmatrix} u \qquad y = \begin{bmatrix} 1 & 0 & 1 & 0 \end{bmatrix} x$$

1. Si discuta la raggiungibilità, l'osservabilità e la stabilità interna del sistema
2. Sulla base della discussione precedente, si determini la funzione di trasferimento del sistema
3. Il sistema è BIBO-stabile?

---

## 🗣️ Orale (appello 1/12/2023)

- Spiegare il proprio scritto (con eventuali errori)
- Teorema della risposta armonica
- Ricavare la formula del sistema retroazionato dal diagramma a blocchi