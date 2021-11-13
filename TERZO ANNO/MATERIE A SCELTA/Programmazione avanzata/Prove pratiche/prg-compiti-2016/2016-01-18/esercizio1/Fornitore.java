package esercizio1;

public class Fornitore extends Thread {

  private Tavolo tav;

  public Fornitore(Tavolo t) {
    tav = t;
  }

  public void run(){
    try{
      while(true) {
        Ingrediente[] ii = new Ingrediente[2];
        int q = (int) (Math.random() * 3);
        ii[0] = Ingrediente.values()[(q+1)%3];
        ii[1] = Ingrediente.values()[(q+2)%3];
        tav.mettiIngredienti(ii); 
      }
    } catch(InterruptedException ie) {
      System.out.println("Sono stato interrotto..."); 
    }
  }
}
