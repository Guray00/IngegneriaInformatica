<?php
require_once "dbaccess.php";
require_once "admin_protected.php";

if (isset($_GET["party_id"])) {
    $party_id = $_GET["party_id"];

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die("Errore di connessione al database: " . mysqli_connect_error());
    }

    // Rimuovo tutti i camerieri
    $query_update_waiters = "UPDATE users SET party_id = NULL WHERE party_id = ? AND role = 'waiter'";
    if ($statement_update_waiters = mysqli_prepare($connection, $query_update_waiters)) {
        mysqli_stmt_bind_param($statement_update_waiters, 'i', $party_id);
        if (mysqli_stmt_execute($statement_update_waiters)) {
            echo "Camerieri deassociati dalla festa con successo.<br>";
        } else {
            echo "Errore durante la deassociazione dei camerieri: " . mysqli_error($connection) . "<br>";
        }
        mysqli_stmt_close($statement_update_waiters);
    } else {
        die("Errore nella preparazione della query per deassociare i camerieri: " . mysqli_error($connection));
    }

    // Setto la festa come terminata
    $query_end_party = "UPDATE parties SET ended = true WHERE id = ?";
    if ($statement_end_party = mysqli_prepare($connection, $query_end_party)) {
        mysqli_stmt_bind_param($statement_end_party, 'i', $party_id);
        if (mysqli_stmt_execute($statement_end_party)) {
            echo "Festa terminata con successo.";
        } else {
            echo "Errore durante l'aggiornamento dello stato della festa: " . mysqli_error($connection);
        }
        mysqli_stmt_close($statement_end_party);
    } else {
        die("Errore nella preparazione della query per terminare la festa: " . mysqli_error($connection));
    }

    mysqli_close($connection);

    header("Location: index.php");
    exit();
} else {
    echo "<script>window.alert('La richiesta è in un formato non corretto')</script>";
}
?>
