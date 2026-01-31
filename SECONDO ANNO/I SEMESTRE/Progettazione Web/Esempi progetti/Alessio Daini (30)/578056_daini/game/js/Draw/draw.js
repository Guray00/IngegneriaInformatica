import { drawEndGameMessage } from "./drawEndGame.js";
//importo dalla cartella Configure
import{Config} from "../Configuration/Config.js";
import{Canvas} from "../Configuration/Canvas.js";

let tank;
let blockManager;
let alienManager;
let alienBullet;
let tankBullet;
let config = Config;
let canvasClass = Canvas;
let canvas = Canvas.canvas;
let ctx = Canvas.ctx;

//inizializzazione necessaria per disegnare
export function initDraw(deps) {
    tank          = deps.tank;
    blockManager  = deps.blockManager;
    alienManager  = deps.alienManager;
    alienBullet   = deps.alienBullet;
    tankBullet    = deps.tankBullet;
    config        = Config;
    canvasClass   = Canvas;
    canvas        = Canvas.canvas;
    ctx           = Canvas.ctx;
}

// ciclo di disegno principale
export function draw() {
    //disegno il rettangolo base
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    drawPanel();

    // se la partita è conclusa con una vittoria o una sconfitta, cambio la grafica e mando messaggi di vittoria o sconfitta nel canvas
    if (Config.gameOverFlag || Config.wonFlag) {
        drawEndGameMessage(canvasClass); // aggiorna continuamente il glitch
        requestAnimationFrame(draw);     // mantiene animazioni glitch
        return; // esce dal resto della logica
    }

    // logica di gioco normale
    tank.moveTank(); // movimento del tank
    tank.drawTank(); // disegno del tank aggiornato
    blockManager.drawBlocks(); // disegno delle pareti che bloccano gli spari
    alienManager.updateAlienPos(); // aggiornamento dei movimenti degli alieni
    alienManager.drawAliens(); // disegno degli alieni
    alienBullet.updateAlienFire(); // aggiornamento proiettili degli alieni e disegno
    tankBullet.updateFire();  // aggiornamento del fuoco del tank e disegno

    requestAnimationFrame(draw);
}

//funzione di utilità per creare il dialog     
export function showRecordDialog(newRecord){ 
    const dialog = document.createElement("div"); 
    dialog.id = "recordDialog"; // testo del messaggio 
    dialog.textContent = newRecord ? "Nuovo record raggiunto!" : "Nessun nuovo record trovato"; 
    document.body.appendChild(dialog); 
    config.appearedDialog = true; 
    //dopo 3 secondi il dialog, contenente gli esiti del record, al seguito del salvataggio del punteggio, sparisce
    setTimeout(function(){ 
        dialog.remove(); 
        config.appearedDialog = false; 
    },3000); 
} 

//disegno del pannello inizialmente nero con bordi bianchi
export function drawPanel() { 
    const borderSize = config.borderSize; 
    ctx.fillStyle = "black"; 
    ctx.fillRect(0, 0, canvas.width, canvas.height); 
    ctx.strokeStyle = "white"; 
    ctx.lineWidth = borderSize;
    ctx.strokeRect(borderSize / 2, borderSize / 2, canvas.width - borderSize,canvas.height - borderSize); 
}


