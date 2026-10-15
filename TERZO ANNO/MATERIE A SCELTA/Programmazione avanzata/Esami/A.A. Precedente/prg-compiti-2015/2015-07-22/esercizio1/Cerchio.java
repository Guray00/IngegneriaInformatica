package esercizio1;

public class Cerchio extends Forma {
  private float r;
  public Cerchio(float x, float y, float r) {
    super(x, y);
    this.r = r;
  }
  public float getDimX(){
    return 2*r;
  }
  public float getDimY(){
    return 2*r;
  }
  public String getType(){
    return "C";
  }
}
