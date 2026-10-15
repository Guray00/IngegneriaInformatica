package esercizio1;

public class Prova {
	public static void main(String[] arg) {
		int n = 5;
		Bancone b = new Bancone(n);
		for(int i=0; i<=n; i++) {
			new BevitoreND(b).start();
		}
	}
}
