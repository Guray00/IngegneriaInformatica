<?php
// api/slots_create.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if(!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor'){
    echo json_encode([
        'success' => false,
        'message' => '[slots_create.php] Accesso negato'
    ]);
    exit;
}

// recupero input
$input = json_decode(file_get_contents('php://input'), true);
$date = $input['date'];
$time = $input['time'];
$mode = $input['mode'];

// controllo input
if (!$date || !$time || !$mode){
    echo json_encode([
        'success' => false,
        'message' => '[slots_create.php] Dati slot mancanti'
    ]);
    exit;
}

try {
    // inserimento slot nel db con prepared statement
    $sql = '
        INSERT INTO slots (tutor_id, date, time, mode)
        VALUES (?, ?, ?, ?)
    ';
    $statement = $pdo->prepare($sql);
    $statement->execute([$_SESSION['user_id'], $date, $time, $mode]);
    echo json_encode([
        'success' => true,
        'message' => '[slots_create.php] Slot creato con successo'
    ]);
}
catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[slots_create.php] Errore server'
    ]);
}