// Dati.java

import java.io.*;
import java.util.*;

public class Dati implements Serializable {

  private final double[] dati;

  public Dati(int dim) {
    dati = new double[dim];
  }
  
  public void inizializza(double valore) {
    Arrays.fill(dati,valore);   
  }
  
  public boolean equals(Object d) { //(1)
    return Arrays.equals(dati, ((Dati)d).dati); //(2)    
  }       
}

/*
(1) Si usa il parametro generico Object per ridefinire equals ereditato da Object.
(2) All'interno del corpo di un metodo di una classe si puo' accedere ai campi
    privati di parametri di quella classe.
*/