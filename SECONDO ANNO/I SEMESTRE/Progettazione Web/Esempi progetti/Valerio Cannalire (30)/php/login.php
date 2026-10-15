<?php
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo "Richiesta non consentita.";
    exit();
}

session_start();
require_once 'connessione.php';

// verifica di correttezza e sicurezza
$username = isset($_POST['username']) ? trim($_POST['username']) : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

if (empty($username) || empty($password)) {
    echo "Tutti i campi sono obbligatori.";
    exit();
}

$pattern_username = "/^[A-Za-z][A-Za-z0-9]{5,11}$/";
$pattern_password = "/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,15}$/";

if (!preg_match($pattern_username, $username)) {
    echo "Lo username non rispetta i criteri di complessità del server.";
    exit();
}

if (!preg_match($pattern_password, $password)) {
    echo "La password inserita non rispetta i criteri di complessità del server.";
    exit();
}

// verifica login
$query_login = "SELECT id_utente, password FROM utenti WHERE username = ?";

if ($stmt_login = mysqli_prepare($conn, $query_login)) {
    mysqli_stmt_bind_param($stmt_login, "s", $username);
    mysqli_stmt_execute($stmt_login);
    mysqli_stmt_bind_result($stmt_login, $id_utente, $password_db);
    
    if (mysqli_stmt_fetch($stmt_login)) {
        if (password_verify($password, $password_db)) {
            mysqli_stmt_close($stmt_login);
            mysqli_close($conn);

            // registrazione della sessione
            $_SESSION['id_utente'] = $id_utente;
            $_SESSION['username'] = $username;
            $_SESSION['loggato'] = true;

            session_write_close();
            echo "OK";
            exit();
        }
    }
    
    echo "Username o password errati. Riprova.";
    mysqli_stmt_close($stmt_login);
} else {
    echo "Si è verificato un errore tecnico durante l'accesso.";
}

mysqli_close($conn);
exit();
?>