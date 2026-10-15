// Progetto.java

import java.io.*;

public class Progetto implements Serializable {

  private final String obiettivo;
  private final int numeroMinimoSponsor;
  private int numeroCorrenteSponsor = 0;
  private final double finanziamentoMinimo;
  private double finanziamentoCorrente = 0.0;
  private int portaRicezioneProponente;

  public Progetto(String ob, int nms, double fm, int prp) {
    obiettivo = ob;
    numeroMinimoSponsor = nms;
    finanziamentoMinimo = fm;
    portaRicezioneProponente = prp;
  }

  public boolean verificaAttivazione() { 
    if (( numeroCorrenteSponsor >= numeroMinimoSponsor) &&
       ( finanziamentoCorrente >= finanziamentoMinimo))
      return true;
    return false;
  }
  
  public String toString() { 
    String r = "obiettivo: " + obiettivo + 
            "; sponsor: " + numeroCorrenteSponsor + "/" + numeroMinimoSponsor +
            "; finanziamento: " + finanziamentoCorrente + "/" + finanziamentoMinimo;
    return r;
  }
        
  public void sponsorizza(double importo) {
    if (importo > 0) {
      finanziamentoCorrente += importo;
      numeroCorrenteSponsor++;}
  }

  public int restituisciPortaRicezioneProponente() { return portaRicezioneProponente; }
  public double restituisciFinanziamentoCorrente() { return finanziamentoCorrente; }  
}  