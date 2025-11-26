<?php
// api/session.php
header('Content-Type: application/json; charset=utf-8');
session_start();

// controllo sessione
if (isset($_SESSION['user_id']) && isset($_SESSION['role'])) {
    echo json_encode([
        'logged' => true,
        'user_id' => $_SESSION['user_id'],
        'role' => $_SESSION['role'],
        'username' => $_SESSION['username']
    ]);
} else {
    echo json_encode(['logged' => false]);
}
?>