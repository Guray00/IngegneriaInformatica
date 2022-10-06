public class Spettatore1 extends Thread {

  private Spettacolo s;

  public Spettatore1(String n, Spettacolo s) {
    super(n);
    this.s = s;
  }
  
  public void run(){
    try {
      int[] p = s.prenota(3, true);
      System.out.println(getName());
      System.out.print("ho prenotato ");
      for(int x: p)
        System.out.print(x + " ");
      Thread.sleep(2000);
      s.annulla(p);
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    }
  }
}
