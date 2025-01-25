<?php
require_once "dbaccess.php";
require_once "admin_protected.php";

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['party_id'])) {
    $party_id = $_POST['party_id'];

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    // Cancello tutti gli ordini
    $orders_query = "DELETE FROM orders WHERE party_id = ?";
    if ($statement = mysqli_prepare($connection, $orders_query)) {
        mysqli_stmt_bind_param($statement, 'i', $party_id);
        if (!mysqli_stmt_execute($statement)) {
            echo "Errore nell'eliminazione dell'ordine: " . mysqli_error($connection);
        }
        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }
    
    // Cancello tutti gli articles_ordered
    $articles_ordered_query = "DELETE FROM articles_ordered WHERE party_id = ?";
    if ($statement = mysqli_prepare($connection, $articles_ordered_query)) {
        mysqli_stmt_bind_param($statement, 'i', $party_id);
        if (!mysqli_stmt_execute($statement)) {
            echo "Errore nell'eliminazione dell'ordine: " . mysqli_error($connection);
        }
        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }

    // Cancello il magazzino
    $articles_query = "DELETE FROM articles WHERE party_id = ?";
    if ($statement = mysqli_prepare($connection, $articles_query)) {
        mysqli_stmt_bind_param($statement, 'i', $party_id);
        if (!mysqli_stmt_execute($statement)) {
            echo "Errore nell'eliminazione dell'articolo: " . mysqli_error($connection);
        }
        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }

    // Rimuovo dalla festa i camerieri
    $update_query = "UPDATE users SET party_id = NULL WHERE party_id = ? AND role = 'waiter'";
    if ($update_statement = mysqli_prepare($connection, $update_query)) {
        mysqli_stmt_bind_param($update_statement, 'i', $party_id);
        mysqli_stmt_execute($update_statement);
        mysqli_stmt_close($update_statement);
    } else {
        die("Errore nella preparazione della query di aggiornamento: " . mysqli_error($connection));
    }

    // Elimino la festa
    $delete_query = "DELETE FROM parties WHERE id = ?";
    if ($delete_statement = mysqli_prepare($connection, $delete_query)) {
        mysqli_stmt_bind_param($delete_statement, 'i', $party_id);
        if (!mysqli_stmt_execute($delete_statement)) {
            echo "Errore durante la rimozione della festa: " . mysqli_error($connection);
        }
        mysqli_stmt_close($delete_statement);
    } else {
        die("Errore nella preparazione della query di eliminazione: " . mysqli_error($connection));
    }

    mysqli_close($connection);

    header("Location: index.php");
    exit();
}
?>
