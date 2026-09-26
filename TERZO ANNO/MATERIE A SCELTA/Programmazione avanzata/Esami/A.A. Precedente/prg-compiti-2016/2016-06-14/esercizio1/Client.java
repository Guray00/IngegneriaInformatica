public class Client extends Thread {

	private boolean prio;
	private ServerLicenze sl;

	public Client(ServerLicenze sl, boolean prio) {
		this.sl = sl;
		this.prio = prio;
	}

	public void run(){
		while(true) {
			try {
				Licenza l = sl.prendi(prio);
				System.out.println(getName() + ": ho preso licenza n. " + l.getNumero());
				sleep((int)(Math.random()*1000));
				sl.restituisci(l);
				sleep((int)(Math.random()*1000));
			} catch (InterruptedException ie) {
        System.out.println("Sono stato interrotto...");		
			}
		}
	}
}
