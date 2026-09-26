public class Giocatore extends Thread {

	// Riferimento al giocatore precedente (null per il primo)
	private Giocatore precedente;
	// Riferimento al giocatore successivo (null per l'ultimo)
	private Giocatore successivo;
	// La parola
	private String s;
	// true se ha bisbigliato la parola
	private boolean pronto;

	public Giocatore(String nome) {
		super(nome);
	}

	/* Imposta il giocatore precedente */
	public void setPrecedente(Giocatore g) {
		this.precedente = g;
	}

	/* Imposta il giocatore successivo */
	public void setSuccessivo(Giocatore g) {
		this.successivo = g;
	}


	public void run(){
	  try {
		Thread.sleep((int)(Math.random()*1000));
		if(precedente == null) {
			// Sono il primo della fila, invento una parola
			s = inventa();
		} else {
			// Non sono il primo, mi metto in ascolto
			s = precedente.ascolta();
			// Altero la parola
			s = modifica(s);
			System.out.println(Thread.currentThread() + ": ho capito " + s);
		}
		if(successivo == null) {
			// Sono l'ultimo, pronuncio a voce alta
			emetti(s);
		} else {
			// Passo la parola al successivo
			bisbiglia();
		}
   	  } catch (InterruptedException ie) {
		System.out.println("Sono stato interrotto...");
	  }
	}

	/* Metodo potenzialmente loccate. Invocato sul giocatore i-esimo dal giocatore (i+1)-esimo
   */
	public synchronized String ascolta() throws InterruptedException {
		while(!pronto)
			wait();
		return s;
	}

	/* Bisbiglia e eventualmente sblocca il giocatore successivo fermo in ascolta() */
	public synchronized void bisbiglia() {
		pronto = true;
		notify();
	}

	private String inventa() {
		String[] parole = {"Programma", "Esame", "Studente", "Compito"};
		int k = (int) (Math.random() * parole.length);
		String r = parole[k];
		System.out.println(Thread.currentThread() + ": ho inventato " + r);
		return r;
	}

	private void emetti(String s) {
		System.out.println(Thread.currentThread() + ": la parola e': " + s);
	}

	private String modifica(String s) {
		// Lunghezza della parola
		int l = s.length();
		// Indice a caso
		int k = (int) (Math.random() * l);
		// Carattere a caso
		char c = (char)(((int)(Math.random() * ('z' - 'a'))) + 'a');
		// Converto la stringa in array di caratteri
		char[] ar = s.toCharArray();
		// Ne modifico uno
		ar[k] = c;
		// Creo nuovo oggetto stringa
		return new String(ar);
	}
}
