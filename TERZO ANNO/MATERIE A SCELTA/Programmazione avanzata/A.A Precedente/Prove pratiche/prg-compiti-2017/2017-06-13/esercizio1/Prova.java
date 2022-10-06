package esercizio1;

public class Prova {

  public static void main(String[] args) {

    final String[] d = new String[]{"AB1234", "CD9999", "XY3456"};

    Gestore g = new Gestore(d);

    Cliente c1 = new Cliente(g);
    Cliente c2 = new Cliente(g);
    Cliente c3 = new Cliente(g);
    Cliente c4 = new Cliente(g);
    c1.start();
    c2.start();
    c3.start();
    c4.start();
  }
}
