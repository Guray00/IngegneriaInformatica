package esercizio1;

public class Visualizzatore extends Thread {

  private Documento d;

  public Visualizzatore(Documento d){
    this.d = d;
  }
  
  public void run(){
    try {
      String s = d.versioneDefinitiva();
      System.out.println(s);
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    }
  }
}
