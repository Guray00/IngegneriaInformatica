<?php
// api/tutor_details.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';

// controllo tutor_id
$tutor_id = (int)($_GET['id'] ?? 0);
if ($tutor_id <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'ID Tutor mancante'
    ]);
    exit;
}

try {
    // recupero dettagli tutor e controllo esistenza
    $sql = '
        SELECT username, description, cost_online, cost_presenza
        FROM tutor
        WHERE id = ?
    ';
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$tutor_id]);
    $tutor = $stmt->fetch();
    if (!$tutor) {
        echo json_encode([
            'success' => false,
            'message' => 'Tutor non trovato'
        ]);
        exit;
    }

    // recupero materie tutor
    $sql2 = '
        SELECT s.name 
        FROM subject s
        JOIN tutor_subject ts ON s.id = ts.subject_id
        WHERE ts.tutor_id = ?
        ORDER BY s.name ASC
    ';
    $stmtSub = $pdo->prepare($sql2);
    $stmtSub->execute([$tutor_id]);
    $subjects = $stmtSub->fetchAll(PDO::FETCH_COLUMN);

    echo json_encode([
        'success' => true,
        'tutor' => $tutor,
        'subjects' => $subjects
    ]);
}
catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Errore server'
    ]);
}