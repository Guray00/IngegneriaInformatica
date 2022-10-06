public class Buffer {

  // Dimensione di default
  private static int DEFAULT_SIZE = 10;
  // Numero di messaggi contenuti nel buffer
  private int quanti;
  // Indici per le operazioni di estrazione e inserimento
  private int testa, coda;
  // Contenitore dei messaggi
  private Messaggio[] vett;
  
 
  public Buffer(int s) {
    vett = new Messaggio[s];
  }

  public Buffer() {
    this(DEFAULT_SIZE);
  }
  
  /*
   * Inserisce un messaggio nel buffer. Il chiamante si blocca nel caso in cui
   * il buffer sia pieno.
   */
  public synchronized void inserisci(Messaggio m) throws InterruptedException {
    // Se pieno mi blocco
    while(pieno())
      wait();
    // Inserisce in coda
    vett[coda] = m;
    // Aggiorna coda in modo circolare
    coda = (coda + 1) % vett.length;
    // Aggiorna quanti
    quanti++;
    // Risveglia eventuali thread bloccati 
    notifyAll();
  }
   
  /* 
   * Estrae q messaggi dalla coda. 
   * Aspetta che ci siano almeno q messaggi o meno di q se qualcuno è a priorità 
   */
  public synchronized Messaggio[] estrai(int q) throws InterruptedException, IllegalArgumentException {
    if(q > vett.length)
      throw new IllegalArgumentException();
    // Mi blocco se:
    // ci sono meno di q messaggi e nessuno di questi e' prioritario
    while(quanti < q && !presentiMessaggiAPrio(q))
      wait();    
    // Crea un array che conterra' il risultato
    q = q<quanti ? q : quanti;
    Messaggio[] res = new Messaggio[q];
    for(int i=0; i<q; i++) { 
      res[i] = vett[testa];
      testa = (testa +1) % vett.length;
    }
    // Aggiorna quanti
    quanti -= q;
    // Risveglia eventuali thread bloccati
    notifyAll();
    return res;
  }

  /* 
   * Restuisce true se uno dei primi q messaggi, partendo 
   * dalla testa, e' prioritario.
   */
  synchronized boolean presentiMessaggiAPrio(int q) {
    // Scorro i primi q mesasggi o meno di q se nel buffer ce ne sono di meno
    for(int i=testa; i!=coda && i<q; i=(i+1)%vett.length)
      if (vett[i].isPrioritario())
        return true;
    return false;
  }
  
  /*
   * Restituisce true se il buffer e' pieno, false altrimenti
   */
  public synchronized boolean pieno() {
    return quanti == vett.length;
  }

  /*
   * Restituisce true se il buffer e' vuoto, false altrimenti
   */ 
  public synchronized boolean vuoto() {
    return quanti == 0;
  } 

  /*
   * Restituisce una stringa che rappresenta lo stato del buffer 
   */
  public synchronized String toString(){
    String tmp = "";
    for(int i=testa; i!=coda; i=(i+1)%vett.length)
      tmp += vett[i].isPrioritario() ? "P" : "N";
    return tmp;
  }
}
