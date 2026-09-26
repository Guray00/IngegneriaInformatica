package esercizio1;

public class Bevitore extends Thread {
	Bancone b;
	
	public Bevitore(Bancone b){
		this.b = b;
	}

	public void run(){
		try {
			while(true) {
				prendiELascia();
			}
		} catch (InterruptedException ie) {
			System.out.println(getName() + ": sono stato interrotto");
		}
	}

	void prendiELascia() throws InterruptedException {
		if(Math.random()<0.5) {
			b.prendiFiasco();
			b.prendiBicchiere();
		} else {
			b.prendiBicchiere();
			b.prendiFiasco();
		}
		System.out.println(getName() + ": Bevo...");
		if(Math.random()<0.5) {
			b.lasciaFiasco();
			b.lasciaBicchiere();
		} else {
			b.lasciaBicchiere();
			b.lasciaFiasco();
		}
		System.out.println(getName() + ": lasciato");
	}
}
