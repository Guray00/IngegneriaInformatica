package esercizio1;

public class Negozio {

	private int n;
	private int numero;
	private int inAttesa;
	private boolean inservizio;

	public Negozio(int n) {
		this.n = n;
	}

	public synchronized void attendi() throws InterruptedException, SalaPienaException {
		if(inAttesa == n) 
			throw new SalaPienaException();
		inAttesa++;
		int mioNumero = (numero + inAttesa) % (n + 1);
		System.out.println(Thread.currentThread().getName() + ": ho preso il numero " + mioNumero);
		notifyAll();
		while(mioNumero != numero) {
			wait();	
                }
		inservizio = false;
		inAttesa--;
		System.out.println(Thread.currentThread().getName() + ": ho fatto ");
		notifyAll();
	}

	public synchronized void servi() throws InterruptedException {
		while(inAttesa==0 || inservizio) {
			wait();
		}
		numero = (numero + 1) % (n + 1);
		inservizio = true;
		notifyAll();
	}
}
