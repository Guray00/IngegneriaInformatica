<?php
session_start();
// Classi usate
require_once(__DIR__."/classes/Agenzia.php");
require_once(__DIR__."/classes/Annuncio.php");
require_once(__DIR__."/config/config.php");

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Ogni volta ricostruito il costruttore
$Agenzia = new Agenzia($_GET["a"]);
$_SESSION["IdAgenzia"] = $Agenzia->GetIdAgenzia();
// Se l'agenzia non ha permesso rimanda al sito di trovocasa
if($Agenzia->GetPermesso() == 0 || $_GET["a"] == "") header('Location: ./404.html');

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
        <link rel="stylesheet" type="text/css" href="./styles/home/form-generica.css" media="screen"/>
        <link rel="stylesheet" type="text/css" href="./styles/home/vetrina-generica.css" media="screen"/>

        <!-- codici css specifici per la versione -->
        <link rel="stylesheet" type="text/css" href="./styles/home/form-verticale.css" media="screen"/>
        <link rel="stylesheet" type="text/css" href="./styles/home/vetrina-larga.css" media="screen"/>
        <link rel="stylesheet" type="text/css" href="./styles/stile-testata.css" media="screen"/>
    </head>
    <body style="border: 5px;">
        <div id="loading" style="display: none;">
            <img alt="caricatore" src="./images/loader.gif"/>
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
        <?php //include_once "./testata.php"; ?>
        <!-- parte relativa al corpo del sito -->
        <input id="colore1" type="hidden" value="<?= $Agenzia->GetColore1() ?>"/>
        <input id="colore2" type="hidden" value="<?= $Agenzia->GetColore2() ?>"/>
        <input id="limite-annunci" type="hidden" value="<?= $Agenzia->GetLimiteAnnunciXPagina() ?>"/>

        <div id="blocco-form">
            <div>
                <!-- parte della form interna -->
                <div>
                    <span class="nome-elemento-form">Comune:</span>
                    <input type="text" id="comune" name="comune" onkeydown="PremiInvio(event);" autocomplete="off"/>
                    <div id="comuni-possibili"></div>
                </div>
                <!-- visualizzazione di tutte le tipologie contrattuali di quella determinata agenzia -->
                <div>
                    <span class="nome-elemento-form">Tipologia Contrattuale:</span>
                    <select id="tipo_contratto" name="tipo_contratto">
                      <option value="" selected>Qualsiasi</option>
                      <?php
                          $Contratti = $Agenzia->GetContratti();
                          foreach($Contratti as $key => $Contratto){
                              echo "<option value=\"".$key."\">".$Contratto."</option>";
                          }
                      ?>
                    </select>
                </div>
                <!-- visualizzazione di tutte le tipologie di immobili di quella determinata agenzia -->
                <div>
                    <span class="nome-elemento-form">Tipologia Immobile:</span>
                    <select id="tipo_immobile" name="tipo_immobile">
                      <option value="" selected>Qualsiasi</option>
                        <?php
                            $TipoImmobili = $Agenzia->GetTipoImmobili();
                            foreach($TipoImmobili as $key => $TipoImmobile){
                                echo "<option value=\"".$key."\">".$TipoImmobile."</option>";
                            }
                        ?>
                    </select>
                </div>
                <!-- inseirmento input per il prezzo min e massimo -->
                <div>
                    <div class="nome-prezzo-form">
                        Prezzo Minimo:
                        <input id="prezzo_min" type="tel" name="prezzo_min"/>
                    </div>
                    <div class="nome-prezzo-form">
                        Prezzo Massimo:
                        <input id="prezzo_max" type="tel" name="prezzo_max"/>
                    </div>
                </div>
                <div class="nome-elemento-form">
                   Includi prezzo riservato
                   <input id="riservato" type="checkbox" checked>
                </div>
                <div id="invio" onclick="EseguiForm();">CERCA</div>
                <div id="error-span">
                    <div class="error"></div>
                    <div class="warning"></div>
                </div>
                <a href="./manuale.html">Clicca per il manuale.</a>
            </div>
        </div>

        <!-- codice html per la vetrina -->
        <div id="blocco-vetrina">
            <?php
                $Annunci = $Agenzia->GetAnnunci();
                $i=0;
                if(count($Annunci) != 0){
                  foreach($Annunci as $key => $Annuncio){
                      if($Agenzia->GetLimiteAnnunciXPagina() == $i) break;
                      $i++;
                      # Visualizzazione della fotografia, ottenendo il valore dall'attributo della classe
                      echo '<div style="background-image: -webkit-linear-gradient(left, #F0F0F0 0%, '.$Agenzia->GetColore1().' 200%);">';
                      echo '  <div id="'.$Annuncio->GetIdAnnuncio().'" onclick="PaginaAnnuncio(this);"
                                                              class="fotografia"
                                                              style="background-image: url('.$Annuncio->GetFotoCopertina().');
                                                                     background-repeat: no-repeat;
                                                                     background-position: center center;
                                                                     background-size: contain;
                                                              "></div>';
                      echo '  <div class="casella-testo-doppia">';
                      # Visualizzazione del comune e della sigla della provincia tra ()
                      echo $Annuncio->GetComune().' ('.$Annuncio->GetSiglaProvincia().')';
                      echo '  </div>';

                      # Categoria [Appartamento / ... ]
                      echo '  <div class="casella-testo-semplice">';
                      echo $Annuncio->GetCategoria();

                      # Testo della descrizione [Zona: Capaci Nel Comune ... ]
                      echo '  </div>';
                      echo '  <div class="casella-descrizione">';
                      echo "<i>[Rif: ".$Annuncio->GetRif()."]</i><br>";
                      echo $Annuncio->GetDescrizione();

                      # Tipologia Contrattuale [Vendita / ... ]
                      echo '  </div>';
                      echo '  <div class="casella-testo-semplice">';
                      echo $Annuncio->GetContratto();

                      # Prezzo dell'annuncio, se questo è Info In Agenzia NON visualizzare il carattere dell'euro
                      echo '  </div>';
                      echo '  <div class="prezzo-annuncio">';

                      echo $Annuncio->GetPrezzoHome();

                      echo '  </div>';
                      echo '</div>';
                  }
                }
            ?>
        </div>

        <!-- SCRIPT -->
        <script src="./jscript/home/functions.js"></script>
        <script src="./jscript/testata.js"></script>
    </body>
</html>
