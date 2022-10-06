import java.util.Random;

public class Analizzatore {

	/* La stringa da analizzare */
	private String stringa;
	/* Generatore di numeri random */
	private Random rand;
	/* I vocaboli da cercare */
	private String[] vocaboli;
	/* Mi dice se quel vocabolo e' tra quelli che devono essere ancora cercati o meno */
	private boolean[] analizzato;
	/* Numero di occorrenze dei vari vocaboli */
	private int[] occorrenze;
	/* Numero di thread da usare nella ricerca */
	private int numThreads;
	/* Quanti vocaboli rimangono da cercare */
	private int daCercare;

	/**
	 * Crea un analizzatore che lavora su una stringa random avente la lunghezza specificata
	 */
	public Analizzatore(int lung) {
		// Per generare la stringa random uso uno string builder
		StringBuilder sb = new StringBuilder(lung);
		// Creo il generatore di numeri random
		rand = new Random();
		for(int i=0; i<lung; i++)
			sb.append(getRandomChar());
		// Trasforma in stringa
		stringa = sb.toString();
	}

	/**
	 * Crea un analizzatore in cui il testo su cui devono essere eseguite
	 * le ricerche e' quello specificato dall'argomento
	 */
	public Analizzatore(String s) {
		stringa = s;
	}

	/* Genera un carattere random nell'intervallo A - Z */
	private char getRandomChar() {
		// Il metodo nextInt() restituisce un intero casuale compreso tra 0 (incluso)
		// e il valore specificato come argomento (escluso)
		return (char)('A' + rand.nextInt('Z'-'A' + 1));
	}

	/* Fa partire la ricerca dei vocaboli usando un numero di thread pari a numThreads */
	public void cerca(String[] vocaboli, int numThreads) {
		this.vocaboli = vocaboli;
		daCercare = vocaboli.length;
		occorrenze = new int[daCercare];
		analizzato = new boolean[daCercare];
		this.numThreads = numThreads;
		// Attiva i thread
		for(int i=0; i<numThreads; i++) {
			new Cercatore().start();
		}
	}

	/* Stampa la lista dei vocaboli affiancata dal numero di occorrenze di ciascun vocabolo */
	public synchronized void stampaRisultato() throws InterruptedException {
		// Attende che tutti abbiano finito
		while(!finito())
			wait();
		for(int i=0; i<vocaboli.length; i++)
			System.out.println(vocaboli[i] + ": " + occorrenze[i]);
	}

	/* Restituisce true se non ci sono piu' vocaboli da cercare, false altrimenti */
	private synchronized boolean finito() {
		return daCercare == 0;
	}

	/* Chiamato ogni volta che un thread ha terminato la ricerca di un vocabolo */
	private synchronized void fatto() {
		daCercare--;
		notify();
	}

	/* Restituisce l'indice di un vocabolo da cercare, -1 se non c'e' piu' niente da cercare */
	private synchronized int indiceVocabolo() {
		// Scorro i vocaboli
		for(int i=0; i<analizzato.length; i++)
			// Se il vocabolo i-esimo deve essere ancora cercato restituisco i e metto
			// il booleano corrispondente a true
			if(!analizzato[i]) {
				analizzato[i] = true;
				return i;
			}
		return -1;
	}

	/* Restituisce il numero di occorrenze di ago in pagliaio */
	public static int cercaVocabolo(String pagliaio, String ago) {
		int startIndex = 0;
		int count = 0;
		for(;;) {
			// Trovo la prima occorrenza a partire da startIndex
			int pos = pagliaio.indexOf(ago, startIndex);
			if(pos<0)       // Se <0 vuol dire che non presente
				return count;
			count++;				// ho trovato una nuova occorrenza: aggiorno contatore e indice
			startIndex = pos + 1;
		}
	}

  // Questa soluzione si basa su una classe interna, ma si poteva anche usare una classe
	// totalmente separata
	class Cercatore extends Thread {
		public void run(){
			int k;
			// Cicla finche' ci sono vocabili da cercare
			while((k=indiceVocabolo()) >= 0) {
				// Prende il vocabolo da cercare
				String v = vocaboli[k];
				System.out.println(getName() + ": cerco " + v);
				// Trova il numero di occorrenze
				int r = cercaVocabolo(stringa, v);
				occorrenze[k] = r;
				fatto();
			}
		}
	}

}
