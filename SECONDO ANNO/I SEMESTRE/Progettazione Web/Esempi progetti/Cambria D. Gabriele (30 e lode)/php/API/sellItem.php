<?php
require_once __DIR__ . "/../includes/methods.php";

session_start();

if(!isset($_SESSION["accountID"])){
    apiError(403);
}

if(!isset($_SERVER['REQUEST_METHOD']) || $_SERVER["REQUEST_METHOD"] !== "POST" || !isset($_POST['itemId'])){
    apiError(405);
}

$id = unserialize($_SESSION['accountID']);

$itemId = $_POST['itemId'];
$esito = sellItem($itemId, $id);

header('Content-Type: application/json');
echo json_encode($esito);

?>