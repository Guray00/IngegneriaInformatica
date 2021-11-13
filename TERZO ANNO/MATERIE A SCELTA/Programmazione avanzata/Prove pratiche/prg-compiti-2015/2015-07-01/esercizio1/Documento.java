package esercizio1;

public class Documento {
  
  // Array in cui vengono memorizzati i caratteri del documento
  private char buf[];
  // Dimensione corrente del documento  
  private int len;
  // Stato del documento (non definitivo / definitivo)
  private boolean definitivo;

  /*
   * Crea un documento di diemsione massima pari a m
   * e inizialmente vuoto
   */
  public Documento(int m) {
    buf = new char[m];
    len = 0;
  }

  /*
   * Crea un documento con dimensione massima pari a 100
   *  e inizialmente vuoto 
   */
  public Documento() {
    this(100);
  }
 
  /*
   * Rimuove dal documento d caratteri a partire dalla posisione pos.
   * Se ci sono meno di d caratteri rimuove quelli che ci sono.
   */ 
  public synchronized void cancella(int pos, int d) throws NonModificabileException {
    for(int i=pos; i+d < len; i++)
      buf[i] = buf[i+d];
    len = len-d > pos ? len-d : pos;
    notifyAll();
  }

  /*
   * Inserice i caratteri della stringa s partendo dalla posizione pos.
   *
   */
  public synchronized void inserisci(int pos, String s) throws NonModificabileException, InterruptedException{
    // Numero dei caratteri da inserire
    int n = s.length();
    // Se non c'e' abbstanza spazio mi blocco
    while(buf.length < len+n)
      wait();
    // Faccio scorrere i caratteri in modo da liberare n posizioni a partire da pos
    for(int i=len-1; i>=pos; i--) 
      buf[i+n] = buf[i];
    // Copio i caratteri della stringa
    for(int i=0; i<n; i++)
      buf[pos+i] = s.charAt(i);
    // Aumento la dimensione del documento
    len += n;
  }
  
  public synchronized String dammi(int pos, int n) throws NonModificabileException {
    String r = new String(buf, pos, n);
    return r;
  }

  /*
   * Rende definitivo il documento rivegliando eventuali thread bloccati
   */
  public synchronized void rendiDefinitivo() {
    definitivo = true;
    notifyAll();
  }

  /*
   * Restituisce la versione definitiva del documento. 
   */
  public synchronized String versioneDefinitiva() throws InterruptedException {
    // Fino a che non e' definitivo mi blocco
    while(!definitivo)
      wait();
    return toString();
  }
  
  /*
   * Restituisce il documento in formato stringa:
   * dimensione_attuale/dimensione_massima contentuto 
   */
  public synchronized String toString(){
    return len+"/"+buf.length + " " + new String(buf, 0, len);
  }
}
