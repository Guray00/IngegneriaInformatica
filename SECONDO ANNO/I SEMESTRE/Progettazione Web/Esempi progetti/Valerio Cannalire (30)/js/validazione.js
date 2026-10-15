let loginUser, loginPass, loginInvia, loginErr;
let regUser, regPass, regPassConf, regInvia, regErr;

function validazioneLogin(event) {
    if(event && event.target)
        event.target.classList.add("modificato");

    if (!loginUser.checkValidity() || !loginPass.checkValidity())
    {
        loginInvia.disabled = true;
        loginErr.textContent = "Lo username deve iniziare con una lettera, non può contenere caratteri speciali e deve essere compreso tra 6 e 12 caratteri.\nLa password deve contenere almeno una minuscola, una maiuscola, un numero, un carattere speciale e deve avere lunghezza compresa tra 8 e 15 caratteri.";
    }
    else
    {
        loginInvia.disabled = false;
        loginErr.textContent = "";
    }
}

function validazioneRegistrazione(event) {
    if (event && event.target)
        event.target.classList.add("modificato");

    if (!regUser.checkValidity() || !regPass.checkValidity() || !regPassConf.checkValidity())
    {
        regInvia.disabled = true;
        regErr.textContent = "Lo username deve iniziare con una lettera, non può contenere caratteri speciali e deve essere compreso tra 6 e 12 caratteri.\nLa password deve contenere almeno una minuscola, una maiuscola, un numero, un carattere speciale e deve avere lunghezza compresa tra 8 e 15 caratteri.";
    }
    else if(regPass.value != "" && (regPass.value != regPassConf.value))
    {
        regInvia.disabled = true;
        regErr.textContent = "Le due password non coincidono.";
    }
    else
    {
        regInvia.disabled = false;
        regErr.textContent = "";
    }
}

function gestisciInvioLogin(event) {
    event.preventDefault(); // impedisce il ricaricamento della pagina

    const datiForm = new FormData(event.target);

    fetch("php/login.php", {
        method: "POST",
        body: datiForm
    })
    .then(function(risposta) {
        return risposta.text();
    })
    .then(function(messaggio) {
        if (messaggio === "OK") {
            window.location.href = "php/home.php"; 
        } else {
            loginErr.textContent = messaggio;
        }
    })
    .catch(function(errore) {
        loginErr.textContent = "Errore di connessione al server.";
    });
}

function gestisciInvioRegistrazione(event) {
    event.preventDefault(); // impedisce il ricaricamento della pagina

    const datiForm = new FormData(event.target);

    fetch("php/registrazione.php", {
        method: "POST",
        body: datiForm
    })
    .then(function(risposta) {
        return risposta.text();
    })
    .then(function(messaggio) {
        if (messaggio === "OK") {
            alert("Registrazione avvenuta con successo! Ora puoi effettuare il login.");
            event.target.reset();
            document.getElementById("sezione-registrazione").classList.add("nascosto");
            document.getElementById("sezione-login").classList.remove("nascosto");
            regErr.innerHTML = "&nbsp;";
        } else {
            regErr.textContent = messaggio;
        }
    })
    .catch(function(errore) {
        regErr.textContent = "Errore di connessione al server.";
    });
}

function inizializza() {
    generaHeader({
        guida: true,
        percorsoGuida: false,
        profilo: false,
        linkDestinazione: false
    });
    loginUser = document.getElementById("login-username");
    loginPass = document.getElementById("login-password");
    loginInvia = document.getElementById("btn-login-invia");
    loginErr = document.getElementById("err-login");

    loginUser.addEventListener("input", validazioneLogin);
    loginPass.addEventListener("input", validazioneLogin);
    
    regUser = document.getElementById("reg-username");
    regPass = document.getElementById("reg-password");
    regPassConf = document.getElementById("reg-password-conf");
    regInvia = document.getElementById("btn-reg-invia");
    regErr = document.getElementById("err-reg");

    regUser.addEventListener("input", validazioneRegistrazione);
    regPass.addEventListener("input", validazioneRegistrazione);
    regPassConf.addEventListener("input", validazioneRegistrazione);

    const btnMostraReg = document.getElementById("btn-mostra-reg");
    const btnMostraLogin = document.getElementById("btn-mostra-login");
    const sezLogin = document.getElementById("sezione-login");
    const sezReg = document.getElementById("sezione-registrazione");

    btnMostraReg.addEventListener("click", function() {
        sezLogin.classList.add("nascosto");
        sezReg.classList.remove("nascosto");
        regErr.innerHTML = "&nbsp;";
    });
    btnMostraLogin.addEventListener("click", function() {
        sezReg.classList.add("nascosto");
        sezLogin.classList.remove("nascosto");
        loginErr.innerHTML = "&nbsp;";
    });

    const formLogin = document.getElementById("form-login");
    formLogin.addEventListener("submit", gestisciInvioLogin);

    const formReg = document.getElementById("form-registrazione");
    formReg.addEventListener("submit", gestisciInvioRegistrazione);
}

document.addEventListener("DOMContentLoaded", inizializza);