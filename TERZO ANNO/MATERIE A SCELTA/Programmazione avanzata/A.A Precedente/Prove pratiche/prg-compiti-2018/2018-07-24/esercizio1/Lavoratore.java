public class Lavoratore implements Runnable {

  private String nome;
  private Barriera barriera;

  Lavoratore(String n, Barriera b) {
    nome = n;
    barriera = b;
  }

  public void run() {
    while (true) {
      try {
        int quanto = (int)(Math.random() * 1000);
        Thread.sleep(quanto);
        barriera.attendi();
        System.out.println(Thread.currentThread()+": Finito");
      } catch (InterruptedException ex) {
        System.out.println(Thread.currentThread() + ": Sono stato interrotto"); return;
      } catch (BarrieraRottaException ex) {
        System.out.println(Thread.currentThread() + ": Barriera rotta"); return;
      }
    }
  }

  public static void main(String[] args) {
    final int N = 5;
    Barriera b = new Barriera(N);
    Thread[] tt = new Thread[N];
    for (int i = 0; i < N; i++) {
      tt[i] = new Thread(new Lavoratore("Lavoratore-" + i, b));
      tt[i].start();
    }
  }
}
