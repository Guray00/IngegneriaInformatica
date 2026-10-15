<?php
require_once 'accesso_post.php';
require_once 'connessione.php';

$id_utente = $_SESSION['id_utente'];
$stringa_ricerca = isset($_POST['chiave_ricerca']) ? trim($_POST['chiave_ricerca']) : '';
$risultati = [];

if ($stringa_ricerca !== '') {
    $query_ricerca = "SELECT f.id_forum, f.nome_forum, u.username AS creatore,
                        (f.id_creatore = ?) AS is_admin,
                        COUNT(DISTINCT i.id_utente) AS totale_iscritti, COUNT(DISTINCT p.id_post) AS totale_post,
                        SUM(i.id_utente = ?) AS partecipa
                      FROM forum f
                      JOIN utenti u ON f.id_creatore = u.id_utente
                      LEFT JOIN iscrizioni_forum i ON f.id_forum = i.id_forum
                      LEFT JOIN post p ON f.id_forum = p.id_forum
                      WHERE f.nome_forum LIKE ?
                      GROUP BY f.id_forum, u.username
                      LIMIT 20";

    if ($stmt = mysqli_prepare($conn, $query_ricerca)) {
        $param_ricerca = "%" . $stringa_ricerca . "%";
        mysqli_stmt_bind_param($stmt, "iis", $id_utente, $id_utente, $param_ricerca);
        
        $risultati = estraiElenchiForumUniversale($stmt);
        
        mysqli_stmt_close($stmt);
    }
}

mysqli_close($conn);

header('Content-Type: application/json; charset=utf-8');
echo json_encode($risultati);
exit();
?>