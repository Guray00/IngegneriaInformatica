<?php
require_once "../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'])){
	apiError(403);
}

$personaggi = getAllPG();

$costanti = [
	"DEFAULT_PF" 	  => Personaggio::DEFAULT_PF,
	"MIN_HEALTH"	  => Personaggio::MIN_HEALTH,
	"DEFAULT_FOR_DES" => Personaggio::DEFAULT_FOR_DES,
	"MAX_FOR_DES"	  => Personaggio::MAX_FOR_DES,
	"MIN_FOR_DES"	  => Personaggio::MIN_FOR_DES,
	"DODGE_LOOKUP" 	  => Personaggio::DODGE_LOOKUP,
	"DAMAGE_LOOKUP"   => Personaggio::DAMAGE_LOOKUP
];

$esito = [
	"personaggi" => $personaggi,
	"costanti" => $costanti
];


header('Content-Type: application/json');
echo json_encode($esito);

?>