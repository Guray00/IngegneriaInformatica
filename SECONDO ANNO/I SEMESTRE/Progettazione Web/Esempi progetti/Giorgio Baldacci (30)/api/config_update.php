<?php
// api/config_update.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor') {
    echo json_encode([
        'success' => false,
        'message' => '[config_update.php] Accesso negato'
    ]);
    exit;
}

// recupero input e controllo
$input = json_decode(file_get_contents('php://input'), true);
$desc = trim($input['description']);
$cost_online = (float)($input['cost_online']);
$cost_presenza = (float)($input['cost_presenza']);
$subjects = $input['subjects'];
if (strlen($desc) > 500) {
    echo json_encode([
        'success' => false,
        'message' => 'Descrizione troppo lunga'
    ]);
    exit;
}

try {
    $pdo->beginTransaction();

    // aggiorna desc e costi    
    $sql = '
        UPDATE tutor
        SET description = ?, cost_online = ?, cost_presenza = ?
        WHERE id = ?
    ';
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$desc, $cost_online, $cost_presenza, $_SESSION['user_id']]);

    // rimozione delle vecchie materie
    $sql2 = '
        DELETE FROM tutor_subject
        WHERE tutor_id = ?
    ';
    $del = $pdo->prepare($sql2);
    $del->execute([$_SESSION['user_id']]);

    // inserimento quelle nuove materie
    if (!empty($subjects)) {
        $sql3 = '
            INSERT INTO tutor_subject (tutor_id, subject_id)
            VALUES (?, ?)
        ';
        $ins = $pdo->prepare($sql3);
        foreach ($subjects as $sub_id) {
            $ins->execute([$_SESSION['user_id'], (int)$sub_id]);
        }
    }

    $pdo->commit();
    echo json_encode([
        'success' => true,
        'message' => 'Configurazione salvata'
    ]);
} catch (Exception $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => '[config_update.php] Errore: ' . $e->getMessage()
    ]);
}
?>