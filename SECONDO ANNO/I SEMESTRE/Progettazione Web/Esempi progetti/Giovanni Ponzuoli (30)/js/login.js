let loggedUsers = null;

function setUp() {

    //Reperimento numero di utenti attualmente loggati dal DB
    let x = new XMLHttpRequest();
    x.open('POST', '../php/getLoggedUsers.php', true);
    x.send();

    x.onload = function() {
        loggedUsers = JSON.parse(x.responseText);

        //Check sul numero di utenti attualmente loggati sul DB
        if (loggedUsers == 0) {
            document.getElementById('leftLogin').style.display = 'inline';
            document.getElementById('rightLogin').style.display = 'none';
        } else if (loggedUsers == 1) {
            document.getElementById('leftLogin').style.display = 'none';
            document.getElementById('rightLogin').style.display = 'inline';
        } else {
            //Redirezione automatica al Tavolo di Gioco
            window.location.href = '../php/game.php';
        }
    }

    document.getElementById('invalidLeftCredentials').style.display = 'none';
    document.getElementById('invalidRightCredentials').style.display = 'none';
}

function validateLogin(ont) {

    //Validazione del login tramite ricerca sul DB
    let x = new XMLHttpRequest();
    x.open('POST', '../php/login_validation.php', true);

    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    if (!ont) {

        let lft = document.getElementById('leftLogin').getElementsByTagName('input');
        x.send('ont=0&usr=' + lft[0].value + '&pwd=' + lft[1].value);
    } else {

        let rgt = document.getElementById('rightLogin').getElementsByTagName('input');
        x.send('ont=1&usr=' + rgt[0].value + '&pwd=' + rgt[1].value);
    }

    x.onload = function() {

        if (JSON.parse(x.responseText) == "Good") {

            if (!ont) {
                document.getElementById('leftLogin').style.display = 'none';
                document.getElementById('rightLogin').style.display = 'inline';
            } else {
                window.location.href = '../php/game.php';
            }
        } else {
            if (!ont) {
                document.getElementById('invalidLeftCredentials').firstChild.nodeValue = JSON.parse(x.responseText);
                document.getElementById('invalidLeftCredentials').style.display = 'inline';
            } else {
                document.getElementById('invalidRightCredentials').firstChild.nodeValue = JSON.parse(x.responseText);
                document.getElementById('invalidRightCredentials').style.display = 'inline';
            }
        }
    }
}