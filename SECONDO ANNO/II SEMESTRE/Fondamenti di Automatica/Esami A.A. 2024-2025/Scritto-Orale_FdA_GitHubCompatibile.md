
# Scritto / Orale FdA - 03/06/2025

## 1 - Risposta libera e forzata

### Esercizio 1.1
1. Calcola la **risposta libera** della funzione di trasferimento:
$$
G(s) = \frac{s + 4}{s(s + 2)^2}
$$

con condizioni iniziali:
$$
y(0) = 0, \quad \dot{y}(0) = -1, \quad \ddot{y}(0) = 1
$$

2. Il sistema è **BIBO-stabile**? Perché?

#### Variante 1.1.1
Funzione di trasferimento:
$$
G(s) = \frac{s + 9}{s(s + 5)^2}
$$

Condizioni iniziali:
$$
y(0) = 0, \quad \dot{y}(0) = -2, \quad \ddot{y}(0) = -1
$$

#### Variante 1.1.2
Funzione di trasferimento:
$$
G(s) = \frac{s + 2}{s(s + 2)^2}
$$

Condizioni iniziali:
$$
y(0) = 1, \quad \dot{y}(0) = -1, \quad \ddot{y}(0) = 1
$$

2. Calcola la realizzazione minima e il modello a variabili di stato associato.
3. Discuti stabilità interna e BIBO-stabilità.

---

## 2 - Progettazione del controllore

### Esercizio 2.1
Funzione di trasferimento:
$$
G(s) = 50 \frac{s - 20}{(s + 10)(s + 5)^2}
$$

Progettare il regolatore $R(s)$ con specifiche:
- Errore nullo a regime (gradino)
- Reiezione disturbi carico ≥ 20 dB per $\omega \leq 0.1$ rad/s
- Reiezione disturbi misura ≥ 20 dB per $\omega \geq 50$ rad/s
- Margine fase ≥ 45°

#### Variante 2.1.1
$$
G(s) = \frac{20000}{s(s + 10)(s + 2)^3}
$$

---

## 3 - Bode e Nyquist

### Esercizio 3.1
Tracciare Bode e Nyquist per:
$$
G(s) = \frac{(s+1)^2}{s(s+100)^2}
$$

#### Variante 3.1.1
$$
G(s) = \frac{10}{s(1+s)}
$$

---

## Domande frequenti orale
- Analisi modale
- Luogo delle radici
- Matrice canonica, osservabilità e raggiungibilità
- Stabilità interna, BIBO-stabilità
- Lemma PBH
