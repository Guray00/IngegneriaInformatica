package esercizio1;

public class Utente extends Thread {
  private Lavagna l;
  public Utente(String nome, Lavagna l) {
    super(nome);
    this.l = l;
  }
  public void run(){
    try {
      l.entra(this);
      Quadrato q = new Quadrato(5, 6, 7);
      l.inserisci(q);
      l.inserisci(new Cerchio(8, 9, 10));
      l.cancella(q);
      l.esci(this);
      System.out.println(l);
      System.out.println(l.log());
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    }
  }
}
