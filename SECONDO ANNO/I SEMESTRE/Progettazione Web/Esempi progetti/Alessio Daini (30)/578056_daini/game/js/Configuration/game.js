//importo dalla cartella Configure
import { Config } from "./Config.js";
import { Canvas } from "./Canvas.js"; 

//importo dalla cartella Alien
import { Alien} from "../Alien/Alien.js";
import { AlienBullet } from "../Alien/AlienBullet.js";
import{AliensManager} from "../Alien/AlienManager.js";

//importo dalla cartella Initializator
import { Initializator } from "../Initializator/Inizializator.js";

//importo dalla cartella Fetch
import { readUsername } from "../Fetch/readUsername.js";

//importo dalla cartella Tank
import { Tank } from "../Tank/Tank.js";
import { TankBullet } from "../Tank/TankBullet.js";

//importo dalla cartella Table
import { manageRanking } from "../Table/Ranking/ranking.js";
import{ manageHistory} from "../Table/History/history.js"
//importo dalla cartella game
import { saveProgress } from "../EndGame/endGame.js";

//importo dalla cartella Draw
import {initDraw} from "../Draw/draw.js";

//importo dalla cartella Block
import{BlocksManager} from "../Block/BlockManager.js";

// Inizializza elementi
Canvas.init();

// Avvio del gioco
export async function StartGame() {
    Canvas.changeFocus(); // cambio il focus e lo concentro sul canvas
    Config.game = true; // il gioco è cominciato
    // disattivo tutti i bottoni
    Config.startButton.disabled = true; 
    Config.showButton.disabled = true;
    Config.historyButton.disabled = true;
    Config.backButton.disabled = true;

    //inizializzazione oggetti da gioco e le UI
    const tank = new Tank();
    const blockManager = new BlocksManager(tank);
    const alien = new Alien();
    const alienManager = new AliensManager(tank, alien);
    const tankBullet = new TankBullet(tank);
    const alienBullet = new AlienBullet(tank);
    const initializator = new Initializator(tankBullet);

    // Inizializza draw con le stesse istanze
    initDraw({
        tank,
        blockManager,
        alienManager,
        alienBullet,
        tankBullet
    });

    initializator.initControls();
    initializator.drawGame();
    initializator.resetGame(); // attivo il listener per poter resettare il gioco
}

//lettura asincrona del cookie contenente lo username dell'utente
const username = await readUsername();
Config.username = username; 
Config.labelName.textContent = username; // aggiornamento del label contenente il nome dell'utente
Config.updatePointsHeader(); // aggiornamento grafico del punteggio

// Listeners
Config.saveButton.addEventListener("click", saveProgress); // listener per salvare i progressi del gioco
Config.startButton.addEventListener("click", StartGame); // listener per iniziare il gioco
Config.showButton.addEventListener("click", manageRanking); // bottone per mostrare la tabella
Config.historyButton.addEventListener("click", manageHistory); // bottone per mostrare i progressi dell'utente
// listener per tornare indietro
Config.backButton.addEventListener("click", () => {
    if(!Config.appearedDialog) 
        window.location.replace("../../PlayerManagement/html/userServices/login.html");
});
