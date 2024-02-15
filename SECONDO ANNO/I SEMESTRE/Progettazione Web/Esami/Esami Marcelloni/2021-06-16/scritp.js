/*
griglia 10x10
tasto START
estrae 5 elementi della griglia e assegna un numero progressivo da 1 a 5
estrae un elemento dela griglia (diverso dai precedenti) come punto di partenza
parte un cronometro che indica la durata della partita (in secondi)
obiettivo:
muovere con le freccie il quadrato nero e raccogliere i quadrati numeri nell'ordine corretto
e senza mai riattraversarse lo stesso quadratino
contatore quadratini che conta il numero di quadratini attraversati
contatore bersagli che conta il numero di quadratini numerati attraversati
in caso di errore: (riattraversamento o ordine scorretto)
-> fine gioco + finestra (3secondi) che notifica la cosa all'utente
in caso di vittoria:
-> fine gioco + finestra (indeterminato) che notifica la cosa e comunica il tempo impiegato per concludere la partita
quando la finestra si chiude/viene chiusa il gioco si riporta alle condizioni iniziali
*/

// matrice in cui salvo i riferimenti agli elementi del griglia
let matrice = [];
// array delle caselle estratte
let bersagli = [];
// posizione di partenza
let player = {
    x: null,
    y: null
}
// tempo
let time = 0;
// timeout
let timeout;

function delete_grid(){
    let target = document.querySelector(".grid-container table");
    if(target){
        target.remove();
        console.log("Tabella rimossa!");
    }
}

function create_grid(){
    let dim = 10;
    let target = document.querySelector(".grid-container");
    let table = document.createElement("table")
    target.appendChild(table);
    target = table;
    console.log(target);
    for(let i = 0; i < dim;i++){
        // crea le righe
        let row = document.createElement("tr");
        target.appendChild(row);
        let riga = [];
        matrice.push(riga);
        for(let j = 0; j < dim;j++){
            // crea gli elementi delle righe
            let field = document.createElement("td");
            row.appendChild(field);
            // associa l'elemento alla matrice
            matrice[i].push(field);
        }
    }
    console.log(matrice);
    console.log("Tabella creata!");
}


function trova_bersagli(){
    let x, y;
    while(bersagli.length < 5){
        x = Math.floor(Math.random()*10);
        y = Math.floor(Math.random()*10);
        // controllo che non sia già stata scelta
        if(!matrice[x][y].classList.contains("bersaglio")){
            bersagli.push(matrice[x][y]);
            matrice[x][y].classList.add("bersaglio");
            matrice[x][y].classList.add(bersagli.length);
            matrice[x][y].textContent = bersagli.length;
        } 
    }
    console.log(bersagli);
}

function player_position(){
    
    while(!player.x){
        let x = Math.floor(Math.random()*10);
        let y = Math.floor(Math.random()*10);

        // controlla che non sia un bersaglio
        if(!matrice[x][y].classList.contains("bersaglio")){
            player.x = x;
            player.y = y;
            console.log(player);
            matrice[x][y].classList.add("player");
            // casella vista
            matrice[x][y].classList.add("seen");
        }
    }
}

function start_watch(){
    document.querySelector(".tempo .value").textContent = time;
    time++;
    timeout = setTimeout(start_watch,1000);
}

function move_player(y, x){
    // x e y sono le posizioni relative rispetto alla posizione del giocatore
    let quadratini = document.querySelector(".quadratini .value").textContent;
    if(!quadratini){
        quadratini = 0;
    }
    quadratini++;
    // vecchia posizione
    matrice[player.x][player.y].classList.remove("player");

    player.x += x;
    player.y += y;


    // uscita dai bordi
    if(player.x < 0){
        player.x = 0;
        quadratini--;
        matrice[player.x][player.y].classList.add("player");
        return;
    }else if(player.x > 9){
        player.x = 9;
        quadratini--;
        matrice[player.x][player.y].classList.add("player");
        return;
    }

    if(player.y < 0){
        player.y = 0;
        quadratini--;
        matrice[player.x][player.y].classList.add("player");
        return;
    }else if(player.y > 9){
        player.y = 9;
        quadratini--;
        matrice[player.x][player.y].classList.add("player");
        return;
    }

    // riattraversamento
    if(matrice[player.x][player.y].classList.contains("seen")){
        fine_partita(false);
        return;
    }

    // controllo che i bersagli siano attraversati in ordine
    if(matrice[player.x][player.y].classList.contains("bersaglio")){
        if(matrice[player.x][player.y] != bersagli[0]){
            fine_partita(false);
            return;
        }else{
            // bersaglio corretto
            bersagli.splice(0,1);
            console.log(bersagli);
            document.querySelector(".bersagli .value").textContent++;
            if(bersagli.length == 0){
                fine_partita(true);
            }
        }
    }

    document.querySelector(".quadratini .value").textContent = quadratini;
    // nuova posizione
    matrice[player.x][player.y].classList.add("player", "seen");

    
}

function fine_partita(esito){
    clearTimeout(timeout);
    if(esito){
        console.log("vittoria");
        let _result = window.open("", "", "width=200, heigth=300");
        _result.document.open();
        _result.document.write("Hai vinto in " + time + " secondi!");
        setTimeout(function(){
            _result.close();
        },20000)
        set_up();
    }else{
        console.log("sconfitta");
        let _result = window.open("", "", "width=200, heigth=300");
        _result.document.open();
        _result.document.write("Hai perso!");
        setTimeout(function(){
            _result.close();
        },3000)
        set_up();
    }
    // riattiva start
    document.querySelector(".start").disabled = false;
}

function start_game(){
    // disattiva start
    document.querySelector(".start").disabled = true;
    // estre i bersagli
    trova_bersagli();

    // posiziona il giocatore
    player_position();

    // fa partire il cronometro
    start_watch();
}

function set_up(){
    
    // reset
    // matrice in cui salvo i riferimenti agli elementi del griglia
    matrice = [];
    // array delle caselle estratte
    bersagli = [];
    // posizione di partenza
    player.x = null;
    player.y = null;
    // tempo
    time = 0;
    // quadratini
    document.querySelector(".quadratini .value").textContent = 0;
    // bersagli
    document.querySelector(".bersagli .value").textContent = 0;
    // cancello e ricreo la griglia
    // alla prima aperta non ci sono problemi
    delete_grid();
    create_grid();
}


set_up();
// aggiunge l'event listerner
addEventListener('keydown', function(e){
    let tasto = e.code;
    //console.log(tasto);
    switch(tasto){
        case 'ArrowLeft':
            move_player(-1, 0);
            break;
        case 'ArrowRight':
            move_player(1, 0);
            break;
        case 'ArrowUp':
            move_player(0, -1);
            break;
        case 'ArrowDown':
            move_player(0, 1);
            break;
        default:
            break;
    }
});