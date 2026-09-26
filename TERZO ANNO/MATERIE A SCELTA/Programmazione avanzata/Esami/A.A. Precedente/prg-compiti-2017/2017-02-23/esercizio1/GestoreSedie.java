public class GestoreSedie {

  /* Stato delle sedie */
  private boolean[] sediaOccupata;
  /* Numero corrente di sedie */
  private int numeroSedie;
  /* Numero corrente di partecipanti */
  private int numeroPartecipanti;
  /* Musica on/off */
  private boolean musica;
  /* Numero di partecipanti in piedi pronti a ballare */
  private int prontiBallare;
  /* Numero di partecipanti che ballano */
  private int cheBallano;
  /* Numero di partecipanti seduti */
  private int seduti;
  /* Sedia da eliminare/già eliminata */
  private boolean daEliminare;
  /* Numero di partecipanti + capobanda pronti iniziare un nuovo turno */
  private int arrivati;

  /*
   * Crea un gestore con n sedie.
   * Le sedie sono inizialmente tutte libere.
   * Il numero di partecipanti è pari al numero delle sedie più uno.
   */
  public GestoreSedie(int n){
      numeroSedie = n;
      numeroPartecipanti = n+1;
      sediaOccupata = new boolean[n];
  }

  /*
   * I partecipanti e il capobanda si fermano in questo metodo all'inizio di un
   * nuovo turno. Il metodo restituisce true se si deve continueare a giocare, false
   * altrimenti.
   */
  public synchronized boolean inizioTurno() throws InterruptedException {
    System.out.println(Thread.currentThread().getName() + ": inizioTurno");
    arrivati++;
    while(arrivati<numeroPartecipanti+1)
      wait();
    notifyAll();
    return numeroSedie>0;
  }

  /*
   * Il capobanda si blocca in questo metodo fino a quando tutti i partecipanti
   * non sono pronti a ballare
   */
  public synchronized void aspettaTuttiProntiBallare() throws InterruptedException {
    while(prontiBallare < numeroPartecipanti)
      wait();
  }

  /*
   * Il capobanda si blocca in questo metodo fino a quando tutti i partecipanti
   * non sono tutti seduti.
   */
  public synchronized void aspettaTuttiSeduti() throws InterruptedException {
    while(seduti <= numeroSedie)
      wait();
  }

  /*
   * Il capobanda si blocca in questo metodo quando c'è qualche pertecipante
   * che non ha ancora iniziato a ballare
   */
  public synchronized void aspettaTuttiProntiSedere() throws InterruptedException {
    while(cheBallano < numeroPartecipanti)
      wait();
  }

  /*
   * I partecipanti si bloccano in attesa che il gestore elimini una sedia
   */
  public synchronized void attendoEliminazioneSedia() throws InterruptedException {
    while(daEliminare)
      wait();
  }

  /*
   * Chiamato dai partecipanti per indicare che sono pronti a ballare
   */
  public synchronized void prontoABallare() {
    prontiBallare++;
    if(prontiBallare == numeroPartecipanti)
      notifyAll();
  }

  /*
   * Chiamato dai partecipanti per indicare che hanno cominciato a ballare.
   */
  public synchronized void inizioABallare() {
    cheBallano++;
    if(cheBallano == numeroPartecipanti)
      notifyAll();
  }

  /*
   * Capobanda accende la musica
   */
  public synchronized void musicaOn() throws InterruptedException {
    System.out.println(Thread.currentThread().getName() + ": musica on");
    cheBallano = 0;
    musica = true;
    daEliminare = true;
    notifyAll();
  }

  /*
   * Capobanda spegne la musica
   */
  public synchronized void musicaOff() throws InterruptedException {
    System.out.println(Thread.currentThread().getName() + ": musica off");
    seduti = 0;
    musica = false;
    notifyAll();
  }

  /*
   * I partecipanti provano a prendere una sedia.
   * Il metodo restituisce true se la sedia viene presa, false altrimenti.
   */
  public synchronized boolean prendoSedia() {
    boolean ris = false;
    seduti++;
    for(int i=0; i<numeroSedie; i++)
      if(!sediaOccupata[i]) {
        sediaOccupata[i] = true;
        ris = true;
        break;
      }
    notifyAll();
    return ris;
  }

 /*
  * I partecipanti attendono che la musica parta.
  */
  public synchronized void attendoMusica() throws InterruptedException {
    while(!musica) {
      wait();
    }
  }

  /*
   * I partecipanti attendono che la musica venga spenta.
   */
  public synchronized void attendoFineMusica() throws InterruptedException {
    while(musica) {
      wait();
    }
  }

  /*
   * Il gestore rimuove una sedia.
   */
  public synchronized void diminuisciSedie() throws InterruptedException {
    numeroSedie--;
    numeroPartecipanti--;
    arrivati = 0;
    System.out.println("Adesso ci sono " + numeroSedie + " sedie");
    for(int i=0; i<numeroSedie; i++)
      sediaOccupata[i]=false;
    daEliminare = false;
    notifyAll();
  }

}
