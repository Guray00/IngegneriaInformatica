import java.io.*;

public abstract class ImageProcessor {

    /* Nome del file in cui salvare il risultato */
    private String filename;
    /* Numero di flussi che devono ancora terminare */
    private int toComplete;
    /* Numero di flussi da usare */
    private int n;

    public ImageProcessor(String filename) {
        this.filename = filename;
    }

    public synchronized void process(Image i, int n) throws InterruptedException, IOException {
      // Attiva n flussi
      for(int j=0; j<n; j++)
        new Worker(i, j).start();
      this.n = n;
      toComplete = n;
      // Attende che tutti i flussi abbiano finito
      waitForComplete();
      // Salva su file
      save(i);
    }

    private void save(Image i) throws IOException {
      DataOutputStream dos = new DataOutputStream(new FileOutputStream(filename));
      dos.writeInt(i.getRows());
      dos.writeInt(i.getColumns());
      for(int x=0; x<i.getRows(); x++)
        for(int y=0; y<i.getColumns(); y++)
          dos.writeByte(i.pixel[x][y]);
    }

    // Attende che tutti i flussi abbiano finito
    private void waitForComplete() throws InterruptedException {
      while(toComplete > 0)
        wait();
    }

    // Chiamato alla fine di ogni flusso
    private synchronized void completed() {
      toComplete--;
      if(toComplete == 0)
          notify();
    }

    /* Implementato dalle sottoclassi, defiisce il tipo di elaborazione da compiere */
    protected abstract void processRow(Image i, int j);

    /* Flusso di esecuzione */
    class Worker extends Thread {

      private Image i;
      private int index;

      Worker(Image i, int index) {
        this.i = i;
        this.index = index;
      }

      public void run() {
        int r = i.getRows();
        for(int j=index; j<r; j+=n)
          processRow(i, j);
        completed();
      }
    }
}
