<?php
require_once 'verifica_login.php';
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="utf-8">
    <title>Consigli Non Richiesti - Profilo</title>
    <link rel="stylesheet" href="../css/globale.css">
    <link rel="stylesheet" href="../css/profilo.css"> 
    <script src="../js/generaHeader.js"></script>
    <script src="../js/profilo.js"></script>
</head>
<body>

    <header></header>

    <main>
        <div class="griglia-statistiche">
            <div class="cella-statistica">
                <span id="stat-post" class="numero-stat"></span>
                <span class="etichetta-stat">Post Pubblicati</span>
            </div>
            <div class="cella-statistica">
                <span id="stat-bilancio" class="numero-stat"></span>
                <span class="etichetta-stat">Bilancio Voti</span>
            </div>
            <div class="cella-statistica">
                <span id="stat-forum" class="numero-stat"></span>
                <span class="etichetta-stat">Forum seguiti</span>
            </div>
        </div>

        <div id="area-pulsante-logout"></div>
    </main>
</body>
</html>