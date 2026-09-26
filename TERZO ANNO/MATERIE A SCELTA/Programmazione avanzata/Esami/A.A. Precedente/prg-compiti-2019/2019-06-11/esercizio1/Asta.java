package es1;

public class Asta {
 
  // Descrizione del bene messo all'asta 
  protected String descrizione;
  // Durata dell'asta in secondi
  protected int durata;
  // Offerta piu' alta ricevuta
  protected float offMax;
  // Partecipante che ha fatto l'offerta piu' alta
  protected Partecipante agg;
  // Indica se l'asta e' attiva o meno
  protected boolean attiva;
  // Indica se l'asta e' terminata
  protected boolean finita;
  // Istante di inizio dell'asta
  protected long tempoInizio;
  // Aggiudica il bene allo scadere del tempo
  protected Sveglia sveglia;

  /**
   * Crea un oggetto asta
   */ 
  public Asta(String descrizione, int durata) {
    this.descrizione = descrizione;
    this.durata = durata;
    this.sveglia = new Sveglia(); 
  }  

  /**
   * Restituisce la descrizione del bene
   */
  public String getDescrizione() {
    return descrizione;
  }

  /**
   * L'asta ha inizio
   */
  public synchronized void attiva() {
    attiva = true;
    // Prende il tempo attuale come istante di inizio
    tempoInizio = System.currentTimeMillis();
    // Fa partire il thread ausiliario sveglia
    sveglia.start();
  }


  /**
   * Termina prematuramente l'asta, aggiudicando il bene al migliore offerente
   */
  public synchronized void aggiudicaAdesso() throws AstaNonAttivaException {
    if(!attiva)
      throw new AstaNonAttivaException();
    // Interrompe il thread sveglia
    sveglia.interrupt();
  }

  /**
   * Offerta del partecipante c
   * Restituisce true se l'offerta fatta e' la piu' alta, false altrimenti
   */
  public synchronized boolean offerta(float quanto, Partecipante c) throws AstaNonAttivaException {
    if(!attiva)
      throw new AstaNonAttivaException("Asta non ancora attiva");
    // Controlla se l'offerta attuale e' la piu' alta
    if(quanto > offMax) {
      offMax = quanto;
      agg = c;
      return true;
    }
    return false;
  }

  /**
   * Metodo chiamato dai partecipanti, permette loro di capire se hanno vinto
   */ 
  public synchronized boolean hoVinto(Partecipante c) throws InterruptedException {
    // Attende la fine dell'asta
    while(!finita) 
      wait();
    return c == agg;
  }

  /**
   * Aggiudica il bene al migliore offerente
   */
  private synchronized void aggiudica() {
    System.out.println("Tempo scaduto");
    finita = true;
    notifyAll();
  }
  
  class Sveglia extends Thread { 
    
    public void run(){
      try {
        // Se non l'asta non e' arrivata a scadenza o se il thread non e' stato interrotto
        // allora dorme
        while(System.currentTimeMillis() < tempoInizio + 1000*durata && !isInterrupted()) {
          sleep(tempoInizio + 1000*durata - System.currentTimeMillis());
        }          
        // Se arriva un interrupt esce dal ciclo
      } catch (InterruptedException ie) {}
      aggiudica(); 
    }
  }
  
}
