<?php
if(!isset($_GET['party_id'])) {
    header("location: index.php");
    exit();
}
require_once "dbaccess.php";
$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if (mysqli_connect_errno()) {
    die(mysqli_connect_error());
}
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['user_id']) && isset($_POST['party_id'])) {
    $user_id = intval($_POST['user_id']);
    $party_id = intval($_POST['party_id']);

    // Rimuovo il cameriere dalla festa
    $query = "UPDATE users SET party_id = NULL WHERE id = ?";
    if ($statement = mysqli_prepare($connection, $query)) {
        mysqli_stmt_bind_param($statement, 'i', $user_id);
        mysqli_stmt_execute($statement);

        if (mysqli_stmt_affected_rows($statement) > 0) {
            header("Location: gestione_camerieri.php?party_id=" . $party_id);
            exit();
        } else {
            echo "<p>Errore nella rimozione del cameriere</p>";
        }

        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }
}
?>
<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Gestione Camerieri</title>
    <link rel="stylesheet" href="../css/gestione_camerieri.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/gestione_camerieri.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; require_once "back_dashboard.php"; ?>
        <h1 id="title">Gestione Camerieri</h1>
    </header>
    <main>
        <?php
            require_once "check.php";
            require_once "admin_protected.php";
            require_once "dbaccess.php";

            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if(mysqli_connect_errno()) {
                die(mysqli_connect_error());
            }

            $party_id = intval($_GET['party_id']);

            // Prendo le info sulla festa corrente
            $query = "SELECT * FROM parties WHERE id = ?";
            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 'i', $party_id);
                mysqli_stmt_execute($statement);
                $result = mysqli_stmt_get_result($statement);

                if (mysqli_num_rows($result) === 0) {
                    echo "<p>Nessuna festa trovata</p>";
                } else {
                    $row = mysqli_fetch_assoc($result);
                    echo '<h3>' . 'Codice per camerieri: ' . htmlspecialchars($row["waiters_code"]) . '</h3>';
                }

                mysqli_stmt_close($statement);
            } else {
                die("Errore nella preparazione della query: " . mysqli_error($connection));
            }

            // Recupero la lista dei camerieri associati alla festa corrente
            $query = "SELECT * FROM users WHERE party_id = ? AND role='waiter';";
            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 'i', $party_id);
                mysqli_stmt_execute($statement);
                $result = mysqli_stmt_get_result($statement);

                if (mysqli_num_rows($result) === 0) {
                    echo "<p>Nessun cameriere</p>";
                } else {
                    echo '<table>';
                    echo '<thead><tr>
                            <th>Email</th>
                            <th>Ordini in corso</th>';
                    echo "<th>Azioni</th></tr></thead>";
                    echo '<tbody>';

                    while ($row = mysqli_fetch_assoc($result)) {
                        $waiter_id = $row['id'];
                        $pending_orders = false;

                        // Recupero le informazioni su eventuali ordini in corso del cameriere
                        $orders_query = "SELECT * FROM orders WHERE waiter_id = ? AND served_time IS NULL";
                        if ($orders_statement = mysqli_prepare($connection, $orders_query)) {
                            mysqli_stmt_bind_param($orders_statement, 'i', $waiter_id);
                            mysqli_stmt_execute($orders_statement);
                            $orders_result = mysqli_stmt_get_result($orders_statement);

                            if (mysqli_num_rows($orders_result) > 0) {
                                $pending_orders = true;
                            }
                            mysqli_stmt_close($orders_statement);
                        }

                        echo '<tr>';
                        echo '<td>' . htmlspecialchars($row["email"]) . '</td>';
                        echo '<td>' . ($pending_orders ? "Sì" : "No") . '</td>';
                        echo '<td>';

                        if (!$pending_orders) {
                            echo '
                                <form method="POST" action="" onsubmit="return confirmDelete();">
                                    <input type="hidden" name="user_id" value="' . $row['id'] . '">
                                    <input type="hidden" name="party_id" value="' . $party_id . '">
                                    <button class="delete-button" type="submit">
                                        <img class="delete-icon" src="../assets/delete.svg" alt="Elimina">
                                    </button>
                                </form>';
                        } else {
                            echo '<span>Ci sono ordini in corso</span>';
                        }

                        echo '</td>';
                        echo '</tr>';
                    }

                    echo '</tbody>';
                    echo '</table>';
                }

                mysqli_stmt_close($statement);
            } else {
                die("Errore nella preparazione della query: " . mysqli_error($connection));
            }

            mysqli_close($connection);
        ?>
    </main>
</body>
</html>
