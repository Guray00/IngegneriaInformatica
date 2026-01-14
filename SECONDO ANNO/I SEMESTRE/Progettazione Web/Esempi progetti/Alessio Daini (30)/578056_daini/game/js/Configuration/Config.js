export class Config {
  // --- Stati generali ---
  static game = false;
  static wonFlag = false;
  static gameOverFlag = false;
  static tableOn = false;
  static resized = false;
  static appearedDialog = false;
  static right = true;
  static show = true;
  static drawing = false;
  static rows = 4;
  static cols = 13;
  static borderSize = 30;

  // --- Riferimenti globali ---
  static fireVet = []; // vettore per gestire i proiettili del tank
  static alienFireVet = []; //vettore per gestire i proiettili degli alieni
  static blockVet = []; // vettore per gestire i muri che bloccano gli spari
  static alienVet = []; // il vettore per gestire gli alieni
  static keys = {}; // mappa delle chiavi


  // --- Dati di gioco ---
  static points = 0; // punteggio
  static mul = 1; // moltiplicatore del gioco
  static manyAlienkKilled = 0; // quanti alieni uccisi di seguito
  static alienNumber = 52; // numero di alieni disponibili
  static bonus = 500;  // punteggio bonus in caso di vittoria
  static step = 0.5; // tempo di delay di movimento degli alieni


  // --- UI e bottoni ---
  static saveButton = document.getElementById("save"); // bottone per salvare i progressi
  static showButton = document.getElementById("showRecord"); // bottone per mostrare la classifica deui migliori record degli utenti
  static historyButton = document.getElementById("showHistory"); // bottoni per mostrare i 20 migliori progressi degli utenti
  static backButton = document.getElementById("goBack"); // bottone per tornare indietro alla pagina precedente
  static startButton = document.getElementById("start"); // bottone per iniziare la partita
  static labelName = document.getElementById("name"); // label per lo username dell'utente
  static table = document.querySelector("table"); // tabella da stampare
  static div = document.getElementById("tableWrapper"); //wrapper per la tabella

  static resetValue(){
    
    this.fireVet.length = 0;
    this.alienFireVet.length = 0;
    this.blockVet.length = 0;
    this.alienVet.length = 0;

    this.game = true;
    this.wonFlag = false;
    this.gameOverFlag = false;
    this.tableOn = false;
    this.resized = false;
    this.appearedDialog = false;
    this.right = true;

    this.points = 0;
    this.mul = 1;
    this.manyAlienkKilled = 0;
    this.alienNumber = 52;
    this.borderSize = 30;
    this.step = 0.5;
    this.show = true;
    this.drawing = false;

    this.saveButton.disabled = true;
    this.showButton.disabled = true;
    this.historyButton.disabled = true;
    this.backButton.disabled = true;
  }

  static updatePointsHeader() {
      const label = document.getElementById("points");
      if (label) label.textContent = "Punti:" + this.points;
  }

  static updatePoints(){
    this.manyAlienkKilled++;
    if(this.manyAlienkKilled % 6 === 0) this.mul++;
    this.points += ((this.manyAlienkKilled > 1) ? this.mul * this.manyAlienkKilled : 1); //per ogni alieno ucciso si guadagna pari a manyAlienkKilled * mul, altrimenti si guadagna solamente un punto 
    this.updatePointsHeader();
  }

  static resetCounters() {
      this.mul = 1;
      this.manyAlienkKilled = 0;
  }
  
}


