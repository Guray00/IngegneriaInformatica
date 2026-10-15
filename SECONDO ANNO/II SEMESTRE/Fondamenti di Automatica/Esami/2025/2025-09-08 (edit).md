# Scritto / Orale FdA - $08/09/2025$

> Ogni esercizio rappresenta la traccia dello scritto (ognuno ha una traccia diversa allo scritto con un esercizio che può presentare più richieste).
 
> Laddove siano state condivise dagli studenti sono presenti anche le domande dell'orale (anche in questo caso si tratta di esercizi scritti o domande orali)

> Nota bene: molte delle tracce sono simili o uguali a quelle uscite nel primo appello. La parte "variabile" dell'esame comprende le domande dell'orale o le tracce successive alla prima

## 1 - Risposta libera e forzata

### Esercizio 1.1
Calcola la **risposta libera** della funzione di trasferimento
 

   $$G(s) = \frac{s + 3}{s(s + 1)^2}$$

   con condizioni iniziali:
   
   $$y(0) = 0,\quad \dot y(0) = -1,\quad \ddot y(0) = -2$$
   
 1. Il sistema è **BIBO-stabile**? Perché?
 2. Si tracci il Diagramma di Bode e si progetti un regolatore che soddisfi le seguenti specifiche:

 - Errore a regime in risposta al gradino  $<3\$%
 - Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.1$ rad/s
 - Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge100$ rad/s
 - Margine di fase > 45°
> #### Domande Orale
> A me all’orale ha chiesto cosa intendevo con alcune specifiche (come le avrei fatte perché non le avevo finite) e di fargli a voce il controllore all’incirca, perché non avevo fatto tutti i calcoli

### Esercizio 1.2
Calcola la risposta forzata al gradino di:

  $$y''' + 20y'' = u' + 12u$$
 
1. Il sistema è **BIBO-stabile**? Perché?
2. Calcolare la fdt
3. Sulla stessa funzione progettare un regolatore per avere:
  - Errore a gradino nullo
  - Reiezione dei disturbi di carico di almeno 20 dB per $\omega \leq10$ rad/s
  - Reiezione dei disturbi di misura di almeno 20 dB per $\omega \geq1000$ rad/s
  - Margine di fase > 45°

### Esercizio 1.3
Sia data

  $$y'''+8y''+16y'=u'+10u$$
1. Calcolare la risposta forzata
2. Calcolare la funzione di trasferimento
3. Controllare se bibo stabile
4. Usando la stessa funzione, tracciare bode e fare un controllore che rispetti:
 
 - Errore nullo a regime in risposta al gradino
 - Reiezione dei disturbi di carico di almeno 20 dB per $\omega \leq0.1$ rad/s
 - Reiezione dei disturbi di misura di almeno 20 dB per $\omega \geq1000$ rad/s
 - Margine di fase di almeno 45°

> #### Domande Orale
>(le prime due domande l'assistente, la terza Munafo):
> - teorema del valor finale e iniziale (mi ha chiesto la definizione e se riuscivo anche la dimostrazione..)
> - bode per controllare se il controllore rispettava le specifiche
> - trovare una matrice A B e C e far si che il sistema sia marginalmente stabile, osservabile e raggiungibile
> 
### Esercizio 1.4
Sia data

  $$y'''+4y''+4y'= u''+ 4u' + 5u$$
1. Calcolare la risposta forzata
2. Calcolare la funzione di trasferimento
3. Controllare se bibo stabile
4. Usando la stessa funzione, tracciare bode e fare un controllore che rispetti:
- Errore minore del 3% a regime in risposta al gradino
- Reiezione dei disturbi di carico di almeno 40 dB per $\omega \leq0.1$ rad/s
- Reiezione dei disturbi di misura di almeno 20 dB per $\omega \geq1000$ rad/s
- Margine di fase di almeno 45°

> #### Domande Orale
> All'orale mi ha chiesto alcune precisazioni sul compito e poi stabilità, osservabilità e di creargli una matrice A e una B che dovevano risultare asintoticamente stabili e raggiungibili

## 2 - Progettazione del controllore

### Esercizio 2.1
Un impianto ha f.d.t.:

$$G(s)=400\cfrac{s+1}{s(s+2)(s^2+s+5)}$$

progettare per tale impianto un regolatore R(s) tale per cui il sistema a ciclo chiuso

<img width="868" height="240" alt="image" src="https://github.com/user-attachments/assets/11e4e871-914a-445c-ac4c-5bdebd5d254b" />


soddisfi le seguenti specifiche:
* Errore a regime $<10\$% per ingresso a gradino
* Reiezione dei disturbi di carico di almeno 20 dB per $\omega\le0.2$ rad/s
* Reiezione dei disturbi di misura di almeno 20 dB per $\omega\ge30$ rad/s
* Margine di fase di almeno 60°

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
> Disegnare Diagramma di Nyquist

## 3 - Bode e Nyquist

Sia data la fdt  

  $$G(s) = 2000 \cdot \frac{10}{s \ (s+10) \ (s+2)^3}$$

1. Il sistema è Bibo stabile?
2. Disegnare il diagramma di Bode
3. Progettare un controllore per rispettare le seguenti specifiche:
- Errore a regime nullo allo scalino
- Reiezione disturbi di carico di almeno 20 db per $\omega < 0.1 \,\text{rad/s}$
- Reiezione disturbi di misura di almeno 20 db per $\omega > 69 \,\text{rad/s}$
- Margine di fase: $\ge 45^\circ$

4. Discutere il criterio di Nyquist e tracciare il diagramma di Nyquist
> #### Domande Orale
> Differenze tra stabilità bibo e stabilità interna

## 4 - Modello in variabili di stato

### Esercizio 4.1

$$\begin{cases}
\dot x =
\begin{bmatrix}
-1 & 0 & -2 \\
0 & 4 & 0 \\
2 & 0 & -3
\end{bmatrix}
x +
\begin{bmatrix}
    1 \\ 0 \\ 0
\end{bmatrix}
u
\\\,\\
y =
\begin{bmatrix}
   2 & 0 & 0
\end{bmatrix}
x
\end{cases}$$  

1. Stabilità interna, raggiungibilità, osservabilità, modi
2. Scrivere la funzione di trasferimento del sistema
3. BIBO stabile?
4. Diagramma di Bode della seguente fdt: 

$$G(s) = \frac{s+7}{s(s+3)^2}$$

> #### Domande Orale
> Tracciare Nyquist della fdt di prima[ $G(s) = \frac{s+7}{s(s+3)^2}$],  criterio di stabilità di Nyquist

### Esercizio 4.2

Si consideri il sistema descritto dalle equazioni di stato:

$$\begin{cases}
\dot x =
\begin{bmatrix}
    -7&0&0&0\\
    0&-2&0&0\\
    0&0&0&-3\\
    0&0&3&0
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
4. Diagramma di Bode della seguente fdt: 

$$G(s) = \frac{s+3}{s(s+1)^2}$$
> #### Domande Orale
> - Che tipo di stabilità interna è  
  (avevo scritto solo che era stabile, quindi ha voluto che specificassi se era assoluta o marginale)

>- Differenza tra la **BIBO-stabilità** e la stabilità interna

>- Sulla fdt del punto 4 fare un controllore che rispetti le seguenti richieste:
 > - Margine di fase $\ge 45^\circ$
 > - Reiezione dei disturbi di carico di 40 dB per $\omega \le 0.1 \,\text{rad/s}$


