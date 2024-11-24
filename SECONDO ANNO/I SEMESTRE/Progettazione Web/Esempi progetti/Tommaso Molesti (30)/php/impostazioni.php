<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Impostazioni</title>
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <link rel="stylesheet" href="../css/impostazioni.css">
    <script src="../js/impostazioni.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body onload="inizializza()">
    <header>
        <?php require_once "profile.php"; require_once "back_dashboard.php"; require_once "admin_protected.php"; ?>
        <div id="header-container">
            <h1>Impostazioni</h1>
        </div>
    </header>
    <main>
        <?php
        $party_id = $_GET["party_id"];
        require_once "dbaccess.php";
        
        $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
        if (mysqli_connect_errno()) {
            die(mysqli_connect_error());
        }

        // Recupero le informazioni della festa corrente
        $query = "SELECT name FROM parties WHERE id = ?";
        if ($statement = mysqli_prepare($connection, $query)) {
            mysqli_stmt_bind_param($statement, 'i', $party_id);
            mysqli_stmt_execute($statement);
            $result = mysqli_stmt_get_result($statement);

            if ($row = mysqli_fetch_assoc($result)) {
                echo "<form id='change-name' action='aggiorna_nome_festa.php' method='post'>";
                    echo "<input id='change-name-input' name='name' value='{$row['name']}' type='text' />";
                    echo "<input type='hidden' name='party_id' value='{$party_id}' />";
                    echo "<button id='change-name-btn' type='submit'>Aggiorna nome</button>";
                echo "</form>";
            }            

            mysqli_stmt_close($statement);
        } else {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }

        mysqli_close($connection);
        ?>

        <div id="pulsanti-container">
            <a href='magazzino.php?party_id=<?= $party_id ?>'>Magazzino</a>
            <a href='gestione_camerieri.php?party_id=<?= $party_id ?>'>Gestione camerieri</a>
            <a href='ordini.php?party_id=<?= $party_id ?>'>Ordini</a>
            <a id="terminate-party-btn" href='termina_festa.php?party_id=<?= $party_id ?>' onclick="handleMessage(event);">Termina festa</a>
            <a href='resoconto.php?party_id=<?= $party_id ?>'>Resoconto parziale</a>
            <a href='esaurimento_scorte.php?party_id=<?= $party_id ?>'>Esaurimento Scorte</a>
            <a href='ordinamento_articoli.php?party_id=<?= $party_id ?>'>Ordinamento articoli</a>
        </div>
    </main>
</body>
</html>
