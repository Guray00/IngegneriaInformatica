# Domande di PL
Di seguito è presente un elenco molto ampio sulle domande poste durante gli esami orali di Ricerca Operativa svolti dal docente M. Pappalardo.

### Geometria
1. Disegnare problema di PL (di massimo) illimitato superiormente e dire come il simplesso lo certifica (risposta: trattare il caso di AiW^h<0 per ogni i appartenente a N).
   
2. Disegnare un poliedro:
	- con |V|=3 e |E|= 2
	- con una funzione obiettivo per cui il minimo valore è -∞
    - con un solo elemento di E indicando l’insieme V
    - con due elementi di E conicamente indipendenti indicando l'insieme V.
    - senza vertici con |E|=1
    - senza vertici con |V|=1 e |E|=3
  
3. Disegnare un poliedro in R2 illimitato. Ci sono soluzioni di base ammissibili e degeneri?
4. Disegnare un problema in R2 con un solo vertice ottimo e una soluzione non di base ottima
5. Disegnare una soluzione di base primale non ammissibile ed una soluzione primale ammissibile non di base.
   
6.  Disegnare una soluzione di base duale ammissibile e una non ammissibile.  
    
7.  Disegnare un problema di PL(di minimo) illimitato inferiormente e dire come il simplesso lo certifica

8.  Disegnare poi un problema di PL con ottimo finito e poliedro illimitato.


### Definizioni
1. Dare la definizione di poliedro.
   - Esistono poliedri senza vertici?

2. Definizio di vertice di un poliedro.

3. Dare la definizione di una soluzione di base primale ammissibile non ottima. Costruirne una graficamente.

4. Dare la definizione e costruire graficamente una soluzione di base duale non ammissibile. Come si controlla l'ottimalità?

5. Dare la definizione di poliedro e disegnarne uno con 3 vertici e una direzione di recessione.
   
6. Dare la definizione di soluzione di base duale; dire cosa vuol dire degenere e disegnare poi una non ammissibile/ammissibile/degenere/ottima. (-> disegno: fo non nel cono di competenza).

7. Definizione di soluzione di base duale non ammissibile, non degenere e disegnarne una non ammissibile

8.  Spiegare il significato di **vertice degenere**.

9.  Definizione di **regione ammissibile**.
    
10. Definizione di **soluzione ottima**.

11. Dare la definizione di poliedro e disegnare una soluzione di base non ammissibile e degenere (primale/duale).

12. Dare la definizione di poliedro e disegnarne uno che abbia 4 elementi in V e 3 elementi in E.

13. Dare la definizione di poliedro e disegnarne uno con 3 vertici e una direzione di recessione.

14. Dare la definizione di soluzione di base primale, dire cosa significa degenere e disegnarne una ammissibile/non ammissibile e degenere/ottima/ottima non unica.

1. Illustrare le regole anticiclo di Bland per i problemi di PL


### Teoremi
1. Enunciare la **regola anticiclo di Bland** per la PL (per h e per k) e dire a cosa serve.
1. Enunciare il **teorema di Weyl** (rappresentazione dei poliedri) e dire a cosa serve.
2. Enunciare il **teorema della dualità forte** e dire a cosa serve e quando si applica.
3. Enunciare il **teorema fondamentale della PL**, fornirne una breve dimostrazione e dire a cosa serve.

4. Illustrare il **simplesso primale** e dimostrare la correttezza della scelta dell'indice h/k.
   
5.  Enunciare il **Teorema del duale ausiliari**o e indicare la base di partenza del duale ausiliario

6. Enunciare e dimostrare il **test di ottimalità** per la PL. Nel caso degenere cambia qualcosa? (-> Teorema 2.3.6. (Scarti complementari))

7. Enunciare la condizione di ottimalità della PL
   
8.  Illustrare il simplesso duale. 
	- Quante e quali regole anticiclo ci sono?
	- Dimostrare la correttezza.

### Algoritmi
1. Illustrare **l'algoritmo del simplesso duale**.
29. Descrivere l’algoritmo di caricamento per lo Zaino Binario e per lo Zaino Intero
30. Illustrare gli algoritmi che forniscono le valutazioni inferiori e superiori dei problemi dello zaino 0-1 e dello zaino intero.
27. Dire cosa è un algoritmo greedy

## Problemi
1. Scrivere il modello matematico dello Zaino

5.  Scrivere il modello matematico del problema dell'assegnamento di costo minimo. Lo si può rolvere con il simplesso su reti? Perché?
   

###  Domande generali

1. Scrivere il modello del duale ausiliario, dire a cosa serve ed enunciare il teorema che lo caratterizza. (-> Teorema 3.2.2. pg 81).

2. Scrivere il modello del duale ausiliario e dire a cosa serve.

3. Scrivere le formule dei rapporti del simplesso primale e del simplesso duale

4. Dare la definizione di assegnamento fornendo un esempio (5x5) con due assegnamenti ottimi distinti.

5. Illustrare il test di ottimalità per la PL, dire dove si utilizza e commentare il caso degenere.


6. Come si calcolando i vertici del poliedro di un problema di PL

7. Elencare i metodi per trasformare un generico problema di PL in uno standard primale ed in uno standard duale.

8. Implementando l'algoritmo del simplesso su un calcolatore, cosa dovresti fare per poter fornire al programma una base ammissibile di partenza?


    
9.  Dati diversi c dire se il problema da come soluzione -∞, +∞ o soluzione a seconda che il problema sia di massimo o minimo
   
10. Dato un c dire se una base può essere di partenza
   
11. Trovare un c e una base che sia duale ammissibile, dato un poliedro grafico. Come deve essere c per essere duale ammissibile?

13. Scrivere i comandi Linprog per un problema
14. Scrivere la coppia di problemi primale/duale ed enunciare i teoremi della dualità forte e della dualità debole
15. Dimostrare che la funzione obiettivo di un problema di PL di massimo cresce lungo opportuni spigoli
16. Dire quante soluzioni ottime può avere un problema di PL
17. Dire dove sono le soluzioni ottime e le soluzioni di base e perché
18. Dire quado un poliedro è vuoto e quando è illimitato e se si può usare Weierstrass

19. Mostrare un problema di PL, con poliedro dotato di vertici, che sia illimitato sia inferiormente che superiormente