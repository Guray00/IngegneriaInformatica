public class ServerLicenze {

	private Licenza[] lic;
	private int disponibili;
	private int inAttesa;
	private static final int NUM_LIC = 10;

	public ServerLicenze() {
		this(NUM_LIC);
	}

	public ServerLicenze(int n) {
		lic = new Licenza[n];
		for(int i=0; i<n; i++)
			lic[i] = new Licenza();	
		disponibili = n;
	}

	public synchronized Licenza prendi(boolean prio) throws InterruptedException {
		if(prio)
			inAttesa++;
		while(disponibili == 0 || (!prio && inAttesa >0)) {
			wait();
		}
		if(prio)
			inAttesa--;
		Licenza l = null; 
		for(int i=0; i<lic.length; i++)
			if(lic[i].isLibera()) {
				l = lic[i];
				break;
			}
		l.occupa();
		disponibili--;
		return l;
	}	

	public synchronized void restituisci(Licenza l) {
		disponibili++;
		l.libera();
		notifyAll();
	}
	
	public synchronized void acquistate(int k) {
		disponibili += k;
		Licenza[] tmp = new Licenza[lic.length + k];
		for(int i=0; i<lic.length; i++)
			tmp[i] = lic[i];
		for(int i=0; i<k; i++) 
			tmp[lic.length+i] = new Licenza();
		lic = tmp;
		notifyAll();
	}
}
