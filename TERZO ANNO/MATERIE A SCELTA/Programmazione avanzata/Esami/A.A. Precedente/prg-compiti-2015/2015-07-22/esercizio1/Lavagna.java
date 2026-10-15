package esercizio1;

import java.util.*;

public class Lavagna {

  enum Operazione {INSERIMENTO, CANCELLAZIONE};

  private static class Modifica {
    private Date time;
    private Operazione op;
    private Forma forma;
    Modifica(Operazione o, Forma f) {      
      time = new Date();
      op = o;
      forma = f;
    }
    Forma getForma(){
      return forma;
    }
    Date getTime(){
      return time;
    }
    public String toString(){
      return time + " " + op + " " + forma;
    }
  }

  private int n;  
  private float dimx;
  private float dimy;
  private List<Utente> utenti = new ArrayList<Utente>();
  private List<Modifica> modifiche = new ArrayList<Modifica>();
  private List<Forma> forme = new ArrayList<Forma>();

  public Lavagna(float dimx, float dimy, int n) {
    if(dimx <= 0 || dimy <= 0 || n <=0)
      throw new IllegalArgumentException();
    this.n = n;
    this.dimx = dimx;
    this.dimy = dimy;
  }

  public synchronized Utente[] entra(Utente u) throws InterruptedException {
    while(utenti.size()>=n)
      wait();
    utenti.add(u);
    Utente[] tmp = new Utente[utenti.size()];
    tmp = utenti.toArray(tmp);
    return tmp;
  }
  
  public synchronized void esci(Utente u){
    utenti.remove(u);
    notifyAll();
  }

  public synchronized void inserisci(Forma f) {
    if(f.getX() < 0 || f.getY() < 0 || f.getX()+f.getDimX() > dimx || f.getY()+f.getDimY() > dimy)
      throw new IllegalArgumentException();
    forme.add(f);
    modifiche.add(new Modifica(Operazione.INSERIMENTO, f)); 
  }
  
  public synchronized void cancella(Forma f) {
    forme.remove(f);
    modifiche.add(new Modifica(Operazione.CANCELLAZIONE, f)); 
  }

  public synchronized String log(){
    StringBuffer sb = new StringBuffer();
    for(Modifica m: modifiche) {
      sb.append(m);
      sb.append(System.lineSeparator());
    }    
    return sb.toString();
  }

  public synchronized String toString(){
    StringBuffer sb = new StringBuffer("[");
    for(Forma f: forme) {
      sb.append(" " + f);  
    }
    sb.append("]");
    return sb.toString();
  } 
}
