<?php
require_once __DIR__ . "/../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'], $_SESSION['currentPG_nome'])){
	apiError(401);
}

if(!isset($_SERVER['REQUEST_METHOD']) || $_SERVER["REQUEST_METHOD"] !== "POST"){
    apiError(405);
}

if(!isset($_POST['itemId']) && !isset($_POST['itemId_remove'])){
	apiError(405);
}

$id = unserialize($_SESSION['accountID']);
$nomePG = unserialize($_SESSION['currentPG_nome']);
$output = ["error" => false];
try{
	$account = new Account($id, true);
	if(isset($_POST['itemId'])){
		$itemId = json_decode($_POST['itemId']);
		$output['error'] = !$account->equipItem($nomePG, $itemId);
	}
	else{
		$itemId = json_decode($_POST['itemId_remove']);
		$output['error'] = !$account->unequipPGItem($nomePG, $itemId);
	}
}
catch(Exception $e){
	apiError($e->getCode(), $e->getMessage());
}


header('Content-Type: application/json');
echo json_encode($output);

?>