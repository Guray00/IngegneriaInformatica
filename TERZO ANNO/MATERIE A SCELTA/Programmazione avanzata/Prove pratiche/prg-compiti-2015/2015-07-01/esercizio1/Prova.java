package esercizio1;

public class Prova {
  public static void main(String[] args) {
    Documento d = new Documento(50);
    Inseritore i = new Inseritore(d, 5);
    i.start();
    Visualizzatore v = new Visualizzatore(d);
    v.start();
  }
}
