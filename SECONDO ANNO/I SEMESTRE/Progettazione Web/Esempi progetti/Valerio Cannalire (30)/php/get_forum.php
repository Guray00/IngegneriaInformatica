<?php
require_once 'accesso_post.php';
require_once 'connessione.php';
header('Content-Type: application/json; charset=utf-8');

$id_utente = $_SESSION['id_utente'];
$risposta = [
    "iscritto" => [],
    "propri" => []
];

// forum a cui l'utente è iscritto
$query_iscritti = "SELECT f.id_forum, f.nome_forum, u.username AS creatore,
                    (f.id_creatore = ?) AS is_admin, true AS is_iscritto,
                    COUNT(DISTINCT i.id_utente) AS totale_iscritti, COUNT(DISTINCT p.id_post) AS totale_post
                  FROM forum f
                  JOIN iscrizioni_forum i_corrente ON f.id_forum = i_corrente.id_forum
                  JOIN utenti u ON f.id_creatore = u.id_utente
                  LEFT JOIN iscrizioni_forum i ON f.id_forum = i.id_forum
                  LEFT JOIN post p ON f.id_forum = p.id_forum
                  WHERE i_corrente.id_utente = ?
                  GROUP BY f.id_forum, u.username";

if ($stmt = mysqli_prepare($conn, $query_iscritti)) {
    mysqli_stmt_bind_param($stmt, "ii", $id_utente, $id_utente);
    // Sfruttiamo la funzione universale esterna
    $risposta["iscritto"] = estraiElenchiForumUniversale($stmt);
    mysqli_stmt_close($stmt);
}

// forum creati dall'utente
$query_propri = "SELECT f.id_forum, f.nome_forum, u.username AS creatore,
                    true AS is_admin, COUNT(DISTINCT i.id_utente) AS totale_iscritti, 
                    COUNT(DISTINCT p.id_post) AS totale_post, SUM(i.id_utente = ?) AS partecipa
                 FROM forum f
                 JOIN utenti u ON f.id_creatore = u.id_utente
                 LEFT JOIN iscrizioni_forum i ON f.id_forum = i.id_forum
                 LEFT JOIN post p ON f.id_forum = p.id_forum
                 WHERE f.id_creatore = ?
                 GROUP BY f.id_forum, u.username";

if ($stmt = mysqli_prepare($conn, $query_propri)) {
    mysqli_stmt_bind_param($stmt, "ii", $id_utente, $id_utente);
    // Sfruttiamo la stessa identica funzione universale esterna
    $risposta["propri"] = estraiElenchiForumUniversale($stmt);
    mysqli_stmt_close($stmt);
}

mysqli_close($conn);

$risposta['username_loggato'] = htmlspecialchars($_SESSION['username']);
echo json_encode($risposta);
exit();
?>