<?php

// funzione booleana per verificare se un utente sia iscritto a un forum
function isIscritto($conn, $id_utente, $id_forum) {
    if ($id_forum <= 0 || $id_utente <= 0) return false;
    $sql = "SELECT 1 FROM iscrizioni_forum WHERE id_utente = ? AND id_forum = ?";
    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) return false;
    mysqli_stmt_bind_param($stmt, "ii", $id_utente, $id_forum);
    mysqli_stmt_execute($stmt);
    $res = mysqli_stmt_get_result($stmt);
    $esito = (mysqli_num_rows($res) > 0);
    mysqli_stmt_close($stmt);
    return $esito;
}

// verifica iscrizione tramite tabella forum nel database
function verificaIscrizioneForum($conn, $id_utente, $id_forum, $formato_json) {
    if (!isIscritto($conn, $id_utente, $id_forum)) {
        inviaErroreValidazione("Operazione negata: devi essere iscritto a questo forum.", $formato_json);
    }
    return true;
}

// verifica iscrizione a partire da tabella post
function verificaIscrizionePost($conn, $id_utente, $id_post, $formato_json) {
    if ($id_post <= 0) inviaErroreValidazione("ID Post non valido.", $formato_json);
    $sql = "SELECT id_forum FROM post WHERE id_post = ?";
    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, "i", $id_post);
    mysqli_stmt_execute($stmt);
    $riga = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt));
    mysqli_stmt_close($stmt);
    if (!$riga) inviaErroreValidazione("Il post specificato non esiste.", $formato_json);
    return verificaIscrizioneForum($conn, $id_utente, (int)$riga['id_forum'], $formato_json);
}

// funzione booleana per verificare se un utente sia l'admin di un forum
function isAmministratore($conn, $id_utente, $id_forum) {
    if ($id_forum <= 0 || $id_utente <= 0) return false;
    $sql = "SELECT id_creatore FROM forum WHERE id_forum = ?";
    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) return false;
    mysqli_stmt_bind_param($stmt, "i", $id_forum);
    mysqli_stmt_execute($stmt);
    $res = mysqli_stmt_get_result($stmt);
    $forum = mysqli_fetch_assoc($res);
    mysqli_stmt_close($stmt);
    return ($forum && (int)$forum['id_creatore'] === $id_utente);
}

// verifica admin tramite tabella forum nel database
function verificaAmministratoreForum($conn, $id_utente, $id_forum, $formato_json) {
    if (!isAmministratore($conn, $id_utente, $id_forum)) {
        inviaErroreValidazione("Operazione non consentita: non sei l'amministratore di questo forum.", $formato_json);
    }
    return true;
}

// verifica admin a partire da tabella post
function verificaAmministratorePost($conn, $id_utente, $id_post, $formato_json) {
    if ($id_post <= 0) {
        inviaErroreValidazione("ID Post mancante o non valido.", $formato_json);
    }
    
    $sql = "SELECT f.id_creatore FROM post p 
            JOIN forum f ON p.id_forum = f.id_forum 
            WHERE p.id_post = ?";
    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) {
        inviaErroreValidazione("Errore interno di verifica del server.", $formato_json);
    }
    mysqli_stmt_bind_param($stmt, "i", $id_post);
    mysqli_stmt_execute($stmt);
    $riga = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt));
    mysqli_stmt_close($stmt);

    if (!$riga) {
        inviaErroreValidazione("Post inesistente.", $formato_json);
    }

    if ((int)$riga['id_creatore'] !== $id_utente) {
        inviaErroreValidazione("Operazione non consentita: non sei l'amministratore di questo forum.", $formato_json);
    }
    return true;
}

// gestisce messaggio di errore come testo o come json
function inviaErroreValidazione($messaggio, $json) {
    if ($json) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["error" => $messaggio]);
    } else {
        header('Content-Type: text/plain; charset=utf-8');
        echo $messaggio;
    }
    exit();
}
?>