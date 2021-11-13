// RichiestaDiCompetenze.java

import java.io.*;

public class RichiestaDiCompetenze implements Serializable {

  private final String descrizione;
  private final int portaRichiedente;
  private int portaProponente = 0;

  public RichiestaDiCompetenze(String d, int pr) {
    descrizione = d;
    portaRichiedente = pr;
  }

  public int restituisciPortaRichiedente() { return portaRichiedente; }

  public void inserisciPortaProponente(int pp) { 
    if (!esistePortaProponente()) 
      portaProponente = pp;
  }
         
  public boolean esistePortaProponente() { return (portaProponente != 0); }

  public String toString() { 
    String r = "descrizione: " + descrizione + 
            "\nporta richiedente: " + portaRichiedente + 
            "\nportaProponente: " + portaProponente; 
    return r;
  }
}  