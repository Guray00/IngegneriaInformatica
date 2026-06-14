<?php
require_once 'accesso_post.php';
require_once "connessione.php";
require_once "verifica_status.php";

$id_utente = (int)$_SESSION['id_utente'];

//validazione di sicurezza
if (!isset($_POST['id_forum']) || !isset($_POST['titolo']) || !isset($_POST['contenuto'])) {
    echo "Dati del form incompleti.";
    exit();
}

$id_forum = (int)$_POST['id_forum'];
$titolo = trim($_POST['titolo']);
$contenuto = trim($_POST['contenuto']);
$tag_selezionati = isset($_POST['tag_post']) ? $_POST['tag_post'] : []; 

if (empty($titolo) || strlen($titolo) > 20) {
    echo "Il titolo deve essere compreso tra 1 e 20 caratteri.";
    exit();
}
if (empty($contenuto) || strlen($contenuto) > 500) {
    echo "Il testo del post deve essere compreso tra 1 e 500 caratteri.";
    exit();
}
if (count($tag_selezionati) > 3) {
    echo "Non puoi selezionare più di 3 topic.";
    exit();
}
if (strlen(strip_tags($titolo)) !== strlen($titolo) || strlen(strip_tags($contenuto)) !== strlen($contenuto)) {
    echo "Il post non può contenere codice o tag HTML nocivi.";
    exit();
}

verificaIscrizioneForum($conn, $id_utente, $id_forum, false);

mysqli_begin_transaction($conn);
try {
    $sql_post = "INSERT INTO post (id_utente, id_forum, titolo, contenuto) VALUES (?, ?, ?, ?)";
    $stmt_post = mysqli_prepare($conn, $sql_post);
    mysqli_stmt_bind_param($stmt_post, "iiss", $id_utente, $id_forum, $titolo, $contenuto);
    mysqli_stmt_execute($stmt_post);
    
    $id_nuovo_post = mysqli_insert_id($conn);
    mysqli_stmt_close($stmt_post);

    if (!empty($tag_selezionati)) {
        $sql_pivot = "INSERT INTO topic_post (id_post, id_topic) VALUES (?, ?)";
        $stmt_pivot = mysqli_prepare($conn, $sql_pivot);
        
        foreach ($tag_selezionati as $id_topic_scelto) {
            $id_topic_clean = (int)$id_topic_scelto;
            mysqli_stmt_bind_param($stmt_pivot, "ii", $id_nuovo_post, $id_topic_clean);
            mysqli_stmt_execute($stmt_pivot);
        }
        mysqli_stmt_close($stmt_pivot);
    }

    mysqli_commit($conn);
    echo $id_nuovo_post;

} catch (Exception $e) {
    mysqli_rollback($conn);
    echo "Errore interno durante il salvataggio del post.";
}

mysqli_close($conn);
exit();
?>