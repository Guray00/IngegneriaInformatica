package es1;

import java.util.*;

  /* Thread ausiliario che si occupa di liberare i posti allo scadere 
     del timeout a loro associato */
class Worker extends Thread {

    // I posti da controllare sono memorizzati in una lista di Elem
  private class Elem {
    private int n;
    private int p;
    private long t;

    Elem(int n, int p, long t) {
      this.n = n;
      this.p = p;
      this.t = t;
    }

    int getN() {return n;}
    int getP() {return p;}
    long getT() {return t;}
  }

  // Lista dei posti da controllare
  private List<Elem> le = new ArrayList<Elem>();
  
  private Treno t;  


  Worker(Treno t) {
    this.t = t;
  }

  public void run(){
    Elem e = null;

    try {

      while(true) {
        synchronized(this)  {
          // Se la lista e' vuota si blocca
          while(le.size() == 0)
            wait();
  
          // La lista contiene almeno un elemento, prende il primo
          e = le.remove(0);
        }
        long i;
        // Attende lo scadere del timeout del primo elemento
        while((i = (e.getT() - System.currentTimeMillis())) > 0) 
          sleep(i);
        // Esegue il controllo
        rilascia(e.getN(), e.getP());
      }
    } catch (InterruptedException ie) {
      System.out.println("Sono stato interrotto...");
    }
  } 
    
  // Aggiunge un elemento alla lista
  // Se la lista era vuota risveglia il thread worker  
  synchronized void controlla(int n, int p, long t) {
    Elem e = new Elem(n, p, t);
    le.add(e);
    if(le.size() == 1)
      notify();
  }

  // Controlla se e' stato eseguito il pagamento per il posto 
  // indicato dai parametri e nel caso lo rilascia
  private void rilascia(int n, int p) {
    if(t.posto[n][p] == Stato.selezionato) {
      System.out.println("Il posto " + p + " del vagone " + n + " viene rilasciato");
      t.posto[n][p] = Stato.libero;
    }
  }
}
