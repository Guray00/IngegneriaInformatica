<?php
//permette all'admin di ripristinare il numero di segnalazioni di un post
require_once 'accesso_post.php';
require_once 'connessione.php';
require_once 'verifica_status.php';
header('Content-Type: application/json; charset=utf-8');

$id_utente_corrente = (int)$_SESSION['id_utente'];
$id_post = isset($_POST['id_post']) ? (int)$_POST['id_post'] : 0;

if ($id_post <= 0) {
    echo json_encode(['error' => 'ID Post mancante o non valido.']);
    mysqli_close($conn);
    exit();
}

verificaAmministratorePost($conn, $id_utente_corrente, $id_post, true);

$sql_reset = "DELETE FROM interazioni WHERE id_post = ? AND tipo_interazione = 'segnala'";
$stmt_reset = mysqli_prepare($conn, $sql_reset);
mysqli_stmt_bind_param($stmt_reset, "i", $id_post);

if (mysqli_stmt_execute($stmt_reset)) {
    echo json_encode(['status' => 'OK']);
} else {
    echo json_encode(['error' => 'Errore interno durante il reset delle segnalazioni.']);
}

mysqli_stmt_close($stmt_reset);
mysqli_close($conn);
exit();
?>