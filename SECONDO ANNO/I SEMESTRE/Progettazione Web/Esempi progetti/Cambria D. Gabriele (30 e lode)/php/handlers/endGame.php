<?php

require_once __DIR__ . "/../includes/methods.php";
session_start();

if(!isset($_SERVER['REQUEST_METHOD']) || $_SERVER['REQUEST_METHOD'] !== "POST"){
	pageError(405);
}

if(!isset($_SESSION['accountID'], $_SESSION['currentPG_nome'], $_SESSION['battaglia'])){
	pageError(403);
}



$id = unserialize($_SESSION['accountID']);
$nomePersonaggio = unserialize($_SESSION['currentPG_nome']);
$battaglia = unserialize($_SESSION['battaglia']);

try{
	$account = new Account($id, true);

	$givenUp = false;
	if(!$battaglia['Terminata']){
		$givenUp = true;
		updateGame($battaglia, false);
		
		$pg1 = unserialize($battaglia['pg1']);

		$_SESSION['endgameMessage'] = "Ti sei arreso quindi non guadagni ricompense.";

		if($account->unequipPGItem_onlyUsed($nomePersonaggio, $pg1)){
			$_SESSION['endgameMessage'] .= "\n Gli oggetti utilizzati sono comunque stati rimossi.";
		}

	}
}
catch(Exception $e){
	error_log("Errore " . $e->getCode() . ": durante la endGame.php è stato sollevato il seguente errore: ". $e->getMessage());
	pageError($e->getCode());
}


unset($_SESSION['battaglia']);

session_write_close();
echo json_encode(['ok' => true]);
exit;