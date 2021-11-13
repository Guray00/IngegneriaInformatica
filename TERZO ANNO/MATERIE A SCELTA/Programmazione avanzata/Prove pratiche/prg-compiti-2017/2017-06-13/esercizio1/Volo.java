package esercizio1;

public class Volo {

  // Stato dei singoli posti
  private boolean[] posto = new boolean[60];

  // Numero di clienti che hanno selezionato il volo
  private int nc;

  public synchronized int getNumeroClienti() {
    return nc;
  }

  public synchronized void nuovoCliente() {
    nc++;
  }

  public synchronized void clienteDeseleziona() {
    nc--;
  }

  public synchronized boolean prenota(int row, char seat) {
    if(row<1 || row >10 || seat < 'A' || seat > 'F')
      throw new IllegalArgumentException();
    int index = (row-1)*10 + (seat - 'A');
    if(posto[index]) 
      return false;
    posto[index] = true;
    return true;
  }
}
