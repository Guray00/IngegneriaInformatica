package es1;


/* Codifica lo stato dei posti */
public enum Stato {
  libero, selezionato, prenotato;
  public String toString(){
    switch(this) {
      case libero: return "L";
      case selezionato: return "S";
      case prenotato: return "P";
    }
    return null;
  }
}

