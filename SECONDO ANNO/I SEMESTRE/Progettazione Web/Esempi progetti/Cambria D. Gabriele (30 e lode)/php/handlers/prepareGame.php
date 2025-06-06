<?php

session_start();
require_once __DIR__ . "/../includes/methods.php";

if (!isset($_SERVER['HTTP_REFERER']) || basename($_SERVER['HTTP_REFERER']) !== "gestisciPersonaggio.php" || $_SERVER['REQUEST_METHOD'] !== "POST"){
	pageError(405, "./../pages/");
}

if(!isset($_SESSION['accountID'], $_SESSION['currentPG_nome'])){
	pageError(403, "./../pages/");
}

$id = unserialize($_SESSION['accountID']);
$pgName = unserialize($_SESSION['currentPG_nome']);
try{
	$account = new Account($id, true);

	$personaggio = $account->getPersonaggi($pgName);

	if(!$personaggio){
		pageError(401, "./../pages/");
	}

	$battaglia = $personaggio->getBattagliaInCorso();
	if(!$battaglia){
		$avversario = getRandomPG($id, $personaggio->getLivello());
		if($avversario === null){
			throw new Exception("Nessun avversario disponibile al momento, ci dispiace.", 404);
		}
		$battaglia = $personaggio->creaCombattimento($avversario);
	}
	else{
		$_SESSION['message'] = "Ripristinata la battaglia iniziata in data: " . date('Y-m-d', strtotime($battaglia['DataInizioBattaglia'])) ."\nDato il ripristino è il turno dell'avversario!";
	}
	
	$stato = json_decode($battaglia['StatoPersonaggi'], associative: true);
	if (isset($stato['pg1']) && isset($stato['pg2'])){
		$pg1 = Personaggio::fromArray($stato['pg1']);
		$pg2 = Personaggio::fromArray($stato['pg2']);
		$battaglia['pg1'] = serialize($pg1);
		$battaglia['pg2'] = serialize($pg2);
		unset($battaglia['StatoPersonaggi']);
	}
	else{
		pageError(401, "./../");
	}
	
	$_SESSION['battaglia'] = serialize($battaglia);
}
catch(Exception $e){
	$errorType = $e->getMessage();
	$error = [
		'message' => ERROR_TYPES[$errorType] ?? $errorType,
		'errorcode' => $e->getCode()
	];

	$_SESSION["errorMessage"] = $error;

	error_log("Errore createPG [" .$error['errorcode'] ."]: " . $error['message']);

	http_response_code($error['errorcode']);
	header("Location: ". $_SERVER['HTTP_REFERER']);
	exit;
}

session_write_close();
header("Location: ./../pages/gamePage.php");
exit;