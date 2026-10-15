<?php
require_once 'verifica_login.php';
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="../css/globale.css">
    <link rel="stylesheet" href="../css/forum.css">
    <script src="../js/generaHeader.js"></script>
    <script src="../js/generaDialog.js"></script>
    <script src="../js/forum_stato.js"></script>
    <script src="../js/forum_interfaccia.js"></script>
    <script src="../js/forum_operazioni.js"></script>
    <script src="../js/forum_inizializza.js"></script>
</head>
<body>

    <header></header>

    <main>        
        <aside class="colonna-sinistra">
            
            <div class="sezione-menu-laterale" id="area-pulsanti"></div>

            <div class="sezione-menu-laterale nascosto" id="menu-amministrazione">
                <h2>Sei l'admin</h2>
                <button type="button" id="btn-nuovo-topic">+ Topic</button>
            </div>

            <div class="sezione-menu-laterale">
                <h2>Filtraggio</h2>
                <div id="opzioni-filtri">
                    <label><input type="radio" name="modalita_ricerca" value="affianca" checked>Somma</label>
                    <label><input type="radio" name="modalita_ricerca" value="filtra">Incrocia</label>
                </div>
            </div>

            <div class="sezione-menu-laterale">
                <h2>Topic del Forum</h2>
                <div class="lista-topic-scroll" id="topic-filtri"></div>
            </div>

            <div class="sezione-statistiche">
                <h2>Statistiche Canale</h2>
                <label>Admin: <a id="stat-admin" class="link-profilo"></a></label>
                <label>Iscritti totali: <span id="stat-iscritti"></span></label>
                <label>Post pubblicati: <span id="stat-post"></span></label>
            </div>
        </aside>

        <section class="colonna-centrale" id="feed">
            
        </section>

        <aside id="box-creazione-post" class="colonna-destra chiuso">
            <div class="header-creazione">
                <h2>Crea un nuovo Post</h2>
                <button type="button" id="btn-chiudi-scrittura">✕</button>
            </div>
            <form id="form-nuovo-post">
                <div>
                    <label for="titolo-post">Titolo:</label>
                    <input type="text" id="titolo-post" name="titolo" placeholder="Scrivi il titolo del tuo post qui..." required maxlength="20">
                    <div class="counter-caratteri">Max 20 caratteri</div>
                </div>
                <div>
                    <label for="testo-post">Testo:</label>
                    <textarea id="testo-post" name="contenuto" rows="8" placeholder="Scrivi il tuo post qui..." required maxlength="500"></textarea>
                    <div class="counter-caratteri">Max 500 caratteri</div>
                </div>
                <div>
                    <label>Seleziona i topic (Massimo 3):</label>
                    <div class="lista-topic-scroll" id="topic-creazione"></div>
                </div>
                <span id="err-invio-post" class="errore">&nbsp;</span>
                <button type="submit" id="btn-invia-post">Pubblica Post</button>
            </form>
        </aside>

        <div id="dialog-overlay" class="nascosto"></div>
        <dialog id="dialog-crea"></dialog>

    </main>
</body>
</html>