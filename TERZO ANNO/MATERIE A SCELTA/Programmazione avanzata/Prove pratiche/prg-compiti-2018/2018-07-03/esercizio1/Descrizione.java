public class Descrizione {

  private String produttore;
  private int numero;

  public Descrizione(String p, int n) {
    produttore = p;
    numero = n;
  }

  public boolean corrisponde(Pezzo pez) {
    return corrispondeProd(pez.getProduttore()) &&
           corrispondeNum(pez.getNumero());
  }

  private boolean corrispondeProd(String pezProd) {
    return produttore.equals(pezProd);
  }

  private boolean corrispondeNum(int pezNum) {
    return numero == pezNum;
  }
}
