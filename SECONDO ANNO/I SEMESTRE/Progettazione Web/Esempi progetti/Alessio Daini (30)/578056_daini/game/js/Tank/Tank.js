import { Canvas } from "../Configuration/Canvas.js";
import { Config } from "../Configuration/Config.js";

export class Tank{
    tankX = null;
    tankY = null;
    tankW = null;
    tankH = null;

    keys = null;
    borderSize = null;

    constructor(){
        this.keys = Config.keys;
        this.borderSize = Config.borderSize;

        // le dimensioni del tank sono proporzionali rispetto alle dimensioni del canvas
        this.tankX = Canvas.canvas.width/2;
        this.tankW = Canvas.canvas.width * 0.08;
        this.tankH = Canvas.canvas.height * 0.12;
        this.tankY = Canvas.canvas.height - Config.borderSize - this.tankH * 0.2;
    }

    getTankParts(){
        return [
            { x: this.tankX - this.tankW / 2, y: this.tankY, w: this.tankW, h: this.tankH * 0.2 },
            { x: this.tankX - this.tankW * 0.3, y: this.tankY - this.tankH * 0.3, w: this.tankW * 0.6, h: this.tankH * 0.3 },
            { x: this.tankX - this.tankW * 0.05, y: this.tankY - this.tankH * 0.5, w: this.tankW * 0.1, h: this.tankH * 0.2 }
        ];
    }

    // se ArrowLeft è stato attivato ci si sposta a sinistra, altrimenti a destra
    moveTank() {
        if (this.keys["ArrowLeft"]) this.tankX -= 5 ;
        if (this.keys["ArrowRight"]) this.tankX += 5;   
        //sanitizzazione delle coordinate del tank
        if (this.tankX < this.borderSize + this.tankW / 2) this.tankX = this.borderSize + this.tankW / 2;
        if (this.tankX > Canvas.canvas.width - this.borderSize - this.tankW / 2) this.tankX = Canvas.canvas.width - this.borderSize - this.tankW / 2;
    }

    drawTank() {
        Canvas.ctx.fillStyle = "lime";
        Canvas.ctx.fillRect(this.tankX - this.tankW / 2, this.tankY, this.tankW, this.tankH * 0.2);
        Canvas.ctx.fillRect(this.tankX - this.tankW * 0.3, this.tankY - this.tankH * 0.3, this.tankW * 0.6, this.tankH * 0.3);
        Canvas.ctx.fillRect(this.tankX - this.tankW * 0.05, this.tankY - this.tankH * 0.5, this.tankW * 0.1, this.tankH * 0.2);
    }

}

