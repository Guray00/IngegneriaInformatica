public class Fornitore extends Thread {

  private Deposito d;
  private Pezzo oo;

  public Fornitore(Deposito d, Pezzo oo) {
    this.d = d;
    this.oo = oo;
  }

  public void run(){
    try {
    d.aggiungi(oo);
    System.out.println(Thread.currentThread() + ": pezzo aggiunto");
  } catch (InterruptedException ie) {
    System.out.println("Sono stato interrotto");
  }
  }
}
