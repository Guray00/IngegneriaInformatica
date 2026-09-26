public class Fabbricante extends Thread {

  private Deposito d;
  private Descrizione[] dd;

  public Fabbricante(Deposito d, Descrizione[] dd) {
    this.d = d;
    this.dd = dd;
  }

  public void run(){
    Pezzo[] pp = d.prendi(dd);
    System.out.println(Thread.currentThread() + ": pezzo preso: " + pp);
  }
}
