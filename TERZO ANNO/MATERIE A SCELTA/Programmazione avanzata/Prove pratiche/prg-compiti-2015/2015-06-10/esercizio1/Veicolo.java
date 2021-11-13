package esercizio1;

public class Veicolo extends Thread {

  Incrocio i;
  Direzione d;
  TipoVeicolo t;

  public Veicolo(Incrocio i, Direzione d, TipoVeicolo t) {
    this.i = i;
    this.d = d;
    this.t = t;
  }

  public void run() {
    try {
      i.arrivo(d, t);
      i.esco();
    } catch (InterruptedException ie) {
      // handle... 
    }
  }
}
