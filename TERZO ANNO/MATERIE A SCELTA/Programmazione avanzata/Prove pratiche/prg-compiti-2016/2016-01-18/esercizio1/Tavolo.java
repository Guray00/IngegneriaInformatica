package esercizio1;

public class Tavolo {

  /* Questi tre booleani indicano quali ingredienti sono presenti sul tavolo. */
  private boolean[] ingrPres = new boolean[Ingrediente.values().length];
  

  /* 
     Prende gli ingredienti sul tavolo. 
     Il metodo è bloccante se il tavolo è vuoto 
     o se quelli sul tavolo non consentono al pizzaiolo di fare una pizza.
     Il parametro v indica l'ingrediente già posseduto dal pizzaiolo (quindi 
     gli mancano gli altri due).
  */
  public synchronized void prendiIngredienti(Ingrediente v) throws InterruptedException {
    while(tavoloVuoto() || mancaIngrediente(v)) { 
      // Se il tavolo è vuoto o manca uno degli ingredienti diversi da v mi blocco.
      wait();
    }
    // Rimuovo gli ingredienti dal tavolo
    ingrPres[(v.ordinal()+1)%3] = false;
    ingrPres[(v.ordinal()+2)%3] = false;
    notifyAll();
  }

  /* 
    Il fornitore mette sul tavolo i due ingredienti contenuti nell'array v.
    Se il tavolo non è vuoto si blocca.
   */ 
  public synchronized void mettiIngredienti(Ingrediente[] v) throws InterruptedException {
    while(!tavoloVuoto()) {
      wait();
    }
    for(Ingrediente i: v)
      ingrPres[i.ordinal()] = true;
    notifyAll();
  }

  private boolean tavoloVuoto(){
    boolean res = false;
    for(boolean b: ingrPres) 
      res |= b;
    return !res;
  }

  /*
    Siccome possono esserci solo due ingredienti, se c'è v allora manca uno degli altri due
   */
  private boolean mancaIngrediente(Ingrediente v) {
    return ingrPres[v.ordinal()];
  }
}
