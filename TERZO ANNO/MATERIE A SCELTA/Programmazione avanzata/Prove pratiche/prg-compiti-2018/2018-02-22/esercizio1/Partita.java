public class Partita {
	
	private int[] vv = new int[] {-1, -1};
	private int[] tt = new int[] {-1, -1};
	private boolean[] rr = new boolean[2];
 
	public synchronized Risultato mossa(int v, int t) throws InterruptedException {
		int io = -1;
		if(vv[0] == -1) {
			vv[0] = v;
			tt[0] = t;
			io = 0;
			while(voti()<2)
				wait();
		} else { 
			vv[1] = v;
			tt[1] = t;
			io = 1;
			rr[io] = vv[0] + vv[1] == tt[io];
			rr[(io+1)%2] = vv[0] + vv[1] == tt[(io+1)%2];
			notify();
		}
		if(rr[io] && !rr[(io+1) % 2])
			return Risultato.vinto;
		else if(!rr[io] && rr[(io+1) % 2])
			return Risultato.perso;
		else return Risultato.pari;
	}

	private int voti() {
		return (vv[0] == -1 ? 0 : 1) + (vv[1] == -1 ? 0 : 1);
	}
}
