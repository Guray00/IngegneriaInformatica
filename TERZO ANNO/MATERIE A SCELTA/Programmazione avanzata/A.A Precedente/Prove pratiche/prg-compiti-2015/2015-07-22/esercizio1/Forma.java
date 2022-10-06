package esercizio1;
  
public abstract class Forma {

  protected float x;
  protected float y;

  protected Forma(float x, float y) {
    this.x = x;
    this.y = y;
  } 

  protected float getX(){
    return x;
  }

  protected float getY(){
    return y;
  }

  public String toString(){
    return getType() + "(" + x + ", " + y + ")";
  }

  /**
   * Restituisce la dimensione della forma lungo l'asse delle x (larghezza)
   */ 
  protected abstract float getDimX();


  /**
   * Restituisce la dimensione della forma lungo l'asse delle y (altezza)
   */ 
  protected abstract float getDimY();

  /**
   * Stringa che codifica il tipo di forma: per es. "C" per cerchio, "Q" per quadrato, etc.
   */
  protected abstract String getType();
}
