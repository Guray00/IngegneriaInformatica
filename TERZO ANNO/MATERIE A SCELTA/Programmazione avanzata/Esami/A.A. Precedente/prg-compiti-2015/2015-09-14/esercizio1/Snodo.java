package esercizio1;

public class Snodo {

  static class Coda{
    private int testa;
    private int coda;
    private int quanti;
    private Messaggio[] mes;

    Coda(int n){
      mes = new Messaggio[n];
    }

    synchronized boolean vuota(){
      return quanti == 0;
    }

    synchronized boolean piena(){
      return quanti == mes.length;
    }
    
    synchronized void inserisci(Messaggio m) throws InterruptedException {
      while(piena())
        wait();
      mes[coda] = m;
      coda = (coda + 1) % mes.length;
      quanti++;
      notifyAll();
    }

    synchronized Messaggio estrai() throws InterruptedException {
      while(vuota())  
        wait();
      Messaggio m = mes[testa];
      testa = (testa + 1) % mes.length;
      quanti--;
      notifyAll();
      return m;
    }
  }

  private static final int DEFAULT_DIM = 10;
  private Coda[] ingresso;
  private Coda[] uscita;

  public Snodo(int i, int u, int n) {
    ingresso = new Coda[i];
    for(int x=0; x<i; x++) {
      ingresso[x] = new Coda(n);
    }
    uscita = new Coda[u];
  }

  public Snodo(int i, int u) {
    this(i, u, DEFAULT_DIM);
  }

  public synchronized void collega(int i, int u) {
    if(i<0 || i>=ingresso.length || u<0 || u>=uscita.length)
      throw new CollegamentoException("Ingresso o uscita non esistente");
    uscita[u] = ingresso[i];
  }

  public synchronized void inserisci(Messaggio m, int i) throws InterruptedException {
    ingresso[i].inserisci(m);
  }
  
  public synchronized Messaggio estrai(int u) throws InterruptedException {
    if(uscita[u] == null)
      throw new CollegamentoException("Uscita non collegata");
    return uscita[u].estrai(); 
  }
}
