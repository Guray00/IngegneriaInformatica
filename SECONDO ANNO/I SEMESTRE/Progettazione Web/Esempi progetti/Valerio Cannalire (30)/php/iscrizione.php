<?php
// iscrizione a un forum
require_once 'accesso_post.php';
require_once "connessione.php";
require_once "verifica_status.php";
header("Content-Type: text/plain; charset=UTF-8");

$id_utente = (int)$_SESSION['id_utente'];

if (!isset($_POST['id_forum'])) {
    echo "ID Forum mancante.";
    exit();
}

$id_forum = (int)$_POST['id_forum'];

if (isIscritto($conn, $id_utente, $id_forum)) {
    echo "Sei già iscritto a questo forum.";
    exit();
}

// inserimento
$sql_insert = "INSERT INTO iscrizioni_forum (id_utente, id_forum) VALUES (?, ?)";
$stmt_insert = mysqli_prepare($conn, $sql_insert);
mysqli_stmt_bind_param($stmt_insert, "ii", $id_utente, $id_forum);

if (mysqli_stmt_execute($stmt_insert)) {
    echo "OK";
} else {
    echo "Errore interno durante il salvataggio dell'iscrizione.";
}

mysqli_stmt_close($stmt_insert);
mysqli_close($conn);
exit();
?>