public class Cliente extends Thread {

	private Treno r;

	public Cliente(Treno r) {
		this.r = r;
	}

	public void run(){
		try {
			int k = r.prenota(5, 10000);
			System.out.println(getName() + ": ho prenotato " + k);
			sleep(5000);
			if(Math.random() < 0.5) {
			  System.out.println(getName() + ": disdico " + k);
        r.disdici(k);
      }
		} catch (InterruptedException ie) {
			System.out.println("Interrotto");
		} catch (PrenotazioneFallitaException pfe) {
			System.out.println("Prenotazione fallita");
		}
	}
}
