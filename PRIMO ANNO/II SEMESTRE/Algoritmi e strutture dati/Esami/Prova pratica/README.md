# Prova pratica di programmazione in C++.

## Struttura delle cartelle corrsipondenti ai vari esercizi
Le cartelle sono organizzate per corrispondere ai vari esercizi inclusi nella prova pratica.

## Uso dello script evaluate.sh
Lo script `evaluate.sh` consente di valutare le soluzioni degli esercizi. È necessario disporre di un compilatore come `clang` o `gcc` aggiornato al supporto di C++17, per cui è sufficiente una versione di Ubuntu maggiore o uguale della 18.04 LTS. Lo script verifica la correttezza delle soluzioni e non la loro efficienza. Per eseguirlo, aprire il terminale ed entrare nella cartella dell'esercizio desiderato:
```bash
cd <cartella-esercizio>
```
quindi eseguire lo script con il comando:
```bash
bash evaluate.sh <sorgente.cpp>
```
Lo script compila il file sorgente e lo esegue con diversi input di test, evidenziando le eventuali differenze tra l'output atteso e quello ottenuto in caso di errori. Ogni esercizio include una proposta di soluzione, che non è stata necessariamente fornita dal docente. Si noti che alcune soluzioni più datate, contrassegnate col suffisso `deprecated`, potrebbero non compilare correttamente con versioni recenti dei compilatori.


## Metodi di soluzione

Molti esercizi possono essere risolti adattando la logica di inserimento all'algoritmo richiesto. Tuttavia, la pratica corretta prevede di implementare l'algoritmo su una struttura dati preesistente, senza manipolarne la logica di inserimento. Ad esempio, l'inserimento in un albero binario ha una complessità $O(n^2)$, e i vincoli di complessità si applicano indipendentemente dall'inserimento.

Le soluzioni proposte cercano di evitare campi intrusivi, ove non esplicitamente richiesto, ma preferiscono riempire strutture dati ausiliarie come hash map o hash set, che offrono complessità costante per inserimento, cancellazione e ricerca. È possibile comunque utilizzare campi intrusivi per semplificare la soluzione, ma in un contesto reale è consigliabile mantenere la struttura dati originale inalterata.

Per l'implementazione delle hash table con il metodo della concatenazione, gestire i puntatori in C++ può risultare complesso e incline a errori. Di seguito alcuni esempi di come strutturare le hash table:
```cpp
template <typename T>
struct Elem {
    T key;
    Elem* next;
    Node(T key, Node* next = nullptr) : key(key), next(next) {}
};

// Uso di puntatori a puntatori
Elem **table = new Elem*[size];

// Uso di unique_ptr per una gestione automatica della memoria
std::unique_ptr<Elem<T>*[]> table = std::make_unique<Elem<T>*[]>(size);

// Uso di vector per evitare la gestione manuale dei puntatori
std::vector<Elem<T>*> table(size);

// Implementazione con vector di liste per gestire le collisioni
std::vector<std::list<T>> table(size);

```
Si raccomanda l'uso di `std::vector` per gli elementi della tabella hash poiché raramente una lista concatenata supera in performance un vettore. La struttura finale utilizzata è:

```cpp  
std::vector<std::vector<T>> table(size);
```

Questo formato consente una gestione efficace delle collisioni, dove il numero di collisioni corrisponde alla lunghezza del vettore in posizione i-esima.

