//importo dalla cartella di COnfigure
import {Config } from "../Configuration/Config.js";
import { Canvas } from "../Configuration/Canvas.js";
//importo dalla cartella Alien
import { Alien} from "../Alien/Alien.js";
import { AlienBullet } from "../Alien/AlienBullet.js";
import{AliensManager} from "../Alien/AlienManager.js";
//importo dalla cartella Tank
import { Tank } from "../Tank/Tank.js";
import { TankBullet } from "../Tank/TankBullet.js";
//importo dalla cartella draw
import { draw } from "../Draw/draw.js";
//importo dalla cartella BlockManager
import{BlocksManager} from "../Block/BlockManager.js";

export class Initializator {

    tankBullet = null;

    constructor(tankBullet) {
        this.tankBullet = tankBullet;
    }

    //inizializzazioni listeners per le pressioni dei tasti in keydown e keyup
    initControls() {
        // metto a true keys nella chiave di indice e.key
        document.addEventListener("keydown", e => {
            Config.keys[e.key] = true;
        });
        // metto a false keys nella chiave di in dice e.key
        document.addEventListener("keyup", e => {
            
            Config.keys[e.key] = false;
            // se la chiave contiene f o F come carattere si spara
            if (e.key === "f" || e.key === "F") {
                this.tankBullet.createFire();
            }

        });
    }

    // metodo per ridimensionare il canvas al ridimensionare della pagina
    resizeGame() {
        Canvas.gameContainer.style.transform = "scale(1)";
        const baseWidth = Canvas.gameContainer.offsetWidth;
        const baseHeight = Canvas.gameContainer.offsetHeight;
        const scaleX = window.innerWidth / baseWidth;
        const scaleY = window.innerHeight / baseHeight;
        const scale = Math.min(scaleX, scaleY);
        Canvas.gameContainer.style.transform = "scale" + scale;
    }

    // il listener per resettare le dimensioni del canvas
    resetGame(){
        document.addEventListener("keydown",(event) =>{ this.restartGame(event)});
    }

    //funzione per inizializzare il disegno
    drawGame() {
        if (Config.drawing) return;
        Config.drawing = true; // si può disegnare il canvas e il gioco
        draw();
        // se non è ancora stato attivato il listener, lo attiviamo e ridimensiono il gioco
        if (!Config.resized) {
            window.addEventListener("resize", this.resizeGame.bind(this)); // mi assicuro che this rimanga lo stesso durante la chiamata
            // window diventerebbe undefined, perché this punterebbe a window
            this.resizeGame();
            Config.resized = true;
        }
    }

    // metodo per ricominciare il gioco
    restartGame(event) {

        // Controlla se è un reset valido
        // se il gioco è concludo ed è stato digitato il pulsante "r" o "R" e le tabelle non sono visibili, possiamo ricominciare con il gioco
        if ((Config.gameOverFlag || Config.wonFlag) && (event.key === "r" || event.key === "R") && !Config.tableOn && !Config.appearedDialog) {
    
            Canvas.changeFocus();

            Config.resetValue();

            Config.updatePointsHeader();
    
            Canvas.init();
    
            const tank = new Tank();
            const blockManager = new BlocksManager(tank);
            const alien = new Alien();
            const alienManager = new AliensManager(tank, alien);
            const tankBullet = new TankBullet(tank);
            const alienBullet = new AlienBullet(tank);
    
            alienBullet.lastAlienShot = 0;
            alienBullet.alienShootDelay = 500;

        }
    }
    
}







