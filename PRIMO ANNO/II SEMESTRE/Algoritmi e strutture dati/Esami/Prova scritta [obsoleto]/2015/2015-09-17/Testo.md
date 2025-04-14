## Algoritmi e strutture dati - 17 settembre 2015

#### Esercizio 1

Scrivere una funzione ricorsiva che stampa i nodi di uno heap in ordine simmetrico.

```
‌‌ 







‌‌ 
```

#### Esercizio 2

Siano date le due stringhe "XYZXZXY" e "XXYZXYY":

1. Trovare, utilizzando l'algoritmo di programmazione dinamica visto a lezione la lunghezza della più lunga sottosequenza comune alle due stringhe e tutte le sottosequenze di lunghezza massima.
2. Descrivere a parole l'algoritmo utilizzato e calcolarne la complessità


\# |\# |x  |y  |z  |x  |z  |x  |y  
:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:
\# |   |   |   |   |   |   |   |   
x  |   |   |   |   |   |   |   |   
x  |   |   |   |   |   |   |   |   
y  |   |   |   |   |   |   |   |   
z  |   |   |   |   |   |   |   |   
x  |   |   |   |   |   |   |   |   
y  |   |   |   |   |   |   |   |   
y  |   |   |   |   |   |   |   |   

```
Lunghezza della PLSC:
PLSC:
‌‌ 






‌‌ 
```

#### Esercizio 3

Indicare l'uscita del seguente programma:

1. Così come è scritto
2. Togliendo la funzione stampa della classe B

Indicare le funzioni che vengono chiamate e spiegare il risultare dei due programmi

```cpp
class A {
    protected:
        int x;
        int y;
    public:
        A() { x=1; y=2;}
        void stampa() { cout << x << '\t' << y << endl;}
};

class B: public A {
    int y;
    public:
        B() {x=3; y=4;}
        void stampa() {cout << x << '\t' << y << endl;}
};

int main() {
    B* obj = new B;
    obj->stampa();
}

```

```
‌‌ 





‌‌ 
```

#### Esercizio 4

Calcolare la complessità in funzione di n dell'istruzione

```cpp
y = g(f(n));
```

con le seguenti definizioni di funzione. Indicare le eventuali relazioni di ricorrenza e spiegare brevemente il calcolo della complessità dei cicli.

```cpp
int f(int x) {
    if (x <= 1) return 1;
    int a=0; int b=0;
    for (int i=1; i<=x; i++)
        a++;
    for(int i=1; i<=x*x; i++)
        b++;
    cout << f(x-1)+a+b;
    return a+b;
}

int g(int x) {
    if (x<=1) return 10;
    int b=0;
    for (int i=1; i<=f(x); i++)
        b+=1;
        return b+g(x/2)+g(x/2);
}

```

#### Esercizio 5

Descrivere l'algoritmo heapsort e indicare e giustificare la sua complessità.ù

```
‌‌ 







‌‌ 
```

#### Esercizio 6

Scrivere una funzione che, dato un albero generico non vuoto ad etichette di tipo int, memorizzato figlio-fratello, cancella l'ultimo figlio di ogni nodo se è una foglia.

```
‌‌ 







‌‌ 
```

#### Esercizio 7

Descrivere il metodo di ricerca hash discutendo le possibili scelte. Fornire un esempio di collisione e un esempio di agglomerato.

```
‌‌ 







‌‌ 
```
