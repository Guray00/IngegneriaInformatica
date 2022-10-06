package esercizio1;

public class Prova {
  public static void main(String[] args) {
    Tavolo t = new Tavolo();
    Pizzaiolo p1 = new Pizzaiolo(Ingrediente.POMODORO, t);
    Pizzaiolo p2 = new Pizzaiolo(Ingrediente.MOZZARELLA, t);
    Pizzaiolo p3 = new Pizzaiolo(Ingrediente.PASTA, t);
    p1.start();
    p2.start();
    p3.start();
    Fornitore f = new Fornitore(t);
    f.start();
  }
}
