<?php
// api/bookings_cancel.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'student') {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_cancel.php] Accesso negato'
    ]);
    exit;
}

// recupero e controllo input
$input = json_decode(file_get_contents('php://input'), true);
$booking_id = (int)($input['booking_id']);
if (!$booking_id || $booking_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_cancel.php] Prenotazione non valida'
    ]);
    exit;
}

try {
    // verifica che la prenotazione esista e appartenga allo studente
    $sql = '
        SELECT id
        FROM bookings
        WHERE id = ? AND student_id = ?
    ';
    $check_booking = $pdo->prepare($sql);
    $check_booking->execute([$booking_id, $_SESSION['user_id']]);
    if ((int)$check_booking->fetchColumn() === 0) {
        echo json_encode([
            'success' => false,
            'message' => '[bookings_cancel.php] Prenotazione non trovata'
        ]);
        exit;
    }

    // controlla che non sia entro le prossima 24h
    $sql1 = '
        SELECT date, time
        FROM slots
        WHERE id = (
            SELECT slot_id
            FROM bookings
            WHERE id = ?
        )
    ';
    $stmt_time = $pdo->prepare($sql1);
    $stmt_time->execute([$booking_id]);
    $slot = $stmt_time->fetch();

    $slot_datetime = new DateTime($slot['date'] . ' ' . $slot['time']);
    $now = new DateTime();

    // differenza e controllo
    $interval = $now->diff($slot_datetime);
    $hours = ($interval->days * 24) + $interval->h;
    if ($slot_datetime <= $now || ($hours < 24 && $interval->invert == 0)) {
        echo json_encode([
            'success' => false,
            'message' => 'Troppo tardi per cancellare'
        ]);
        exit;
    }

    // cancellazione prenotazione
    $pdo->beginTransaction();
    $sql2 = '
        DELETE FROM bookings
        WHERE id = ?
    ';
    $delete = $pdo->prepare($sql2);
    $delete->execute([$booking_id]);
    $pdo->commit();
    echo json_encode([
        'success' => true,
        'message' => '[bookings_cancel.php] Prenotazione cancellata con successo'
    ]);
}
catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_cancel.php] Errore server'
    ]);
}
?>