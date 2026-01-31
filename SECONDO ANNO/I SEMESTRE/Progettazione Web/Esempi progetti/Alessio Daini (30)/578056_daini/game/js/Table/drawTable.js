//importo dalla cartella Configure
import {Config} from "../Configuration/Config.js";
import { Canvas } from "../Configuration/Canvas.js";
//importo dalla cartella Fetch


Canvas.init();

export function hide() {
    Canvas.hideCanvas(); // nascondiamo il display
}

export function show() {
    Canvas.setVisibleCanvas(); // rendiamo visibile il canvas
}

function buildTable(rows,manyColumn){
    const manyRows = rows.length; 
    for(let i = 0; i < manyRows + 1;++i){ 

        const tr = document.createElement("tr"); 
        
        for(let j = 0; j < manyColumn;++j){ 
        
            const td = document.createElement("td"); 
        
            if(i === 0){
                // gestione prima riga della tabella 
                if(manyColumn === 3) td.textContent = ((j === 0)? "pos" : ((j === 1) ? "username" : "record")); 
                else td.textContent = ((j === 0)? "username" : ( (j === 1) ? "punteggio" : ( (j === 2)? "data" : "risultato partita") ) ); 
                
            //gestione altre righe: caso classifica dei record di ogni utente
            } else if (manyColumn === 3){
                 
                const row = rows[i-1]; 
                // prima colonna: posizione in classifica; seconda colonna: username dell'utente; terza colonna: il record personale dell'utente
                td.textContent = ((j === 0) ? row.pos : ((j === 1) ? row.username : row.record)); 
                const pos = Number(row.pos); 
                
                // colorazione a seconda della posizione in classifica 
                if (pos <= 3) { 
                    const className = ((pos === 1) ? "gold" : ((pos === 2) ? "silver" : "bronze")); 
                    td.classList.add(className); 
                } 
            //gestione altre righe: i migliori 20 performance salvate dall'utente
            }else{ 
                const row = rows[i-1]; 
                // prima colonna username; seconda colonna: il punteggio; terza colonna: la data di sessione di gioco; quarta colonna: vittoria o sconfitta
                td.textContent = ((j === 0)? row.username : ( (j === 1) ? row.points : ( (j === 2)? row.date : row.won) ) ); 
            } 
        
            tr.appendChild(td); 
        }

        Config.table.appendChild(tr); 
    }
        
}
        
export function drawTable(rows,manyColumn){ 
    // se c'è una tabella presente,  ne eliminiamo le righe
    if(Config.table.rows.length != 0){ 
        const rowsTable = Config.table.querySelectorAll("tr"); 
        for(let rows of rowsTable) rows.remove(); 
    } 
    // si disegna la tabella corrente
    buildTable(rows,manyColumn); 
} 

