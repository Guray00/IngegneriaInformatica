package esercizio1;

public class Pedone extends Thread {

  private Strada s;

  public Pedone(Strada s) {
    this.s = s;
  }

  public void run() {
    try {
      s.arrivaPedone();
      s.escePedone();
    } catch (InterruptedException ie) {
      // handle... 
    }
  }
}
