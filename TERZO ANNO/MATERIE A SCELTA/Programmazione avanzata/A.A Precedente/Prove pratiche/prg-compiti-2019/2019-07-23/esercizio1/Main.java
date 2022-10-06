public class Main {
	public static void main(String[]args) throws InterruptedException {

		final int QUANTI_LET = 50;
		final int QUANTI_SCR = 1;
		final int QUANTE_OP = 30000;
		final int DIMENSIONE = 200000;
		final int NUMERO_VALORI = 170000;
		final int MAX_VAL = 1000000;

		Contenitore c = new Contenitore(DIMENSIONE, NUMERO_VALORI, MAX_VAL);
		Lettore[] l = new Lettore[QUANTI_LET];
		Scrittore[] s = new Scrittore[QUANTI_SCR];

		for(int i=0; i<QUANTI_LET; i++)
			l[i] = new Lettore(c, QUANTE_OP);
		for(int i=0; i<QUANTI_SCR; i++)
			s[i] = new Scrittore(c, QUANTE_OP);

		System.out.println("Attivo i thread");
		for(Scrittore x: s)
			x.start();
		for(Lettore x: l)
			x.start();

		long max = 0;
		long q;
		for(Lettore x: l) {
			x.join();
			q = x.quantoTempo();
			if(q > max)
				max=q;
		}
		for(Scrittore x: s) {
			x.join();
			q = x.quantoTempo();
			if(q > max)
				max=q;
		}
		System.out.println(max);
	}
}
