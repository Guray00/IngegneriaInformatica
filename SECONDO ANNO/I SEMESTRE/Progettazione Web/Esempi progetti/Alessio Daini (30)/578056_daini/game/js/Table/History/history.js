//import dalla cartella Fetch
import { requestHistory } from "../../Fetch/requestHistory.js";
import { readUsername } from "../../Fetch/readUsername.js";

//import falla cartella Configure
import { Config } from "../../Configuration/Config.js";
import {Canvas} from "../../Configuration/Canvas.js";
//import da drawTable
import { hide,show,drawTable } from "../drawTable.js";

export async function manageHistory() {
    if (Config.appearedDialog) return;

    const showed = Config.show;
    const gameOver = Config.gameOverFlag;
    const won = Config.wonFlag;

    if (showed) {
        const username = await readUsername(); // mi ricavo lo username
        if (Canvas !== null) hide();
        await showHistory(username); // mostro la tabella dei migliori 20 performance dell'utente

        if (!gameOver && !won) Config.startButton.disabled = true;
        Config.showButton.disabled = true;
        Config.historyButton.textContent = "Torna a giocare";
        Config.show = false;
        Config.tableOn = true;

    } else {
        if (Canvas !== null) show();
        Config.div.style.display = "none"; // nascondi tabella

        if (!gameOver && !won) Config.startButton.disabled = false;
        Config.showButton.disabled = false;
        Config.historyButton.textContent = "Guarda i tuoi migliori progressi";
        Config.show = true;
        Config.tableOn = false;
    }
}

// metodo che manda come richiesta i migliori 20 performance dell'utente e ne disegna la tabella
async function showHistory(username) {
    const rows = await requestHistory(username);
    drawTable(rows, 4);
    Config.div.style.display = "block";
}