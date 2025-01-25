//validare HTML
//dare un'occhiata al connectDatabase.bat
//riga 206 sistemare il get Users e game php

//*********** DONE *************

//sistemare record con la sessione di gioco onbeforeunload oppure trigger sulle nuove partite
//sistemare i bottoni di gioco nel play game 
//sistemare la selezione della domanda di recupero
//creare la pagina con la classifica
//riguardare la parte grafica e togliere elementi in più
//validare CSS




























let clock = null;
let vec = null;
let firstChoice = null;
let secondChoice = null;
let discovered = null;

let turnPlayer = null;

let lft_score = null;
let lft_helps = null;
let lft_errors = null;

let rgt_score = null;
let rgt_helps = null;
let rgt_errors = null;

let sgt = null;
let clock_sgt = null;

let swpIn = null;
let swpOut = null;
let clock_swp = null;

let dblTurn = null;


// Fisher-Yates Algorithm to create a permutation
function FY_Algorithm(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        const temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}

function setUp() {

    //Corretta Sequenza di visualizzazione
    document.getElementById('leftScore').style.display = 'none';
    document.getElementById('rightScore').style.display = 'none';

    document.getElementById('turnPlayerReminder').firstChild.nodeValue = 'Click the button below to start the game!';
    document.getElementById('newGame').style.display = 'inline';
    document.getElementById('logOutAll').style.display = 'inline';
    document.getElementById('exitGame').style.display = 'none';

    //Creazione Tavolo di Gioco
    let tbl = document.getElementById('gameField');

    for (let i = 0; i < 4; i++) {

        let tr = document.createElement('tr');
        tbl.appendChild(tr)

        for (let j = 0; j < 8; j++) {

            let td = document.createElement('td');
            tr.appendChild(td);
            td.id = i * 8 + j;
            td.className = 'covered';
        }
    }

    //Visualizzazione utenti nel Tavolo di Gioco
    let x = new XMLHttpRequest();

    x.open('POST', '../php/getUsers.php', true);
    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    x.send();

    x.onload = function() {
        if (JSON.parse(x.responseText) != 'notGood') {
            document.getElementById('leftName').firstChild.nodeValue = JSON.parse(x.responseText)['lp'];
            document.getElementById('rightName').firstChild.nodeValue = JSON.parse(x.responseText)['rp'];
        };
    }

}

function playGame() {

    //Inizializzazione punteggi e sistemazione interazioni
    document.getElementById('leftScore').style.display = 'inline';
    document.getElementById('rightScore').style.display = 'inline';
    document.getElementById('newGame').style.display = 'none';
    document.getElementById('logOutAll').style.display = 'none';
    document.getElementById('exitGame').style.display = 'inline';

    //Inizializzazione aiuti
    let ltp = document.getElementById('leftTwentyFivePercent');
    ltp.onclick = function() {
        twentyfivePercentChoice(0);
    }
    ltp.className = null;

    let lsw = document.getElementById('leftSwap');
    lsw.onclick = function() {
        swap(0);
    }
    lsw.className = null;

    let ltw = document.getElementById('leftTwice');
    ltw.onclick = function() {
        doubleTurn(0);
    }
    ltw.className = null;

    let rtp = document.getElementById('rightTwentyFivePercent');
    rtp.onclick = function() {
        twentyfivePercentChoice(1);
    }
    rtp.className = null;

    let rsw = document.getElementById('rightSwap');
    rsw.onclick = function() {
        swap(1);
    }
    rsw.className = null;

    let rtw = document.getElementById('rightTwice');
    rtw.onclick = function() {
        doubleTurn(1);
    }
    rtw.className = null;

    //Inizializzazione carte
    let tds = document.getElementById('gameField').getElementsByTagName('td');

    for (let i = 0; i < tds.length; i++) {
        tds[i].className = 'covered';
        tds[i].style.backgroundImage = "url('../images/cards/c.png')";
        tds[i].onclick = function() {
            makeSelection(this.id);
        }
    }

    //Inizializzazione Quadro di Gioco
    vec = new Array(32);
    for (let i = 0; i < 32; i++) {
        vec[i] = Math.floor(i / 2);
    }
    vec = FY_Algorithm(vec);

    //Inizializzazione Variabili di Gioco
    firstChoice = secondChoice = -1;

    discovered = 0;

    turnPlayer = Math.round(Math.random());
    playerTurnBoxShadow();

    lft_score = 0;
    rgt_score = 0;
    resetScores();

    lft_helps = 3;
    rgt_helps = 3;

    lft_errors = 0;
    rgt_errors = 0;

    clock_sgt = 0;
    clock_swp = 0;

    dblTurn = 0;

    player = Math.floor(Math.random() * 2);

    //Creazione della sessione di gioco sul DB
    let y = new XMLHttpRequest();

    y.open('POST', '../php/game_session.php', true);
    y.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    lft = document.getElementById('leftName').firstChild.nodeValue;
    rgt = document.getElementById('rightName').firstChild.nodeValue;

    y.send("lp=" + lft + "&rp=" + rgt);
}

function playerTurnBoxShadow() {

    //Visualizzazione della box shadow del giocatore di turno
    let thd = document.getElementById('turnPlayerReminder');

    let lft = document.getElementById('leftPlayer');
    let rgt = document.getElementById('rightPlayer');

    if (!turnPlayer) {

        thd.firstChild.nodeValue = document.getElementById('leftName').firstChild.nodeValue + " turn";

        lft.className = 'play';
        rgt.className = 'wait';
    } else {

        thd.firstChild.nodeValue = document.getElementById('rightName').firstChild.nodeValue + " turn";

        lft.className = 'wait';
        rgt.className = 'play';
    }
}

function resetScores() {

    //Inizializzazione del punteggio
    let lft = document.getElementById('leftScore');
    let rgt = document.getElementById('rightScore');

    lft.style.content = "url('../images/scores/0Left.png')";
    rgt.style.content = "url('../images/scores/0Right.png')";
}

function updateScores() {

    //Visualizzazione aggiornamento punteggio
    if (!turnPlayer) {
        let lft = document.getElementById('leftScore');

        //Check sulla vittoria della partita
        if (++lft_score < 9) {
            url_ = '../images/scores/' + lft_score + 'Left.png';
        } else {
            url_ = '../images/scores/' + lft_score + '.png';
        }

        lft.style.content = "url('" + url_ + "')";
    } else {
        let rgt = document.getElementById('rightScore');

        //Check sulla vittoria della partita
        if (++rgt_score < 9) {
            url_ = '../images/scores/' + rgt_score + 'Right.png';
        } else {
            url_ = '../images/scores/' + rgt_score + '.png';
        }

        rgt.style.content = "url('" + url_ + "')";
    }
}

function makeSelection(id) {

    let tds = document.getElementById('gameField').getElementsByTagName('td');

    //Check sulla selezione
    if (firstChoice === -1 && secondChoice === -1) {

        //Prima selezione del turno
        firstChoice = parseInt(id);

        //Visualizzazione prima carta scoperta
        tds[firstChoice].className = 'uncovered';
        url_ = '../images/cards/c_' + vec[firstChoice] + '.png';
        tds[firstChoice].style.backgroundImage = "url('" + url_ + "')";
        tds[firstChoice].onclick = null;

    } else if (firstChoice !== -1 && secondChoice === -1) {

        //Seconda selezione del turno
        secondChoice = parseInt(id);

        //Visualizzazione seconda carta scoperta
        tds[secondChoice].className = 'uncovered';
        url_ = '../images/cards/c_' + vec[secondChoice] + '.png';
        tds[secondChoice].style.backgroundImage = "url('" + url_ + "')";
        tds[secondChoice].onclick = null;

        //Check sulla correttezza della selezione
        if (vec[firstChoice] === vec[secondChoice]) {
            clock = setTimeout('goodSelection()', 2000);
        } else {
            clock = setTimeout('wrongSelection()', 2000);
        }

    } else {

    }
}

function goodSelection() {
    let tds = document.getElementById('gameField').getElementsByTagName('td');

    if (clock_sgt) {
        clearTimeout(clock_sgt);
        disableTwentyFivePercentChoice();
    }

    //Visualizzazione aggiornamento corretta selezione
    tds[firstChoice].className = tds[secondChoice].className = 'found';
    tds[firstChoice].style.backgroundImage = tds[secondChoice].style.backgroundImage = 'none';

    //Reset del turno
    firstChoice = secondChoice = -1;

    //Aggiornamento punteggio
    updateScores();

    //Check di Fine Partita
    if (++discovered == 16) {
        endGame();
    }

    //Check per la disabiitazione del comando TwentyFivePercentChoice per mancanza di tessere
    if (discovered == 14) {
        document.getElementById('leftTwentyFivePercent').onclick = null;
        document.getElementById('rightTwentyFivePercent').onclick = null;
    }
}

function wrongSelection() {
    let tds = document.getElementById('gameField').getElementsByTagName('td');

    //Visualizzazione aggiornamento errata selezione
    tds[firstChoice].className = tds[secondChoice].className = 'covered';
    tds[firstChoice].style.backgroundImage = tds[secondChoice].style.backgroundImage = "url('../images/cards/c.png')";

    //Ripristino proprietà di Selezione
    tds[firstChoice].onclick = function() {
        makeSelection(this.id);
    };

    tds[secondChoice].onclick = function() {
        makeSelection(this.id);
    };

    if (clock_sgt) {
        clearTimeout(clock_sgt);
        disableTwentyFivePercentChoice();
    }

    //Reset del turno
    firstChoice = secondChoice = -1;

    //Check utilizzo aiuto DoubleTurn
    if (dblTurn) {
        dblTurn--;
    } else {
        //Cambio giocatore di turno
        turnPlayer = !turnPlayer;
    }

    //Aggiornamento numero di errori per il giocatore di turno
    if (!turnPlayer) {
        lft_errors++;
    } else {
        rgt_errors++;
    }

    //Cambio box shadow per giocatore di turno
    playerTurnBoxShadow();
}

function twentyfivePercentChoice(ont) {
    let tds = document.getElementById('gameField').getElementsByTagName('td');

    //Check sulla situazione di selezione (dopo aver scoperto la prima carta e nel proprio turno)
    if (firstChoice !== -1 && secondChoice === -1 && ont == turnPlayer) {
        if (!ont) {
            document.getElementById('leftTwentyFivePercent').onclick = null;
            document.getElementById('leftTwentyFivePercent').className = 'used';

            lft_helps--;
        } else {
            document.getElementById('rightTwentyFivePercent').onclick = null;
            document.getElementById('rightTwentyFivePercent').className = 'used';
            rgt_helps--;
        }

        //Creazione dell'array con gli aiuti
        sgt = new Array();

        //Ricerca carta corrispondente e push tra le carte suggerite
        for (let i = 0; i < vec.length; i++) {
            if (vec[i] == vec[firstChoice] && i !== firstChoice) {
                sgt.push(i);
                break;
            }
        }

        //Scelta random e non ridondante delle restanti carte da suggerire
        for (let i = 0; i < tds.length; i++) {
            let k = Math.floor(Math.random() * 32);
            let flag = 0;

            for (let j = 0; j < sgt.length; j++) {
                if (sgt[j] === k) {
                    flag = 1;
                    break;
                }
            }
            if (flag || tds[k].className !== 'covered') {
                i--;
            } else {
                sgt.push(k);

                if (sgt.length === 4) {
                    break;
                }
            }
        }

        //Colorazione temporalmente casuale delle carte suggerite
        sgt = FY_Algorithm(sgt);
        for (let i = 0; i < sgt.length; i++) {
            tds[sgt[i]].className = 'suggested';
        }

        //Timeout di visualizzazione
        clock_sgt = setTimeout('disableTwentyFivePercentChoice()', 5000);
    }
}

function disableTwentyFivePercentChoice() {

    //Disabilitazione carte suggerite
    let tds = document.getElementById('gameField').getElementsByTagName('td');

    for (let i = 0; i < sgt.length; i++) {
        if (tds[sgt[i]].className === 'uncovered' || tds[sgt[i]].className === 'suggested') {
            tds[sgt[i]].className = 'covered';
        };
    }
}

function swap(ont) {
    let tds = document.getElementById('gameField').getElementsByTagName('td');

    //Check sulla situazione di selezione (dopo aver scoperto la prima carta e nel proprio turno)
    if (firstChoice !== -1 && secondChoice === -1 && ont == turnPlayer) {
        if (!ont) {
            document.getElementById('leftSwap').onclick = null;
            document.getElementById('leftSwap').className = 'used';

            lft_helps--;
        } else {
            document.getElementById('rightSwap').onclick = null;
            document.getElementById('rightSwap').className = 'used';

            rgt_helps--;
        }

        //Scelta random della carta da scambiare
        swpIn = swpOut = firstChoice;
        while (swpIn === firstChoice || tds[swpIn].className !== 'covered') {
            swpIn = Math.floor(Math.random() * 32);
        }

        //Scambio
        let aux;
        vec[aux] = vec[swpOut];
        vec[swpOut] = vec[swpIn];
        vec[swpIn] = vec[aux];

        tds[swpIn].className = tds[swpOut].className = 'swapped';
        tds[swpIn].style.backgroundImage = tds[swpOut].style.backgroundImage = "url(../images/cards/c.png)";

        //Ripristino situazione iniziale di turno
        tds[firstChoice].onclick = function() {
            makeSelection(this.id);
        };
        firstChoice = -1;

        //Timeout di visualizzazione
        clock_swp = setTimeout('disableSwap()', 2000);
    }
}

function disableSwap() {
    //Disabilitazione carte scambiate

    let tds = document.getElementById('gameField').getElementsByTagName('td');

    tds[swpIn].className = tds[swpOut].className = 'covered';
}

function doubleTurn(ont) {

    //Check sulla situazione di selezione (prima di aver scoperto la prima carta e nel proprio turno)
    if (firstChoice === -1 && secondChoice === -1 && ont == turnPlayer) {
        dblTurn++;

        if (!ont) {
            document.getElementById('leftTwice').onclick = null;
            document.getElementById('leftTwice').className = 'used';

            lft_helps--;
        } else {
            document.getElementById('rightTwice').onclick = null;
            document.getElementById('rightTwice').className = 'used';

            rgt_helps--;
        }
    }
}

function showProfile(ont) {

    //Ottenimento del profilo selezionato
    let x = new XMLHttpRequest();
    x.open('POST', '../php/getProfile.php', true);

    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    let lft = document.getElementById('leftName').firstChild.nodeValue;
    let rgt = document.getElementById('rightName').firstChild.nodeValue;

    //Check sulla situazione di selezione (prima di giocare o nel proprio turno)
    if (ont == turnPlayer || turnPlayer == null) {

        //Apertura nuova pagina con le statistiche
        const wdw = document.open('', '', 'width=800,height=400');

        if (!ont) {
            x.send("pr=" + lft + "&vs=" + rgt);
        } else {
            x.send("pr=" + rgt + "&vs=" + lft);
        }

        x.onload = function() {
            let data = JSON.parse(x.responseText);

            let html = "<!DOCTYPE html><html lang='en-US'><head><meta charset='utf-8'><title> Social Memory </title> <link rel='stylesheet' href='../css/profile.css'><link rel='stylesheet' href='../css/footer.css'></head> <body>";

            html += "<div id='information'> <h2>" + data.profile + "</h2><p id ='joined'> Joined since<br>" + data.joined + "</p>" + "<p id ='score'> Score " + data.score + "</p>" + "<p id ='tier'> Tier " + data.tier + "</p></div>";
            html += "<div id='stats'><p id='played'>Games played " + data.played + "</p><p id='won'>Games won " + data.won + "</p><p id='playedVs'>Games played against " + data.opponent + " " + data.playedVs + "</p><p id='wonVs'>Games won against " + data.opponent + " " + data.wonVs + "</p><p id='tiedVs'>Games tied against " + data.opponent + " " + data.tiedVs + "</p><p id='lostVs'>Games lost against " + data.opponent + " " + data.lostVs + "</p></div>";

            html += "</body></html>";

            wdw.document.write(html);
        }
    }
}

function logOut(ont) {

    //Check sulla situazione di selezione (prima di giocare o nel proprio turno)
    if (ont == turnPlayer || turnPlayer == null) {
        let rsl = window.confirm('Are you sure you want to quit the game and logout?');

        if (rsl) {

            //Aggionamento del logout sul DB
            let x = new XMLHttpRequest();

            x.open('POST', '../php/logout_session.php', true);
            x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            let lft = document.getElementById('leftName').firstChild.nodeValue;
            let rgt = document.getElementById('rightName').firstChild.nodeValue;

            if (!ont) {
                x.send("lo=0&lp=" + lft + "&rp=" + rgt);
            } else {
                x.send("lo=1&lp=" + lft + "&rp=" + rgt);
            }

            x.onload = function() {
                if (x.responseText) {
                    window.location.href = './login.php';
                };
            }
        }
    }
}

function showManual() {
    document.open('../manual.html', '', 'width =1000,height=500');
}

function endGame() {

    let tds = document.getElementById('gameField').getElementsByTagName('td');

    //Visualizzazione Tavolo di Gioco Scoperto alla fine della partita
    for (let i = 0; i < tds.length; i++) {
        tds[i].className = 'uncovered';
        url_ = '../images/cards/c_' + vec[i] + '.png';
        tds[i].style.backgroundImage = "url('" + url_ + "')";
    }

    //Disabilitazione aiuti
    document.getElementById('leftTwentyFivePercent').onclick = null;
    document.getElementById('leftSwap').onclick = null;
    document.getElementById('leftTwice').onclick = null;

    document.getElementById('rightTwentyFivePercent').onclick = null;
    document.getElementById('rightSwap').onclick = null;
    document.getElementById('rightTwice').onclick = null;

    //Visualizzazione del risultato nella barra di interazione
    let thd = document.getElementById('turnPlayerReminder');
    let lft = document.getElementById('leftName').firstChild.nodeValue;
    let rgt = document.getElementById('rightName').firstChild.nodeValue;

    if (lft_score > rgt_score) {
        thd.firstChild.nodeValue = lft + ' wins the game! Click the button below to start a new game';
    } else if (lft_score < rgt_score) {
        thd.firstChild.nodeValue = rgt + ' wins the game! Click the button below to start a new game';
    } else {
        thd.firstChild.nodeValue = 'Tie game! Click the button below to start a new game';
    }

    //Registrazione della partita nel DB
    let x = new XMLHttpRequest();

    x.open('POST', '../php/close_game_session.php', true);
    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    x.send("lp=" + lft + "&lPo=" + lft_score + "&lHe=" + lft_helps + "&lEr=" + lft_errors + "&rp=" + rgt + "&rPo=" + rgt_score + "&rHe=" + rgt_helps + "&rEr=" + rgt_errors);

    //Sistemazione footer
    document.getElementById('newGame').style.display = 'inline';
    document.getElementById('logOutAll').style.display = 'inline';
    document.getElementById('exitGame').style.display = 'none';

    //Eliminazione giocatore di turno
    turnPlayer = null;
}

function leaveGame() {

    //Ottenimento password del giocatore non di turno per chiudere il matvh con nulla di fatto dal DB
    let x = new XMLHttpRequest();
    x.open('POST', '../php/getPassword.php', true);

    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    if (!turnPlayer) {
        x.send("pfl=" + document.getElementById('rightName').firstChild.nodeValue);
    } else {
        x.send("pfl=" + document.getElementById('leftName').firstChild.nodeValue);
    }

    x.onload = function() {
        if (x.responseText) {
            let ppt = 0;

            if (!turnPlayer) {
                ppt = prompt(document.getElementById('rightName').firstChild.nodeValue + ' please enter your password to leave the game', '');
            } else {
                ppt = prompt(document.getElementById('leftName').firstChild.nodeValue + ' please enter your password to leave the game', '');
            }

            if (ppt == JSON.parse(x.responseText)) {

                //Cancellazione partita dal DB
                let y = new XMLHttpRequest();
                y.open('POST', '../php/delete_game_session.php', true);

                y.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                let lft = document.getElementById('leftName').firstChild.nodeValue;
                let rgt = document.getElementById('rightName').firstChild.nodeValue;

                y.send('lp=' + lft + '&rp=' + rgt);

                y.onload = function() {

                    //Logout congiunto dal DB
                    let x_0 = new XMLHttpRequest();
                    let x_1 = new XMLHttpRequest();

                    x_0.open('POST', '../php/logout_session.php', true);
                    x_0.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                    x_1.open('POST', '../php/logout_session.php', true);
                    x_1.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                    let lft = document.getElementById('leftName').firstChild.nodeValue;
                    let rgt = document.getElementById('rightName').firstChild.nodeValue;

                    x_0.send("lo=0&lp=" + lft + "&rp=" + rgt);
                    x_1.send("lo=1&lp=" + lft + "&rp=" + rgt);
                }
                window.location.href = '../index.php';
            } else {
                alert('Invalid input, game continues');
            }
        }
    }
}

function logOutAll() {

    //Logout Congiunto dal DB
    let x_0 = new XMLHttpRequest();
    let x_1 = new XMLHttpRequest();

    x_0.open('POST', '../php/logout_session.php', true);
    x_0.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    x_1.open('POST', '../php/logout_session.php', true);
    x_1.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    let lft = document.getElementById('leftName').firstChild.nodeValue;
    let rgt = document.getElementById('rightName').firstChild.nodeValue;

    x_0.send("lo=0&lp=" + lft + "&rp=" + rgt);
    x_1.send("lo=1&lp=" + lft + "&rp=" + rgt);

    window.location.href = '../index.php';
}

window.addEventListener('beforeunload', (e) => {

    e.returnValue = "Are you sure to leave this page. Users will be logged out";
})