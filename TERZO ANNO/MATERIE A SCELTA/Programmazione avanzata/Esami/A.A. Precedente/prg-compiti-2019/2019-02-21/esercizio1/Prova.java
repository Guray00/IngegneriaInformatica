public class Prova {
  public static void main(String[] args) {
    try {
    Roulette r = new Roulette();
    for(int i=0; i<5; i++)
      new Giocatore(r, 4000).start();
    r.avvia();
    } catch (InterruptedException ie) {
      System.out.println("Sono stato interrotto...");
    }
  }
}
