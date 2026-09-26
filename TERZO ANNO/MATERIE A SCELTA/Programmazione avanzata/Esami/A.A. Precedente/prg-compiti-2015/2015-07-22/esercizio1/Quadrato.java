package esercizio1;

public class Quadrato extends Forma {
  private float d;
  public Quadrato(float x, float y, float d) {
    super(x, y);
    this.d = d;
  }
  public float getDimX(){
    return d;
  } 
  public float getDimY(){
    return d;
  }
  protected String getType() {
    return "Q";
  }
}
