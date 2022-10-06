package esercizio1;

public class Prova {
  public static void main(String[] args) {
    Lavagna l = new Lavagna(50f, 50f, 5);
    Utente u1 = new Utente("Utente 1", l);
    Utente u2 = new Utente("Utente 2", l);
    u1.start();
    u2.start();
  }
}
