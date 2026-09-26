package es1;

import java.util.*;

public class Treno {
 
  /* Numero di posti in ogni vagone*/ 
  private static int DIM_VAG = 60;
  /* Tempo dopo il quale un posto selezionato torna libero se non viene eseguito il pagamento */
  private static long TIMEOUT = 5000;

  // Numero di vagoni del treno
  private int nvag;  
  // Thread ausilario che si preoccupa di rilasciare i posti
  private Worker worker;
  // Stato dei posti del treno, ogni riga un vagone
  Stato[][] posto;

  /**
   * Crea un treno con nvag vagoni
   */
  public Treno(int nvag) {
    this.nvag = nvag;
    this.posto = new Stato[nvag][DIM_VAG];
    for(int i=0; i<nvag; i++) 
      for(int j=0; j<DIM_VAG; j++)
        posto[i][j] = Stato.libero;
    this.worker = new Worker(this);
    worker.start();
  }

  /**
   * Visualizza lo stato del vagone n
   */ 
  public void visualizza(int n) {
    for(int i=0; i<DIM_VAG; i++) {
      System.out.print(posto[n][i]);
      if((i+1) % 6 == 0) System.out.println();
    }
  }
  
  /**
   * Prenota il posto p nel vagone n 
   */
  public synchronized boolean seleziona(int n, int p) {
    System.out.println("Selezione posto " + p + " del vagone " + n);
    boolean res = false;
    if(posto[n][p] == Stato.libero) {
        posto[n][p] = Stato.selezionato;
        long tempo = System.currentTimeMillis();
        // chiede al worker di controllare il posto in questione
        // tra allo scadere del timeout
        worker.controlla(n, p, tempo+TIMEOUT); 
        res = true;
    }
    return res;
  }

  /**
   * Completa l'acquisto per il posto p del vagone n
   */
  public synchronized boolean paga(int n, int p) {
    System.out.println("Pagamento per posto " + p + " del vagone " + n);
    if(posto[n][p] == Stato.selezionato) {
      posto[n][p] = Stato.prenotato;
      return true;
    }
    return false;
  }

}
