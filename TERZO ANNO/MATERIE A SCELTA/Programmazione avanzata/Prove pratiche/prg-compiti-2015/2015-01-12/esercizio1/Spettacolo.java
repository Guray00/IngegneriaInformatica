public class Spettacolo {
  
  // Numero di posti di default di uno spettacolo
  private static final int POSTI_DEFAULT = 100;

  // Posti liberi rimanenti
  private int postiLiberi;

  // Indica se il posto i-esimo e' occupato (true) o libero (false)
  private boolean[] posto;

  // Numero di abbonati bloccati su una prenota
  private int abbonatiInAttesa;
 
  public Spettacolo(int p) {
    postiLiberi = p;
    posto = new boolean[p];
  }

  public Spettacolo() {
    this(POSTI_DEFAULT);
  }

  public synchronized int[] prenota(int q, boolean abbonato) throws InterruptedException {
    if(abbonato) 
      abbonatiInAttesa++;
    while(postiLiberi < q || (!abbonato && abbonatiInAttesa > 0))
      wait();
    if(abbonato)
      abbonatiInAttesa--;
    int j = 0;
    int[] res = new int[q];
    for(int i=0; i<posto.length && j<q; i++) {
      if(!posto[i]) {
        posto[i] = true;
        res[j++] = i;
      }
    }
    postiLiberi -= q;
    return res;
  }

  public synchronized void annulla(int[] v) {
    postiLiberi += v.length;
    for(int x: v)
      posto[x] = false;
    notifyAll();
  }
}
