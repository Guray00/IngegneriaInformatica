import { Canvas } from "../Configuration/Canvas.js";
import { Config } from "../Configuration/Config.js";
import{Block} from "./Block.js";

export class BlocksManager{

    block = null;

    constructor(tank){

        const gap = Canvas.canvas.width * 0.28; // spazio fra blocchi

        const baseY = tank.tankY - tank.tankH * 2; // posizione verticale sopra il tank

        this.block = new Block(); // utilizzo un oggetto di tipo block, visto che tutti i blocchi hanno stessa dimensione

        for (let i = 0; i < 4; i++) {
            const x = Canvas.canvas.width * 0.04 + i * gap; // distribuiti
            const y = baseY;
            Config.blockVet.push({ x, y, w: this.block.blockW, h: this.block.blockH, lifes: 5 });
        }
    }

    drawBlocks() {
        Canvas.ctx.fillStyle = "white";
        for (let b of Config.blockVet) {
            Canvas.ctx.fillRect(b.x, b.y, b.w, b.h);
        }
    }

}
