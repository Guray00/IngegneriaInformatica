public class Giocatore extends Thread {

	private Partita p;

	public Giocatore(Partita p) {
		this.p = p;
	}

	public void run() {
		try {
		Risultato r;
		int v = (int)(Math.random() * 6);
		int t = v + (int)(Math.random() * 6);
  	System.out.println(getName() + ": v=" + v + ", t="+t);
		r = p.mossa(v, t);
		System.out.println(getName() + ": " + r);
		} catch (InterruptedException ie) {
			System.err.println(ie.getMessage());
		}
	}
}
