
import java.io.*;
import java.util.*;

public class Memorizzatore {
  
  // Contiene i valori
  private float[] buffer;
  // Contiene i numeri d'ordine dei valori corrispondenti
  private int[] ordbuf;
  // Posti liberi nel memorizzatore
  private int liberi;
  // Numero d'ordine del prossimo valore che può essere trasferito direttamente su file
  private int ordine;
  // Dove i valori vengono scritti
  private Writer ds;

  public Memorizzatore(String fn, int n) throws IOException {
    buffer = new float[n];
    ordbuf = new int[n];
    // Il valore -1 indica che tale posto è libero
    Arrays.fill(ordbuf, -1);
    ds = new FileWriter(fn);
    liberi = n;
  }

  public synchronized void deposita(float r, int o) throws InterruptedException, IOException {
    System.out.println(Thread.currentThread().getName() + " deposita " + r + " " + o);
    while(ordine != o && liberi == 0) {
      // Non e' il mio turno e non c'e' spazio per bufferizzare il dato
      System.out.println(Thread.currentThread().getName() + " non e' il mio turno e non c'e' spazio");
      wait();  
    }
    
    if(ordine == o) {
      System.out.println(Thread.currentThread().getName() + " e' il mio turno");
      // E' il mio turno scrivo il dato nel file
      scrivi(r);  
      while(true) {
        ordine++;
        // guardo se nel buffer ci sono dati relativi
        // al nuovo valore di ordine
        int d = doveDatiInBuffer(ordine);
        if(d != -1) {
          // Questo valore puo' adesso essere trasferito su file
          float tmp = buffer[d];
          ordbuf[d] = -1;
          // Scrivo i dati nel file
          scrivi(tmp);
          // Libero lo spazio
          liberi++;
        } else {
          // Qualche thread bloccato puo' adesso memorizzare nel buffer se necessario
          notifyAll();
          return; 
        }
      }    
    } else {
      // Non e' il mio turno: memorizzo nel buffer e esco
      // Cerco il primo libero
      int indice = doveDatiInBuffer(-1);
      ordbuf[indice] = o;
      buffer[indice] = r;
      liberi--;
    }
  }

  /*
   * Restituisce l'indice dell'array corrispondente al numero d'ordine 
   * (o -1 se non presente).
   */
  private int doveDatiInBuffer(int ordine) {
    for(int i=0; i<ordbuf.length; i++) {
      if(ordbuf[i] == ordine)
        return i;
    } 
    return -1;
  }

  /*
   * Scrive il valore r nel file (insieme al suo numero d'ordine)
   */
  private void scrivi(float r) throws IOException {
    ds.write(ordine + " " + r + "\n");
    ds.flush();
  }
  
}
