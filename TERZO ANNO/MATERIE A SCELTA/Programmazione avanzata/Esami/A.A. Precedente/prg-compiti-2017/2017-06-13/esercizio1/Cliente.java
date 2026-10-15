package esercizio1;

public class Cliente extends Thread {
  
  private Gestore g;

  public Cliente(Gestore g) {
    this.g = g;
  }

  public void run(){
    try {
      g.seleziona(this, "AB1234");
      System.out.println("Volo selezionato");
      boolean r = g.prenota(this, 1, 'A');
      System.out.println("Prenotazione: " + r);
      sleep(2000);
      g.deseleziona(this);
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    } catch (VoloNonSelezionatoException vn) {
      System.err.println(vn.getMessage());
    } catch (VoloNonEsistenteException ne) {
      System.err.println(ne.getMessage());
    }
  } 
}
