public class Spettatore2 extends Thread {

  private Spettacolo s;

  public Spettatore2(String n, Spettacolo s) {
    super(n);
    this.s = s;
  }
  
  public void run(){
    try {
      Thread.sleep(1000);
      int[] p = s.prenota(3, true);
      System.out.println(getName());
      System.out.print("ho prenotato ");
      for(int x: p)
        System.out.print(x + " ");
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    }
  }
}
