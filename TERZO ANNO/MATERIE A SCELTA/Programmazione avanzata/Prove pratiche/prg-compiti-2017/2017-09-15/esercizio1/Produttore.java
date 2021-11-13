import java.io.*;

public class Produttore extends Thread {
  
  private int o;
  private int q;
  private Memorizzatore m;

  /*
   * Inserisce q valori partendo dal numero d'ordine o.
   */
  public Produttore(int o, int q, Memorizzatore m) {
    this.m = m;
    this.o = o;
    this.q = q;
  } 

  public void run() {
    try {
      for(int i=0; i<q; i++) {
        m.deposita((float)Math.random(), o);
        o++;  
      }
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    } catch (IOException ioe) {
      System.err.println(ioe.getMessage());
    }
    System.out.println(Thread.currentThread().getName() + " ho finito");
  } 
}
