
import{ gameOver} from "../EndGame/endGame.js";
import { Config } from "../Configuration/Config.js";
import { Canvas } from "../Configuration/Canvas.js";

export class AlienBullet{
    lastAlienShot = 0;
    alienShootDelay = 500;
    tank = null;

    constructor(tank){
        this.tank = tank;
        this.lastAlienShot = 0;
        this.alienShootDelay = 500;
    }
    
    createAlienFire(alienCell){
        const fireX = alienCell.x + alienCell.w / 2 - 2;
        const fireY = alienCell.y + alienCell.h;
        Config.alienFireVet.push({ x: fireX, y: fireY, width: 4, height: 15, alive: true }); 
    }
    
    drawAlienBullet(fireX, fireY,width,height) {
        Canvas.ctx.fillStyle = "purple";
        Canvas.ctx.fillRect(fireX, fireY, width, height);
    }

    updateAlienFire(){
        if (!Config.alienVet.length) return;
        if (!Config.game) return;
    
        const now = Date.now();
        // ogni almeno 500 ms si aggiorna il fuoco dell'alieno
        if (now - this.lastAlienShot >= this.alienShootDelay) {

            this.lastAlienShot = now; // aggiornamento del tempo dello sparo partito
    
            // scegli colonna casuale
            const i = Math.floor(Math.random() * Config.cols);
            let posY = Config.rows - 1; // ultima riga
            let pos = posY * Config.cols + i;
            let alienCell = Config.alienVet[pos];
    
            // risali finché trovi un alieno vivo
            while (posY > 0 && !alienCell.alive) {
                posY--;
                pos = posY * Config.cols + i;
                alienCell = Config.alienVet[pos];
            }
            
            //se trovo un alieno vivo, si può sparare a partire da quell'alieno
            if (alienCell.alive) {
                this.createAlienFire(alienCell);
            }

        }

        // abbasso il proiettile
        this.alienFireDown();
    
    }

    checkAlienCollision(alienBullet,index){

        //elimina se colpisco una parete
        for(let i = 0; i < Config.blockVet.length;++i){
            let block = Config.blockVet[i];
    
            const collideX = alienBullet.x <= block.x + block.w && alienBullet.x + alienBullet.width >= block.x;
            const collideY = alienBullet.y <= block.y + block.h && alienBullet.y + alienBullet.height >= block.y;
    
            if(collideX && collideY){
                block.lifes--;
                if(block.lifes <= 0) Config.blockVet.splice(i,1);
                Config.alienFireVet.splice(index,1);
                return;
            }
    
        }
    
        //gameOver se il proiettile tocca il carroarmato
        const tankParts = this.tank.getTankParts();
    
        for (const part of tankParts) {
            const collideX = alienBullet.x < part.x + part.w && (alienBullet.x + alienBullet.width) > part.x;
            const collideY = alienBullet.y < part.y + part.h && (alienBullet.y + alienBullet.height) > part.y;
    
            if (collideX && collideY) {
                gameOver();
                return;
            }
        }
    
        // elimina se esce dallo schermo
        if (alienBullet.y > Canvas.canvas.height - Config.borderSize - alienBullet.height) {
            Config.alienFireVet.splice(index,1);
        }
    }

    // muove e disegna quelli esistenti
    alienFireDown() {
        for (let i = Config.alienFireVet.length - 1; i >= 0; i--) {
            let alienBullet = Config.alienFireVet[i];
            alienBullet.y += 5;
            this.drawAlienBullet(alienBullet.x, alienBullet.y,alienBullet.width,alienBullet.height);
            this.checkAlienCollision(alienBullet,i);
        }
    }

}


