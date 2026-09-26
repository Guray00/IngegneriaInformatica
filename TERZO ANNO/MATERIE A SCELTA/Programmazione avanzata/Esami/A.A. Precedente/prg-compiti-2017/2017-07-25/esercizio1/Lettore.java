package esercizio1;

public class Lettore extends Thread {

  private Tabella t;
  private String k;

  public Lettore(Tabella t, String k) {
    this.t = t;
    this.k = k;
  }

  public void run(){
    while(true) {
      try {
        double r = t.read(k);
        System.out.println(getName() + ": ho letto " + r);
      } catch(ElementoNonTrovatoException en) {
        System.out.println(en.getMessage());
      }
    }    
  }
}
