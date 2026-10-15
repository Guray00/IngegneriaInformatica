<?php
require_once 'accesso_post.php';
require_once 'connessione.php'; 
require_once 'verifica_status.php';
header('Content-Type: application/json; charset=utf-8');

// verifica di sicurezza
$id_utente_corrente = (int)$_SESSION['id_utente'];
$id_post = isset($_POST['id_post']) ? (int)$_POST['id_post'] : 0;
$titolo = isset($_POST['titolo']) ? trim($_POST['titolo']) : '';
$contenuto = isset($_POST['contenuto']) ? trim($_POST['contenuto']) : '';
$topics_scelti = isset($_POST['tag_post']) ? $_POST['tag_post'] : [];

if ($id_post <= 0 || empty($contenuto)) {
    echo json_encode(['error' => 'Dati del post non validi o testo mancante.']);
    mysqli_close($conn);
    exit();
}

if (strlen(strip_tags($titolo)) !== strlen($titolo) || strlen(strip_tags($contenuto)) !== strlen($contenuto)) {
    echo json_encode(['error' => 'Il post modificato non può contenere codice o tag HTML nocivi.']);
    mysqli_close($conn);
    exit();
}

verificaAmministratorePost($conn, $id_utente_corrente, $id_post, true);

mysqli_begin_transaction($conn);
try {
    // update su tabella post
    $sql_update_post = "UPDATE post SET titolo = ?, contenuto = ?, modificato = 1 WHERE id_post = ?";
    $stmt_update_post = mysqli_prepare($conn, $sql_update_post);
    mysqli_stmt_bind_param($stmt_update_post, "ssi", $titolo, $contenuto, $id_post);
    mysqli_stmt_execute($stmt_update_post);
    mysqli_stmt_close($stmt_update_post);

    // eliminazione dei topic legati al post
    $sql_delete_legami = "DELETE FROM topic_post WHERE id_post = ?";
    $stmt_delete_legami = mysqli_prepare($conn, $sql_delete_legami);
    mysqli_stmt_bind_param($stmt_delete_legami, "i", $id_post);
    mysqli_stmt_execute($stmt_delete_legami);
    mysqli_stmt_close($stmt_delete_legami);

    if (!empty($topics_scelti) && is_array($topics_scelti)) {
        //inserimento dei nuovi topic con cui il post è etichettato
        $sql_insert_legame = "INSERT INTO topic_post (id_post, id_topic) VALUES (?, ?)";
        $stmt_insert_legame = mysqli_prepare($conn, $sql_insert_legame);
        
        $contatore = 0;
        foreach ($topics_scelti as $id_topic) {
            if ($contatore >= 3) break; 
            $id_topic_int = (int)$id_topic;
            mysqli_stmt_bind_param($stmt_insert_legame, "ii", $id_post, $id_topic_int);
            mysqli_stmt_execute($stmt_insert_legame);
            $contatore++;
        }
        mysqli_stmt_close($stmt_insert_legame);
    }

    mysqli_commit($conn);
    echo json_encode(['status' => 'OK']);

} catch (Exception $e) {
    mysqli_rollback($conn);
    echo json_encode(['error' => 'Errore durante l\'aggiornamento dei topic associati.']);
}

mysqli_close($conn);
exit();
?>