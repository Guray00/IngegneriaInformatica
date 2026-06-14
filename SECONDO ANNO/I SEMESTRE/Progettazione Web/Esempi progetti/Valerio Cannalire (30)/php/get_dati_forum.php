<?php
require_once 'accesso_post.php';
require_once 'connessione.php'; 
require_once 'verifica_status.php';
header('Content-Type: application/json; charset=utf-8');

$id_utente_corrente = (int)$_SESSION['id_utente'];

$input = json_decode(file_get_contents("php://input"), true);
$id_forum = isset($_POST['id_forum']) ? (int)$_POST['id_forum'] : (isset($input['id_forum']) ? (int)$input['id_forum'] : 0);

if ($id_forum <= 0) {
    echo json_encode(['error' => 'ID Forum mancante o non valido']);
    mysqli_close($conn);
    exit();
}

// Si verifica l'esistenza del forum e si recuperano le informazioni testuali di intestazione
$sql_info = "SELECT f.nome_forum, u.username, f.id_creatore 
             FROM forum f 
             JOIN utenti u ON f.id_creatore = u.id_utente 
             WHERE f.id_forum = ?";
$stmt_info = mysqli_prepare($conn, $sql_info);
mysqli_stmt_bind_param($stmt_info, "i", $id_forum);
mysqli_stmt_execute($stmt_info);
$forum_info = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt_info));
mysqli_stmt_close($stmt_info);

if (!$forum_info) {
    echo json_encode(['error' => 'Forum inesistente']);
    mysqli_close($conn);
    exit();
}

$risposta = [];
$risposta['nome_admin'] = htmlspecialchars($forum_info['username']); 
$risposta['nome_forum'] = htmlspecialchars($forum_info['nome_forum']); 

// status utente
$is_admin_corrente = ((int)$forum_info['id_creatore'] === $id_utente_corrente);
$risposta['is_admin'] = $is_admin_corrente;
$risposta['is_iscritto'] = isIscritto($conn, $id_utente_corrente, $id_forum);

// conteggio Iscritti
$sql_count_iscritti = "SELECT COUNT(*) as totale FROM iscrizioni_forum WHERE id_forum = ?";
$stmt_iscritti = mysqli_prepare($conn, $sql_count_iscritti);
mysqli_stmt_bind_param($stmt_iscritti, "i", $id_forum);
mysqli_stmt_execute($stmt_iscritti);
$risposta['totale_iscritti'] = (int)mysqli_fetch_assoc(mysqli_stmt_get_result($stmt_iscritti))['totale'];
mysqli_stmt_close($stmt_iscritti);

// Conteggio post totali non bannati
$sql_count_post = "SELECT COUNT(DISTINCT p.id_post) as totale 
                   FROM post p 
                   LEFT JOIN interazioni i ON p.id_post = i.id_post AND i.tipo_interazione = 'segnala'
                   WHERE p.id_forum = ?
                   GROUP BY p.id_forum
                   HAVING COUNT(i.id_utente) < 5";
$stmt_post_count = mysqli_prepare($conn, $sql_count_post);
mysqli_stmt_bind_param($stmt_post_count, "i", $id_forum);
mysqli_stmt_execute($stmt_post_count);
$res_post_count = mysqli_stmt_get_result($stmt_post_count);
$risposta['totale_post'] = ($row_post = mysqli_fetch_assoc($res_post_count)) ? (int)$row_post['totale'] : 0;
mysqli_stmt_close($stmt_post_count);

// Elenco topic
$sql_topic = "SELECT id_topic, titolo_topic FROM topic WHERE id_forum = ?";
$stmt_topic = mysqli_prepare($conn, $sql_topic);
mysqli_stmt_bind_param($stmt_topic, "i", $id_forum);
mysqli_stmt_execute($stmt_topic);
$res_topic = mysqli_stmt_get_result($stmt_topic);
$risposta['topics'] = [];
while ($row_t = mysqli_fetch_assoc($res_topic)) {
    $risposta['topics'][] = [
        'id_topic' => (int)$row_t['id_topic'],
        'titolo_topic' => htmlspecialchars($row_t['titolo_topic'])
    ];
}
mysqli_stmt_close($stmt_topic);

// lista post e gestione condizionale post segnalati 5 volte
$clausola_having = $is_admin_corrente ? "" : " HAVING COUNT(DISTINCT CASE WHEN i.tipo_interazione = 'segnala' THEN i.id_utente END) < 5 ";

$sql_posts_list = "SELECT
                    p.id_post,
                    p.titolo,
                    p.contenuto,
                    p.data_pubblicazione,
                    p.modificato,
                    u.username AS autore,
                    COUNT(DISTINCT CASE WHEN i.tipo_interazione = 'like' THEN i.id_utente END) AS cont_like,
                    COUNT(DISTINCT CASE WHEN i.tipo_interazione = 'dislike' THEN i.id_utente END) AS cont_dislike,
                    COUNT(DISTINCT CASE WHEN i.tipo_interazione = 'segnala' THEN i.id_utente END) AS cont_segnala,
                    (COUNT(DISTINCT CASE WHEN i.tipo_interazione = 'like' THEN i.id_utente END) -
                    COUNT(DISTINCT CASE WHEN i.tipo_interazione = 'dislike' THEN i.id_utente END)) AS ranking,
                    GROUP_CONCAT(DISTINCT t.titolo_topic) AS tag_associati,
                    MAX(CASE WHEN i.id_utente = ? AND i.tipo_interazione IN ('like', 'dislike') THEN i.tipo_interazione END) AS interazione_utente,
                    MAX(CASE WHEN i.id_utente = ? AND i.tipo_interazione = 'segnala' THEN 1 ELSE 0 END) AS segnalato
                  FROM post p
                  JOIN utenti u ON p.id_utente = u.id_utente
                  LEFT JOIN interazioni i ON p.id_post = i.id_post
                  LEFT JOIN topic_post tp ON p.id_post = tp.id_post
                  LEFT JOIN topic t ON tp.id_topic = t.id_topic
                  WHERE p.id_forum = ?
                  GROUP BY p.id_post, p.titolo, p.contenuto, p.data_pubblicazione, p.modificato, u.username
                  $clausola_having
                  ORDER BY ranking DESC, p.data_pubblicazione DESC
                  LIMIT 100";

$stmt_posts = mysqli_prepare($conn, $sql_posts_list);
mysqli_stmt_bind_param($stmt_posts, "iii", $id_utente_corrente, $id_utente_corrente, $id_forum);
mysqli_stmt_execute($stmt_posts);
$res_posts = mysqli_stmt_get_result($stmt_posts);
$risposta['posts'] = [];
while ($row_p = mysqli_fetch_assoc($res_posts)) {
    $tags_array = [];
    if (!empty($row_p['tag_associati'])) {
        foreach (explode(',', $row_p['tag_associati']) as $singolo_tag) {
            $tags_array[] = htmlspecialchars(trim($singolo_tag));
        }
    }

    $risposta['posts'][] = [
        'id_post' => (int)$row_p['id_post'],
        'autore' => htmlspecialchars($row_p['autore']),
        'titolo' => htmlspecialchars($row_p['titolo']),
        'contenuto' => htmlspecialchars($row_p['contenuto']),
        'data' => $row_p['data_pubblicazione'],
        'modificato' => (int)$row_p['modificato'],
        'likes' => (int)$row_p['cont_like'],
        'dislikes' => (int)$row_p['cont_dislike'],
        'segnalato_da_me' => (int)$row_p['segnalato'],
        'segnalazioni' => (int)$row_p['cont_segnala'],
        'ranking' => (int)$row_p['ranking'],
        'tags' => $tags_array,
        'mia_interazione' => $row_p['interazione_utente']
    ];
}
mysqli_stmt_close($stmt_posts);
mysqli_close($conn);
$risposta['username_loggato'] = htmlspecialchars($_SESSION['username']);
echo json_encode($risposta);
exit();
?>