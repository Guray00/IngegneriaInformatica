<?php
//gestisce la connessione col database

// Credenziali di default obbligatorie da specifiche del corso
define('DB_HOST', 'localhost');
define('DB_NAME', 'cannalire_635881');
define('DB_USER', 'root');
define('DB_PWD', '');

$conn = mysqli_connect(DB_HOST, DB_USER, DB_PWD, DB_NAME);
if (!$conn) {
    die("Si è verificato un errore tecnico temporaneo. Riprova più tardi. Errore: " . mysqli_connect_error());
}

mysqli_set_charset($conn, "utf8mb4");

//funzione di utilità usata in cerca_forum e in get_forum
function estraiElenchiForumUniversale($stmt) {
    $risultati = [];
    
    mysqli_stmt_execute($stmt);
    $res = mysqli_stmt_get_result($stmt);
    
    while ($row = mysqli_fetch_assoc($res)) {
        $risultati[] = [
            "id_forum"        => (int)$row["id_forum"],
            "nome_forum"      => htmlspecialchars($row["nome_forum"]),
            "creatore"        => htmlspecialchars($row["creatore"]),
            "is_admin"        => (bool)$row["is_admin"],
            // Gestisce sia il campo 'is_iscritto' (da get_forum) sia il campo 'partecipa' (da cerca_forum)
            "is_iscritto"     => isset($row["partecipa"]) ? $row["partecipa"] > 0 : (bool)$row["is_iscritto"],
            "totale_iscritti" => (int)$row["totale_iscritti"],
            "totale_post"     => (int)$row["totale_post"]
        ];
    }
    
    return $risultati;
}
?>