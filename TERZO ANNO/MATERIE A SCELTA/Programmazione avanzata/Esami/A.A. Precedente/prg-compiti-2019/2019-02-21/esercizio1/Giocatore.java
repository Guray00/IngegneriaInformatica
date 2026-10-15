public class Giocatore extends Thread {
  
  private Roulette r;
  private long t;

  public Giocatore(Roulette r, long t) {
    this.r = r;
    this.t = t;
  }

  public static int generaNumero() {
    return ((int)(Math.random()*36)) + 1;
  }


  public void run(){
    try {
      int n = generaNumero();
      Thread.sleep((long)(Math.random()*t));
      System.out.println(getName() + ": punto sul " + n);
      boolean vinto = r.puntata(n);
      System.out.println(getName() + (vinto ? ": ho" : ": non ho") + " vinto");
    } catch (PuntateNonPossibiliException pne) {
      System.out.println(getName() + ": troppo tardi...");
    } catch (InterruptedException ie) {
      System.out.println(getName() + ": sono stato interrotto...");
    }
  }
}
