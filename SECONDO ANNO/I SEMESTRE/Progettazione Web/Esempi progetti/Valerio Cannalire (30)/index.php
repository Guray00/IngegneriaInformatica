<?php
session_start();

/*se l'utente è già loggato viene reinderizzato alla home*/
if (isset($_SESSION['loggato']) && $_SESSION['loggato'] === true) {
    header("Location: php/home.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="utf-8">
    <title>Consigli Non Richiesti - Accesso</title>
    <link rel="stylesheet" href="css/globale.css"> 
    <link rel="stylesheet" href="css/logreg.css">
    <script src="js/generaHeader.js"></script>
    <script src="js/validazione.js"></script>
</head>
<body>

    <header></header>

    <main>        
        <section id="sezione-login" class="box-autenticazione">
            <h2>Accedi al sito</h2>
            <form id="form-login" action="php/login.php" method="POST">
                <div class="campo">
                    <label for="login-username">Username:</label>
                    <input type="text" id="login-username" name="username" title="Lo username deve iniziare con una lettera e contenere tra 6 e 12 caratteri alfanumerici." pattern="[A-Za-z][A-Za-z0-9]{5,11}" placeholder="Inserisci username..." required>
                </div>
                
                <div class="campo">
                    <label for="login-password">Password:</label>
                    <input type="password" id="login-password" name="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,15}"  placeholder="Inserisci password..." required>
                </div>

                <span class="errore" id="err-login">&nbsp;</span>

                <button type="submit" id="btn-login-invia" disabled>Accedi</button>
            </form>
            <p class="switch-autenticazione">Non hai un account? <button type="button" id="btn-mostra-reg">Registrati qui</button></p>
        </section>

        <section id="sezione-registrazione" class="box-autenticazione nascosto">
            <h2>Crea il tuo Account</h2>
            <form id="form-registrazione" action="php/registrazione.php" method="POST">
                <div class="campo">
                    <label for="reg-username">Username:</label>
                    <input type="text" id="reg-username" name="username" pattern="[A-Za-z][A-Za-z0-9]{5,11}" placeholder="Scegli uno username..." required>
                </div>

                <div class="campo">
                    <label for="reg-password">Password:</label>
                    <input type="password" id="reg-password" name="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,15}" placeholder="Crea una password..." required>
                </div>

                <div class="campo">
                    <label for="reg-password-conf">Conferma Password:</label>
                    <input type="password" id="reg-password-conf" name="password_conf" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,15}" placeholder="Ripeti la password..." required>
                </div>
                
                <span class="errore" id="err-reg">&nbsp;</span>

                <button type="submit" id="btn-reg-invia" disabled>Registrati</button>
            </form>
            <p class="switch-autenticazione">Hai già un account? <button type="button" id="btn-mostra-login">Accedi qui</button></p>
        </section>

    </main>

    <footer>
        <p>Progetto di Valerio Cannalire</p>
    </footer>

</body>
</html>