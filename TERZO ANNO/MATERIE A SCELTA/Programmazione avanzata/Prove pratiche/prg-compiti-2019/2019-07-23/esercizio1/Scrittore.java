public class Scrittore extends Thread {

	private int q;
	private Contenitore c;
	private long start;
	private long end;

	Scrittore(Contenitore c, int q){
		this.q = q;
		this.c = c;
	}

	public void run() {
		try {
			start = System.currentTimeMillis();
			for(int i=0; i<q; i++) {
				int k = (int)(Math.random()*10000) + 1;
				c.aggiungi(k);
			}
			end = System.currentTimeMillis();
			System.out.println("Scrittore: " + (end-start));
		} catch (InterruptedException ie) {
			System.err.println("Sono stato interrotto...");
		} catch (ContenitorePienoException cpe) {
			System.err.println("Contenitore pieno...");
		}
	}

	public long quantoTempo() {
		return end-start;
	}
}
