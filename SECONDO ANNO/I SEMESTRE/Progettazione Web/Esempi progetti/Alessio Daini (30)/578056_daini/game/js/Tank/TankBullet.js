import { won } from "../EndGame/endGame.js";
import { Canvas } from "../Configuration/Canvas.js";
import { Config } from "../Configuration/Config.js";

export class TankBullet{

    tank = null;
    tankX = null;
    tankY = null;
    tankW = null;
    tankH = null;
    widthBullet = 4;
    heightBullet = 10;

    constructor(tank){
        this.tank = tank;
    }

    createFire() {
        const startX = this.tank.tankX;
        const startY = this.tank.tankY - this.tank.tankH * 0.5;
        Config.fireVet.push({ alive: true, posX: startX, posY: startY });
    }

    updateFire() {
        Canvas.ctx.fillStyle = "red";
    
        for (let i = 0; i < Config.fireVet.length; i++) {
            let bullet = Config.fireVet[i];
            if (!bullet.alive) continue;
            bullet.posY -= 10;
            Canvas.ctx.fillRect(bullet.posX - 2, bullet.posY - 10, this.widthBullet, this.heightBullet);
            this.checkCollision(bullet);
        }
    
        for (let i = Config.fireVet.length - 1; i >= 0; i--) {
            if (!Config.fireVet[i].alive) Config.fireVet.splice(i, 1);
        }
    }

    checkCollision(bullet) {

        //se colpisco il bordo o il muro il moltiplicatore si resetta, così il suo contatore
        if (bullet.posY < Config.borderSize * 2) {
            bullet.alive = false;
            Config.resetCounters();
            return;
        }
    
        // collisione con i blocchi
        for (let i = 0; i < Config.blockVet.length; ++i) {
            let block = Config.blockVet[i];
            let rangeBlockX = bullet.posX + this.widthBullet >= block.x && bullet.posX <= block.x + block.w;
            let rangeBlockY = bullet.posY >= block.y && bullet.posY <= block.y + block.h;
    
            if (rangeBlockX && rangeBlockY) {
                    bullet.alive = false;
                    block.lifes--;
                    Config.resetCounters();
                    if (block.lifes === 0) {
                        Config.blockVet.splice(i, 1);
                    }
                    return; // esco dopo collisione con blocco
                }
            }
    
        // collisione con gli alieni
        for (let i = 0; i < Config.alienVet.length; ++i) {
            let alien = Config.alienVet[i];
            let rangeAlienX = bullet.posX + this.widthBullet >= alien.x && bullet.posX <= alien.x + alien.w;
            let rangeAlienY = bullet.posY >= alien.y && bullet.posY <= alien.y + alien.h;
    
            if (rangeAlienX && rangeAlienY && alien.alive) {
                bullet.alive = false;
                Config.updatePoints(); 
            // riduci le vite (se vuoi più colpi richiesti, imposta lifes iniziale >1)

            let numberAlien = --Config.alienNumber;

            if( (numberAlien > 13 && numberAlien % 13 === 0) || (numberAlien < 13 && numberAlien % 5 === 0))
            Config.step++;
    
            alien.lifes--;
            if (alien.lifes <= 0) 
                // rimuovi l'alieno dall'array
                alien.alive = false;
            
            if(Config.alienNumber == 0)
                won();
    
            return; // esco, bullet consumato
        }
    
      }
    
    }

}
