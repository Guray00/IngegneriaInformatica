// Domanda.java
import com.thoughtworks.xstream.*;

public class Domanda {
  private String testo;
  private double sommaOpinioni;
  private int numeroOpinioni;
  private int numeroSufficienteOpinioni;
  private int portaOpinionistaInterrogante;
  
  public Domanda(String t, int suffOp, int portaOpInterr) {
    testo = t; 
    sommaOpinioni = 0.0;
    numeroOpinioni = 0;
    numeroSufficienteOpinioni = suffOp;
    portaOpinionistaInterrogante = portaOpInterr;
  }

  public Domanda(String xml) {
    Domanda d = (Domanda)(new XStream()).fromXML(xml);
    testo = d.testo; 
    sommaOpinioni = d.sommaOpinioni;
    numeroOpinioni = d.numeroOpinioni;
    numeroSufficienteOpinioni = d.numeroSufficienteOpinioni;
    portaOpinionistaInterrogante = d.portaOpinionistaInterrogante;
  }
  
  public boolean sufficientiOpinioni() {
    return numeroOpinioni >= numeroSufficienteOpinioni;
  }

  public String toString() {
    return (new XStream()).toXML(this);
  }
  
  public double elaboraRisposta () {
    return sommaOpinioni/numeroOpinioni;
  }

  public void esprimiOpinione (double op) {
    sommaOpinioni += op;
    numeroOpinioni++;
  }

  public int portaOpinionistaInterrogante () {
    return portaOpinionistaInterrogante;
  }
}  
