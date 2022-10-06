package esercizio1;

public class Bancone {

	private boolean fiascoPreso;
	private int bicchieriDisp;

	public Bancone(int n) {
		bicchieriDisp = n;
	}

	public synchronized void prendiBicchiere() throws InterruptedException {
		while(bicchieriDisp == 0)
			wait();
		bicchieriDisp--;
	}

	public synchronized void lasciaBicchiere() {
		bicchieriDisp++;
		notifyAll();
	}
		
	public synchronized void prendiFiasco() throws InterruptedException {
		while(fiascoPreso)
			wait();
		fiascoPreso = true;
	}

	public synchronized void lasciaFiasco() {
		fiascoPreso = false;
		notifyAll();
	}
}
