<?php
//registrazione al sito
require_once 'connessione.php';

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405); // Method Not Allowed
    echo "Richiesta non consentita.";
    exit();
}

// verifica correttezza e sicurezza
$username = isset($_POST['username']) ? trim($_POST['username']) : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';
$password_conf = isset($_POST['password_conf']) ? $_POST['password_conf'] : '';

if (empty($username) || empty($password) || empty($password_conf)) {
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

if ($password !== $password_conf) {
    echo "Le password inserite non corrispondono.";
    exit();
}

// si verifica che lo username non sia già presente del DB
$query_verifica = "SELECT id_utente FROM utenti WHERE username = ?";
if ($stmt_verifica = mysqli_prepare($conn, $query_verifica)) {
    mysqli_stmt_bind_param($stmt_verifica, "s", $username);
    mysqli_stmt_execute($stmt_verifica);
    mysqli_stmt_store_result($stmt_verifica);

    if (mysqli_stmt_num_rows($stmt_verifica) > 0) {
        mysqli_stmt_close($stmt_verifica);
        echo "Lo username scelto è già utilizzato da un altro utente.";
        exit();
    }
    mysqli_stmt_close($stmt_verifica);
}

// inserimento
$password_criptata = password_hash($password, PASSWORD_BCRYPT);
$query_inserimento = "INSERT INTO utenti (username, password) VALUES (?, ?)";

if ($stmt_inserimento = mysqli_prepare($conn, $query_inserimento)) {
    mysqli_stmt_bind_param($stmt_inserimento, "ss", $username, $password_criptata);

    if (mysqli_stmt_execute($stmt_inserimento)) {
        mysqli_stmt_close($stmt_inserimento);
        mysqli_close($conn);
        echo "OK";
        exit();
    } else {
        echo "Errore di esecuzione durante il salvataggio dei dati.";
    }
    mysqli_stmt_close($stmt_inserimento);
} else {
    echo "Errore tecnico nella preparazione del salvataggio.";
}

mysqli_close($conn);
exit();
?>