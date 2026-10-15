<?php
require_once 'accesso_post.php';
require_once "connessione.php";
require_once "verifica_status.php";

$id_utente = (int)$_SESSION['id_utente'];

if (!isset($_POST['id_forum']) || !isset($_POST['nome_topic'])) {
    echo "Dati mancanti.";
    exit();
}

$id_forum = (int)$_POST['id_forum'];
$titolo_topic = trim($_POST['nome_topic']);

if (empty($titolo_topic) || strlen($titolo_topic) > 20) {
    echo "Il nome del topic non è valido (Max 20 caratteri, senza spazi).";
    exit();
}

if (strlen(strip_tags($titolo_topic)) !== strlen($titolo_topic)) {
    echo "Il nome del topic non può contenere codice o tag HTML.";
    mysqli_close($conn);
    exit();
}

verificaAmministratoreForum($conn, $id_utente, $id_forum, false);

// verifica duplicati
$sql_check_dup = "SELECT id_topic FROM topic WHERE id_forum = ? AND titolo_topic = ?";
$stmt_dup = mysqli_prepare($conn, $sql_check_dup);
mysqli_stmt_bind_param($stmt_dup, "is", $id_forum, $titolo_topic);
mysqli_stmt_execute($stmt_dup);
$res_dup = mysqli_stmt_get_result($stmt_dup);
$esiste_gia = mysqli_fetch_assoc($res_dup);
mysqli_stmt_close($stmt_dup);

if ($esiste_gia) {
    echo "Questo topic esiste già all'interno del forum.";
    exit();
}

// inserimento
$sql_insert = "INSERT INTO topic (id_forum, titolo_topic) VALUES (?, ?)";
$stmt_insert = mysqli_prepare($conn, $sql_insert);
mysqli_stmt_bind_param($stmt_insert, "is", $id_forum, $titolo_topic);

if (mysqli_stmt_execute($stmt_insert)) {
    echo mysqli_insert_id($conn); 
} else {
    echo "Errore interno durante il salvataggio del topic.";
}

mysqli_stmt_close($stmt_insert);
mysqli_close($conn);
exit();
?>