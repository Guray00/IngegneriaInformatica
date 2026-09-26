public class Capobanda extends Thread {

  private GestoreSedie g;

  public Capobanda(GestoreSedie g) {
    this.g = g;
    setName("Capobanda");
  }

  public void run() {
    try {
      while(g.inizioTurno()) {
        g.aspettaTuttiProntiBallare();
        g.musicaOn();
        //sleep(100);
        g.aspettaTuttiProntiSedere();
        g.musicaOff();
        g.aspettaTuttiSeduti();
        g.diminuisciSedie();
      }
    } catch(InterruptedException ie) {
      System.out.println("Sono stato interrotto");
    }
  }
}
