package esercizio1;

public class Inseritore extends Thread {

  private Documento d;
  private int n;
  private int x;

  public Inseritore(Documento d, int n) {
    this.d = d;
    this.n = n;
  }
  
  public void run(){
    try {
      for(int i=0; i<n; i++){
        String s = generaStringa();
        d.inserisci(0, s);
        System.out.println("Ho inserito " + s);
      }
      d.rendiDefinitivo();
    } catch (InterruptedException ie){
      System.err.println(ie.getMessage());
    } catch (NonModificabileException nme) {
      System.err.println(nme.getMessage());
    }  
  }

  private String generaStringa(){
    return "prova"+x++;     
  }
}
