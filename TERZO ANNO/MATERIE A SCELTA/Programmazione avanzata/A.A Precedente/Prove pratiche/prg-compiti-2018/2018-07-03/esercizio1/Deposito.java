import java.util.*;

public class Deposito {

  private Set<Pezzo> ll = new HashSet<Pezzo>();
  private int dimRic;
  private Thread inAttesa;

  public Deposito() {
    dimRic = Integer.MAX_VALUE;
  }

  public synchronized void aggiungi(Pezzo pp) throws InterruptedException {
    while(ll.contains(pp)) {
      System.out.println(Thread.currentThread() + ": non posso inserire, devo attendere");
      wait();
    }
    ll.add(pp);
    System.out.println(ll);
    notifyAll();
  }

  public synchronized Pezzo[] prendi(Descrizione[] dd) {
    try {
      while(!ciSonoTutti(dd) && dd.length < dimRic) {
        dimRic = dd.length;
        if(inAttesa != null)
          inAttesa.interrupt();
        inAttesa = Thread.currentThread();
        System.out.println(Thread.currentThread() + ": mi blocco, dimRic " + dimRic);
        wait();
      }
    } catch (InterruptedException ie) {
      System.out.println(Thread.currentThread() + ": mi hanno risvegliato e esco...");
      return null;
    }
    if(ciSonoTutti(dd)) {
      Pezzo[] pp = rimuoviTutti(dd);
      notifyAll();
      return pp;
    } else {
      return null;
    }
  }

  private Pezzo[] rimuoviTutti(Descrizione[] dd) {
    List<Pezzo> res = new ArrayList<Pezzo>(dd.length);
    for(Descrizione d: dd) {
      for(Pezzo p: ll)
        if(d.corrisponde(p)) {
          res.add(p);
          ll.remove(p);
          break;
        }
    }
    return res.toArray(new Pezzo[res.size()]);
  }

  private boolean ciSonoTutti(Descrizione[] dd) {
    for(Descrizione d: dd) {
      boolean trovato = false;
      for(Pezzo p: ll)
        if(d.corrisponde(p)) {
          trovato = true;
          break;
        }
        if(!trovato)
          return false;
    }
    return true;
  }
}
