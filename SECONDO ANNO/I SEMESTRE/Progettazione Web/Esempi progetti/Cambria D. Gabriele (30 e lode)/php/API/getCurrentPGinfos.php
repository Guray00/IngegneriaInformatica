<?php

require_once __DIR__ . "/../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'], $_SESSION['currentPG_nome'])){
	apiError(403);
}


$PG_name = unserialize($_SESSION['currentPG_nome']);

$account = null;
$id = unserialize($_SESSION['accountID']);
try {
	$account = new Account($id, true);
} 
catch (Exception $e) {
	apiError($e->getCode(), $e->getMessage());
}

$personaggio = $account->getPersonaggi($PG_name);

if($personaggio === null)
	apiError(400);

header('Content-Type: application/json');
echo json_encode($personaggio->getStatsAndEquipment());

?>