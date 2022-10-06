import java.util.Objects;

public class Pezzo {

  private final String produttore;
  private final int numero;

  public Pezzo(String p, int n) {
    produttore = p;
    numero = n;
  }

  public int getNumero(){
    return numero;
  }

  public String getProduttore() {
    return produttore;
  }

  public boolean equals(Object o) {
    if(o == null)
      return false;
    if(!(o instanceof Pezzo))
      return false;
    Pezzo p = (Pezzo) o;
    return produttore.equals(p.produttore) && numero == p.numero;
  }

  public int hashCode() {
    return Objects.hash(produttore, numero);
  }
}
