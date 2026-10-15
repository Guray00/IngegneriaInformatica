package esercizio1;

public class Cliente extends Thread {

	private Negozio n;
	
	public Cliente(Negozio n) {
		this.n = n;
	}

	public void run(){
		try {
			n.attendi();	
		} catch (InterruptedException ie){
			System.out.println("Sono stato interrotto...");
		} catch (SalaPienaException sp) {
			System.out.println("Sala piena, me ne vado.");
		}
	}
}
