<?php
require_once(__DIR__."/config/config.php");
require_once(__DIR__."/classes/Agenzia.php");
require_once(__DIR__."/classes/Annuncio.php");
$ERRORE_FOTO = false;

session_start();
if(is_null($_SESSION["IdAgenzia"])) header("Location: ./404.html");
$Agenzia = new Agenzia($_SESSION["IdAgenzia"]);

$Annunci = $Agenzia->GetAnnunci();
$Contratti = $Agenzia->GetAllContratti();
$Categorie = $Agenzia->GetAllCategorie();
$Comuni = $Agenzia->GetAllComuni();
$ClassiEnergetiche = $Agenzia->GetAllClassiEnergetiche();
$_SESSION["loggato"] = $Agenzia->GetIdAgenzia();

// Inserimento e caricamento foto annuncio
if(isset($_FILES["foto-new"]) && isset($_POST["submit"])){
  $_SESSION["rif"] = $_POST["rif"];
  // Inserimento del database della riga nuova collegata all'annuncio
  $target_dir = "./foto/foto-annunci/";
  $target_file = $target_dir . basename($_FILES["foto-new"]["name"]);
  $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
  if($imageFileType != "jpg"){
    // Errore
    echo "<script>alert('Devi inserire una immagine jpg');</script>";
    $ERRORE_FOTO = true;
  } else {
    $Annuncio = new Annuncio($_POST["id-annuncio"]);
    $IdFoto = $Annuncio->InserisciFotoDataBase();
    $target_file = $target_dir . $IdFoto . ".jpg";
    if(!$Annuncio->CaricaFotoServer($_FILES["foto-new"]["tmp_name"], $target_file)){
      echo "<script>alert('File non caricato!');</script>";
      $ERRORE_FOTO = true;
    }
  }
}

// Inserimento del LOGO
if(isset($_FILES["logo-new"]) && isset($_POST["submit"])){
  // Inserimento del database della riga nuova collegata all'annuncio
  $target_dir = "./foto/loghi-agenzie/";
  $target_file = $target_dir . basename($_FILES["logo-new"]["name"]);
  $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
  if($imageFileType != "jpg"){
    // Errore
    echo "<script>alert('Devi inserire una immagine jpg');</script>";
    $ERRORE_FOTO = true;
  } else {
    $target_file = $target_dir . $Agenzia->GetIdAgenzia() . ".jpg";
    if(!$Agenzia->AggiornaLogo($_FILES["logo-new"]["tmp_name"], $target_file)){
      echo "<script>alert('Logo non aggiornato!');</script>";
      $ERRORE_FOTO = true;
    }
  }
}

// Se il caricamento è andato a buon fine, allora ricarica la pagina per non tenere in memoria i dati
if ($ERRORE_FOTO == false && $_SERVER['REQUEST_METHOD'] == 'POST') {
    header("Location: ".$_SERVER['PHP_SELF']);
    exit;
}

?>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="utf-8">
        <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
        <meta property="og:type" content="website" />
        <meta property="og:title" content="Sito web ufficiale di: <?= $Agenzia->GetNomeAgenzia(); ?>" />
        <meta property="og:description" content="<?= $Agenzia->GetNomeAgenzia(); ?> è un'agenzia immobiliare. Il sito web è un servizio offerto da bobo!"/>
        <meta name="description" content="<?= $Agenzia->GetNomeAgenzia(); ?> è un'agenzia immobiliare. Il sito web è un servizio offerto da bobo!"/>

        <!-- codici css comuni a tutte le versioni -->
        <link rel="stylesheet" type="text/css" href="styles/personal-page/personal-page.css" media="screen">
        <link rel="stylesheet" type="text/css" href="styles/stile-testata.css" media="screen">
        <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
        <title>Pagina personale - <?php echo $Agenzia->GetNomeAgenzia(); ?></title>
    </head>
    <body>
        <!-- parte relativa alla testata -->
        <div id="testata" style="background-image: -webkit-linear-gradient(left, #F0F0F0 0%, <?= $Agenzia->GetColore2(); ?> 200%);">
            <a href="./index.php?a=<?= $Agenzia->GetIdAgenzia(); ?>">
              <?php
                if(file_exists("./foto/loghi-agenzie/".$Agenzia->GetIdAgenzia().".jpg"))
                  echo "<img alt='logo' src='./foto/loghi-agenzie/".$Agenzia->GetIdAgenzia().".jpg'/>";
                else echo "<img alt='logo' src='./foto/loghi-agenzie/no-logo.jpg'/>";
              ?>
            </a>
            <div id="blocco-destra">
              <i class="bi bi-box-arrow-right" onclick="Esci()"></i>
              <button onclick="Login()">
                <?php
                    if(!isset($_SESSION["loggato"])) echo "Entra come Agenzia";
                    else echo "Benvenuto!";
                ?>
              </button>
            </div>
        </div>
        <div id="container">
            <div id="impo-sito">
                <div id="intestazione-impo-sito" class="intestazione" onclick="MostraNascondi('#intestazione-impo-sito', '#dati-impo-sito');">
                    <span>Personalizzazione Sito</span>
                    <span class="azione-click">Nascondi</span>
                </div>
                <div id="dati-impo-sito">
                    <div class="dato-impo-sito">
                        <h3>Nome Agenzia</h3>
                        <input type="text" id="agenzia_nome" class="campo-input" name="agenzia_nome" value="<?= $Agenzia->GetNomeAgenzia(); ?>"/>
                    </div>
                    <div class="dato-impo-sito">
                        <h3>Colore Principale</h3>
                        <input type="color" id="colore1" name="colore1" value="<?= $Agenzia->GetColore1(); ?>"/>
                    </div>
                    <div class="dato-impo-sito">
                        <h3>Colore Secondario</h3>
                        <input type="color" id="colore2" name="colore2" value="<?= $Agenzia->GetColore2(); ?>"/>
                    </div>
                    <div id="insert-logo">
                      <h3>Logo Agenzia <span class="specifica">[.JPG]</span></h3>
                      <form enctype="multipart/form-data" action="./personal-page.php" method="POST">
                        <label for="logo-new" class="logo-new">Inserisci un immagine:</label>
                        <input type="file" id="logo-new" class="logo-new" name="logo-new" accept="image/jpg"/>
                        <input type="submit" name="submit" id="salva-logo-nuovo" value="INSERISCI NUOVO LOGO"/>
                      </form>
                    </div>
                    <button onclick="SalvaImpostazioni()">Salva Impostazioni</button>
                </div>
            </div>

            <div id="annunci">
                <div id="intestazione-annunci" class="intestazione" onclick="MostraNascondi('#intestazione-annunci', '#dati-annunci');">
                    <span>Inserisci o Modifica Annunci</span>
                    <span class="azione-click">Nascondi</span>
                </div>
                <div id="dati-annunci">
                  <button type="button" onclick="InserisciAnnuncio()">Inserisci</button>
                  <div id="ricerca">
                    <input type="text" id="riferimento-input" class="campo-input" placeholder="Modifica tramite Riferimento..." <?= isset($_SESSION["rif"]) ? "value='".$_SESSION["rif"]."'" : "";  ?>>
                    <button type="button" onclick="ModificaAnnuncio()">Modifica</button>
                  </div>
                  <div id="error-rif">Riferimento non valido!</div>
                  <div id="annuncio">
                    <div id="sopra-annuncio">
                      <h2>&nsbp;</h2>
                      <button id="salva-annuncio" onclick="SalvaAnnuncio()">Salva Annuncio</button>
                    </div>
                    <div id="errori">Errori presenti!</div>
                    <!-- dati generici -->
                    <div id="intestazione-generali-annuncio" class="intestazione-annuncio" onclick="MostraNascondi('#intestazione-generali-annuncio', '#campi-generali-annuncio');">
                        <span>Informazioni Generali</span>
                        <span class="azione-click">Mostra</span>
                    </div>
                    <div class="cat-modifica" id="campi-generali-annuncio">
                      <div>
                        <h3>Riferimento <span class="specifica">Max: 20 caratteri</span></h3>
                        <input type="text" class="campo-input" id="riferimento"/>
                      </div>
                      <div>
                        <h3>Titolo</h3>
                        <input type="text" class="campo-input" id="titolo"/>
                      </div>
                      <div>
                        <h3>Contratto</h3>
                        <select id="contratto" class="campo-input">
                          <?php
                            foreach ($Contratti as $Contratto) {
                              echo "<option value='".$Contratto["IdContratto"]."'>".$Contratto["Contratto"];
                            }
                          ?>
                        </select>
                      </div>
                      <div>
                        <h3>Categoria</h3>
                        <select id="categoria" class="campo-input">
                          <?php
                            foreach ($Categorie as $Categoria) {
                              echo "<option value='".$Categoria["IdCategoria"]."'>".$Categoria["Categoria"];
                            }
                          ?>
                        </select>
                      </div>
                      <div>
                        <h3>Prezzo <span class="specifica"><br>&euro; [solo numeri, non virgole o punti] <br>oppure riservato ["Info In Agenzia" o 0]</span></h3>
                        <input type="text" class="campo-input" id="prezzo"/>
                      </div>
                      <div>
                        <h3>Numero Locali</h3>
                        <input type="text" class="campo-input" id="numero-locali"/>
                      </div>
                      <div>
                        <h3>Superficie <span class="specifica">mq</span></h3>
                        <input type="text" class="campo-input" id="superficie"/>
                      </div>
                      <div id="blocco-descrizione">
                        <h3>Descrizione</h3>
                        <textarea id="descrizione" cols="80"></textarea>
                      </div>
                    </div>
                    <!-- dati geografici -->
                    <div id="intestazione-geografiche-annuncio" class="intestazione-annuncio" onclick="MostraNascondi('#intestazione-geografiche-annuncio', '#campi-geografici-annuncio');">
                        <span>Informazioni Geografiche</span>
                        <span class="azione-click">Mostra</span>
                    </div>
                    <div class="cat-modifica" id="campi-geografici-annuncio">
                      <div>
                        <h3>Comune</h3>
                        <select id="comune" class="campo-input">
                          <?php
                            foreach ($Comuni as $Comune) {
                              echo "<option value='".$Comune["IdComune"]."'>".$Comune["Comune"]." (".$Comune["SiglaProvincia"].")";
                            }
                          ?>
                        </select>
                      </div>
                      <div>
                        <h3>Indirizzo</h3>
                        <input type="text" class="campo-input" id="indirizzo"/>
                      </div>
                      <div>
                        <h3>Localit&agrave;</h3>
                        <input type="text" class="campo-input" id="localita"/>
                      </div>
                    </div>
                    <!-- dati energetici -->
                    <div id="intestazione-energetica-annuncio" class="intestazione-annuncio" onclick="MostraNascondi('#intestazione-energetica-annuncio', '#campi-energetici-annuncio');">
                        <span>Informazioni Energetiche</span>
                        <span class="azione-click">Mostra</span>
                    </div>
                    <div class="cat-modifica" id="campi-energetici-annuncio">
                      <div>
                        <h3>Classe Energetica</h3>
                        <select id="classe-energetica" class="campo-input">
                          <?php
                            foreach ($ClassiEnergetiche as $ClasseEnergetica) {
                              echo "<option value='".$ClasseEnergetica["IdClasseEnergetica"]."'>".$ClasseEnergetica["ClasseEnergetica"];
                            }
                          ?>
                        </select>
                      </div>
                      <div>
                        <h3>IPE <span class="specifica">kWh/mq</span></h3>
                        <input type="text" class="campo-input" id="ipe"/>
                      </div>
                    </div>
                    <!-- dati secondari -->
                    <div id="intestazione-secondari-annuncio" class="intestazione-annuncio" onclick="MostraNascondi('#intestazione-secondari-annuncio', '#campi-secondari-annuncio');">
                        <span>Informazioni Secondarie</span>
                        <span class="azione-click">Mostra</span>
                    </div>
                    <div class="cat-modifica" id="campi-secondari-annuncio">
                      <div>
                        <h3>Numero Camere</h3>
                        <input type="text" class="campo-input" id="camere"/>
                      </div>
                      <div>
                        <h3>Numero Bagni</h3>
                        <input type="text" class="campo-input" id="bagni"/>
                      </div>
                      <div>
                        <h3>Box Auto</h3>
                        <input type="checkbox" id="box-auto"/>
                      </div>
                      <div>
                        <h3>Balcone</h3>
                        <input type="checkbox" id="balcone"/>
                      </div>
                      <div>
                        <h3>Mansarda</h3>
                        <input type="checkbox" id="mansarda"/>
                      </div>
                      <div>
                        <h3>Cantina</h3>
                        <input type="checkbox" id="cantina"/>
                      </div>
                      <div>
                        <h3>Arredato</h3>
                        <input type="checkbox" id="arredato"/>
                      </div>
                      <div>
                        <h3>Giardino</h3>
                        <input type="checkbox" id="giardino"/>
                      </div>
                      <div>
                        <h3>Ascensore</h3>
                        <input type="checkbox" id="ascensore"/>
                      </div>
                    </div>
                    <div>
                      <div id="intestazione-foto-annuncio" class="intestazione-annuncio" onclick="MostraNascondi('#intestazione-foto-annuncio', '#campi-foto-annuncio');">
                          <span>Foto</span>
                          <span class="azione-click">Mostra</span>
                      </div>
                      <div class="cat-modifica" id="campi-foto-annuncio">
                        <input type="hidden" id="copertina">
                        <div id="foto-tutte">
                        </div>
                        <div id="insert-foto">
                          <form enctype="multipart/form-data" action="./personal-page.php" method="POST">
                            <label for="foto-new" class="foto-new">Inserisci un immagine: <span class="specifica">[.JPG]</span></label>
                            <input type="file" id="foto-new" class="foto-new" name="foto-new" accept="image/jpg"/>
                            <input type="hidden" name="scopo" id="scopo"/>
                            <input type="hidden" name="riferimento-vecchio" id="riferimento-vecchio"/>
                            <input type="hidden" name="id-annuncio" id="id-annuncio"/>
                            <input type="hidden" name="rif" id="rif"/>
                            <input type="submit" name="submit" id="salva-foto-nuova" value="INSERISCI NUOVA FOTO"/>
                          </form>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
            </div>
        </div>

        <script src="./jscript/personal-page/personal-page.js"></script>
    </body>
</html>
