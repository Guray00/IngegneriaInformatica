import { gameOver } from "../EndGame/endGame.js";
import { Canvas } from "../Configuration/Canvas.js";
import { Config } from "../Configuration/Config.js";

export class AliensManager {

    tank = null;

    alien = null;

    constructor(tank, alien) {

        this.tank = tank;
        this.alien = alien;

        const leftMargin = Canvas.canvas.width * 0.05;
        const availableW = Canvas.canvas.width - 2 * leftMargin;
        const colGap = (availableW - Config.cols * this.alien.alienW) / (Config.cols - 1);
        const rowGap = Canvas.canvas.height * 0.02;

        for (let r = 0; r < Config.rows; r++) {
            for (let c = 0; c < Config.cols; c++) {
                const x = leftMargin + c * (this.alien.alienW + colGap);
                const y = Config.borderSize + r * (this.alien.alienH + rowGap);
                Config.alienVet.push({
                    x, y,
                    w: this.alien.alienW,
                    h: this.alien.alienH,
                    row: r,
                    col: c,
                    lifes: 1,
                    alive: true
                });
            }
        }

    }

    //disegno solo alieni vivi
    drawAliens() {
        for (let a of Config.alienVet) {
            if (a.alive) {
                const img = this.alien.getCurrentAlienFrame();
                Canvas.ctx.drawImage(img, a.x, a.y, a.w, a.h);
            }
        }
    }

    updateAlienPos() {
        let collision = false;

        // se stiamo a destra verifichiamo che l'alieno vivo più a destra faccia collisione con la parete bianca del canvas
        if (Config.right) {
            let maxRight = Math.max(...Config.alienVet.filter(a => a.alive).map(a => a.x + a.w));
            if (maxRight + Config.step >= Canvas.canvas.width - Config.borderSize) collision = true;
        }
        //stessa cosa, ma con l'alieno più a sinistra vivo e la parete bianca 
        else {
            let minLeft = Math.min(...Config.alienVet.filter(a => a.alive).map(a => a.x));
            if (minLeft - Config.step <= Config.borderSize) collision = true;
        }
        // faccio scendere gli alieni in caso in cui la collisione sia verificata
        if (collision) {
            for (let alien of Config.alienVet) alien.y += 10;
            Config.right = !Config.right;
        }
        // altrimenti gli alieni si spostano orizzontalmente 
        else {
            for (let alien of Config.alienVet) alien.x += Config.right ? Config.step : -Config.step;
        }

        // collisione con blocchi
        for (let alien of Config.alienVet) {
            //ignoro gli alieni nonn vivi
            if (!alien.alive) continue;
            // per ciascun blocco si verifica se c'è almeno un alieno che si collide con la parete: in tal caso viene eliminato in memoria
            for (let i = Config.blockVet.length - 1; i >= 0; i--) {
                let block = Config.blockVet[i];
                if (alien.x < block.x + block.w && alien.x + alien.w > block.x &&
                    alien.y < block.y + block.h && alien.y + alien.h > block.y) {
                    Config.blockVet.splice(i, 1);
                }
            }
        }

        // collisione con tank
        for (let alien of Config.alienVet) {
            //ignoro gli alieni morti
            if (!alien.alive) continue;
            // ottengo le coordinate del tank
            const tankParts = this.tank.getTankParts();
            //verifichiamo per ciascuna parte se almeno un alieno collide con il tank: se è vero, gameover
            for (const part of tankParts) {
                if (alien.x < part.x + part.w && alien.x + alien.w > part.x &&
                    alien.y + alien.h > part.y) {
                    gameOver();
                    return;
                }
            }
        }

        // collisione con la terra
        // vediamo la quota più bassa dell'alieno più in basso e che sia vivo
        const livingAliensHeightMax = Math.max(...Config.alienVet.filter(a => a.alive).map(a => a.y + a.h));
        //gameOver nel caso in cui ci sia collisione(considero il fotogramma, non la dimensione stessa dell'alieno)
        if (livingAliensHeightMax >= Canvas.canvas.height - Config.borderSize) {
            gameOver();
            return;
        }
    }
}
