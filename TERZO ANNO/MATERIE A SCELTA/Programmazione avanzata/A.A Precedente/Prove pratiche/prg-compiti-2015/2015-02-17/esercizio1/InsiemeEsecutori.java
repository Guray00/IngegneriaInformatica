/* 
 * NOTA:
 * Questa soluzione include codice che consente di eseguire
 * lo shutdown dell'insieme di esecutori (in modo semplice):
 * quando viene chiamato il metodo fine(), l'insieme di esecutori 
 * si porta in uno stato in cui non accetta piu' compiti; gli 
 * esecutori portano a termine eventuali compiti in esecuzione e 
 * escono dal ciclo. 
 * Alcuni compiti in coda potrebbero non essere mandati in esecuzione
 * se viene eseguito lo shutdown. E' possibile, con qualche 
 * modifica, imporre che gli esecutori completino tutti i compiti in coda
 * prima di terminare la propria vita. Il tutto dipende, ovviamente, da 
 * quale deve essere la politica da seguire durante la fase di arresto. 
 */

public class InsiemeEsecutori {

  // Array di esecutori
  private Esecutore[] es;

  // Coda di compiti  
  private Compito[] cc;
  // Indici per l'accesso in testa e coda
  private int front, back;
  // Numero di compiti in coda
  private int quanti;
  
  // Indica se l'insieme di esecutori deve continuare ad operare
  // o fermarsi
  private boolean ancora = true;

  // Essendo classe interna ha automaticamente un riferimento
  // all'oggetto InsiemeEsecutori
  class Esecutore extends Thread {
    
    // Quando diventa false l'esecutore esce dal ciclo 
    private boolean vai = true; 
  
    public void run(){
      try {
        // Rimane nel ciclo finché non viene chiamato il
        // metodo fine() sull'insieme di esecutori
        while(vai()) {         
          // Prende il compito in testa alla coda
          Compito c = prendi();
          // Lo esegue
          c.esegui();
        }
      } catch (InterruptedException ie) {
        // Eccezioni di questo tipo vengono
        // ignorate e causano l'uscita dal ciclo
      } 
    }
    
    // Restituisce il valore di vai 
    synchronized boolean vai() {
      return vai;
    }
  
    // Ferma l'esecutore
    synchronized void ferma() {
      vai = false;
      interrupt();
    }
  }

  // Costruttore della classe InsiemeEsecutori
  public InsiemeEsecutori(int n, int s) {
    // Se uno dei parametri è invalido lancia eccezione
    if(n <= 0 || s <= 0) 
      throw new IllegalArgumentException();
    // Crea array di compiti
    cc = new Compito[s];
    // Crea array di Esecutori
    es = new Esecutore[n];
    // Crea gli esecutori e li fa partire
    for(int i=0; i<n; i++) {
      es[i] = new Esecutore();
      es[i].start();
    }
  }

  // Inserisce un compito in fondo alla coda
  public synchronized void sottometti(Compito c) throws InterruptedException {
    // Se l'insieme di esecutori è stato fermato lancia eccezione
    if(!ancora())
      throw new IllegalStateException("Insieme esecutori fermato");
    // Se la coda è piena si blocca
    while(quanti == cc.length)
      wait();
    // Inserisce in coda
    cc[back] = c;
    back = (back + 1) % cc.length;
    quanti++;
    // Sblocca esecutori
    notifyAll();
  }

  // Estrae un compito dalla testa della coda
  private synchronized Compito prendi() throws InterruptedException {
    // Se la coda è vuota si blocca
    while(quanti == 0)
      wait();
    // Estrae dalla testa
    Compito c = cc[front];
    front = (front+1) % cc.length;
    quanti--;
    // Sblocca eventuali thread bloccati su sottometti
    notifyAll();
    return c;
  }

  // Shutdown dell'insieme di esecutori
  public synchronized void fine(){
    ancora = false;
    // Interrompe Esecutori (escono da wait se bloccati)
    for(Esecutore e: es)
      e.ferma();
  }
  
  // Restituisce true se l'insieme di esecutori è in funzione
  // false se è stato eseguito shutdown
  public synchronized boolean ancora() {
    return ancora;
  }
}
