public class Deposito {

  private final int[] quantita;
  private final int n;
  private final int m;
  private int tot;

  public Deposito(int n, int m) {
    quantita = new int[n];
    this.n = n;
    this.m = m;
  }

  public int getNumeroPezzi(){
    return n;
  }

  /*
   * Gli elementi di p che valgono true indicano i pezzi gia' posseduti dal robot, quelli
   * che valgono false i pezzi mancanti.
   * Il metodo restituisce true se almeno uno dei pezzi che mancano al robot e'
   * presente nel deposito.
   */
  private boolean pezziDisponibili(boolean[] p) {
    boolean ris = false;
    for(int i=0; i<p.length; i++)
      if(!p[i])
        ris |= quantita[i]>0;
    return ris;
  }

 /*
  * Prende un pezzo tra quelli che mancano al robot.
  * Restituisce l'indice del tipo di pezzo (zero-based)
  */
  public synchronized int prendi(boolean[] p) throws InterruptedException {
    while(!pezziDisponibili(p))
      wait();
    for(int i=0; i<p.length; i++)
      if(!p[i] && quantita[i] > 0) {
        quantita[i]--;
        tot--;
        notifyAll();
        return i;
      }
    return -1;
  }

 /*
  * Deposita un nuovo pezzo.
  */
  public synchronized void deposita() throws InterruptedException {
    while(tot == n*m)
      wait();
    tot++;
    int start = (int)(n * Math.random());
    for(int i=0; i<n; i++)
      if(quantita[(start + i)%n] == 0) {
        quantita[(start + i)%n]++;
        System.out.println("Ho depositato " + (start + i)%n);
        notifyAll();
        return;
      }
    for(int i=0; i<n; i++)
      if(quantita[(start + i)%n] < m) {
        quantita[(start + i)%n]++;
        System.out.println("Ho depositato " + (start + i)%n);
        notifyAll();
        return;
      }
  }
}
