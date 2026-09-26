public class Barriera {

  // Numero di thread che si devono sincronizzare sulla barriera
  private final int n;
  // Decrementato ogni volta che un thread raggiunge la barriera
  private int contatore;
  // Contatore dei rilasci
  private int rilascio;
  // Stato della barriera
  private boolean rotta;

  public Barriera(int n) {
    this.n = n;
    this.contatore = n;
  }

  // Invocato dai thread quando arrivano alla barriera
  public synchronized void attendi() throws InterruptedException,
                                            BarrieraRottaException{
    // Decrementa il contatore
    contatore--;

    // Se la barriera e' rotta, esce con un'eccezione
    if(rotta) {
      throw new BarrieraRottaException();
    } else if(Thread.interrupted()) {
      // Il thread ha il flag interrupted attivo
      // Porta la barriera nello stato rotta
      rotta = true;
      // Sveglia tutti
      notifyAll();
      // Esce con un'eccezione
      throw new InterruptedException();
    } if (contatore == 0) {
      // E' l'ultimo thread, deve eseguire un rilascio
      contatore = n;
      rilascio++;
      // Risveglia tutti
      notifyAll();
    } else {
      // Non e' l'ultimo, si deve bloccare
      int rilascioCorrente = rilascio;
      while(true) {
        try {
          // si blocca
          wait();
        } catch (InterruptedException ie) {
          // E' stato interrotto
          if (rilascioCorrente == rilascio) {
            // Rompe la barriera
            rotta = true;
            // Sveglia tutti
            notifyAll();
            throw ie;
          } else {
            Thread.currentThread().interrupt();
          }
        }
        // E' stato risvegliato, deve capire se in modo normale o anormale
        // Risveglio anormale (un altro thread e' uscito per interrupt e
        // ha svegliato tutti)
        if(rotta)
          throw new BarrieraRottaException();

        // Risveglio normale
        if(rilascioCorrente != rilascio)
            return;
      }
    }
  }

  public synchronized void reset() {
      rotta = false;
      contatore = n;
      rilascio++;
      notifyAll();
  }

  public synchronized int inAttesa() {
    return this.n - this.contatore;
  }

  public synchronized boolean isRotta() {
    return this.rotta;
  }

}
