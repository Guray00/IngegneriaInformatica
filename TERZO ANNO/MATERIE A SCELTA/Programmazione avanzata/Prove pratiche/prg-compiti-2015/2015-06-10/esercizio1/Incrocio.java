package esercizio1;

public class Incrocio {
 
  // Intervallo tra una commutazione e l'altra 
  static final long T = 10000;
  // Istante in cui è avvenuta l'ultima commutazione
  private long ultimoCambiamento;
  // Incrocio occupato
  private boolean occupato;
  // Thread che esegue le commutazioni
  private Commutatore com;
  // Bus in attesa lungo le due direzioni
  private int[] busInAttesa;
  // Stato del semaforo
  // Valore - Oriz. - Vert. 
  // 0 -> V R
  // 1 -> G R
  // 2 -> R V
  // 3 -> R G
  private int stato = -1;  

  public Incrocio(){
    busInAttesa = new int[2];
    cambiaStato();
    com = new Commutatore();
    com.start();
  }

  /* 
   * Restituisce il colore lungo le due direzioni in funzione dello stato corrente
   */
  private Colore getColore(Direzione d) {
    switch(stato) {
      case 0: if(d == Direzione.orizzontale) return Colore.verde;
              else return Colore.rosso;
      case 1: if(d == Direzione.orizzontale) return Colore.giallo;
              else return Colore.rosso;
      case 2: if(d == Direzione.orizzontale) return Colore.rosso;
              else return Colore.verde;
      case 3: if(d == Direzione.orizzontale) return Colore.rosso;
              else return Colore.giallo;
    } 
    return null;
  }

  /*
   * Arriva un nuovo veiclo.
   */
  public synchronized void arrivo(Direzione d, TipoVeicolo tv) throws InterruptedException {
    System.out.println("Arrivo");
    if(tv == TipoVeicolo.bus) {
      busInAttesa[d.ordinal()]++;
      com.interrupt();
    }
    // Se l'incrocio è occupato o se il semaforo non è verde mi fermo.
    while(occupato || getColore(d) != Colore.verde) {
      System.out.println("Mi fermo");
      wait();
    }
    if(tv == TipoVeicolo.bus) {
      busInAttesa[d.ordinal()]--;
    }
    occupato = true;
  }
  
  /*
   * Il veicolo che occupa l'incorocio lo libera.
   */ 
  public synchronized void esco() {
    System.out.println("Esco");
    occupato = false;
    notifyAll();
  }

  /*
   * Muove il semaforo nello stato successivo.
   * Registra l'istante in cui avviene il cambiamento.
   */
  private synchronized void cambiaStato(){
    ultimoCambiamento = System.currentTimeMillis();
    stato = (stato + 1) % 4;
    System.out.println("Colori = [" + getColore(Direzione.orizzontale) + " " + getColore(Direzione.verticale) + "]");
    notifyAll();
  }

  /*
   * Restituisce true se e' necessario "velocizzare" il verde.
   */
  private synchronized boolean prioritaBus() {
    System.out.println(stato + " " + busInAttesa[0] + " " + busInAttesa[1]);
    return (stato == 0 && busInAttesa[0] == 0 && busInAttesa[1] > 0) || 
           (stato == 2 && busInAttesa[1] == 0 && busInAttesa[0] > 0);
  }
  
  /*
   * Ogni T millisecondi cambia lo stato del semaforo. 
   * Se viene interrotto, dall'arrivo di un bus, controlla se e'
   * necessario "velocizzare" il verde e nel caso cambia stato senza attendere
   * la fine del periodo.
   */
  private class Commutatore extends Thread {

    public void run(){
      while(true) {
        long adesso = System.currentTimeMillis();
        long quantoTempo = T - (adesso - ultimoCambiamento);
        try {
          Thread.sleep(quantoTempo);
        } catch (InterruptedException ie) {
          System.out.println("Interrotto...");
          if(!prioritaBus())
            continue;      
        } 
        cambiaStato();  
      }
    }
  } 
}
