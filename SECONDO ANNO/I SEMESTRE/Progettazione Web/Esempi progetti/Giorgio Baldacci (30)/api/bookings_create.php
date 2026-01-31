<?php
// api/bookings_create.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'student') {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_create.php] Accesso negato'
    ]);
    exit;
}

// recupero e controllo input
$input = json_decode(file_get_contents('php://input'), true);
$slot_id = (int)($input['slot_id']);
if ($slot_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_create.php] Slot non valido'
    ]);
    exit;
}
$mode = $input['mode'];

try {
    // transazione per prenotare
    $pdo->beginTransaction();

    // verifica che lo slot esista
    $sql = '
        SELECT id
        FROM slots
        WHERE id = ?
    ';
    $check_exist = $pdo->prepare($sql);
    $check_exist->execute([$slot_id]);
    if (!$check_exist->fetch()) {
        $pdo->rollBack();
        echo json_encode([
            'success' => true,
            'message' => '[bookings_create.php] Slot non trovato'
        ]);
        exit;
    }

    // verifica che lo slot non sia già prenotato
    $sql2 = '
        SELECT COUNT(*)
        FROM bookings
        WHERE slot_id = ?
    ';
    $check_booking = $pdo->prepare($sql2);
    $check_booking->execute([$slot_id]);
    if ((int)$check_booking->fetchColumn() > 0) {
        $pdo->rollBack();
        echo json_encode([
            'success' => true,
            'message' => '[bookings_create.php] Slot già prenotato'
        ]);
        exit;
    }

    // inserimento prenotazione
    $sql3 = '
        INSERT INTO bookings (slot_id, student_id, chosenMode)
        VALUES (?, ?, ?)
    ';
    $insert = $pdo->prepare($sql3);
    $insert->execute([$slot_id, $_SESSION['user_id'], $mode]);
    $pdo->commit();
    echo json_encode([
        'success' => true,
        'message' => '[bookings_create.php] Prenotazione effettuata con successo'
    ]);
} catch (Exception $e) {
    $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => '[bookings_create.php] Errore server'
    ]);
}
?>