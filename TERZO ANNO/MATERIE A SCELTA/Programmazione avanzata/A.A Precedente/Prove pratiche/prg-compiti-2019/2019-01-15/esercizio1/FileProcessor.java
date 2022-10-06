import java.io.*;

public abstract class FileProcessor {

    /* Nome del file contenente i dati di ingresso */
    private String filenameInput;
    /* Numero di flussi che devono ancora terminare */
    private int toComplete;
    /* Flussi ausiliari */
    private Worker w1;
    private Worker w2;
    /* Numero di blocchi */
    private long numberOfBlocks;
    /* Lunghezza del file in byte */
    private long fileLength;
    /* Array che contiene i risultati */
    private byte[] res;

    /* Crea un FileProcessor che lavora sul file indicato come argomento */
    public FileProcessor(String filenameInput) throws FileNotFoundException, IOException {
        this.filenameInput = filenameInput;
        // Calcola la lunghezza del file
        RandomAccessFile raf = new RandomAccessFile(filenameInput, "r");
        fileLength = raf.length();
        raf.close();
        // Numero di flussi che devono ancora terminare
        this.toComplete = 2;
    }

    public synchronized byte[] process(int blocksize) throws InterruptedException, IOException {
      // Controlla che la dimensione sia un multiplo della dimensione del blocco
      boolean sizeOK = fileLength % blocksize == 0;
      if(!sizeOK) throw new IllegalArgumentException();
      // Calcola il numero di blocchi
      numberOfBlocks = fileLength / blocksize;
      // Contenitore dei risultati. Suppongo che un array sia sufficiente (in teoria il
      // file potrebbe essere cosi' grande da produrre un numero di risultati maggiore
      // della dimensione massima degli array Java).
      res = new byte[(int)numberOfBlocks];
      // Attiva due flussi: uno lavora a partire dalla testa, l'altro dalla coda.
      // Il valore booleano passato come secondo argomento determina la direzione.
      w1 = new Worker(filenameInput, true, blocksize);
      w1.start();
      w2 = new Worker(filenameInput, false, blocksize);
      w2.start();
      // Attende che i due flussi abbiano finito
      waitForComplete();
      // Restituisce il risultato
      return res;
    }

    /* Attende che tutti i flussi abbiano finito */
    private void waitForComplete() throws InterruptedException {
      while(toComplete > 0)
        wait();
    }

    /* Chiamato alla fine di ogni flusso ausiliario per indicare che ha
       completato i suoi lavori */
    private synchronized void completed() {
      toComplete--;
      if(toComplete == 0)
          notify();
    }

    /* Chiamato dai flussi ogni volta che terminano di processare un blocco.
       Restituisce true se ci sono altri blocchi da processare, false altrimenti */
    private synchronized boolean blocksAvailable() {
      numberOfBlocks--;
      return numberOfBlocks >= 0;
    }

    /* Implementato dalle sottoclassi, defiisce il tipo di elaborazione da compiere */
    protected abstract byte processBlock(byte[] block);

    /* Flusso di esecuzione */
    class Worker extends Thread {
      // true: parte dalla testa false: parte dalla coda
      private boolean direction;
      // Dimensione dei blocchi
      private int blocksize;
      // Usato per spostarsi nel file
      private RandomAccessFile r;

      // Crea un flusso ausiliario. Gli argomenti indicano: il file da cui
      // leggere, la direzione, la dimensione dei blocchi
      Worker(String filenameInput, boolean direction, int blocksize) throws FileNotFoundException, IOException{
        this.direction = direction;
        this.blocksize = blocksize;
        r = new RandomAccessFile(filenameInput, "r");
        if(!direction) {
          // Se parte dalla coda sposta il puntatore del file all'inizio
          // dell'ultimo blocco
          r.seek(r.length()-blocksize);
        }
      }

      // Legge un nuovo blocco
      void readBlock(byte[] buf) throws IOException {
        r.readFully(buf);
        if(!direction){
          // Per il flusso che va al contrario e' necessario riposizionare il
          // puntatore del file all'inzio del blocco precedente. Bisogna sottrarre
          // due volte la dimensione del blocco perche' ogni lettura di lo riporta
          // in avanti di blocksize.
          long pointer = r.getFilePointer();
          pointer = pointer - 2*blocksize;
          r.seek(pointer);
        }
      }

      public void run() {
        try {
          // Buffer per i dati del prossimo blocco
          byte[] b = new byte[blocksize];
          // Risultato
          byte c;
          // Se ci sono blocchi da processare...
          while(blocksAvailable()) {
            // Calcola l'indice del blocco e quindi anche del risultato
            int index = (int)(r.getFilePointer() / blocksize);
            // Legge il prossimo blocco
            readBlock(b);
            // Elabora il blocco e produce il risultato
            c = processBlock(b);
            // Scrive il risultato del blocco nel contenitore dei risultati globali
            res[index] = c;
          }
          // Il flusso ha terminato
          completed();
          // Chiude il file
          r.close();
        } catch (IOException ioe) {
          System.out.println(ioe.getMessage());
        }
      }
    }
}
