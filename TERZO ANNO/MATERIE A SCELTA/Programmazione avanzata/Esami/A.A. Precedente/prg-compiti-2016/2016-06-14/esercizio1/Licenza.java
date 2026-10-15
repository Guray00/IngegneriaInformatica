public class Licenza {

	private int numero;
	private static int cont;
	private boolean libera;

	public Licenza(){
		numero = cont++;
		libera = true;
	}

	public boolean isLibera() {
		return libera;
	}

	public void libera(){
		libera = true;
	}

	public void occupa() {
		libera = false;
	}

	public int getNumero() {
		return numero;
	}
}
