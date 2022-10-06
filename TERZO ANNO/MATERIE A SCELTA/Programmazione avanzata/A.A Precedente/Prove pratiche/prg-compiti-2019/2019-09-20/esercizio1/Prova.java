public class Prova {
	public static void main(String[] args) {
		try {
			// Lunghezza del testo casuale
			int l = Integer.parseInt(args[0]);
			// Numero di thread
			int q = Integer.parseInt(args[1]);
			// Gli argomenti successivi sono i vocaboli
			String[] vocaboli = new String[args.length - 2];
			for(int i=0; i<args.length-2; i++)
				vocaboli[i] = args[i+2];
			// Creo l'analizzatore
			Analizzatore d = new Analizzatore(l);
			// Comincia la ricerca
			d.cerca(vocaboli, q);
			// Stampa il risultato (eventualmente attendendo che sia pronto)
			d.stampaRisultato();
		} catch (InterruptedException ie) {
			System.out.println("Sono stato interrotto...");
		}
	}
}
