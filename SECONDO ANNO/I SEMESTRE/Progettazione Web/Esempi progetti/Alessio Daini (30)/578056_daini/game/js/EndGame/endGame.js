import { Config } from "../Configuration/Config.js";
import{drawEndGameMessage} from "../Draw/drawEndGame.js";

import { sendDBMSRequest } from "../Fetch/sendDBMSRequest.js";
import { updateMatchRequest } from "../Fetch/updateMatchRequest.js";

// funzione di fine partita
function endSetting(won) {
    Config.game = false;             // ferma la logica del gioco
    if (won) Config.wonFlag = true; 
    else Config.gameOverFlag = true;

    // abilitazione bottoni
    Config.saveButton.disabled = false;
    Config.showButton.disabled = false;
    Config.historyButton.disabled = false;
    Config.backButton.disabled = false;
}

// gameOver
export function gameOver(canvas) {
    endSetting(false);
    drawEndGameMessage(canvas);
}

// vittoria
export function won(canvas) {
    endSetting(true);
    Config.points += Config.bonus;
    Config.updatePointsHeader(); // aggiornamento del contatore header, in caso di vittoria
    drawEndGameMessage(canvas); // disegno del canvas nel caso della conclusione di gioco
}

// salva i progressi (puoi continuare con DBMS)
export async function saveProgress() {

    Config.saveButton.disabled = true;

    const username = Config.username;
    if (!username) {
        console.error("Errore: username vuoto");
        return;
    }

    //data allineata rispetto alla datezone locale
    const wonFlag = Config.wonFlag ? 1 : 0; // conversione esplicita per il DBMS
    const oggi = new Date(); // esempio formato di Date: 2026-01-07 14:30:00 GMT+0100 (Italia)
    const offset = oggi.getTimezoneOffset() * 60000; //la differenza in minuti tra UTC e la timezone locale in millesecondi
    const dataMySQL = new Date(oggi - offset).toISOString().slice(0,19).replace('T', ' ');
    // oggi - offset, sottrae in termini di millisecondi la data locale - data rispetto a UTC. sostituendoci la data corretta
    // toISOString per aver la data in formato ISO 2026-01-07T13:30:00.000Z
    // estrazione dei primi 19 caratteri e sostituzione di T con ' ', così che diventi: 2026-01-07 13:30:00, compatibile con il formato DATETIME del DBMS

    try {
        await sendDBMSRequest(username);
        await updateMatchRequest(username, dataMySQL, wonFlag);
    } catch (err) {
        console.error("Errore durante il salvataggio:", err);
    }
}

