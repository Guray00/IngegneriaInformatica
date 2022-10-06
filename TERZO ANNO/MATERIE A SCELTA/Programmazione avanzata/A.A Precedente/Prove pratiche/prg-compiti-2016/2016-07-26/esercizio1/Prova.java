import java.io.*;

public class Prova {
	public static void main(String[] args) throws IOException {
		Deposito d = new Deposito("prova.txt");
		for(int i=0; i<5; i++)
			new Produttore(d).start();
	}
}