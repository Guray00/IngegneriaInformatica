package esercizio1;

public class Scrittore extends Thread {

  private Tabella t;
  private String k;

  public Scrittore(Tabella t, String k) {
    this.t = t;
    this.k = k;
  }

  public void run(){
    while(true) {
      try {
        t.interests(k, 1.1);
        System.out.println(getName() + ": ho aggiunto gli interessi");
      } catch(ElementoNonTrovatoException en) {
        System.out.println(en.getMessage());
      } catch(InterruptedException ie) {
        System.out.println(ie.getMessage());
      }
    }    
  }
}
