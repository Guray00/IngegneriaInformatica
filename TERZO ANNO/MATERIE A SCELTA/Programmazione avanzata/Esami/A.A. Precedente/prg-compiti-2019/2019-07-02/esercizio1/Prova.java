package es1;
public class Prova {
  public static void main(String[] args) {
    Treno t = new Treno(3);
    Cliente c1 = new Cliente(t);
    c1.start();
  }
}
