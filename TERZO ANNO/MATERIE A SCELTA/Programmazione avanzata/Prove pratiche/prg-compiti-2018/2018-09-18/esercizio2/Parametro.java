// Parametro.java
import com.thoughtworks.xstream.*;

public class Parametro {
  private boolean stabilitaCampioni;
  private double sommaCampioni;
  private int numeroCampioni;
  
  public Parametro(double c) {
    sommaCampioni = c; numeroCampioni = 1; stabilitaCampioni = false;
  }

  public Parametro(String xml) {
    Parametro p = (Parametro)(new XStream()).fromXML(xml);
    numeroCampioni = p.numeroCampioni;
    stabilitaCampioni = p.stabilitaCampioni;
    sommaCampioni = p.sommaCampioni;
  }
  
  public void aggiungiCampione (double c) {
    if ((Math.round(sommaCampioni/numeroCampioni) !=
         Math.round((sommaCampioni+c)/(numeroCampioni+1)))
    ) { sommaCampioni+=c; numeroCampioni++; } 
    else
      stabilitaCampioni = true;
  }
  
  public boolean stabilitaCampioni() {
    return stabilitaCampioni;
  }
  
  public double calcolaParametro() {
    return Math.round(sommaCampioni/numeroCampioni);
  }
  
  public String toString() {
    return (new XStream()).toXML(this);
  }
}  
