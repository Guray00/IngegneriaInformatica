import { Canvas } from "../Configuration/Canvas.js";

export class Alien {
    alienW = null;
    alienH = null;

    alienFrames = [new Image(), new Image()]; // uso frame per le animazioni degli alieni
    currentAlienFrame = 0;
    lastAlienFrameTime = 0;
    alienFrameInterval = 300; // ms per frame

    constructor() {

        this.alienFrames[0].src = "../../images/alien1.png";
        this.alienFrames[1].src = "../../images/alien2.png";

        this.alienW = Canvas.canvas.width * 0.06;
        this.alienH = Canvas.canvas.height * 0.08;
    }

    //restituzione frame dell'alieno
    getCurrentAlienFrame() {

        const now = performance.now();
        //ogni 300 ms o più si cambia il frame dell'alieno
        if (now - this.lastAlienFrameTime > this.alienFrameInterval) {
            this.currentAlienFrame = (this.currentAlienFrame + 1) % this.alienFrames.length; // aggiornamento della cella, in modo circolare
            this.lastAlienFrameTime = now;
        }
        
        return this.alienFrames[this.currentAlienFrame];
    }
}
