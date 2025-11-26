<?php
// api/login.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';
session_start();

// recupero input
$input = json_decode(file_get_contents('php://input'), true) ?? [];
$role = trim($input['role'] ?? '');
$username = trim($input['username'] ?? '');
$pwd_attempt = trim($input['password'] ?? '');

// controllo input
if (!$username || !$pwd_attempt || ($role != 'student' && $role != 'tutor')) {
    echo json_encode([
        'success' => false,
        'message' => '[login.php]: Dati non validi'
    ]);
    exit;
}

try {
    // recupero id, username e password dal database
    $sql;
    if ($role == 'tutor')
        $sql = '
            SELECT id, username, password
            FROM tutor WHERE username = ?
        ';
    else
        $sql = '
            SELECT id, username, password
            FROM student WHERE username = ?
        ';

    $statement = $pdo->prepare($sql);
    $statement->execute([$username]);
    $result = $statement->fetch();

    if ($result) {
        $password = $result['password'];
        $ok = false;

        // controllo tentativo di accesso, sia se la password nel database è in chiaro o meno
        if (password_get_info($password)['algo'] != 0) // password hashata (profili creati tramite registrazione)
            $ok = password_verify($pwd_attempt, $password);
        else // password in chiaro (profili creati durante popolazione database)
            $ok = ($pwd_attempt == $password);

        if ($ok) {
            $_SESSION['user_id'] = (int)$result['id'];
            $_SESSION['role'] = $role;
            $_SESSION['username'] = $result['username'];
            echo json_encode([
                'success' => true,
                'role' => $role,
                $username => $result['username']
            ]);
            exit;
        }
    }

    echo json_encode([
        'success' => false,
        'message' => '[login.php]: Credenziali errate'
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => '[login.php]: Errore server',
        'error' =>  $e->getMessage()
    ]);
}
?>