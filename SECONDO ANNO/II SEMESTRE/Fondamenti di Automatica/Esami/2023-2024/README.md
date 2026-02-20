# Scritto FdA — 7 Gennaio 2025

---

## 🔵 PARTE A — Progettazione Controllore

### Variante A1

Data la funzione di trasferimento:

$$G(s) = 150 \cdot \frac{s+10}{s\,(s^2+s+8)^2}$$

Progettare per tale impianto un regolatore $R(s)$ tale per cui il sistema in ciclo chiuso



**Specifiche:**

1. Errore a regime in risposta al gradino $< 5\%$ del valore di regime
2. Tempo di assestamento al $98\% < 2.5\,\text{s}$
3. Smorzamento $> 0.7$

> Il diagramma di Bode di $G(s)$ è fornito nel testo.

---

### Variante A2

Data la funzione di trasferimento:

$$G(s) = 150 \cdot \frac{s+1}{s\,(s+7)(s+8)(s+10)}$$

Schema a retroazione negativa con $R(s)$ e $G(s)$.

**Specifiche:**

1. Banda passante $\geq 0.8\,\text{rad/s}$
2. Errore a regime in risposta al gradino $< 5\%$ del valore di regime *(valore leggermente diverso)*
3. Smorzamento $> 0.7$ *(valore leggermente diverso)*

