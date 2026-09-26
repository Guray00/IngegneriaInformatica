package esercizio1;

public class Coda {

	private int testa, coda;
	private int quanti;
	private final Task[] buffer;
	private int numWorker;
	private final int min, max;

	public Coda(int n, int min, int max) {
		buffer = new Task[n];
		this.min = min;
		this.max = max;
		for(int i=0; i<min; i++)
			new Worker().start();
		numWorker = min;
	}

	public synchronized void inserisci(Task t) throws InterruptedException {
		while(pieno()) {
			if(numWorker < max) {
				new Worker().start();
        numWorker++;
			}
			wait();
		}
		buffer[coda] = t;
		coda = (coda+1) % buffer.length;
		quanti++;
		notifyAll();
	}

	public synchronized boolean pieno() {
		return quanti == buffer.length;
	}

	public synchronized boolean vuoto() {
		return quanti == 0;
	}

	private synchronized Task estrai()  throws InterruptedException {
		while(vuoto()) {
			if(numWorker > min) {
        numWorker--;
        return null;
      }
			wait();
		}
		Task r = buffer[testa];
		testa = (testa+1) % buffer.length;
		quanti--;
		notifyAll();
    return r;
	}


	class Worker extends Thread { 

		public void run(){
      try {
			  while(true) {
				  Task t = estrai();
				  if(t == null) {
					  break;
          }
				  t.esegui();
			  }
      } catch (InterruptedException ie) {
        System.out.println(ie.getMessage());
      }
		}

	}
	
}
