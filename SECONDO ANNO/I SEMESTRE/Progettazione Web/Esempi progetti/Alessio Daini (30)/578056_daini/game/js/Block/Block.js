import { Canvas } from "../Configuration/Canvas.js";

export class Block{

    blockW = null;
    blockH = null;

    constructor(){
        this.blockW = Canvas.canvas.width * 0.08; // larghezza blocco
        this.blockH = Canvas.canvas.height * 0.05; // altezza blocco  
    }
}



