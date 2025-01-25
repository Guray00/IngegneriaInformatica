<?php
// Abilita il buffer di output per permettere reindirizzamenti come header("Location: dashboard.php")
// senza causare errori di intestazioni già inviate, gestendo tutto l'output prima di inviarlo al client
ob_start();
if (!isset($_GET['party_id'])) {
    header("Location: index.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Dashboard Cameriere</title>
    <link rel="stylesheet" href="../css/dashboard_cameriere.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/dashboard_cameriere.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body onload="inizializza()">
<header>
    <h1>Ordini in gestione</h1>
</header>
<main>
<?php
    require_once "check.php";
    require_once "dbaccess.php";
    require_once "profile.php";

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['exit_party'])) {
        $waiter_id = $_POST['user_id'];
        $party_id = $_POST['party_id'];

        // Rimuove il cameriere dalla festa
        $query = "UPDATE users SET party_id = NULL WHERE id = ?";
        if ($statement = mysqli_prepare($connection, $query)) {
            mysqli_stmt_bind_param($statement, 'i', $waiter_id);
            mysqli_stmt_execute($statement);

            if (mysqli_stmt_affected_rows($statement) > 0) {
                $_SESSION["party_id"] = NULL;
                header("Location: index.php");
            }

            mysqli_stmt_close($statement);
        } else {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['fulfill_orders'])) {
        if (!empty($_POST['order_ids'])) {
            $orderIds = $_POST['order_ids'];
            $party_id = $_POST['party_id'];
            $waiter_id = $_POST['waiter_id'];
            
            // Evade gli ordini
            $query = "UPDATE orders SET served_time = NOW() WHERE id = ? AND waiter_id = ?";
            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 'ii', $order_id, $waiter_id);

                foreach ($orderIds as $order_id) {
                    mysqli_stmt_execute($statement);
                }

                mysqli_stmt_close($statement);

                header("Location: dashboard_cameriere.php?party_id=" . $party_id);
                exit();
            } else {
                echo "<p>Errore nella preparazione della query: " . mysqli_error($connection) . "</p>";
            }
        }
    }

    if (isset($_SESSION["role"]) && $_SESSION["role"] == "waiter") {
        $party_id = $_GET['party_id'];
        $waiter_id = $_SESSION["id"];

        // Recupera gli ordini che il cameriere ha in gestione
        $query = "SELECT * FROM orders WHERE party_id = ? AND waiter_id = ? AND served_time IS NULL;";
        if ($statement = mysqli_prepare($connection, $query)) {
            mysqli_stmt_bind_param($statement, 'ii', $party_id, $waiter_id);
            mysqli_stmt_execute($statement);
            $result = mysqli_stmt_get_result($statement);

            if (mysqli_num_rows($result) === 0) {
                echo '<form method="POST" action="" onsubmit="return confirm(\'Sei sicuro di voler uscire dalla festa?\');">';
                echo '<input type="hidden" name="user_id" value="' . $waiter_id . '">';
                echo '<input type="hidden" name="party_id" value="' . $party_id . '">';
                echo '<button class="classic-btn" type="submit" name="exit_party">Esci dalla festa</button>';
                echo '</form>';
                echo "<p id='no-order-text'>Nessun ordine in gestione</p>";
            } else {
                echo '<form method="POST" action="">';
                echo '<input type="hidden" name="party_id" value="' . $party_id . '">';
                echo '<input type="hidden" name="waiter_id" value="' . $waiter_id . '">';
                echo '<button id="submit-btn" class="classic-btn" type="submit" name="fulfill_orders" disabled>Evadi ordini</button>';
                echo '<div class="table-container">';
                echo '<table>';
                echo '<thead><tr>
                    <th>Seleziona</th>
                    <th>Nome</th>
                    <th>Orario</th>
                    <th>Azioni</th>
                <tr></thead>';
                echo '<tbody>';
                while ($row = mysqli_fetch_assoc($result)) {
                    echo '<tr>';
                    echo '<td><input type="checkbox" name="order_ids[]" value="' . $row["id"] . '" class="order-checkbox"></td>';
                    echo '<td>' . $row["name"] . '</td>';
                    echo '<td>' . $row["ordered_time"] . '</td>';
                    echo '<td>';
                    echo '<a href="dettagli_ordine.php?party_id=' . $party_id . '&order_id=' . $row["id"] . '">';
                    echo '<img src="../assets/details.svg" alt="Dettagli" width="20" height="20">';
                    echo '</a>';
                    echo '</td>';
                    echo '</tr>';
                }
                echo '</tbody>';
                echo '</table>';
                echo '</div>';
                
                echo '</form>';
            }

            
            mysqli_stmt_close($statement);
        } else {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        
        $type = "not_handled";
        
        echo "<a id='new-order-button' href='ordini.php?party_id=" . str_replace(" ", "%20", $party_id) . "&type=" . str_replace(" ", "%20", $type) . "'>";
        echo "<p id='new-order-text'>+ Gestisci nuovi ordini</p>";
        echo "</a>";
    } else {
        header("Location: index.php");
        exit();
    }

    mysqli_close($connection);
    ob_end_flush();
?>
</main>
</body>
</html>
