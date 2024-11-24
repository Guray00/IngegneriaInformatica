<?php
require_once "check.php";
require_once "dbaccess.php";


if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["order_id"]) && isset($_POST["party_id"])) {
    $order_id = $_POST["order_id"];
    $party_id = $_POST["party_id"];

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    // Recupero i dati in articles_ordered relativi all'ordine che voglio eliminare
    $query_articles_ordered = "SELECT article_id, quantity FROM articles_ordered WHERE order_id = ?";
    if ($statement_articles_ordered = mysqli_prepare($connection, $query_articles_ordered)) {
        mysqli_stmt_bind_param($statement_articles_ordered, 'i', $order_id);
        mysqli_stmt_execute($statement_articles_ordered);
        $result_articles_ordered = mysqli_stmt_get_result($statement_articles_ordered);

        while ($row = mysqli_fetch_assoc($result_articles_ordered)) {
            $article_id = $row['article_id'];
            $ordered_quantity = $row['quantity'];

            // Aggiungo di nuovo le quantità al magazzino
            $query_update_articles = "UPDATE articles SET quantity = quantity + ? WHERE id = ?";
            if ($statement_update_articles = mysqli_prepare($connection, $query_update_articles)) {
                mysqli_stmt_bind_param($statement_update_articles, 'ii', $ordered_quantity, $article_id);
                mysqli_stmt_execute($statement_update_articles);
                mysqli_stmt_close($statement_update_articles);
            } else {
                die("Errore nella preparazione della query di aggiornamento degli articoli: " . mysqli_error($connection));
            }
        }

        mysqli_stmt_close($statement_articles_ordered);
    } else {
        die("Errore nella preparazione della query per ottenere gli articoli ordinati: " . mysqli_error($connection));
    }

    // Cancello i dati da articles_ordered
    $query_delete_articles_ordered = "DELETE FROM articles_ordered WHERE order_id = ?";
    if ($statement_delete_articles_ordered = mysqli_prepare($connection, $query_delete_articles_ordered)) {
        mysqli_stmt_bind_param($statement_delete_articles_ordered, 'i', $order_id);
        mysqli_stmt_execute($statement_delete_articles_ordered);
        mysqli_stmt_close($statement_delete_articles_ordered);
    } else {
        die("Errore nella preparazione della query per eliminare articles_ordered: " . mysqli_error($connection));
    }

    // Elimino effettivamente l'ordine
    $query_delete_order = "DELETE FROM orders WHERE id = ?";
    if ($statement_delete_order = mysqli_prepare($connection, $query_delete_order)) {
        mysqli_stmt_bind_param($statement_delete_order, 'i', $order_id);
        if (mysqli_stmt_execute($statement_delete_order)) {
            echo "Ordine eliminato con successo.";
        } else {
            echo "Errore nell'eliminazione dell'ordine: " . mysqli_error($connection);
        }
        mysqli_stmt_close($statement_delete_order);
    } else {
        die("Errore nella preparazione della query per eliminare l'ordine: " . mysqli_error($connection));
    }

    mysqli_close($connection);
    
    header("Location: ordini.php?party_id=" . $party_id);
    exit;
} else {
    echo "<script>window.alert('La richiesta è in un formato non corretto')</script>";
}
?>
