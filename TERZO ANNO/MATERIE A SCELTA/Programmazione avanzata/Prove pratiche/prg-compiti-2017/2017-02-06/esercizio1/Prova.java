package esercizio1;

public class Prova {
	public static void main(String[] args) {
		Lotteria l = new Lotteria(10);
		for(int i=0; i<10; i++)
			new Giocatore(l, i).start();
	}
}
