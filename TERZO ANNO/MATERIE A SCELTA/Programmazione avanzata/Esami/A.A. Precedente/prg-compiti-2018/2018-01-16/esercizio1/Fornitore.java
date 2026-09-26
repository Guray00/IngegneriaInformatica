public class Fornitore extends Thread {

  private Deposito d;

  public Fornitore(Deposito d) {
    this.d = d;
  }

  public void run() {
    try {
      while(true) {
         d.deposita();
      }
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    }
  }
}
