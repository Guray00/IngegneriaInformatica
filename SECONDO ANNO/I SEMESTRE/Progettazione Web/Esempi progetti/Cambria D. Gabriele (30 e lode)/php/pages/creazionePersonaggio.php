<?php
session_start();

require_once __DIR__ . "/../includes/methods.php";

if(!isset($_SESSION['accountID'])){
	pageError(403);
}

if (!isset($_SERVER['HTTP_REFERER']) || 
	basename(parse_url($_SERVER['HTTP_REFERER'], PHP_URL_PATH)) !== "dashboard.php" &&
	basename(parse_url($_SERVER['HTTP_REFERER'], PHP_URL_PATH)) !== "creazionePersonaggio.php"){
	header("Location: ./../pages/dashboard.php");
	exit;
}


$account = null;
$id = unserialize($_SESSION['accountID']);
try {
	$account = new Account($id, true);
} 
catch (Exception $e) {
	error_log("Errore durante il recupero dell'account in creazionePersonaggio.php: " . $e->getMessage());
	pageError($e->getCode());
}

if(count($account->getPersonaggi()) === Account::MAX_NUM_PERSONAGGI){
	$_SESSION['message'] = ERROR_TYPES['full_PG'];
	session_write_close();
	header("Location: ./dashboard.php");
	exit;
}

$message = null;
if(isset($_SESSION["createPGError"])){
    $message = $_SESSION["createPGError"];
    unset($_SESSION["createPGError"]);
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Titles</title>
    <link rel="icon" href="./../../images/icon.svg" type="image/svg+xml" sizes="16x16" >
	<link rel="stylesheet" href="./../../css/global/style.css">
	<link rel="stylesheet" href="./../../css/components/personaggio.css">
	<script type="module" src="./../../js/pages/creazionePersonaggio.js"></script>
	<script>
		const createPGError = <?php echo json_encode($message)?>;
	</script>
</head>
<body>
	<header>
        <h1><i>Titles</i></h1>
        <div>
            <form action="../handlers/logout.php" method="POST">
                <button type="submit">Logout</button>
            </form>
        </aside>
    </header>
	<main class="main-section">
		<form class="page-box" action="../handlers/handlePG.php" method="POST">
			<div class="stats-section">
				<div class="lvl-block">
					<p class="lvl-info">Livello <span id="user-lvl">1</span></p>
					<div class="exp-bar"></div>
				</div>
				<div class="stats-block PF">
					<div class="PF-points-block"><div id="PF" class="PF-amount"></div></div>
					<p>PF</p>
				</div>
				<div class="stats-block FOR">
					<div class="FOR-points-block">
						<div class="FOR-amount" id="FOR"></div>
					</div>
					<p>FOR</p>
				</div>
				<div class="stats-block DES">
					<div class="DES-points-block">
						<div class="DES-amount" id="DES"></div>
					</div>
					<p>DES</p>
				</div>
			</div>
			<div class="character-section">
				<div class="character-box">
					<input type="text" name="PG-name" id="PG-name" placeholder="Nome" pattern="^[a-zA-Z]{3,10}$" required autocomplete="off" title="Dalle 3 alle 10 lettere">
					<div class="character-choose">
						<div id="prevPG" class="arrow">←</div>
						<img id="imagePG" class="always-animated" src="" alt="" draggable="false">
						<div id="nextPG" class="arrow">→</div>
					</div>
					<hr>
					<footer>
						<div class="damage-box">
							<p>Danno</p>
							<p id="damage"></p>
						</div>
						<div class="element-pic">
							<input type="radio" value="" name="element" id="element" checked hidden>
							<img id="elementPic" draggable="false" src="" alt="">
    	        		</div>
						<div class="dodge-box">
							<p>Schivata</p>
							<p id="dodge"></p>
						</div>
					</footer>
				</div>
			</div>
			<div class="info-section">
				<div class="prevalence-box">
					<div class="prevalence-block prevails">
						<p title="Il danno inflitto su questo elemento aumenta di 1 punto">Prevale</p>
						<div class="element-pic">
    	            		<img id="prevalePic" draggable="false" src="" alt="">
    	        		</div>
					</div>
					<div class="prevalence-block prevailed">
						<p title="La probabilità di schivare contro questo elemento è dimezzata">Prevalso</p>
						<div class="element-pic">
    	            		<img id="prevalsoPic" draggable="false" src="" alt="">
    	        		</div>
					</div>
				</div>
				<div class="button-container">
					<p>Una volta creato, <b>non potrai più cambiare il nome del personaggio</b></p>
					<button id="createPG" class="animatedBtnBg" type="submit" disabled>Crea</button>
					<button id="backToDash" type="button">Annulla</button>
				</div>
			</div>

		</form>
	</main>
</body>
</html>