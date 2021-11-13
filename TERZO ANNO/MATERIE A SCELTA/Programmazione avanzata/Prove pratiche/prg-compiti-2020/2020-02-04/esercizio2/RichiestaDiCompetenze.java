// RichiestaDiCompetenze.java
import com.thoughtworks.xstream.*;

public class RichiestaDiCompetenze {

  private final String descrizione;
  private final int portaRichiedente;
  private int portaProponente = 0;

  public RichiestaDiCompetenze(String d, int pr) {
    descrizione = d;
    portaRichiedente = pr;
  }

  public RichiestaDiCompetenze(String xml) {
    RichiestaDiCompetenze p = (RichiestaDiCompetenze)(new XStream()).fromXML(xml);
    descrizione = p.descrizione;
    portaRichiedente = p.portaRichiedente;
    portaProponente = p.portaProponente;
  }
  public int restituisciPortaRichiedente() { return portaRichiedente; }

  public void inserisciPortaProponente(int pp) { 
    if (!esistePortaProponente()) 
      portaProponente = pp;
  }
         
  public boolean esistePortaProponente() { return (portaProponente != 0); }
 
  public String toString() {
    return (new XStream()).toXML(this);
  }
}  