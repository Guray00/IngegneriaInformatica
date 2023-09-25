# Esame del 06/06/2023

Gli studenti vengono divisi in gruppi, ad ognuno dei quali è associata una traccia da svolgere. Le tracce sono quattro, e sono riportate di seguito.

## Traccia A

### Domanda 1

Descrivere e discutere il **teorema del valore finale**

### Domanda 2

Data la funzione di trasferimento

$$G(s) = \frac{20\cdot (0.5s + 1)}{(10s^2 + 6s + 11)\cdot(3+s)\cdot(0.04s + 2)}$$

1. Calcolare la risposta al gradino unitario
2. Disegnare qualitativamente la risposta $y(t)$ al gradino $u(t) = 10$
3. Calcolare il valore a regime $y(\infty)$
4. Stimare il tempo di assestamento $T_a$ e periodo di eventuale oscillazione

### Domanda 3

Data

$$G(s) = \frac{k}{(1+2s)\cdot(1++4s)}$$

1. Tracciare il diagramma di Nyquist
2. Progetta una rete corretrice per avere $\phi_M > 45°$ (margine di fase)

### Domanda 4

Date

$$
A = \begin{bmatrix}
    -2 & -3 & 1  \\
     1 & -2 & -1 \\
     0 & 0 & 5
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    1 \\
    1 \\
    0
    \end{bmatrix}
\qquad
C = \begin{bmatrix}
    -1 & 0 & 1
    \end{bmatrix}
$$

1. Stabilità interna e analisi modale
2. Raggiungibilità e osservabilità
3. Stabilità BIBO

## Traccia B

### Domanda 1

Discutere il criterio di Nyquist

### Domanda 2

Data la funzione di trasferimento

$$G(s) = \frac{s^2 + 20s + 87}{s^2 + 4s + 27}$$

1. Calcolare la risposta al gradino unitario
2. Disegnare la risposta $y(t)$ per ingresso unitario $u(t) = 10$
3. Calcolare $y(\infty)$
4. Stimare il tempo di assestamento $T_a$ e periodo di eventuale oscillazione

### Domanda 3

Data la funzione di trasferimento

$$G(s) = \frac{1}{s\cdot(s+2)\cdot(s+10)}$$

1. Tracciare il luogo delle radici e discuterne la stabilità
2. Verificare gli intervaalli di stabilità con il criterio di Routh e Nyquist

### Domanda 4

Date

$$
A = \begin{bmatrix}
    -3 & 1 & 0 \\
    -2 & -3 & 0 \\
     1 & -1 & 3
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    -1 \\
    0 \\
    -1
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    1 & 1 & 0
\end{bmatrix}
\qquad
D = 1
$$

1. Stabilità interna e analisi modale
2. Raggiungibilità e osservabilità
3. Stabilità BIBO

## Traccia C

### Domanda 1

Definire la risposta in frequenza 

### Domanda 2

Data la funzione di trasferimento

$$G(s)= \frac{10}{s\cdot(s+1)(s+2)}$$

Progettare un controllore tale che:

1. il sistema sia retroazionato asintoticamente stabile (?)
2. Il valore a regime dell'errore sia nullo per l'ingresso di una rampa, e disturbo nullo
3. Il valore dell'errore sia nullo per l'ingresso nullo e disturbo alla rampa (?)

### Domanda 3

Data

$$G(s) = \frac{s+2}{s\cdot(s-1)}$$

1. Tracciare il luogo delle radici e discuterne la stabilità
2. Applicare il criterio di Routh e Nyquist 

### Domanda 4

Date

$$
A = \begin{bmatrix}
    -3 & 0 & 0 \\
     1 & -2 & 1 \\
     1 & -1 & -2
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    0 \\
    1 \\
    -1
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    1 & 1 & 0
\end{bmatrix}
\qquad
D = 0
$$

1. Stabilità interna e analisi modale
2. Raggiungibilità e osservabilità
3. Stabilità BIBO

## Traccia D

### Domanda 1

Discutere sensitività e sensitività complementare

### Domanda 2

Data la funzione di trasferimento

$$G(s) = \frac{20\cdot(s+1)}{(10s^2+6s+11)\cdot(4+s)\cdot(0.06s + 2)}$$

1. Calcolare la risposta al gradino unitario
2. Disegnare la risposta $y(t)$ per ingresso unitario $u(t) = 10$
3. Calcolare $y(\infty)$
4. Stimare il tempo di assestamento $T_a$ e periodo di eventuale oscillazione

### Domanda 3

Data

$$G(s) = \frac{s+1}{s^2\cdot(s+4)}$$

1. Tracciare il luogo delle radici e discuterne la stabilità
2. Applicare il criterio di Routh e Nyquist

### Domanda 4

Date

$$
A = \begin{bmatrix}
    -2 & 2 & -1 \\
     0 & -1 & 2 \\
     0 & -2 & -1
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    1 \\
    2 \\
    1
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    0 & 1 & 0
\end{bmatrix}
\qquad
D = 0
$$

1. Stabilità interna e analisi modale
2. Raggiungibilità e osservabilità
3. Stabilità BIBO


# Esame del 04/07/2023

Gli studenti sono divisi in gruppi, ognuno dei quali deve svolgere una delle seguenti tracce, il tempo assegnato per ogni traccia è di circa 30 minuti; successivamente gli studenti vengono chiamati singolarmente alla cattedra per correggere il compito e rispondere a domande di teoria generale (circa 15 minuti).

## Traccia A

### Domanda 1

Spiegare il concetto di stabilità e che relazione ha con la funzione di trasferimento

### Domanda 2

$$G(s) = \frac{9}{(s^2 + s + 0.5)\cdot(s + 2.5)}$$

1. Calcolare la risposta impulsiva
2. Disegnare qualitativamente la risposta $y(t)$ al gradino unitario

### Domanda 3

Per la funzione di trasferimento sopra, progettare un controllore con la tecnica del loop shaping tale che:
- L'errore a regime sia zero per il controllo a gradino unitario
- Il margine di fase sia $\phi_M > 40°$ 


### Domanda 4

$$
A = \begin{bmatrix}
    -2 & 1 & 0  \\
     0 & -2 & 0 \\
     0 & 0 & 1
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    0 \\
    2 \\
    0
    \end{bmatrix}
\qquad
C = \begin{bmatrix}
    -1 & 0 & 1
    \end{bmatrix}
\qquad
D = 3
$$

1. Stabilità interna e analisi modale
2. Raggiungibilità e osservabilità
3. Stabilità BIBO

## Traccia B

### Domanda 1

Definire margine di guadagno e margine di fase ed enunciare il criterio della stabilità per Bode

### Domanda 2

$$G(s) = \frac{9}{(s^2 + 2s + 1.25)\cdot(s + 5.5)}$$

1. Calcolare la risposta impulsiva
2. Disegnare qualitativamente la risposta $y(t)$ al gradino unitario

### Domanda 3

Per la funzione di trasferimento sopra, progettare un controllore utilizzando una rete anticipatrice o ritardatrice tale che:
- L'errore a regime sia zero per il controllo a gradino unitario
- Il margine di fase sia $\phi_M > 40°$ 

### Domanda 4

$$
A = \begin{bmatrix}
    0 & 1 & 0 \\
    0 & 0 & 0 \\
    0 & 0 & -2
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    0 \\
    1 \\
    2
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    0 & 0 & 1
\end{bmatrix}
\qquad
D = 1
$$

1. Stabilità interna e analisi modale
2. Raggiungibilità e osservabilità
3. Stabilità BIBO

# Esame del 25/07/2023

Gli studenti vengono divisi in gruppi, ad ognuno dei quali è associata una traccia da svolgere. Le tracce sono due, e sono riportate di seguito.
Il tempo per svolgere gli esercizi è di circa 1h.
A seguito iniziano gli orali.

## Traccia A

### Domanda 1

Cosa di intende per Diagramma di Bode e Diagramma Nyquist

### Domanda 2

Data la funzione

$$G(s) = \frac{50}{(s + 15)\cdot(s^2+144s+1.06)}$$

1. Calcolo risposta impulsiva
2. Grafico qualitativo
3. Discussione Prestazioni

### Domanda 3

Diagramma Nyquist ed analisi stabilità

### Domanda 4

Progetto controllore con luogo radici
-non oscillatorio

### Domanda 5

Definizione stabilità interna 

### Domanda 6

$$
A = \begin{bmatrix}
    -1 & 1 & 0 \\
    0 & -1 & 0 \\
    0 & 0 & -2
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    0 \\
    1 \\
    1
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    1 & 0 & 1
\end{bmatrix}
\qquad
$$

Discussione Stabilità e Raggiungibilità

## Traccia B

### Domanda 1

Risposta nel tempo vs risposta in frequenza.
Quali sono i vantaggi e gli svantaggi?

### Domanda 2

Data la funzione

$$G(s) = \frac{70}{(s^2+3s+16)}$$

1. Risposta impulsiva
2. Grafico qualitativo

### Domanda 3

Diagramma Nyquist

### Domanda 4

Controllore rete anticip./ritard.
Req:
1. Errore regime zero
2. Margine fase > 75°

### Domanda 5
$$
A = \begin{bmatrix}
    -1 & 1 & 0 & 0\\
    -1 & -1 & 0 & 0\\
    0 & 0 & -1 & 1\\
    0 & 0 & 0 & -1
\end{bmatrix}
\qquad
$$

Nodi e Stabilità

### Domanda 6
$$
A = \begin{bmatrix}
     1 & 0 & 0\\
     0 & -2 & 1\\
     0 & 0 & -2
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    0\\
    1\\
    -2
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    -1 & 1 & 0
\end{bmatrix}
\qquad
D = 5
$$

Ragg. e Oss.

# Esame del 13/09/2023

Gli studenti vengono divisi in gruppi, ad ognuno dei quali è associata una traccia da svolgere. 
Le tracce sono due, e sono riportate di seguito.
Il tempo per svolgere gli esercizi è di circa 30 minuti.
A seguito iniziano gli orali.

## Traccia A

### Domanda 1

Bode e Nyquist

### Domanda 2

Data la funzione

$$G(s) = \frac{20}{(s^2+2s+5)}$$

1. Errore a gradino nullo
2. Margine fase > 40°

### Domanda 3

$$
A = \begin{bmatrix}
     -1 & 1 & 0\\
     0 & -1 & 0\\
     0 & 0 & 2
\end{bmatrix}
\qquad
B = \begin{bmatrix}
    0\\
    -1\\
    -3
\end{bmatrix}
\qquad
C = \begin{bmatrix}
    2 & 0 & 0
\end{bmatrix}
\qquad
D = 2
$$

1. Modi 
2. Entrambe le stabilità
3. Ragg. e Osserv.

### Domanda 4
Final value theorem

## Traccia B

### Domanda 1
Data la funzione

$$G(s) = \frac{50}{(s)\cdot(s+4)}$$

Calcolare e rappresentare risposta impulsiva

### Domanda 2
1. Modi sistema
2. Stab. int.
3. Raggiung.
4. Oss.
5. Bibo

### Domanda 3
Definire ed illustrare margine di fase e ampiezza