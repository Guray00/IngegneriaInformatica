<?php
require_once 'accesso_post.php';
require_once 'connessione.php';

$nome_forum = isset($_POST['nome_forum']) ? trim($_POST['nome_forum']) : '';
$id_creatore = $_SESSION['id_utente'];

if ($nome_forum === '') {
    echo "Il nome del forum non può essere vuoto.";
    mysqli_close($conn);
    exit();
}

if (strlen(strip_tags($nome_forum)) !== strlen($nome_forum)) {
    echo "Il nome del forum non può contenere codice o tag HTML.";
    mysqli_close($conn);
    exit();
}

if (strlen($nome_forum) > 20) {
    echo "Il nome del forum non può superare i 20 characters.";
    mysqli_close($conn);
    exit();
}

// Prevenzione duplicati
$query_controllo = "SELECT id_forum FROM forum WHERE nome_forum = ?";
if ($stmt_check = mysqli_prepare($conn, $query_controllo)) {
    mysqli_stmt_bind_param($stmt_check, "s", $nome_forum);
    mysqli_stmt_execute($stmt_check);
    mysqli_stmt_store_result($stmt_check);
    
    if (mysqli_stmt_num_rows($stmt_check) > 0) {
        echo "Esiste già un forum con questo nome. Scegline un altro.";
        mysqli_stmt_close($stmt_check);
        mysqli_close($conn);
        exit();
    }
    mysqli_stmt_close($stmt_check);
}

mysqli_begin_transaction($conn);

try {
    // A. inserimento del forum
    $query_inserimento = "INSERT INTO forum (id_creatore, nome_forum, descrizione) VALUES (?, ?, NULL)";
    $stmt_forum = mysqli_prepare($conn, $query_inserimento);
    
    if (!$stmt_forum) {
        throw new Exception("Errore nella preparazione della query del forum.");
    }
    
    mysqli_stmt_bind_param($stmt_forum, "is", $id_creatore, $nome_forum);
    
    if (!mysqli_stmt_execute($stmt_forum)) {
        throw new Exception("Errore durante l'esecuzione dell'inserimento del forum.");
    }
    
    // recuper dell'ID appena autogenerato
    $id_nuovo_forum = mysqli_insert_id($conn);
    mysqli_stmt_close($stmt_forum);

    // B. iscrizione automatica del creatore
    $query_iscrizione = "INSERT INTO iscrizioni_forum (id_utente, id_forum) VALUES (?, ?)";
    $stmt_iscr = mysqli_prepare($conn, $query_iscrizione);
    
    if (!$stmt_iscr) {
        throw new Exception("Errore nella preparazione della query di iscrizione.");
    }
    
    mysqli_stmt_bind_param($stmt_iscr, "ii", $id_creatore, $id_nuovo_forum);
    
    if (!mysqli_stmt_execute($stmt_iscr)) {
        throw new Exception("Errore durante l'iscrizione automatica dell'amministratore.");
    }
    
    mysqli_stmt_close($stmt_iscr);

    mysqli_commit($conn);
    
    session_write_close();
    echo "OK"; 

} catch (Exception $e) {
    mysqli_rollback($conn);
    echo "Errore tecnico: impossibile completare la creazione del forum.";
}

mysqli_close($conn);
exit();
?>