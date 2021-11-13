public class Lettore extends Thread {

	private int q;
	private Contenitore c;
	private long start;
	private long end;

	Lettore(Contenitore c, int q){
		this.q = q;
		this.c = c;
	}

	public void run() {
		try {
			start = System.currentTimeMillis();
			for(int i=0; i<q; i++) {
				int k = (int)(Math.random()*10000) + 1;
				c.verifica(k);
			}
			end = System.currentTimeMillis();
			System.out.println(Thread.currentThread().getName() + ": " + (end-start));
		} catch (InterruptedException ie) {
			System.err.println("Sono stato interrotto...");
		}
	}

	public long quantoTempo() {
		return end-start;
	}
}
