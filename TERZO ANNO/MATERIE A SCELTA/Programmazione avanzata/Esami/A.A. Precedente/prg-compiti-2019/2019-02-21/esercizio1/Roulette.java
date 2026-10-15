public class Roulette {

  private long tempoMin;
  private long tempoMax;
  private long T = 100;
  private boolean puntatePossibili;
  private int numeroVincente;
  private boolean fineGioco;

  public Roulette() {
    this(1000, 4000);
  }

  public Roulette(long tmin, long tmax) {
    tempoMin = tmin;
    tempoMax = tmax;
    puntatePossibili = true;
  }

  public synchronized boolean puntata(int x) throws PuntateNonPossibiliException, InterruptedException {
    if (!puntatePossibili)
      throw new PuntateNonPossibiliException();
    while(!fineGioco)
      wait();      
    return x == numeroVincente;
  }

  public void avvia() throws InterruptedException {
    long tempo = (long)(Math.random()*(tempoMax - tempoMin)) + tempoMin;
    for(int i=0; i<tempo; i+=T) {
      numeroVincente = generaNumero();
      System.out.println(numeroVincente);
      if(i>=tempo/2 && puntatePossibili)
        finePuntate(); 
      Thread.sleep(T);
    }
    fine();
  }

  private synchronized void finePuntate() {
    puntatePossibili = false;
    System.out.println("Rien ne va plus, les jeux sont faits!");
  }

  private synchronized void fine() {
    fineGioco = true;
    notifyAll();
  }

  public static int generaNumero() {
    return ((int)(Math.random()*37));
  }
}
