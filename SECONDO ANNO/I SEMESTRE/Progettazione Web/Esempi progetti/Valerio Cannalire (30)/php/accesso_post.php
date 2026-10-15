<?php
//permette di verificare che l'utente sia loggato e l'accesso alla pagina sia fatto tramite metodo POST
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (
    !isset($_SESSION['loggato']) || 
    $_SESSION['loggato'] !== true || 
    !isset($_SESSION['id_utente']) || 
    $_SERVER["REQUEST_METHOD"] !== "POST"
) {
    http_response_code(403);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(["error" => "Sessione scaduta o accesso non consentito."]);
    exit();
}
?>