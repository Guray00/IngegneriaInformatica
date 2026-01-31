<?php
// api/config_get.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// controllo credenziali
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'tutor') {
    echo json_encode([
        'success' => false,
        'message' => '[config_get.php] Accesso negato'
    ]);
    exit;
}

try {
    // recupero dati del profilo tutor e materie
    $sql = '
        SELECT description, cost_online, cost_presenza
        FROM tutor
        WHERE id = ?
    ';
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$_SESSION['user_id']]);
    $profile = $stmt->fetch();

    // recupero tutte le materie disponibili
    $sql2 = '
        SELECT id, name
        FROM subject
        ORDER BY subject.name ASC
    ';
    $stmt = $pdo->prepare($sql2);
    $stmt->execute();
    $all_subjects = $stmt->fetchAll();

    // recupero materie associate al tutor
    $sql3 = '
        SELECT subject_id
        FROM tutor_subject
        WHERE tutor_id = ?
    ';
    $stmt = $pdo->prepare($sql3);
    $stmt->execute([$_SESSION['user_id']]);
    $rows = $stmt->fetchAll();

    // converto in array di id
    $my_subjects = array_map(function ($row) {
        return $row['subject_id'];
    }, $rows);

    echo json_encode([
        'success' => true,
        'profile' => $profile,
        'all_subjects' => $all_subjects,
        'my_subjects' => $my_subjects
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[config_get.php] Errore: ' . $e->getMessage()
    ]);
}
?>