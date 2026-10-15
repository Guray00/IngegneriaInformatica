<?php
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

$sql_delete = "DELETE FROM post WHERE id_post = ?";
$stmt_delete = mysqli_prepare($conn, $sql_delete);
mysqli_stmt_bind_param($stmt_delete, "i", $id_post);

if (mysqli_stmt_execute($stmt_delete)) {
    echo json_encode(['status' => 'OK']);
} else {
    echo json_encode(['error' => 'Errore interno durante l\'eliminazione dal database.']);
}

mysqli_stmt_close($stmt_delete);
mysqli_close($conn);
exit();
?>