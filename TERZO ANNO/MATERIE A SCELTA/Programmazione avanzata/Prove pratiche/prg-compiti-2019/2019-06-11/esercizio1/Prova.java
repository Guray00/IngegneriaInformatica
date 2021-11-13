package es1;

public class Prova {
  public static void main(String[] args) {
    try {
      Asta a = new Asta("Guernica", 5);
      a.attiva();
      Partecipante p1 = new Partecipante(a);
      Partecipante p2 = new Partecipante(a);
      p1.start();
      p2.start();
      a.aggiudicaAdesso(); 
    } catch (AstaNonAttivaException e){
      System.err.println("Asta non attiva");
    }
  }
}
