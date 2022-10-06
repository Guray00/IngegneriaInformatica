// Inserzione.java

import java.io.*;

public class Inserzione implements Serializable {

  private final String descrizioneBene;
  private double miglioreOfferta;
  private final double incrementoAsta;
  private final int portaProponente;
  private int portaCompratore = 0;

  public Inserzione(String db, double mo, double ia, int pp) {
    descrizioneBene = db;
    miglioreOfferta = mo;
    incrementoAsta = ia;
    portaProponente = pp;
  }

  public void effettuaOfferta(double prezzo) { 
    if ((( prezzo - miglioreOfferta ) >= incrementoAsta) &&
       ((( prezzo - miglioreOfferta ) % incrementoAsta) == 0))
          miglioreOfferta = prezzo;
  }
  
  public String toString() { 
    String r = "descrizione: " + descrizioneBene + 
            "\nmigliore offerta: " + miglioreOfferta + 
            "\nincremento d'asta: " + incrementoAsta + 
            "\ncompratore: " + portaCompratore;
    return r;
  }
        
  public double restituisciMiglioreOfferta() { return miglioreOfferta; }
  public void inserisciPortaCompratore(int pc) { portaCompratore = pc; }
  public int restituisciPortaProponente() { return portaProponente; }
}  