// Proposta.java

import java.io.*;

public class Proposta implements Serializable {

  private String contenuto;
  private int numeroSI = 0;
  private int numeroNO = 0;
  private int numeroNI = 0;
  private String risultato = "ingiudicata";

  public Proposta(String c) { contenuto = c; }

  public String restituisciContenuto() { return contenuto; }

  public void vota (String voto) { 
    switch(voto){
      case "SI": numeroSI++; break;
      case "NO": numeroNO++; break;
      default: numeroNI++;
    }
  }          
  
  public void elabora() { 
    if (numeroNI < numeroSI + numeroNO)
      if (numeroSI > numeroNO)
        risultato = "accettata";
      else if (numeroSI < numeroNO)
        risultato = "rifiutata";
  }
  
  public String restituisciRisultato() { return risultato; }
}