public class Prova {
  public static void main(String[] args) {
    Spettacolo sp = new Spettacolo(5);
    Spettatore1 s1 = new Spettatore1("s1", sp);
    Spettatore2 s2 = new Spettatore2("s2", sp);
    s1.start();
    s2.start();
  }
}
