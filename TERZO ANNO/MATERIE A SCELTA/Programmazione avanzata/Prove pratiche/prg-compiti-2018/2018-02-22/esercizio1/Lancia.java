public class Lancia {
	public static void main(String[] args) {
		Partita p = new Partita();
		Giocatore g1 = new Giocatore(p);
		Giocatore g2 = new Giocatore(p);
		g1.start();
		g2.start();
	}
}
