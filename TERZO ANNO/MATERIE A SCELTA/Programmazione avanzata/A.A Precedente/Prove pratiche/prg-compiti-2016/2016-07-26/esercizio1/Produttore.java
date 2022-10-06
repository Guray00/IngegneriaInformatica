public class Produttore extends Thread {

	private Deposito d;
	
	public Produttore(Deposito d) {
		this.d = d;
	}
	
	public void run(){
		int i = 0;
		try {
			while(true) {
				Messaggio m = new Messaggio(getName() + " " + i++);
				d.inserisci(m);
				sleep((long)(Math.random()*2000));
			}
		} catch (InterruptedException ie) {
			System.out.println("Sono stato interrotto...");
		}
	}
}
