## Algoritmi e strutture dati - 24 luglio 2015

#### Esercizio 1

Confrontare le due funzioni F e G dal punto di vista della complessità: dire se una è O dell'altra e viceversa. In caso affermativo, indicare una coppia (n0,c). In caso negativo, giustificare la risposta.

```
      x^4    x divisore di 350
F(n)= 10 x^2 x pari
      x      x dispari

      x^2    x pari
G(n)=
      100 x  x dispari
```

```
‌‌ 






‌‌ 
```

#### Esercizio 2

Indicare l'uscita del seguente programma

```cpp
template<class tipo>
class uno {
    int w;
    static int s;
    public:
        uno() { w=12; }
        int cambia() {w++; cout << w <<
        '\t'; return s+=10; }
};

template<class tipo>
int uno<tipo>::s;

int main() {
    uno<int> obj1, obj2;
    uno<char> obj;
    cout << obj1.cambia() << endl;
    cout << obj2.cambia() << endl;
    cout << obj3.cambia() << endl;
    cout << obj1.cambia() << endl;
}

```

```
‌‌ 




‌‌ 
```

#### Esercizio 3

Descrivere l'algoritmo per trovare la più lunga sottosequenza comune e indicare la complessità.
Applicarlo alle sottosequenze "ABCEAD" e "CABACADED".
```
‌‌ 







‌‌ 
```

#### Esercizio 4

Calcolare la complessità del for in funzione di n.
```cpp
for (int i=0; i <= f(n); i++) cout << i;
```

con la funzione **f** definita come segue. Indicare per esteso le relazioni di ricorrenza.

```cpp
int f(int x) {
    if (x<=0) return 1;
    int a=0;
    for(int i=0; i <= x; i++)
        a+=1;
    int b=f(x/2);
    return a + b + f(x/2);
}
```

```
‌‌ 











‌‌ 
```
#### Esercizio 5

Dare la definizione di heap con le operazioni relative e gli algoritmi che le implementano. Indicare e giustificare la complessità di questi algoritmi.

```
‌‌ 







‌‌ 
```

#### Esercizio 6

Scrivere una funzione booleana che, dato un albero generico non vuoto ad etichette di tipo int, memorizzato figlio-fratello, restituisce true se nell'albero c'è almeno un nodo tale che il suo primo e il suo secondo figlio hanno la stessa etichetta.

```
‌‌ 







‌‌ 
```

#### Esercizio 7

Descrivere il problema della torre di hanoi ed indicare un algoritmo per la sua soluzione.

```
‌‌ 







‌‌ 
```