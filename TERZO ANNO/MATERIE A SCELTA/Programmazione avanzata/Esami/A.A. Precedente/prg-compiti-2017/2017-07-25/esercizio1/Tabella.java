package esercizio1;

public class Tabella {

  // Numero di lettori attivi
  private int readers;
  // Chiavi 
  private String[] keys;
  // Valori
  private double[] values;  

  // La Tabella e' supportata dai vettori. In alternativa 
  // puotrebbe essere fatta una copia.
  public Tabella(String[] keys, double[] values) {
    this.keys = keys;
    this.values = values;
  }

  public double read(String key) throws ElementoNonTrovatoException {
    
    // Incrementa il numero di lettori attivi
    synchronized(this) {
      readers++;
    }

    // Lettura
    double result = 0;
    boolean found = false;
    for(int i=0; i<keys.length; i++) {
      String s = keys[i];
      if(s.equals(key)) {
        result = values[i];
        found = true;
        break;  
      }
    }

    // Decrementa il numero di lettori attivi
    synchronized(this) {
      readers--;
      // L'ultimo lettore fa ripartire eventuali scrittori bloccati
      if(readers == 0)
        notifyAll();
    } 

    if(!found) 
      throw new ElementoNonTrovatoException("Non trovo " + key);
    return result;
  }
  
  public synchronized void interests(String key, double p) throws ElementoNonTrovatoException, InterruptedException {
    // Se ci sono lettori attivi si blocca
    while(readers > 0) { 
      wait();
    }

    // Scrittura
    boolean found = false;
    for(int i=0; i<keys.length; i++) {
      String s = keys[i];
      if(s.equals(key)) {
        found = true;
        values[i] = values[i] * p;
        break;  
      }
    }
    if(!found) 
      throw new ElementoNonTrovatoException("Non trovo " + key);
  }

}
