package esercizio1;

public class Prova {
	public static void main(String[] args) {
		  Negozio neg = new Negozio(5);
		  for(int i=0; i<10; i++)
		  	new Cliente(neg).start();
		  Barbiere b = new Barbiere(neg);
		  b.start();
	}
}
