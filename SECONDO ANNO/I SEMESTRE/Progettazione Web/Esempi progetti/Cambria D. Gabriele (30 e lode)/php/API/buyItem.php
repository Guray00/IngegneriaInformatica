<?php
require_once "./../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'], $_SERVER['REQUEST_METHOD']) || $_SERVER['REQUEST_METHOD'] !== "POST"){
	apiError(403);
}

if(!isset($_POST['itemId'])){
	apiError(400);
}

$id = unserialize($_SESSION['accountID']);

$itemId = $_POST["itemId"];
$esito = buyItem($itemId, $id);

header('Content-Type: application/json');
echo json_encode($esito);


?>