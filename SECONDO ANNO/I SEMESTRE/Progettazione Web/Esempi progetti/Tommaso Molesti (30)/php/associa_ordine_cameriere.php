<?php
require_once "check.php";
require_once "dbaccess.php";

if (isset($_POST['order_ids']) && isset($_POST['party_id'])) {
    $order_ids = $_POST['order_ids'];
    $party_id = $_POST['party_id'];

    $waiter_id = $_SESSION['id'];

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if(mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    $current_time = date('Y-m-d H:i:s');

    mysqli_begin_transaction($connection);

    try {
        // Prendo tutti gli ordini che ha selezionato il cameriere e glieli associo
        foreach ($order_ids as $order_id) {
            $query = "UPDATE orders SET waiter_id = ?, waiter_handled_time = ? WHERE id = ?";

            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 'isi', $waiter_id, $current_time, $order_id);
                mysqli_stmt_execute($statement);

                if (mysqli_stmt_affected_rows($statement) <= 0) {
                    throw new Exception("Errore: impossibile aggiornare l'ordine con ID $order_id.");
                }

                mysqli_stmt_close($statement);
            } else {
                throw new Exception("Errore nella preparazione della query: " . mysqli_error($connection));
            }
        }

        mysqli_commit($connection);

        header("Location: dashboard_cameriere.php?party_id=$party_id");
    } catch (Exception $e) {
        mysqli_rollback($connection);
    }

    mysqli_close($connection);
} else {
    echo "<script>window.alert('La richiesta è in un formato non corretto')</script>";
}
?>
