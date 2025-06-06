<?php
require_once __DIR__ . "/../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'])){
	apiError(401);
	exit;
}


$account = null;
$id = unserialize($_SESSION['accountID']);
try {
	$account = new Account($id, true);
} 
catch (Exception $e) {
	apiError($e->getCode(), $e->getMessage());
}

$lastRefresh = $account->getShopRefresh();

$shopData = getShop($id, $lastRefresh);

$shopItems = $shopData['output'];

header('Content-Type: application/json');
$output = isset($shopItems['updateTime'])?
	[ 'items' => $shopItems['items'], 	'remainingTime' => $shopData['remainingTime'] ]:
	[ 'items' => $shopItems,		  	'remainingTime' => $shopData['remainingTime'] ];


header('Content-Type: application/json');
echo json_encode($output);
?>