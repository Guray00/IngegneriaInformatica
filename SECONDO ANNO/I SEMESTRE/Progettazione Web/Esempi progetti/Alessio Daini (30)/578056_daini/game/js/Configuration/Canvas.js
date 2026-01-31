export class Canvas {
    static canvas = null; //canvas, elemento html
    static ctx = null; // contesto
    static gameContainer = null; // riferimento al container del canvas

    //inizializzazione canvas
    static init() {
        this.canvas = document.getElementById("gameCanvas"); // elemento canvas html
        this.ctx = this.canvas.getContext("2d"); // contesto 2D
        this.gameContainer = document.getElementById("gameContainer"); // div che racchiude il canvas
    }

    // focus e accessibilità: firefox non mette in automatico il focus sul canvas
    static changeFocus(){
        this.canvas.tabIndex = 0;
        this.canvas.focus();
    }

    //nascondi il canvas
    static hideCanvas() {
        this.canvas.style.display = "none";
    }

    //rendi visibile il canvas
    static setVisibleCanvas() {
        this.canvas.style.display = "block";
    }
    
}
