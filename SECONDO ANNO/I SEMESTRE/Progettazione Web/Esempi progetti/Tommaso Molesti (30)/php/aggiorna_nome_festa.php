<?php
require_once "dbaccess.php";
require_once "admin_protected.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['party_id'])) {
    $party_id = intval($_POST['party_id']);
    $name = trim($_POST['name']);

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    // Aggiorno il nome della festa con quello nuovo
    $query = "UPDATE parties SET name = ? WHERE id = ?";
    if ($statement = mysqli_prepare($connection, $query)) {
        mysqli_stmt_bind_param($statement, 'si', $name, $party_id);
        if (mysqli_stmt_execute($statement)) {
            header("Location: impostazioni.php?party_id=" . $party_id);
            exit();
        } else {
            die("Errore nell'aggiornamento: " . mysqli_stmt_error($statement));
        }
        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }

    mysqli_close($connection);
} else {
    echo "<script>window.alert('La richiesta è in un formato non corretto')</script>";
}
?>
