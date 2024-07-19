<?php
    session_start();
    if(!empty($_SESSION["loggato"]) && !is_null($_SESSION["loggato"])) {
        $_SESSION["IdAgenzia"] = $_SESSION["loggato"];
        header("Location: ./personal-page.php");
    }
?>
<html>
    <head>
        <!-- codici css comuni a tutte le versioni -->
        <link rel="stylesheet" type="text/css" href="./styles/login/login.css" media="screen"/>
        <!-- bootstrap usato per le icone -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
        <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
        <title>Accedi</title>
    </head>
    <body>
        <div id="container">
            <div id="login">
                <div>
                    <h3>Username</h3>
                    <input type="text" id="username-login"/>
                </div>
                <div>
                    <h3>Password</h3>
                    <input type="password" id="password-login"/>
                    <i class="bi bi-eye" onclick="MostraNascondiPsw(this, 'password-login')"></i>
                </div>
                <div>
                    <button onclick="Accedi()">Accedi</button>
                </div>
                <h4 id="error-login" class="errors">Credenziali errate!</h4>
                <a class="change" onclick="SetRegistrati()">Non hai un account? Registrati</a>
            </div>
            <div id="registrazione">
              <div>
                  <h3>Nome Azienda</h3>
                  <input type="text" id="azienda"/>
              </div>
              <div>
                  <h3>Username</h3>
                  <input type="text" id="username-register"/>
              </div>
              <div>
                  <h3>Password</h3>
                  <input type="password" id="password-register"/>
                  <i class="bi bi-eye" onclick="MostraNascondiPsw(this, 'password-register')"></i>
              </div>
              <div>
                  <h3>Conferma Password</h3>
                  <input type="password" id="confirm-password-register"/>
                  <i class="bi bi-eye" onclick="MostraNascondiPsw(this, 'confirm-password-register')"></i>
              </div>
              <div>
                  <button onclick="Registrati()">Registrati</button>
              </div>
              <h4 id="error-register" class="errors"></h4>
              <a class="change" onclick="SetAccedi()">Hai gi&agrave; un account? Accedi</a>
            </div>
        </div>

        <script src="./jscript/login/functions.js"></script>
    </body>
</html>
