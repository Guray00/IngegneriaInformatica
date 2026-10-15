<?php
require_once 'accesso_post.php';
require_once 'connessione.php';
header('Content-Type: application/json; charset=UTF-8');

$id_utente_loggato = (int)$_SESSION['id_utente'];
$username_loggato = $_SESSION['username'];

// utente nell'URL o utente corrente
$username_target = isset($_POST['username_profilo']) ? trim($_POST['username_profilo']) : '';
if (empty($username_target)) {
    //utente corrente
    $username_target = $username_loggato;
    $id_utente_target = $id_utente_loggato;
    $is_profilo_proprio = true;
} else {
    //profilo di un altro utente, recupero id
    $is_profilo_proprio = ($username_target === $username_loggato);
    
    $sql_cerca = "SELECT id_utente FROM utenti WHERE username = ?";
    $stmt_cerca = mysqli_prepare($conn, $sql_cerca);
    mysqli_stmt_bind_param($stmt_cerca, "s", $username_target);
    mysqli_stmt_execute($stmt_cerca);
    $res_cerca = mysqli_stmt_get_result($stmt_cerca);
    
    if ($riga_utente = mysqli_fetch_assoc($res_cerca)) {
        $id_utente_target = (int)$riga_utente['id_utente'];
    } else {
        echo json_encode(['error' => 'Utente inesistente.']);
        mysqli_stmt_close($stmt_cerca);
        mysqli_close($conn);
        exit();
    }
    mysqli_stmt_close($stmt_cerca);
}

// numero di post pubblicati dall'utente target
$sql_post = "SELECT COUNT(*) AS totale_post FROM post WHERE id_utente = ?";
$stmt_post = mysqli_prepare($conn, $sql_post);
mysqli_stmt_bind_param($stmt_post, "i", $id_utente_target);
mysqli_stmt_execute($stmt_post);
$res_post = mysqli_stmt_get_result($stmt_post);
$riga_post = mysqli_fetch_assoc($res_post);
$totale_post = (int)$riga_post['totale_post'];
mysqli_stmt_close($stmt_post);

// bilancio complessivo tra like e dislike ricevuti
$sql_bilancio = "SELECT 
                    COUNT(CASE WHEN i.tipo_interazione = 'like' THEN 1 END) - 
                    COUNT(CASE WHEN i.tipo_interazione = 'dislike' THEN 1 END) AS bilancio_voti
                 FROM post p
                 JOIN interazioni i ON p.id_post = i.id_post
                 WHERE p.id_utente = ?";
$stmt_bilancio = mysqli_prepare($conn, $sql_bilancio);
mysqli_stmt_bind_param($stmt_bilancio, "i", $id_utente_target);
mysqli_stmt_execute($stmt_bilancio);
$res_bilancio = mysqli_stmt_get_result($stmt_bilancio);
$riga_bilancio = mysqli_fetch_assoc($res_bilancio);
$bilancio_voti = (int)$riga_bilancio['bilancio_voti'];
mysqli_stmt_close($stmt_bilancio);

// numero di forum a cui l'utente target è iscritto
$sql_forum = "SELECT COUNT(*) AS totale_iscrizioni FROM iscrizioni_forum WHERE id_utente = ?";
$stmt_forum = mysqli_prepare($conn, $sql_forum);
mysqli_stmt_bind_param($stmt_forum, "i", $id_utente_target);
mysqli_stmt_execute($stmt_forum);
$res_forum = mysqli_stmt_get_result($stmt_forum);
$riga_forum = mysqli_fetch_assoc($res_forum);
$totale_iscrizioni = (int)$riga_forum['totale_iscrizioni'];
mysqli_stmt_close($stmt_forum);

mysqli_close($conn);

echo json_encode([
    'is_proprio' => $is_profilo_proprio,
    'username_target' => $username_target,
    'username_loggato' => $username_loggato,
    'statistiche' => [
        'post_pubblicati' => $totale_post,
        'bilancio_valutazioni' => $bilancio_voti,
        'forum_iscritti' => $totale_iscrizioni
    ]
]);
exit();
?>