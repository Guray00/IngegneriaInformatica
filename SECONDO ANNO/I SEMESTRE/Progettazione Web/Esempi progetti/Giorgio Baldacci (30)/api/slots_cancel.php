<?php
// api/slots_cancel.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor') {
    echo json_encode([
        'success' => false,
        'message' => '[slots_cancel.php] Accesso negato'
    ]);
    exit;
}

// recupero e controllo input
$input = json_decode(file_get_contents('php://input'), true);
$slot_id = (int)($input['slot_id']);
if (!$slot_id || $slot_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => '[slots_cancel.php] Lezione non valida'
    ]);
    exit;
}

try {
    // verifica che la prenotazione esista e appartenga allo studente
    $sql = '
        SELECT id
        FROM slots
        WHERE id = ? AND tutor_id = ?
    ';
    $check_booking = $pdo->prepare($sql);
    $check_booking->execute([$slot_id, $_SESSION['user_id']]);
    if ((int)$check_booking->fetchColumn() === 0) {
        echo json_encode([
            'success' => false,
            'message' => '[slots_cancel.php] Lezione non trovata'
        ]);
        exit;
    }

    // cancellazione prenotazione
    $pdo->beginTransaction();
    $sql2 = '
        DELETE FROM slots
        WHERE id = ?
    ';
    $delete = $pdo->prepare($sql2);
    $delete->execute([$slot_id]);
    $pdo->commit();
    echo json_encode([
        'success' => true,
        'message' => '[slots_cancel.php] Lezione cancellata con successo'
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[slots_cancel.php] Errore server'
    ]);
}
