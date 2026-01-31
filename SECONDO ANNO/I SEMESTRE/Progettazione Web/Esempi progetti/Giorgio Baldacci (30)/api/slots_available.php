<?php
// api/slots_available.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';

try {
    // recupero di tutti gli slot disponibili dal db
    // utilizzo left join con bookings per ottenere solo slot non prenotati
    $sql = '
        SELECT s.id, s.date, s.time, s.mode, s.tutor_id, t.username AS tutor_name, t.cost_online, t.cost_presenza
        FROM slots s
        JOIN tutor t ON s.tutor_id = t.id
        LEFT JOIN bookings b ON s.id = b.slot_id
        WHERE b.slot_id IS NULL
        ORDER BY s.date, s.time
    ';

    $statement = $pdo->prepare($sql);
    $statement->execute();
    $rows = $statement->fetchAll();
    echo json_encode([
        'success' => true,
        'slots' => $rows
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[slots_available.php] Errore server'
    ]);
}
?>