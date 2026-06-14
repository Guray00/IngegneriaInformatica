<?php
require_once 'verifica_login.php';
$nome_utente = htmlspecialchars($_SESSION['username']);
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="utf-8">
    <title>Consigli Non Richiesti - Home</title>
    <script src="../js/generaHeader.js"></script>
    <script src="../js/generaDialog.js"></script>
    <script src="../js/home.js"></script>
    <link rel="stylesheet" href="../css/globale.css"> 
    <link rel="stylesheet" href="../css/home.css">
</head>
<body>

    <header></header>

    <main>
        
        <section>
            <h2>Cerca forum:</h2>
            <input type="search" id="barra-ricerca" placeholder="Scrivi il nome di un forum..." maxlength="20">
            <div id="lista-ricerca" class="forum-list"></div>
        </section>

        <section>
            <h2>Forum a cui partecipi</h2>
            <div id="lista-iscritto" class="forum-list"></div>
        </section>

        <section>
            <h2>I tuoi forum</h2>
            <button type="button" id="btn-apri-dialog">Crea Forum <span>+</span></button>
            <div id="lista-propri" class="forum-list"></div>
        </section>

        <div id="dialog-overlay" class="nascosto"></div>
        <dialog id="dialog-crea"></dialog>

    </main>
</body>
</html>