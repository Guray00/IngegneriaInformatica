// Taccuino.java

import java.io.*;
import java.util.*;

public class Taccuino implements Serializable {

  private final String questione;
  private final String[] proposte;

  public Taccuino(int dim, String q) {
    questione = q;
    proposte = new String[dim];
	Arrays.fill(proposte," ");
  }

  public void proponi(int partecipante, String proposta) {
    this.proposte[partecipante] = proposta;
  }
}