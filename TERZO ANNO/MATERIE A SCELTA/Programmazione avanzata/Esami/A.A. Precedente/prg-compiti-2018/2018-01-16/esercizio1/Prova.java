public class Prova {
  public static void main(String[] args) {
    Deposito d = new Deposito(5, 3);
    new Robot(d).start();
    new Robot(d).start();
    new Robot(d).start();
    new Fornitore(d).start();
  }
}
