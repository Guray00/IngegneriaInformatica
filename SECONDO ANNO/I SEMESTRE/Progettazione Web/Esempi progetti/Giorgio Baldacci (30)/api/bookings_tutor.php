<?php
// api/bookings_tutor.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor') {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_tutor.php] Accesso negato'
    ]);
    exit;
}

try {
    // recupero delle prenotazioni del tutor
    $sql = '
        SELECT b.id AS booking_id, b.student_id, s.id AS slot_id, s.date, s.time, s.mode, st.username AS student_name, b.paid, t.cost_online, t.cost_presenza
        FROM bookings b
        JOIN slots s ON b.slot_id = s.id
        JOIN student st ON b.student_id = st.id
        JOIN tutor t ON s.tutor_id = t.id
        WHERE s.tutor_id = ?
        ORDER BY s.date, s.time
    ';
    $statement = $pdo->prepare($sql);
    $statement->execute([$_SESSION['user_id']]);
    $rows = $statement->fetchAll();
    echo json_encode([
        'success' => true,
        'bookings' => $rows
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_tutor.php] Errore server' . $e->getMessage()
    ]);
}
?>