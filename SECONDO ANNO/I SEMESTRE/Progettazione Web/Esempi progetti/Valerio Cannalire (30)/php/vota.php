<?php
require_once 'accesso_post.php';
require_once 'connessione.php';
require_once "verifica_status.php";
header('Content-Type: application/json; charset=utf-8');

$id_utente = (int)$_SESSION['id_utente'];

if (!isset($_POST['id_post']) || !isset($_POST['tipo_voto'])) {
    echo json_encode(["error" => "Dati della richiesta incompleti."]);
    mysqli_close($conn);
    exit();
}

$id_post = (int)$_POST['id_post'];
$tipo_voto = trim($_POST['tipo_voto']); 

if ($tipo_voto !== 'like' && $tipo_voto !== 'dislike') {
    echo json_encode(["error" => "Tipo di voto non consentito."]);
    mysqli_close($conn);
    exit();
}

verificaIscrizionePost($conn, $id_utente, $id_post, true);

mysqli_begin_transaction($conn);
try {
    // si verifica se nel DB sia presente un'interazione dell'utente per lo specifico post
    $sql_check = "SELECT tipo_interazione FROM interazioni 
                  WHERE id_utente = ? AND id_post = ? AND (tipo_interazione = 'like' OR tipo_interazione = 'dislike')";
    $stmt_check = mysqli_prepare($conn, $sql_check);
    mysqli_stmt_bind_param($stmt_check, "ii", $id_utente, $id_post);
    mysqli_stmt_execute($stmt_check);
    $res_check = mysqli_stmt_get_result($stmt_check);
    $voto_precedente = mysqli_fetch_assoc($res_check);
    mysqli_stmt_close($stmt_check);

    $prossima_interazione = null;

    if ($voto_precedente) {
        if ($voto_precedente['tipo_interazione'] === $tipo_voto) {
            //se l'interazione è quella già presente allora si procede con l'eliminazione
            $prossima_interazione = null;
        } else {
            //altrimenti si cambia
            $prossima_interazione = $tipo_voto;
        }
    } else {
        // altrimenti si inserisce
        $prossima_interazione = $tipo_voto;
    }

    // si elimina l'interazione precedente
    $sql_clean = "DELETE FROM interazioni 
                  WHERE id_utente = ? AND id_post = ? AND (tipo_interazione = 'like' OR tipo_interazione = 'dislike')";
    $stmt_clean = mysqli_prepare($conn, $sql_clean);
    mysqli_stmt_bind_param($stmt_clean, "ii", $id_utente, $id_post);
    mysqli_stmt_execute($stmt_clean);
    mysqli_stmt_close($stmt_clean);

    if ($prossima_interazione !== null) {
        // inserimento nuova interazione
        $sql_insert = "INSERT INTO interazioni (id_utente, id_post, tipo_interazione) VALUES (?, ?, ?)";
        $stmt_insert = mysqli_prepare($conn, $sql_insert);
        mysqli_stmt_bind_param($stmt_insert, "iis", $id_utente, $id_post, $prossima_interazione);
        mysqli_stmt_execute($stmt_insert);
        mysqli_stmt_close($stmt_insert);
    }

    // ranking finale
    $sql_ranking = "SELECT 
                        COALESCE(SUM(CASE WHEN tipo_interazione = 'like' THEN 1 ELSE 0 END), 0) - 
                        COALESCE(SUM(CASE WHEN tipo_interazione = 'dislike' THEN 1 ELSE 0 END), 0) AS nuovo_ranking
                    FROM interazioni WHERE id_post = ?";
    $stmt_ranking = mysqli_prepare($conn, $sql_ranking);
    mysqli_stmt_bind_param($stmt_ranking, "i", $id_post);
    mysqli_stmt_execute($stmt_ranking);
    $res_ranking = mysqli_stmt_get_result($stmt_ranking);
    $row_ranking = mysqli_fetch_assoc($res_ranking);
    $nuovo_ranking = (int)($row_ranking['nuovo_ranking'] ?? 0);
    mysqli_stmt_close($stmt_ranking);

    mysqli_commit($conn);

    echo json_encode([
        "status" => "OK",
        "nuovo_ranking" => $nuovo_ranking,
        "mia_interazione" => $prossima_interazione
    ]);

} catch (Exception $e) {
    mysqli_rollback($conn);
    echo json_encode(["error" => "Impossibile elaborare il voto sul database."]);
}

mysqli_close($conn);
exit();
?>