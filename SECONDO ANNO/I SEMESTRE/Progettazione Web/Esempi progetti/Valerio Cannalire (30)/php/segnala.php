<?php
require_once 'accesso_post.php';
require_once 'connessione.php';
require_once "verifica_status.php";
header('Content-Type: application/json; charset=utf-8');

$id_utente = (int)$_SESSION['id_utente'];

if (!isset($_POST['id_post'])) {
    echo json_encode(["error" => "ID del post mancante."]);
    mysqli_close($conn);
    exit();
}

$id_post = (int)$_POST['id_post'];

verificaIscrizionePost($conn, $id_utente, $id_post, true);

mysqli_begin_transaction($conn);
try {
    // si vede se fosse presente una segnalazione nel DB: se presente eliminazione, altrimenti inserimento
    $sql_check = "SELECT tipo_interazione FROM interazioni 
                  WHERE id_utente = ? AND id_post = ? AND tipo_interazione = 'segnala'";
    $stmt_check = mysqli_prepare($conn, $sql_check);
    mysqli_stmt_bind_param($stmt_check, "ii", $id_utente, $id_post);
    mysqli_stmt_execute($stmt_check);
    $res_check = mysqli_stmt_get_result($stmt_check);
    $segnalazione_esistente = mysqli_fetch_assoc($res_check);
    mysqli_stmt_close($stmt_check);

    $prossimo_stato = null;

    if ($segnalazione_esistente) {
        // si elimina la segnalazione presente nel DB
        $sql_delete = "DELETE FROM interazioni WHERE id_utente = ? AND id_post = ? AND tipo_interazione = 'segnala'";
        $stmt_delete = mysqli_prepare($conn, $sql_delete);
        mysqli_stmt_bind_param($stmt_delete, "ii", $id_utente, $id_post);
        mysqli_stmt_execute($stmt_delete);
        mysqli_stmt_close($stmt_delete);
        $prossimo_stato = null; 
    } else {
        /*se durante la sessione di un utente che aveva segnalato un post l'admin ripristinasse le segnalazioni, l'utente 
        continuerebbe a vedere il post come segnalato da lui. Se rimuovesse il post il numero di segnalazioni diventerebbe negativo.
        Quindi si verifica cosa l'utente veda nella sua interfaccia.
        */
        $stato_visivo_client = isset($_POST['stato_corrente_client']) ? $_POST['stato_corrente_client'] : '';

        if ($stato_visivo_client === 'attivo') {
            //non si fa nulla
            $prossimo_stato = null;
        } else {
            // si inserisce la nuova segnalazione
            $sql_insert = "INSERT INTO interazioni (id_utente, id_post, tipo_interazione) VALUES (?, ?, 'segnala')";
            $stmt_insert = mysqli_prepare($conn, $sql_insert);
            mysqli_stmt_bind_param($stmt_insert, "ii", $id_utente, $id_post);
            mysqli_stmt_execute($stmt_insert);
            mysqli_stmt_close($stmt_insert);
            $prossimo_stato = "segnala"; 
        }
    }

    $sql_count = "SELECT COUNT(DISTINCT id_utente) AS totale_segnalazioni FROM interazioni 
                  WHERE id_post = ? AND tipo_interazione = 'segnala'";
    $stmt_count = mysqli_prepare($conn, $sql_count);
    mysqli_stmt_bind_param($stmt_count, "i", $id_post);
    mysqli_stmt_execute($stmt_count);
    $res_count = mysqli_stmt_get_result($stmt_count);
    $row_count = mysqli_fetch_assoc($res_count);
    $totale_segnalazioni = (int)$row_count['totale_segnalazioni'];
    mysqli_stmt_close($stmt_count);

    mysqli_commit($conn);

    echo json_encode([
        "status" => "OK",
        "mia_interazione" => $prossimo_stato,
        "totale_segnalazioni" => $totale_segnalazioni
    ]);

} catch (Exception $e) {
    mysqli_rollback($conn);
    echo json_encode(["error" => "Impossibile elaborare la segnalazione sul database."]);
}

mysqli_close($conn);
exit();
?>