public class Partita {

	private int n;

	/**
   * Crea una partita con  n giocatori.
   */
	public Partita(int n) {
		this.n = n;
	}


	public void vai() {
		Giocatore precedente = null;
		for(int i=0; i<n; i++) {
			// Crea un nuovo giocatore
			Giocatore x = new Giocatore("Giocatore" + i);
			// Imposta il suo predecessore (null per il primo della fila)
			x.setPrecedente(precedente);
			// Imposta il giocatore corrente come successivo del precedente
			if(precedente != null)
				precedente.setSuccessivo(x);
			// Aggiorno precedente
			precedente = x;
			// Il thread viene avviato
			x.start();
		}
	}

	public static void main(String[] args) {
		Partita p = new Partita(10);
		p.vai();
	}
}
