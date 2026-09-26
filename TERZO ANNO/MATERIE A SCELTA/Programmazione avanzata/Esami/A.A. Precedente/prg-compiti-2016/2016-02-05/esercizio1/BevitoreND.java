package esercizio1;

public class BevitoreND extends Bevitore {
	
	public BevitoreND(Bancone b){
		super(b);
	}

	void prendiELascia() throws InterruptedException {
		b.prendiFiasco();
		b.prendiBicchiere();
		System.out.println(getName() + ": Bevo...");
		b.lasciaFiasco();
		b.lasciaBicchiere();
		System.out.println(getName() + ": lasciato");
	}
}
