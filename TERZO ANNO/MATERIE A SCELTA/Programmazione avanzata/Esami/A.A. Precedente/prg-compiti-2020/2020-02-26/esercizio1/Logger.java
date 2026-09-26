
import java.io.*;
import java.util.*;

public class Logger {

  private Map<Integer, String> map = new HashMap<Integer, String>();
  // Posti liberi nel logger
  private int liberi;
  // Numero d'ordine del prossimo valore che può essere trasferito direttamente su file
  private int ordine;
  // Dove i valori vengono scritti
  private Writer ds;

  public Logger(String fn, int n) throws IOException {
    ds = new FileWriter(fn);
    liberi = n;
  }

  public synchronized void log(String r, int o) throws InterruptedException, IOException {
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
        String s = map.get(ordine);
        if(s != null) {
          // Questo valore puo' adesso essere trasferito su file
          // Scrivo i dati nel file
          scrivi(s);
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
      map.put(o, r);
      liberi--;
    }
  }



  /*
   * Scrive il valore r nel file (insieme al suo numero d'ordine)
   */
  private void scrivi(String r) throws IOException {
    ds.write(ordine + " " + r + "\n");
    ds.flush();
  }

}
