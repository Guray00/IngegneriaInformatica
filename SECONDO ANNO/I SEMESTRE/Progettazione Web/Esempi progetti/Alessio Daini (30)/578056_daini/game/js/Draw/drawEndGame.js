import{Config} from "../Configuration/Config.js";

// helper per disegnare testo con effetto "glitch"
function drawGlitchText(ctx, text, x, y, fontSize) {
    ctx.save();//salvo lo stato del canvas, mi serve per quando si vuole ritornare allo schermo nero di partenza
    ctx.textAlign = "center";
    ctx.font = "bold " + fontSize + "px Arial";

    // disegno di base (bianco)
    ctx.fillStyle = "white";
    ctx.fillText(text, x, y);

    // RGB split
    const layers = [
        { color: "red" },
        { color: "lime" },
        { color: "cyan" }
    ];

    //colori posizionati casualmente
    for (const layer of layers) {
        const dx = (Math.random() - 0.5) * (fontSize * 0.06);
        const dy = (Math.random() - 0.5) * (fontSize * 0.06);
        ctx.fillStyle = layer.color; //metto i colori del layers
        ctx.globalAlpha = 0.6;
        ctx.fillText(text, x + dx, y + dy); // coloro un testo, di dimensione leggermente variabile, in modo da rendere visibili i glitch
    }

    ctx.globalAlpha = 1.0; // si sovrappongono i prossimi frame su quelli già disegnati, avendo effetto opaco

    // pixel di disturbo
    const textWidth = ctx.measureText(text).width; // dimensione del testo in pixel
    const noiseCount = Math.floor(Math.random() * 19) + 1;
    // produzioni di rettangoli di disturbo casuale, fino a 20 volte per chiamata
    for (let i = 0; i < noiseCount; i++) {
        const px = x - textWidth / 2 + Math.random() * textWidth;
        const py = y - fontSize * 0.7 + Math.random() * fontSize * 1.2;
        const w = Math.random() * 3 + 1; // larghezza casuale dei pixel
        const h = Math.random() * 3 + 1; // altezza causale dei pixel
        ctx.fillStyle = Math.random() > 0.5 ? "white" : "rgba(255,255,255,0.3)";
        ctx.fillRect(px, py, w, h); // riempio di bianco i pixel, in modo da dare un effetto di disturbo
    }

    ctx.restore(); // ripristino il canvas allo stato precedente, usando le impostazioni precedentemente salvate
}

function drawShiningText(ctx,canvas,x,y,fontSize){
    const smallFont = Math.max(14, Math.floor(canvas.width * 0.04)); // massimo fra carattere 14 e una dimensione proporzionale del canvas
    ctx.font = smallFont + "px Arial";
    ctx.textAlign = "center";
    // si sceglie il seno, perché è una funzione periodica usata per la trasmissione di segnali, quindi risulta oscillante in maniera costante per ogni 2 pi greco
    //Date.now restituisce in ms la Data attuale
    const alpha = Math.abs(Math.sin(Date.now() / 200)); // abbiamo periodo 2 pigreco e per ogni 200 millisecondi si hanno circa 1257 ms, che sono 1.3 secondi di tempo per il lampeggio
    ctx.fillStyle = "rgba(255,255,255," + alpha + ")";
    ctx.fillText("Premi R per ricominciare", x, y + fontSize * 0.9);
}

// disegna il messaggio di fine gioco sul canvas principale
export function drawEndGameMessage(canvasClass) {
    if (!canvasClass) return;

    const ctx = canvasClass.ctx;
    const canvas = canvasClass.canvas;
    if (!ctx || !canvas) return; // se sono a null, non posso disegnare

    // sfondo semitrasparente
    ctx.fillStyle = "rgba(0,0,0,0.85)";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    const message = Config.gameOverFlag ? "GAME OVER" : (Config.wonFlag ? "VITTORIA!" : "");
    const fontSize = Math.max(80, Math.floor(canvas.width * 0.15));
    const x = canvas.width / 2;
    const y = canvas.height / 2 - Math.floor(fontSize * 0.15);

    //disegno del testo glichato
    drawGlitchText(ctx, message, x, y, fontSize);

    // testo secondario lampeggiante
    drawShiningText(ctx,canvas,x,y,fontSize);
}
