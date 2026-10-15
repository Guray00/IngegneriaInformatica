package esercizio1;

public class Auto extends Thread {

  private Strada s;

  public Auto(Strada s) {
    this.s = s;
  }

  public void run() {
    try {
      s.arrivaAuto();
      s.esceAuto();
    } catch (InterruptedException ie) {
      // handle... 
    }
  }
}
