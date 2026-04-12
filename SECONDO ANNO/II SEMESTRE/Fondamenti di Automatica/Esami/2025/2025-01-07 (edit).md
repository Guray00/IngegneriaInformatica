# Scritto FdA — 7 Gennaio 2025

---

## 🔵 PARTE A — Progettazione Controllore

### Variante A1

Data la funzione di trasferimento:

$$G(s) = 150 \cdot \frac{s+10}{s\,(s^2+s+8)^2}$$

Progettare per tale impianto un regolatore $R(s)$ tale per cui il sistema in ciclo chiuso

<img width="577" height="163" alt="image" src="https://github.com/user-attachments/assets/d404e4a4-e314-452d-a22f-5e1ca5e8cd82" />

**Specifiche:**

1. Errore a regime in risposta al gradino $< 5\%$ del valore di regime
2. Tempo di assestamento al $98\% < 2.5\,\text{s}$
3. Smorzamento $> 0.7$

<img width="732" height="596" alt="image" src="https://github.com/user-attachments/assets/f8f08f62-dff7-4b6f-9053-0cb2a0c26d3b" />

---

### Variante A2

Data la funzione di trasferimento:

$$G(s) = 150 \cdot \frac{s+1}{s\,(s+7)(s+8)(s+10)}$$

Schema a retroazione negativa con $R(s)$ e $G(s)$.

**Specifiche:**

1. Banda passante $\geq 0.8\,\text{rad/s}$
2. Errore a regime in risposta al gradino $< 5\%$ del valore di regime
3. Smorzamento $> 0.7$

<img width="732" height="596" alt="image" src="https://github.com/user-attachments/assets/16c04ea1-5b09-4590-9e70-b89bd16c33f0" />

---
