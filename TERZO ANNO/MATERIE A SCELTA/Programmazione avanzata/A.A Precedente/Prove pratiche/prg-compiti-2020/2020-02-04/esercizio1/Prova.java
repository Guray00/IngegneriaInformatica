public class Prova {
	public static void main(String[] args){
		Treno r = new Treno(20);
		for(int i=0; i<5; i++)
			new Cliente(r).start();
	}
}
