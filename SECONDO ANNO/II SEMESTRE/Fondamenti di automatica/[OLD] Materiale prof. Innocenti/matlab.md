# Come usare matlab per FdA
Questo file è incompleto e vuole essere una linea guida per l'utilizzo di matlab per l'esame di Fondamenti di Automatica. La guida non copre il processo di installazione, per la quale è sufficiente registrarsi con le credenziali di ateneo sul sito e scaricare il programma con la licenza ottenuta. _Siete invitati ad arricchire questo documento per renderlo il più funzionale possibile!_

## Introduzione
### Inserire funzione di trasferimento
#### Tramite Zeri e Poli
Per inserire in modo comodo una funzione di trasferimento
è sufficiente realizzare tre variabili `z` `p` `k` contenenti rispettivamente i valori di zeri, poli e guadagno. 

```matlab
% esempio
z = [-1 -2 -3]
p = [-4 -5 -6]
k = 1
```

si dovrà poi creare la funzione `sys` da tali informazioni attraverso la funzione `zpk`
```matlab
%esempio
sys = zpk(z, p, k)
```

#### Tramite TF
Se vogliamo inserire la funzione direttamente senza  specificare
zeri o poli è possibile definire `s = tf('s')` e definire `sys` di conseguenza (ricorda sempre di specificare il prodotto con `*`)

```matlab
% esempio
s = tf('s')
sys = (s-1)/[(s^2 + s + 1)*(s+10)]

%           s - 1
%  ------------------------
%  s^3 + 11 s^2 + 11 s + 10
```

### Come utilizzare file esterni
#### Aprendo i file
Per utilizzare file esterni è sufficiente aprili su matlab, eseguirli tramite il comando _run_ e una volta fatto ciò richiamare le funzioni aggiunte mediante il nome della funzione.

#### Aggiungendoli al path [consigliato]
E' possibile aggiungere la cartella contenente i file utilizzati al path quando richiesto, oppure copiare tutti i file che si vuole utilizzare dentro la cartella MATLAB in documenti.

## Root Locus
Per disegnare il lugo delle radici dato un sistema `sys` precedentemente inserito, è sufficiente utilizzare il comando `rlocus(sys)`

```matlab
%esempio
z = [-1 -2 -3]
p = [-4 -5 -6]
k = 1

sys = zpk(z, p, k)
rlocus(sys)
```

## Bode

### Tramite Bode standard
Per disegnare il diagramma di Bode dato un sistema `sys` precedentemente inserito, è sufficiente utilizzare il comando `bode(sys)`

```matlab
%esempio
z = [-1 -2 -3]
p = [-4 -5 -6]
k = 1

sys = zpk(z, p, k)
bode(sys)
```
### Tramite asymp
Prima di procedere _(se non aggiunto al path)_:
- Aprire il file `asymp.m`
- Eseguirlo (se richiesto premere su `change folder`)
  
Digitare nella shell il comando `asymp(sys, min, max)` con:
- `sys`: funzione di trasferimento
- `min`: minima decade di interesse
- `max`: massima decade di interesse 

_**nota**: min e max sono parametri opzionali._


```matlab
%esempio
z = [-1 -2 -3]
p = [-4 -5 -6]
k = 1

sys = zpk(z, p, k)
min = 0.1
max = 100
asymp(sys, min, max)
```

## Nyquist

### Tramite Nyquist standard
Per disegnare il diagramma di Nyquist dato un sistema `sys` precedentemente inserito, è sufficiente utilizzare il comando `nyquist(sys)`

```matlab
%esempio
z = [-1 -2 -3]
p = [-4 -5 -6]
k = 1

sys = zpk(z, p, k)
nyquist(sys)
```

### Tramite nyqlog
Prima di procedere _(se non aggiunto al path)_:
- Aprire il file `nyqlog.m`
- Eseguirlo (se richiesto premere su `change folder`)
  
Digitare nella shell il comando `nyqlog(sys)` con:
- `sys`: funzione di trasferimento


```matlab
%esempio
z = [-1 -2 -3]
p = [-4 -5 -6]
k = 1

sys = zpk(z, p, k)
nyqlog(sys)
```
