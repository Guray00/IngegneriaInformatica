<?php

require_once __DIR__ . "/../includes/methods.php";
session_start();
header('Content-Type: application/json');


if(!isset($_SESSION['accountID'], $_SESSION['currentPG_nome'])){
	apiError(403);
}

if(!isset($_SESSION['battaglia'])){
	apiError(401);
}

$battaglia = unserialize($_SESSION['battaglia']);
$tempoRimanente = Personaggio::DEFAULT_TURN_TIME;
if(!$battaglia['Terminata']){    
    $durataTurno = Personaggio::DEFAULT_TURN_TIME;
    $currentTime = new DateTime("now");
    
    $tempoPassato = $currentTime->getTimestamp() - unserialize($battaglia['DataUltimoTurno'])->getTimestamp();
    
    $tempoRimanente = Personaggio::DEFAULT_TURN_TIME - $tempoPassato;
    
    if($tempoRimanente < 0){
        $tempoRimanente = 0;
    }    
}

$minuti = $tempoRimanente / 60;
$secondi = $tempoRimanente % 60;
$tempoRimanenteFormattato = sprintf("%02d:%02d", $minuti, $secondi);

$myPG = unserialize($battaglia['pg1'])->getAll();
$pg1_filtrato = [
    'nome'            => $myPG['nome'],
    'pathImmaginePG'  => $myPG['pathImmaginePG'],
    'PF'              => $myPG['PF'],
    'temp_PF'         => ($myPG['temp_PF'] >= 0)? $myPG['temp_PF'] : 0,
    'zaino' 		  => $myPG['zaino']
];

if($myPG['arma']){
    $pg1_filtrato['arma'] = $myPG['arma']['PathImmagine'];
}
if($myPG['armatura']){
    $pg1_filtrato['armatura'] = $myPG['armatura']['PathImmagine'];
}

$enemyPG = unserialize($battaglia['pg2'])->getAll();

$pg2_filtrato = [
    'nome'            => $enemyPG['nome'],
    'pathImmaginePG'  => $enemyPG['pathImmaginePG'],
    'PF'              => $enemyPG['PF'],
    'temp_PF'         => ($enemyPG['temp_PF'] >= 0)? $enemyPG['temp_PF'] : 0,
];

if($enemyPG['arma']){
    $pg2_filtrato['arma'] = $enemyPG['arma']['PathImmagine'];
}
if($enemyPG['armatura']){
    $pg2_filtrato['armatura'] = $enemyPG['armatura']['PathImmagine'];
}

$output = [
	'pg1'			 		 => $pg1_filtrato,
	'pg2'			 		 => $pg2_filtrato,
    'vittoria'               => $battaglia['Vittoria_Giocatore1'],
	'turno' 		 		 => $battaglia['Turno_Giocatore1'],
    'tempoRimanente' 		 => $tempoRimanenteFormattato,
	'tempoRimanente_secondi' => $tempoRimanente
];

echo json_encode($output);