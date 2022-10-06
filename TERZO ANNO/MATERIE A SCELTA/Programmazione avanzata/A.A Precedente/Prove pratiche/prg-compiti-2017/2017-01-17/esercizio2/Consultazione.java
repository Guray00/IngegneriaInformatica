// Consultazione.java

import java.io.*;

public class Consultazione implements Serializable {

  private final String sintomi;
  private String diagnosi = null;

  public Consultazione(String s) { sintomi = s; }
  public void inserisciDiagnosi(String d) { diagnosi = d; }
  public boolean diagnosiInserita() { return diagnosi != null; }
  public String toString() { return sintomi + "; " + diagnosi; }
        
}  