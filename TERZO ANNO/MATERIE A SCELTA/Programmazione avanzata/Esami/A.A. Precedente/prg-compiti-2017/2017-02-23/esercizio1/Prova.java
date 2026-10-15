public class Prova {
  public static void main(String[] args) {
    final int q = Integer.parseInt(args[0]);
    GestoreSedie g = new GestoreSedie(q);
    for(int i=0; i<=q; i++)
      new Partecipante(g).start();
    new Capobanda(g).start();
  }
}
