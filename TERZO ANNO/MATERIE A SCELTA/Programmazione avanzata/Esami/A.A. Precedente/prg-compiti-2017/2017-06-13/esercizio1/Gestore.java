package esercizio1;

import java.util.*;


public class Gestore {

  /* Associa i codici ai voli. */
  private Map <String, Volo> lv = new HashMap<String, Volo>();

  /* Associa agli utenti il volo che hanno selezionato. */
  private Map<Cliente, Volo> tm = new HashMap<Cliente, Volo>();

  /**
   * Crea un gestore.
   * Suppongo che il gestore venga creato prima che i clienti inizino a lavorarci sopra. 
   * Non c'è quindi un problema di corse critiche nell'accesso a lv.
   */
  public Gestore(String[] data){
    for(String c: data) {
      lv.put(c, new Volo());
    }
  }

  /**
   * Il cliente x seleziona il volo indicato dal codice c.
   */
  public void seleziona(Cliente x, String c) throws InterruptedException, VoloNonEsistenteException {
    
    // Trova l'oggetto volo associato al codice in questione.
    Volo v = find(c);

    // Un volo con tale codice non è stato trovato.
    if(v == null)
      throw new VoloNonEsistenteException();

    // Sincronizzazione sull'oggetto volo.
    synchronized(v) {

      // Se selezionato già da tre clienti mi blocco.
      while(v.getNumeroClienti() >= 3)
        v.wait();

      // Incremento il contatore che tiene traccia del numero di clienti che hanno
      // selezionato questo volo.
      v.nuovoCliente();

      // Associo il volo selezionato all'utente.
      // Serve per prenotazioni successive.
      inserisci(x, v);
    }
  } 

  /**
   * Rimuove selezione precedentemente eseguita dall'utente
   */
  public void deseleziona(Cliente x) {

    // Rimuove il cliente dalla map.
    // Viene restutuito il volo precedentemente selezionato.
    Volo v = rimuovi(x);

    // Se null: l'utente non aveva selezionato nessun volo.
    // Se diverso da null: decremento il contatore di clienti associati al volo
    // e risveglio eventuali bloccati.
    if(v != null) 
	    synchronized(v) {
		    v.clienteDeseleziona();
		    v.notify();
	    }
  }
  
  /**
   * Il cliente x prenota il posto indicato da row e seat
   */
  public boolean prenota(Cliente x, int row, char seat) 
 	      throws IllegalArgumentException, VoloNonSelezionatoException {

    // Ottengo il volo selezionato in precedenza dall'utente.
    Volo v = getVolo(x);
    
    // Se l'utente non aveva selezionato nessun volo lancio eccezione.
    if(v == null)
      throw new VoloNonSelezionatoException();
        
    // Esegue prenotazione vera e propria sull'oggetto volo.   
    synchronized(v) {
      return v.prenota(row, seat);
    }
  }

  /** 
   * Restituisce il volo associato al codice c 
   */
  private Volo find(String c) {
    synchronized(tm) {
      return lv.get(c);
    }
  }
  
  /**
   * Il cliente ha selezionato il volo. 
   * Inserisco associazione della tabella. 
   */
  private void inserisci(Cliente x, Volo v) {
    synchronized(tm) {
      tm.put(x, v);
    } 
  }
  
  /**
   * Il cliente ha deselezionato un volo. 
   * Rimuovo associazione dalla tabella. 
   */
  private Volo rimuovi(Cliente x) {
    synchronized(tm) {
      return tm.remove(x);
    }
  }
  
  /**
   * Restituisce il volo precedentemente selezionato dall'utente.
   */
  private Volo getVolo(Cliente x){
    synchronized(tm){
      return tm.get(x);
    }
  }

}
