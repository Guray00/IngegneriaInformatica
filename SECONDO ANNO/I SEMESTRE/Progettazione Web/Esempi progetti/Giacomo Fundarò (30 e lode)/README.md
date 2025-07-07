# Graph Visualizer

Graph Visualizer è una piattaforma web interattiva per la **creazione, simulazione e gestione di grafi**.  
Permette di disegnare grafi, ottimizzare la disposizione dei nodi con algoritmi fisici, salvare e importare strutture.

## Funzionalità

**Creazione e Visualizzazione:**  
Si possono creare e osservare i grafi in modo intuitivo:
- Click sul canvas: aggiunge un nodo.
- Click su due nodi diversi: aggiunge un arco fra i due nodi.

**Personalizzazione:**
- Doppio click su un nodo: appare un prompt per modificare il suo peso.
- Click su un arco: appare un prompt per modificare la sua lunghezza a riposo. (gli archi si comportano come delle molle)

**Ottimizzazione:**
- Cliccando il tasto ottimizza in basso a sinistra sito applicherà un algoritmo (Goldstein-Fruchterman) per rendere il grafo più "leggibile"

**Salvataggio:**
- Puoi salvare i tuoi grafi e importarli successivamente dal tuo profilo utente.
- Ogni grafo è associato all’utente autenticato.

## Struttura del progetto

- `/html` — pagine HTML principali
- `/css` — fogli di stile per layout, temi e componenti
- `/js` — logica frontend (disegno, interazione, autenticazione, simulazione)
- `/php` — backend PHP per autenticazione, salvataggio e gestione grafi

## Consigli per gli altri studenti

-Trattate la presentazione come un business pitch: conoscete a fondo i punti di forza del progetto e illustrateli con passione. Se il tema vi interessa davvero, il professore lo noterà. Più dettagli fornite, meno domande vi farà il docente.

-Condividete gli ostacoli superati: ad esempio, rendere il canvas ad alta qualità su schermi Hi‑DPI mi ha dato filo da torcere; spiegare problemi simili e come li avete risolti dimostra spirito critico.

-Evitate un copione rigido: adattatevi a ciò che il professore visualizza a schermo, descrivendo in tempo reale le funzioni.

-Aspettatevi questo flow per la presentazione: prima esplorerà tutto il sito senza guardare il codice; poi chiederà un po' di volte «Qual è il file che fa X?». Starà a voi spiegare come avete implementato quella funzione; alla fine userà il validator su qualche file qua e là.

-Meglio piccolo ma curato: un progetto compatto che funziona vale più di uno enorme con parti rotte. Se un tasto “doveva fare X” ma non lo fa, meglio toglierlo che giustificarlo.


## Da sistemare

- Avrei dovuto dare una sistemata ai file js per riordinare le funzioni, attualmente è un po' un casino.

- Avrei dovuto implementare un tasto per eliminare i Grafi dal db.

---

**Autore:** Giacomo Fundarò
