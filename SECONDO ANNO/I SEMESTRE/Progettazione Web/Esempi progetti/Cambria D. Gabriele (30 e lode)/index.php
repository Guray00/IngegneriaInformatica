<?php

session_start();

require_once "./php/includes/methods.php";

$message = null;
$loginError = null;

if(isset($_SESSION["loginError"])){
    $loginError = $_SESSION["loginError"];
    unset($_SESSION["loginError"]);
}

if(isset($_SESSION["message"])){
    $message = $_SESSION["message"];
    unset($_SESSION["message"]);
}
?>


<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Titles</title>
    <link rel="icon" href="images/icon.svg" type="image/svg+xml" sizes="16x16" >
    <meta charset="UTF-8">
    <link rel="stylesheet" href="./css/global/style.css">
    <link rel="stylesheet" href="./css/pages/index.css">
    <script type="module" src="./js/pages/index.js"></script>
    <script>
        const loginError = <?php echo json_encode($loginError); ?>;
        const message = <?php echo json_encode($message)?>;
    </script>
</head>
<body>
    <header>
        <h1><i>Titles</i></h1>
        <aside>
            <button id="loginBtn">Login</button>
            <button id="registerBtn">Sign Up</button>
        </aside>
    </header>

    <section class="intro">
        <div class="context">
            <h2>Benvenuto in <i>Titles</i></h2>
            <p><i>Titles</i> è un gioco che ti permette di creare personaggi e giocare contro quelli degli altri utenti.</p>
        </div>
    </section>

    <section class="infos">
        <div class="slider">
            <button id="slider-prev" class="slider-btn">&#8592;</button>
            <img id="slider-img" src="" alt="Immagine dello slider"/>
            <button id="slider-next" class="slider-btn">&#8594;</button>
        </div>
        <div class="info">
            <h3 id="info-title">Battaglie</h3>
            <div id="info-text">
                <p>Le battaglie si sviluppano in turni da 30 secondi l'uno.</p>
                <p>Durante il tuo turno puoi scegliere se <b>attaccare</b> oppure <b>utilizzare un oggetto</b>.</p>
                <p>Tutti i personaggi hanno una possibilità automatica di <i>schivare i colpi avversari</i>, calcolata in base alle loro statistiche.</p>
            </div>
        </div>

    </section>
    <footer class="footer">
        <a href="documentazione.html"> Guida al gioco</a>
        <p>Creato da <i>Gabriele Domenico Cambria - mat. 672642</i></p>
    </footer>
    <div id="loginModule" class="module"></div>
</body>
</html>
