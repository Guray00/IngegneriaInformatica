<?php
require_once "check.php";
require_once "admin_protected.php";
require_once "dbaccess.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (is_array($data)) {
        $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
        if (mysqli_connect_errno()) {
            die(mysqli_connect_error());
        }

        $success = true;
        foreach ($data as $article) {
            $id = intval($article['id']);
            $sort_index = intval($article['sort_index']);

            // Aggiorno i sort_index degli articoli in base all'ordine nuovo
            $query = "UPDATE articles SET sort_index = ? WHERE id = ?";
            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 'ii', $sort_index, $id);
                if (!mysqli_stmt_execute($statement)) {
                    $success = false;
                }
                mysqli_stmt_close($statement);
            } else {
                $success = false;
            }
        }

        if ($success) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false]);
        }

        mysqli_close($connection);
    } else {
        echo json_encode(['success' => false]);
    }
} else {
    echo json_encode(['success' => false]);
}
?>
