// SommaPrezzi.java

import java.io.*;

public class SommaPrezzi implements Serializable {

  private double sommaPrezzi;
  private int numeroCommercianti;

  public SommaPrezzi() {
    sommaPrezzi = 0.0;
    numeroCommercianti = 0;
  }
  public void aggiungiPrezzo(double p) { sommaPrezzi += p; numeroCommercianti++;}

  public void rimuoviPrezzo(double p) { sommaPrezzi -= p; numeroCommercianti--;}

  public double calcolaPrezzoMedio() { return sommaPrezzi/numeroCommercianti;}
}