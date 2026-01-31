<?php
// api/pay_single.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor') {
    echo json_encode([
        'success' => false,
        'message' => '[pay_single.php] Accesso negato'
    ]);
    exit;
}

// recupero e controllo input
$input = json_decode(file_get_contents('php://input'), true);
$booking_id = (int)($input['booking_id']);
if ($booking_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => '[pay_single.php] ID prenotazione non valido'
    ]);
    exit;
}

try {
    // recupero la prenotazione per verificare che esista e appartenga al tutor loggato
    $sql = '
        SELECT b.id
        FROM bookings b
        JOIN slots s ON b.slot_id = s.id
        WHERE b.id = ? AND s.tutor_id = ?
    ';
    $check_booking = $pdo->prepare($sql);
    $check_booking->execute([$booking_id, $_SESSION['user_id']]);

    if (!$check_booking->fetch()) {
        echo json_encode([
            'success' => false,
            'message' => '[pay_single.php] Lezione non trovata o non di tua competenza'
        ]);
        exit;
    }

    // transazione per segnare la lezione come pagata
    $pdo->beginTransaction();
    $sql2 = '
        UPDATE bookings
        SET paid = 1
        WHERE id = ?
    ';
    $update = $pdo->prepare($sql2);
    $update->execute([$booking_id]);
    $pdo->commit();

    echo json_encode([
        'success' => true,
        'message' => '[pay_single.php] Lezione pagata con successo'
    ]);
} catch (Exception $e) {
    $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => '[pay_single.php] Errore server: ' . $e->getMessage()
    ]);
}
?>