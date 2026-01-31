<?php
// api/bookings_student.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || ($_SESSION['role'] ?? '') !== 'student') {
    echo json_encode([
        'success' => false,
        'message' => '[bookings_student.php] Accesso negato'
    ]);
    exit;
}

try {
    // recupero delle prenotazioni dello studente
    $sql = '
        SELECT b.id AS booking_id, b.chosenMode, s.id AS slot_id, s.date, s.time, s.mode, t.username AS tutor_name, b.paid, t.cost_online, t.cost_presenza
        FROM bookings b
        JOIN slots s ON b.slot_id = s.id
        JOIN tutor t ON s.tutor_id = t.id
        WHERE b.student_id = ?
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
        'message' => '[bookings_student.php] Errore server'
    ]);
}
?>