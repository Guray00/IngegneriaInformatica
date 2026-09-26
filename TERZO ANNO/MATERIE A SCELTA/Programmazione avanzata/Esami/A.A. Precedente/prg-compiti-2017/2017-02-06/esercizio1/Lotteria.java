package esercizio1;

public class Lotteria {

	private Biglietto[] numero;
	private int venduti;
	private Biglietto estratto;
	private int n;

	public Lotteria(int n) {
		numero = new Biglietto[n];
		this.n = n;
	}

	public synchronized Biglietto prendiNumero(int p) throws NumeroPresoException {
		if(p<0 || p>=n)
			throw new IllegalArgumentException();
		if(numero[p] != null)
			throw new NumeroPresoException();
		Biglietto t = new Biglietto();
		numero[p] = t;
		venduti++;
		return t;
	}
	
	public synchronized boolean attendiEstrazione(Biglietto[] bb) throws InterruptedException {
		if(venduti == n) {
			estrai();
			notifyAll();
		}
		while(venduti != n)
			wait();
		for(int i=0; i<bb.length; i++)
			if(bb[i]==estratto)
				return true;
		return false;	
	}

	private void estrai() {
		int t = (int)(Math.random()*n);
		estratto = numero[t];
	}
}
