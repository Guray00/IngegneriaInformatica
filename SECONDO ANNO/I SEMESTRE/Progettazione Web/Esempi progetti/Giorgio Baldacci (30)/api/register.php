<?php
// api/register.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// recupero input e controllo
$input = json_decode(file_get_contents('php://input'), true);
$role = trim($input['role']);
$username = trim($input['username']);
$password = trim($input['password']);
if (!$username || !$password || ($role != 'student' && $role != 'tutor')) {
    echo json_encode([
        'success' => false,
        'message' => '[register.php]: Dati non validi'
    ]);
    exit;
}
$hash = password_hash($password, PASSWORD_DEFAULT);

try {
    // controllo se esiste già un utente dello stesso tipo con stesso username
    $sql;
    if ($role == 'tutor')
        $sql = '
            SELECT id
            FROM tutor
            WHERE username = ?
        ';
    else
        $sql = '
            SELECT id
            FROM student
            WHERE username = ?
        ';

    $check_usr = $pdo->prepare($sql);
    $check_usr->execute([$username]);
    if ($check_usr->fetch()) {
        echo json_encode([
            'success' => false,
            'message' => '[register.php]: Username non disponibile'
        ]);
        exit;
    }

    // inserimento nel database
    $sql2;
    if ($role == 'tutor')
        $sql2 = '
            INSERT INTO tutor (username, password)
            VALUES (?, ?)
        ';
    else
        $sql2 = '
            INSERT INTO student (username, password)
            VALUES (?, ?)
        ';

    $insert = $pdo->prepare($sql2);
    $insert->execute([$username, $hash]);
    echo json_encode([
        'success' => true,
        'message' => '[register.php]: Tutor registrato'
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[register.php]: Errore server',
        'error' =>  $e->getMessage()
    ]);
}
?>