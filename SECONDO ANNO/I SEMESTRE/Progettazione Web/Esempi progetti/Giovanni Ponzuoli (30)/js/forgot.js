let clock_fgt = null;

function setUp() {
    //Corretta Sequenza di visualizzazione
    document.getElementById('usrForgot').style.display = 'inline';
    document.getElementById('pwdForgot').style.display = 'none';
}

function validateUsrForgot() {

    //Validazione della presenza dell'user nel DB
    let x = new XMLHttpRequest();
    x.open('POST', '../php/forgot_user_validation.php', true);

    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    let inputs = document.getElementById('usrForgot').getElementsByTagName('input');

    let usr = inputs[0].value;

    x.send("usr=" + usr);

    x.onload = function() {
        if (JSON.parse(x.responseText) == "Good") {

            //Corretta Sequenza di visualizzazione
            document.getElementById('usrForgot').style.display = 'none';
            document.getElementById('pwdForgot').style.display = 'inline';
            document.getElementById('answered').style.display = 'none';

            //Reperimento domanda di recupero dal DB
            let y = new XMLHttpRequest();
            y.open('POST', '../php/getQuestion.php', true);

            y.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            y.send("usr=" + usr);

            y.onload = function() {

                //Check sull'acquisizione della domanda
                if (JSON.parse(y.responseText) != "notGood") {
                    document.getElementById('recQuestion').textContent = JSON.parse(y.responseText);
                }
            }
        } else {
            //Visualizzazione Errore
            document.getElementById('invalidUsrCredentials').style.display = 'inline';
            document.getElementById('invalidUsrCredentials').firstChild.nodeValue = JSON.parse(x.responseText);
        }
    }
}

function validatePwdForgot() {

    //Validazione della correttezza della risposta alla domanda di recupero nel DB
    let x = new XMLHttpRequest();
    x.open('POST', '../php/forgot_password_validation.php', true);

    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    let inputs = document.getElementById('usrForgot').getElementsByTagName('input');
    let usr = inputs[0].value;

    let inputs_ = document.getElementById('pwdForgot').getElementsByTagName('input');
    let ans = inputs_[0].value;

    x.send("usr=" + usr + "&ans=" + ans);

    x.onload = function() {

        //Check sulla correttezza della risposta
        if (JSON.parse(x.responseText)['vld']) {

            //Visualizzazione della password recuperata
            document.getElementById('notAnswered').style.display = 'none';
            document.getElementById('answered').style.display = 'inline';
            document.getElementById('showPassword').firstChild.nodeValue = 'Your password is ' + JSON.parse(x.responseText)['pwd'];

            //Redirezione con timeout alla pagina di login
            clock_fgt = setTimeout("window.location.href = '../php/login.php';", 3000);

        } else {
            //Visualizzazione Errore
            document.getElementById('invalidPwdCredentials').firstChild.nodeValue = JSON.parse(x.responseText)['msg'];
            document.getElementById('invalidPwdCredentials').style.display = 'inline';
        };
    }
}