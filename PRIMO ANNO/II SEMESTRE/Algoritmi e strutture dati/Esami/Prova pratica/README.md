# Prova pratica di programmazione in C++

## Download dei testi di esame

È possibile scaricare la cartella utilizzando il seguente comando:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/Guray00/IngegneriaInformatica/master/PRIMO%20ANNO/II%20SEMESTRE/Algoritmi%20e%20strutture%20dati/Esami/Prova%20pratica/download.sh | sh
```

Assicurarsi di avere `curl` e `git` installati sul proprio sistema.

## Uso dello script evaluate.sh

Lo script `evaluate.sh` consente di valutare le soluzioni degli esercizi. È necessario disporre di un compilatore come `clang` o `gcc` aggiornato al supporto di C++17, per cui è sufficiente una versione di Ubuntu maggiore o uguale della 18.04 LTS. Lo script verifica la correttezza delle soluzioni e non la loro efficienza. Per eseguirlo, aprire il terminale ed entrare nella cartella dell'esercizio desiderato:

```bash
cd <cartella-esercizio>
```

quindi eseguire lo script con il comando:

```bash
bash evaluate.sh <sorgente.cpp>
```

Lo script compila il file sorgente e lo esegue con diversi input di test, evidenziando le eventuali differenze tra l'output atteso e quello ottenuto in caso di errori. Ogni esercizio include una proposta di soluzione, che non è stata necessariamente fornita dal docente. Si noti che alcune soluzioni più datate, contrassegnate col suffisso `deprecated`, possono essere ignorate. Nel caso si provi a compilarle ed esse non compilino, provare ad inserire il flag `-std=c++98`:

```bash
g++ -std=c++98 soluzione_deprecated.cpp -o soluzione_deprecated
```

## Metodi di soluzione

Molti esercizi possono essere risolti adattando la logica di inserimento all'algoritmo richiesto. Tuttavia, la pratica corretta prevede di implementare l'algoritmo su una struttura dati preesistente, senza manipolarne la logica di inserimento. Ad esempio, l'inserimento in un albero binario ha una complessità $O(n^2)$, e i vincoli di complessità si applicano indipendentemente dall'inserimento.

Le soluzioni proposte cercano di evitare campi intrusivi, ove non esplicitamente richiesto, ma preferiscono riempire strutture dati ausiliarie come hash map o hash set, che offrono complessità costante per inserimento, cancellazione e ricerca. È possibile comunque utilizzare campi intrusivi per semplificare la soluzione, ma in un contesto reale è consigliabile mantenere la struttura dati originale inalterata.

Per l'implementazione delle hash table con il metodo della concatenazione, gestire i puntatori in C++ può risultare complesso e incline a errori. Di seguito alcuni esempi di come strutturare le hash table:

```cpp

struct T { .. }

// Uso di puntatori a puntatori, T conterra al suo interno un campo T* next
T **table = new T*[size];

// Uso di unique_ptr per una gestione automatica della memoria, layout in memoria equivalente al caso precedente.
// Anche in questo caso T* rappresenta un puntatore a un elemento che a sua volta conterrà il puntatore all'elemento successivo
std::unique_ptr<T*[]> table = std::make_unique<T*[]>(size);

// Si può usare anche vector, sempre con la lista concatenata intrusiva
std::vector<T*> table(size);

// Implementazione con vector di liste non intrusive, T in questo caso non contiene il puntatore all'elemento successivo, essendo
// ciò gestito dal container list
std::vector<std::list<T>> table(size);

// Si può rimpiazzare la list ancora una volta con un vector
std::vector<std::vector<T>> table(size);

```

Si raccomanda l'uso di `std::vector` anche per gli elementi della tabella hash poiché, a meno di casi specifici come rimozioni nel mezzo alla collezione, una lista concatenata in pratica non supera mai in performance un vettore, che risulta anche più semplice da utilizzare. Il numero di collisioni della i-esima entry della tabella hash corrisponde alla lunghezza del vettore in posizione i-esima.


## Nota sul contenuto della cartella

Le soluzioni della prova pratica devono essere compatibili in sede d'esame con C++03; i costrutti di c++11 o versioni successive non saranno accettati e genereranno errori di compilazione nella VM utilizzata all'esame. Per le soluzioni compatibili con il standard c++03 (vecchissimo, considerando che lo standard di default di g++-15 è c++17), fare riferimento ai file con nome soluzione_updated.cpp.