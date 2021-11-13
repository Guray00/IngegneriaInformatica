package es1;

public class Partecipante extends Thread {

  private Asta asta;  

  public Partecipante(Asta asta) {
    this.asta = asta;
  }

  public void run() {
    try {
      boolean r = asta.offerta(100, this);
      System.out.println("Risultato dell'offerta: " + r);
      r = asta.hoVinto(this);
      System.out.println("Ho vinto: " + r);
    } catch (Exception e) {
      System.err.println("Eccezione: " + e.getMessage());
    }
  }
} 
