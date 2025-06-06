<?php
session_start();
require_once __DIR__ . "/../includes/methods.php";

if(!isset($_SESSION['battaglia'], $_SESSION['accountID'])){
	apiError(403, "Sessione non valida!");
}

if(!isset($_SERVER['REQUEST_METHOD']) || $_SERVER['REQUEST_METHOD'] !== "POST"){
	apiError(405, "Metodo non consentito");
}

$battaglia = unserialize($_SESSION['battaglia']);

if($battaglia['Terminata']){
	echo json_encode(["ok" => false]);
	exit;
}
	
/**
 * @var Personaggio
 */
$pg1 = unserialize($battaglia['pg1']);
/**
 * @var Personaggio
 */
$pg2 = unserialize($battaglia['pg2']);

$turnoAttuale = $battaglia["Turno_Giocatore1"];

$oraAttuale = new DateTime("now");
$inizioUltimoTurno = unserialize($battaglia['DataUltimoTurno']);

/**
 * @var $randomMove è `false` solo se il turno è dell'utente (`$turnoAttuale === true`) e se la mossa selezionata dall'utente è valida e non casuale e/o con oggetti casuali
 */
$randomMove = false;
$victory = null;
$message = "";

try{
	if($turnoAttuale){

		$azione = $_POST['azione'] ?? null;

		$randomMove =
			// Superato il limite di tempo
			$oraAttuale->getTimestamp() - $inizioUltimoTurno->getTimestamp() >= Personaggio::DEFAULT_TURN_TIME ||
			// non è stata selezionata un'azione
			!$azione ||
			// L'azione è quella di usare un'oggetto ma non è specificato quale
			($azione === 'usa_oggetto' && !isset($_POST['oggetto_index'])) ||
			// L'azione è casuale
			$azione === 'casuale';

		if(!$randomMove){
			if($azione === 'attacco'){
				$esito = $pg1->attack($pg2);
				$message .= ($esito['colpito'])?
					"Il tuo colpo ha colpito!\n Hai fatto " . $esito['dannoInflitto'] . " danni":
					$pg2->getNome() . " ha schivato!";
			}
			else{
				$objectToUse = (int)$_POST['oggetto_index'];
				$info = $pg1->getItemInfo($objectToUse);
				if(!$pg1->useItem($objectToUse)){
					$randomMove = true;
					$message .= "Non posiedi questo oggetto, la tua mossa sarà quindi scelta casualmente.\n";
				}
				else{
					$message .= "Hai utilizzato ". $info['Nome'] .":\n\"" . $info['Descrizione'] . "\"";
				}
			}
		}

		if($randomMove){
			$esito = randomMove($pg1, $pg2);
			if($esito['mossa'] === 'attacco'){
				$message .= "Hai attaccato";
				$message .= ($esito['colpito'])?
					" e il tuo colpo ha colpito!\n Hai fatto " . $esito['dannoInflitto'] . " danni\n":
					", ma " . $pg2->getNome() . " ha schivato!";
			}
			else{
				$message .= "Hai utilizzato l'oggetto " . $esito['oggetto'] . "\n";
			}
		}

	}
	else{
		$esito = randomMove($pg2, $pg1);
		$message .= $pg2->getNome();
		if($esito['mossa'] === 'attacco'){
			$message .= " ha attaccato";
			$message .= ($esito['colpito'])?
				" e il suo colpo ha colpito!\n Ti ha fatto " . $esito['dannoInflitto'] . " danni\n":
				", ma lo hai schivato!";
		}
		else{
			$message .= " ha utilizzato l'oggetto " . $esito['oggetto'] . "\n";
		}
	}


	$battaglia['pg1'] = serialize($pg1);
	$battaglia['pg2'] = serialize($pg2);
	$battaglia["Turno_Giocatore1"] = !$turnoAttuale;
	$battaglia['DataUltimoTurno'] = serialize($oraAttuale);

	if($pg1->isDead() || $pg2->isDead()){
		updateGame($battaglia, $pg2->isDead());

		
		$id = unserialize($_SESSION['accountID']);
		$account = new Account($id, true);

		$nomePersonaggio = unserialize($_SESSION['currentPG_nome']);

		$account->unequipPGItem_onlyUsed($nomePersonaggio, $pg1);
		$nLivelliGuadagnati = $account->addPGExp($nomePersonaggio, $battaglia['Vittoria_Giocatore1']);
	
		if($nLivelliGuadagnati === null)
			apiError(500);
	
	
		$exp = $battaglia['Vittoria_Giocatore1']? Personaggio::EXP_WIN : Personaggio::EXP_LOSS;
	
		$_SESSION['endgameMessage'] = "Hai guadagnato " . $exp . " punti esperienza!\n";
	
		if($nLivelliGuadagnati > 0){
			$_SESSION['endgameMessage'] .= "Il personaggio ha guadagnato anche ". $nLivelliGuadagnati . " livell";
			$_SESSION['endgameMessage'] .= ($nLivelliGuadagnati > 1)? "i" : "o";
			$_SESSION['endgameMessage'] .= "!\n Hai guadagnato ".Account::COINS_LVL_UP." monete e sono state aggiunte delle ricompense all'inventario!";
		}
	}
	else{
		updateGame($battaglia);
	}

	$_SESSION['battaglia'] = serialize($battaglia);
	$_SESSION['gameMessage'] = $message;
}
catch(Exception $e){
	if($e->getCode() === 1010){
		apiError(1010, $e->getMessage());
	}
	error_log($e->getMessage(), $e->getCode());
	apiError(500, "ERRORE DEL SERVER");
}

session_write_close();
header('Content-Type: application/json');
echo json_encode(["ok" => true]);


/**
 * Il pg1 esegue una mossa casuale sul pg2
 * @param Personaggio $pg1 colui che fa la mossa
 * @param Personaggio $pg2 colui che subisce la mossa
 * @param boolean $updateDB indica se la mossa deve avere ripercussioni sullo zaino complessivo del personaggio. [Default: `false`]
 * @return array contenente informazioni sulla mossa eseguita
 * 		- `"mossa": indica la mossa eseguita
 * 		- `"colpito"`?: SOLO SE la mossa era `"attacco"`
 * 		- `"dannoInflitto"`?: SOLO SE la mossa era `"attacco"` e `"colpito"` è `true`
 * 		- `"oggetto"`?: SOLO SE la mossa era `"oggetto"`, contiene il nome dell'oggetto utilizzato
 */
function randomMove(&$pg1, &$pg2, $updateDB = false){
	$output = [
		"mossa" => null,
	];


	$pg1VitaStats = $pg1->getAllPF();
	if($pg1VitaStats['tmp_PF'] < ($pg1VitaStats['PF'] / 2)){
		$oggetto = $pg1->getBestOggettoCura();
		if($oggetto){
			$output['mossa'] = 'oggetto';
			$oggetti = [$oggetto];
		}
	}

	if(!$output['mossa']){
		$pg2VitaStats = $pg2->getAllPF();
		if($pg2VitaStats['tmp_PF'] < ($pg2VitaStats['PF'] / 2)){
			$azioni = ['attacco'];
			$oggetto = $pg1->getBestOggettoFOR();
			if($oggetto){
				$azioni[] = 'oggetto';
				$oggetti = [$oggetto];
			}

			$output['mossa'] = $azioni[array_rand($azioni)];
		}
	}

	if(!$output['mossa']){
		$oggetti = $pg1->getOggettiUtilizzabili();
		$azioni = ['attacco'];
		if($oggetti !== null)
			$azioni[] = 'oggetto';

		$output['mossa'] = $azioni[array_rand($azioni)];
	}

	if($output['mossa'] === 'attacco'){
			$esitoMossa = $pg1->attack($pg2);
			$output['colpito'] = $esitoMossa['colpito'];
			if($esitoMossa['colpito']){
				$output['dannoInflitto'] = $esitoMossa['dannoInflitto'];
			}
	}
	else{
		$oggetto = $oggetti[array_rand($oggetti)];
		$pg1->useItem($oggetto['ID'], $updateDB);
		$output['oggetto'] = $oggetto['Nome'];
	}

	return $output;
}

?>