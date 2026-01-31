<?php
// api/pay_all.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor') {
    echo json_encode([
        'success' => false,
        'message' => '[pay_all.php] Accesso negato'
    ]);
    exit;
}

// recupero e controllo input
$input = json_decode(file_get_contents('php://input'), true);
$student_id = (int)$input['student_id'];
if (!$student_id) {
    echo json_encode([
        'success' => false,
        'message' => '[pay_all.php] ID studente mancante'
    ]);
    exit;
}

try {
    // transazione per segnare le lezioni come pagate
    $pdo->beginTransaction();

    // update con join per assicurarsi che il tutor stia pagando solo le lezioni dei suoi slot
    // e solo quelle non ancora pagate (paid = 0)
    $sql = '
        UPDATE bookings b
        JOIN slots s ON b.slot_id = s.id
        SET b.paid = 1
        WHERE b.student_id = ? 
          AND s.tutor_id = ? 
          AND b.paid = 0
    ';

    $statement = $pdo->prepare($sql);
    $statement->execute([$student_id, $_SESSION['user_id']]);
    $count = $statement->rowCount();
    $pdo->commit();

    echo json_encode([
        'success' => true,
        'message' => "Segnate come pagate $count lezioni",
        'count' => $count
    ]);
} catch (Exception $e) {
    $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => '[pay_all.php] Errore server: ' . $e->getMessage()
    ]);
}
?>