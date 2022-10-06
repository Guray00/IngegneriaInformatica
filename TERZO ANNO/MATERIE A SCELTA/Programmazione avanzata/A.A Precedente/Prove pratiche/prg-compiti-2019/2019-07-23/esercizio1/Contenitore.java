public class Contenitore {

	// Array che contiene i valori
	protected int[] valori;
	// Numero di valori nel contenitore
	protected int quanti;
	// Numero di lettori impegnati in una operazione di verifica
	protected int lettori;
	// C'e' uno scrittore attivo
	protected boolean scrittore;

	/**
	 * Crea un contenitore con capacita' s.
	 * Inizialmente sono presenti q valori casuali compresi tra 1 e m.
	 */
	public Contenitore(int s, int q, int m) {
		valori = new int[s];
		for(int i=0; i<q; i++) {
			int k = (int) (Math.random()*m) + 1;
			inserisci(k);
		}
	}

	/**
	 * Restituisce una rappresentazione del contenitore in formato stringa
	 */
	public String toString(){
		String s = "< ";
		for(int i=0; i<quanti; i++)
			s = s + valori[i] + " ";
		s += ">";
		return s;
	}

	/**
	 * Verifica se il valore v e' presente nel Contenitore
	 */
	public boolean verifica(int v) throws InterruptedException {
		synchronized(this) {
			// Se c'e' uno scrittore attivo mi devo bloccare
			while(scrittore)
				wait();
			// Comincia una nuova operazione di verifica
			lettori++;
		}
		// Verifica vera e propria
		boolean trovato = false;
		int inizio = 0;
		int fine = quanti-1;
		while(inizio<fine) {
			int x = (inizio+fine)/2;
			if(valori[x] == v) {
				trovato = true;
  				break;
			} else if(valori[x] > v)
				fine = x - 1;
			else inizio = x + 1;
		}
		synchronized(this) {
			// La verifica e' terminata
			lettori--;
			// Se e' l'ultima verifica attiva devo risvegliare eventuali scrittori
			// bloccati
			if(lettori == 0)
				notifyAll();
		}
		return trovato;
	}

  /**
	 * Aggiunge il valore v al Contenitore
	 */
	public void aggiungi(int v) throws ContenitorePienoException, InterruptedException {
		// Se il contenitore e' pieno lancio eccezione
		if(quanti == valori.length)
			throw new ContenitorePienoException();

		synchronized(this) {
			// Se sono in corso operazioni di lettura o di scrittura devo attendere
			while(scrittore || lettori>0)
				wait();
			// Comincia una operazione di scrittura
			scrittore = true;
		}
		inserisci(v);
		synchronized(this) {
			// Fine dell'operazione di scrittura
			scrittore = false;
			// Risveglio eventuali lettori/scrittori bloccati
			notifyAll();
		}
	}

	// Inserimento vero e proprio del valore v
	private void inserisci(int v) {
		// Trova la posizione in cui deve essere inserito per mantenere il vettore
		// ordinato
		int k = trovapos(v);
		// Trasla gli elementi successivi per fare posto
		trasla(k);
		// Inserisce
		valori[k] = v;
		quanti++;
	}

	// Trova la posizione in cui deve essere inserito il nuovo valore per lasciare
	// il vettore ordinato
	private int trovapos(int v) {
		int i;
		for(i=0; i<quanti; i++)
			if(valori[i]>=v)
				break;
		return i;
	}

	// Sposta tutti i valori di una posizione
	private void trasla(int k) {
		for(int i=quanti; i>k; i--)
			valori[i] = valori[i-1];
	}
}
