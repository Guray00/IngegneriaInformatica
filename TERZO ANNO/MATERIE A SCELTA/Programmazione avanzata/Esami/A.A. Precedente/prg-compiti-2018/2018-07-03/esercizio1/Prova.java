public class Prova {
  public static void main(String[] args) throws Exception {
    Deposito d = new Deposito();
    new Fornitore(d, new Pezzo("ABC", 123)).start();
    new Fornitore(d, new Pezzo("DEF", 666)).start();
    Thread.sleep(1000);
    new Fabbricante(d, new Descrizione[]{new Descrizione("ABC", 123),
                                         new Descrizione("DEF", 666),
                                         new Descrizione("XYZ", 999)}).start();
    Thread.sleep(1000);

    new Fabbricante(d, new Descrizione[]{new Descrizione("ABC", 123),
                                         new Descrizione("DEF", 666)}).start();
    Thread.sleep(1000);

    new Fabbricante(d, new Descrizione[]{new Descrizione("ABC", 123)}).start();

  }
}
