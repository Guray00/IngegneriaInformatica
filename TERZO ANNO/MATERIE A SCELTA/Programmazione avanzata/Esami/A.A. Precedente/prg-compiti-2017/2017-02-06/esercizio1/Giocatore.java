package esercizio1;

public class Giocatore extends Thread {

	private Lotteria l;
	private int p;

	public Giocatore(Lotteria l, int p) {
		this.l = l;
		this.p = p;
	}
	
	public void run() {
		try {
			Biglietto b = l.prendiNumero(p);
			boolean ris = l.attendiEstrazione(new Biglietto[]{b});
			System.out.println(ris?"Ho vinto":"Non ho vinto");
		} catch(NumeroPresoException npe) { 
			System.out.println("Gia' preso");
		} catch(InterruptedException ie) {
			System.out.println("Interrotto");
		}
	}
}
