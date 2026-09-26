package esercizio1;

public class Pizzaiolo extends Thread {

  private Ingrediente ii;
  private Tavolo tav;

  public Pizzaiolo(Ingrediente i, Tavolo t){
    ii = i;
    tav = t;
  }

  public void run(){
    try {
      while(true) {
        tav.prendiIngredienti(ii);
        System.out.println(getName() + ": Pizzaaaa!!!"); 
        sleep(1000);
      }
    } catch (InterruptedException ie) {
      System.out.println("Sono stato interrotto...");
    }
  }
}
