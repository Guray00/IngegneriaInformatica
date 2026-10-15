import java.io.*;

public class Deposito {
	
	private static int DEFAULT_DIM = 20;
	private static int PERIOD = 10000;
	private Messaggio[] dep;
	private int q;
	private BufferedWriter writer;
	private Worker w;
  private long ultimoSalvataggio;
	
	public Deposito(String n) throws IOException{
		this(n, DEFAULT_DIM);
	}
	
	public Deposito(String n, int x) throws IOException {
		dep = new Messaggio[x];
		writer = new BufferedWriter(new FileWriter(n));
		w = new Worker();
		w.start();
	}
	
	public synchronized void inserisci(Messaggio m) throws InterruptedException {
		while(pieno())
			wait();
		dep[q++] = m;
		if(pieno())
			w.interrupt();
	}
	
	private boolean pieno() {
		return q == dep.length;
	}
	
	private class Worker extends Thread {

		public void run() {
			try {
			  while(true) {
          long tmp = ultimoSalvataggio + PERIOD; 
          while(System.currentTimeMillis() < tmp && !pieno()) {
            try {
					    sleep(tmp - System.currentTimeMillis());
            } catch (InterruptedException ie) {
              // Il flag interrupted è automaticamente resettato 
              // nel momento in cui questa eccezione viene lanciata.
            }
          }
					salva();
				} 
			} catch (IOException io) {
				System.out.println("Errore di I/O");  	
			}
		}
	}
	
	private synchronized void salva() throws IOException{
		for(int i=0; i<q; i++) {
			Messaggio t = dep[i];
			String s = t.toString();
			writer.write(s);
      writer.newLine();
		} 
		q = 0;
		writer.flush();
    ultimoSalvataggio = System.currentTimeMillis();
		notifyAll();
	}
}
