package esercizio1;

public class Prova {
  public static void main(String[] args) {
    String[] kk = new String[]{"ABC", "DEF", "GHI"};
    double[] vv = new double[]{10.0, 20.0, 30.0};
    Tabella tab = new Tabella(kk, vv);
    for(int i=0; i<10; i++)
      new Lettore(tab, kk[i%kk.length]).start();
    for(int i=0; i<3; i++)
      new Scrittore(tab, kk[i%kk.length]).start();
  }
}
