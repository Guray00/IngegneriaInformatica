<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Esaurimento Scorte</title>
    <link rel="stylesheet" href="../css/esaurimento_scorte.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/esaurimento_scorte.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; require_once "back_dashboard.php"; require_once "admin_protected.php"; ?>
        <h1 id="title">Esaurimento Scorte</h1>
    </header>
    <main>
    <?php
        $party_id = $_GET["party_id"];
        require_once "dbaccess.php";

        $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
        if (mysqli_connect_errno()) {
            die(mysqli_connect_error());
        }

        // Prendo solo gli articoli della festa corrente che hanno la quantità tracciata e < 20 
        $query = "SELECT name, quantity FROM articles WHERE party_id = ? AND quantity < 20 AND tracking_quantity = 1 ORDER BY quantity ASC";
        if ($statement = mysqli_prepare($connection, $query)) {
            mysqli_stmt_bind_param($statement, 'i', $party_id);
            mysqli_stmt_execute($statement);
            $result = mysqli_stmt_get_result($statement);

            if (mysqli_num_rows($result) > 0) {
                echo '<table>';
                echo '<thead><tr><th>Articolo</th><th>Quantit&agrave; rimanente</th></tr></thead>';
                echo '<tbody>';

                while ($row = mysqli_fetch_assoc($result)) {
                    echo '<tr>';
                    echo '<td>' . htmlspecialchars($row["name"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["quantity"]) . '</td>';
                    echo '</tr>';
                }

                echo '</tbody>';
                echo '</table>';
            } else {
                echo "<p>Nessun articolo in esaurimento.</p>";
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
