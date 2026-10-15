package esercizio1;

import java.io.*;

public class Deposito {
	
	private static class Coda {
		private Object[] ar;
		private int testa, coda, quanti;
		Coda(int n) {
			ar = new Object[n];
		}
		synchronized void inserisci(Object o) throws InterruptedException {
			while(piena())
				wait();
			ar[coda] = o;
			coda = (coda+1)%ar.length;
			quanti++;
			notifyAll();
		}
		synchronized Object estrai() throws InterruptedException {
			while(vuota())
				wait();
			Object tmp = ar[testa];
			testa = (testa+1)%ar.length;
			quanti--;
			notifyAll();
			return tmp;
		}
		synchronized boolean piena() {
			return quanti == ar.length;
		}
		synchronized boolean vuota() {
			return quanti == 0;
		}
	}	

	/* Periodo con cui avvengono i salvataggi automatici */
	private final static int PERIOD = 10000;
	/* Coda dei lavori */
	private Coda codaL;
	/* Coda dei risultati */
	private Coda codaR;
	private BufferedWriter writer;
	private Worker w;
  	private long ultimoSalvataggio;
	

	public Deposito(int nl, int nr) throws IOException {
		codaL = new Coda(nl);
		codaR = new Coda(nr);
		writer = new BufferedWriter(new FileWriter("out.txt"));
		w = new Worker();
		w.start();
	}

	public void inserisciLavoro(Lavoro l) throws InterruptedException {
		codaL.inserisci(l);
	}

	public Lavoro estraiLavoro() throws InterruptedException {
		return (Lavoro) codaL.estrai();
	}

	public void inserisciRisultato(Risultato r) throws InterruptedException {
		codaR.inserisci(r);
	}

	public Risultato estraiRisultato() throws InterruptedException {
		return (Risultato) codaR.estrai();
	}

	private class Worker extends Thread {
		public void run() {
			try {
				while(true) {
          				long tmp = ultimoSalvataggio + PERIOD; 
          				while(System.currentTimeMillis() < tmp) {
            					try {
				      			sleep(tmp - System.currentTimeMillis());
            					} catch (InterruptedException ie) {
							// Eat
            					}
          				}
				  	salva();
				} 
			} catch (IOException io) {
				System.out.println("Errore di I/O");  	
			} catch (InterruptedException ie) {
				System.out.println("Interrotto");  	
			}
		}
	}
	
	private void salva() throws IOException, InterruptedException{
		while(!codaR.vuota()) {
			Risultato r = (Risultato)codaR.estrai();
			String s = r.toString();
			writer.write(s);
      			writer.newLine();
		} 
		writer.flush();
    		ultimoSalvataggio = System.currentTimeMillis();
	}
}
