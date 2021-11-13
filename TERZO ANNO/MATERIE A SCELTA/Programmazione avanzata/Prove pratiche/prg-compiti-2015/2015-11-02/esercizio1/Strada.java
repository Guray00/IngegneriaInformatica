package esercizio1;

public class Strada {

  /*
   * Colori del semaforo 
   */
  private enum Colore {rosso, giallo, verde};

  /* 
   * Lo stato viene codificato con un singolo intero
   * 0 verde auto, rosso pedoni
   * 1 giallo auto, rosso pedoni
   * 2 rosso auto, verde pedoni
   * 3 rosso auto, giallo pedoni
   */
  private int stato;

  /*
   * Numero di pedoni che attendono di attraversare la strada
   */
  private int numPedoniInAttesa;

  /*
   * Cambia a tempo lo stato del semaforo
   */
  private Commutatore c;

  /*
   * Tempo tra uno stato del semaforo e il successivo
   */ 
  private final long T = 5000;

  /*
   * La strada è occupata da un'auto o da un pedone
   */
  private boolean occupato;

  public Strada(){
    c = new Commutatore();
    c.start();
  }

  /* 
   * Restituisce il colore del semaforo per le auto
   */
  public Colore getColoreAuto(){
    switch(stato){
      case 0: return Colore.verde;
      case 1: return Colore.giallo;
      default: return Colore.rosso;
    }
  }
  
  /*
   * Restituisce il colore del semaforo per i pedoni
   */ 
  public Colore getColorePedoni(){
    switch(stato){
      case 2: return Colore.verde;
      case 3: return Colore.giallo;
      default: return Colore.rosso;
    }
  }

  /* 
   * Un'auto deve percorrere la strada
   */
  public synchronized void arrivaAuto() throws InterruptedException {
    System.out.println("Auto: arrivo");
    // Se la strada è occupata o il semaforo non è verde mi fermo
    while(occupato || getColoreAuto() != Colore.verde)
      wait(); 
    occupato = true;
    System.out.println("Auto: entro");
  }

  /*
   * Un pedone deve attraversare la strada
   */
  public synchronized void arrivaPedone() throws InterruptedException {
    System.out.println("Pedone: arrivo");
    numPedoniInAttesa++;
    // Se il semaforo è verde per le auto attivo il commutatore per
    // consentire il passaggio dei pedoni
    if(getColoreAuto() == Colore.verde) {
      c.vai();
    }
    // Se il semaforo per i pedoni non è verde mi fermo
    while(getColorePedoni() != Colore.verde)
      wait();
    occupato = true;
    System.out.println("Pedone: entro");
    numPedoniInAttesa--;
  }

  /*
   * Un'auto ha percorso la strada
   */
  public synchronized void esceAuto(){
    occupato = false;
    notifyAll();
    System.out.println("Auto: esco");
  }
  
  /*
   * Un pedone ha attraversato la strada
   */
  public synchronized void escePedone(){
    occupato = false;
    System.out.println("Pedone: esco");
    notifyAll();
  }

  /*
   * Passa da uno stato al successivo
   */
  private synchronized void cambiaStato(){
    stato = (stato + 1) % 4;
    System.out.println("Colori = [" + getColoreAuto() + " " + getColorePedoni() + "]");
    notifyAll();
  }


  private class Commutatore extends Thread {

    /*
     * Se il numero di pedoni in attesa è zero, si blocca
     */ 
    synchronized void aspetta() throws InterruptedException {
      while(numPedoniInAttesa == 0)
        wait();
    }

    /*
     * Attivo il commutatore in modo da permettere il passaggio dei pedoni
     */
    synchronized void vai(){
      notify();
    }

    public void run(){
      while(true) {
        try {
          aspetta();
          cambiaStato();
          Thread.sleep(T);
          cambiaStato();
          Thread.sleep(T);
          cambiaStato();
          Thread.sleep(T);
          cambiaStato();
        } catch (InterruptedException ie) {
        }
      }
    }
  }

}
