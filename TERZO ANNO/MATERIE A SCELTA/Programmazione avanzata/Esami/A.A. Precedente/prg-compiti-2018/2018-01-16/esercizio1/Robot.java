public class Robot extends Thread {

  private Deposito d;
  private boolean[] presente;

  public Robot(Deposito d) {
    this.d = d;
    presente = new boolean[d.getNumeroPezzi()];
  }

  private boolean completo() {
    boolean ris = true;
    for(int i=0; i<presente.length; i++)
      ris &= presente[i];
    return ris;
  }

  public void run() {
    try {
      while(true) {
        if(!completo()) {
          int x = d.prendi(presente);
          presente[x] = true;
        } else {
          System.out.println(getName() + ": prodotto.");
          for(int i=0; i<presente.length; i++)
            presente[i] = false;
        }
      }
    } catch (InterruptedException ie) {
      System.err.println(ie.getMessage());
    }
  }
}
