package esercizio1;
	
public class Barbiere extends Thread {
	private Negozio n;
	public Barbiere(Negozio n) {
		this.n = n;
	}
	public void run(){
		try {
			while(true) {
				n.servi();
			}
		} catch (InterruptedException ie) {
			System.out.println("Sono stato interrotto...");
		}
	}
}
