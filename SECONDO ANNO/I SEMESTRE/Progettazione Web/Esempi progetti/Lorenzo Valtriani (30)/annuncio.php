<?php
require_once(__DIR__."/classes/Agenzia.php");
require_once(__DIR__."/classes/Annuncio.php");
require_once(__DIR__."/classes/ViewAnnuncio.php");
require_once(__DIR__."/config/config.php");

session_start();

$View = new ViewAnnuncio((Int)$_GET["a"]);
if($View->GetErrore() == 1) header('Location: ./404.html');
$Agenzia = new Agenzia($View->GetIdAgenzia());
$_SESSION["IdAgenzia"] = $Agenzia->GetIdAgenzia();

?>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="utf-8">
        <title><?= $Agenzia->GetNomeAgenzia(); ?></title>
        <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
        <meta property="og:type" content="website" />
        <meta property="og:title" content="Sito web ufficiale di: <?= $Agenzia->GetNomeAgenzia(); ?>" />
        <meta property="og:description" content="<?= $Agenzia->GetNomeAgenzia(); ?> è un'agenzia immobiliare. Il sito web è un servizio offerto da bobo!"/>
        <meta name="description" content="<?= $Agenzia->GetNomeAgenzia(); ?> è un'agenzia immobiliare. Il sito web è un servizio offerto da bobo!"/>

        <!-- codici css comuni a tutte le versioni -->
        <link rel="stylesheet" type="text/css" href="./styles/annuncio/conteiner-annuncio.css" media="screen"/>
        <link rel="stylesheet" type="text/css" href="./styles/stile-testata.css" media="screen"/>

        <!-- usato bootstrap solo e soltanto per le icone -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    </head>
    <body style="border: 5px;" onload="Carica()">
        <div id="pop-up-foto">
            <i id="chiudi-pop-up" class="bi bi-x-lg" onclick="ChiudiPopUp()"></i>
            <i id="freccia-sinistra" class="bi bi-arrow-left" onclick="PreImgPopUp()"></i>
            <img id="foto-sfondo"></img>
            <i id="freccia-destra" class="bi bi-arrow-right" onclick="AftImgPopUp()"></i>
        </div>

        <!-- parte relativa alla testata -->
        <div id="testata" style="background-image: -webkit-linear-gradient(left, #F0F0F0 0%, <?= $Agenzia->GetColore2(); ?> 200%);">
            <a href="./index.php?a=<?= $Agenzia->GetIdAgenzia(); ?>">
              <?php
                if(file_exists("./foto/loghi-agenzie/".$Agenzia->GetIdAgenzia().".jpg"))
                  echo "<img alt='logo' src='./foto/loghi-agenzie/".$Agenzia->GetIdAgenzia().".jpg'/>";
                else echo "<img alt='logo' src='./foto/loghi-agenzie/no-logo.jpg'/>";
              ?>
            </a>
            <button onclick="Login()">
              <?php
                  if(!isset($_SESSION["loggato"])) echo "Entra come Agenzia";
                  else echo "Benvenuto!";
              ?>
            </button>
        </div>

        <?php echo "<script src='./jscript/annuncio/funcions.js'></script>"; ?>
        <div id="contenitore" style="background-image: -webkit-linear-gradient(left, #F0F0F0 0%, <?php echo $Agenzia->GetColore1(); ?> 200%);">
            <div id="annuncio">
                <div id="foto-principale">
                    <img src="<?php $View->getFotoCopertina(); ?>" onclick="FotoIngrandita()">
                </div>
                <div id="lista-foto">
                    <?php $View->getFoto(); ?>
                </div>
                <div class="blocco">
                    <h2 id="titolo"><?php $View->GetTitolo(); ?></h3>
                    <div class="sotto-blocco">
                        <span id="prezzo"><?php $View->GetPrezzo(); ?></span>
                    </div>
                </div>
                <div class="blocco">
                    <h3>Descrizione:</h3>
                    <h4><?php $View->GetDescrizione(); ?></h4>
                </div>
                <div class="blocco">
                    <h3>Caratteristiche:</h3>
                    <?php $View->GetCaratteristiche(); ?>
                </div>
                <div class="blocco">
                    <?php $View->GetPosizione(); ?>
                </div>
            </div>
        </div>

        <script src="./jscript/testata.js"></script>
    </body>
</html>
