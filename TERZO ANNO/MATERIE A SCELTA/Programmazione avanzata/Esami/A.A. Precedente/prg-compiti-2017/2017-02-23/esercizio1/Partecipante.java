public class Partecipante extends Thread {

  private GestoreSedie g;
  private boolean eliminato;

  public Partecipante(GestoreSedie g) {
    this.g = g;
  }

  public void run() {
    try {
      while(g.inizioTurno()) {
        g.prontoABallare();
        g.attendoMusica();
        System.err.println(getName() + ": ballo.");
        g.inizioABallare();
        g.attendoFineMusica();
        boolean presa = g.prendoSedia();
        if(!presa) {
          eliminato = true;
          break;
        }
        g.attendoEliminazioneSedia();
      }
      if(eliminato) System.out.println(getName() + ": sono stato eliminato.");
      else System.out.println(getName() + ": ho vinto.");
    } catch(InterruptedException ie) {
      System.out.println("Sono stato interrotto");
    }
  }
}
