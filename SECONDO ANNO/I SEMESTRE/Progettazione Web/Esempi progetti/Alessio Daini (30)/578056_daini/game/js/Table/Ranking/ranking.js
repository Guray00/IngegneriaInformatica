import{requestRankingDBMS} from "../../Fetch/requestRankingDBMS.js"
//import dalla cartella Configure
import{Config} from "../../Configuration/Config.js";
import {Canvas} from "../../Configuration/Canvas.js";
//import da drawtable
import{drawTable,hide,show} from "../drawTable.js";

// metodo che manda come richiesta il ranking e ne disegna la tabella
async function showRecord() {
    const rows = await requestRankingDBMS();
    drawTable(rows, 3);
    Config.div.style.display = "block";
}

export async function manageRanking() {
    if (Config.appearedDialog) return;

    const showed = Config.show;
    const gameOver = Config.gameOverFlag;
    const won = Config.wonFlag;

    if (showed) {

        if (Canvas !== null) hide(); // nascondiamo il canvas se il canvas non è null

        await showRecord(); // mostriamo il ranking dei record degli utenti

        // si disattiva il bottone, conclusa la prima partita
        if (!gameOver && !won) Config.startButton.disabled = true;
        Config.historyButton.disabled = true; // disattivo il bottone per la tabella degli utenti
        Config.showButton.textContent = "Torna a giocare"; // modifico il testo del bottone
        // rendo visibile solo la tabella corrente
        Config.show = false; 
        Config.tableOn = true;

    } else {

        if (Canvas !== null) show(); // mostriamo il canvas, se non è null
        Config.div.style.display = "none"; // nascondi tabella

        if (!gameOver && !won) Config.startButton.disabled = false;
        Config.historyButton.disabled = false;
        Config.showButton.textContent = "Guarda il sistema di ranking";
        //rendo visibile il canvas
        Config.show = true;
        Config.tableOn = false;

    }
}
