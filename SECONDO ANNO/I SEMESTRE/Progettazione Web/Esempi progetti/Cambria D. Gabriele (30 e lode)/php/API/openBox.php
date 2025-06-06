<?php
require_once __DIR__ . "/../includes/methods.php";

session_start();

if(!isset($_SESSION['accountID'], $_SERVER['REQUEST_METHOD']) || $_SERVER['REQUEST_METHOD'] !== "POST"){
	apiError(403);
}

if(!isset($_POST['boxID'], $_POST['boxNome'])){
	apiError(400);
}

$id = unserialize($_SESSION["accountID"]);

$box = ['id' => $_POST["boxID"], 'nome' => $_POST["boxNome"]];

$esito = openBox($box, $id);

header('Content-Type: application/json');
echo json_encode($esito);

?>