<?php
if (!isset($_GET['party_id'])) {
    header("location: index.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <title>Ordinamento Articoli</title>
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <link rel="stylesheet" href="../css/ordinamento_articoli.css">
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
    <script src="../js/ordinamento_articoli.js"></script>
    <script>
        let articoli = <?php
            require_once "dbaccess.php";

            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if (mysqli_connect_errno()) {
                die(mysqli_connect_error());
            }

            $party_id = intval($_GET['party_id']);
            // Prendo tutti gli articoli non rimossi della festa corrente
            $query = "SELECT id, name, sort_index FROM articles WHERE party_id = ? AND removed IS false ORDER BY sort_index ASC;";
            
            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 'i', $party_id);
                mysqli_stmt_execute($statement);
                $result = mysqli_stmt_get_result($statement);
                
                if (mysqli_num_rows($result) === 0) {
                    echo "[]";
                } else {
                    $articles = mysqli_fetch_all($result, MYSQLI_ASSOC);
                    echo json_encode($articles);
                }
                mysqli_stmt_close($statement);
            } else {
                die("Errore nella preparazione della query: " . mysqli_error($connection));
            }
        ?>;
    </script>
</head>
<body onload="buildTable()">
    <header>
        <?php
            require_once "check.php";
            require_once "profile.php";
            require_once "back_dashboard.php";
            require_once "admin_protected.php";
        ?>
        <div id="header-container">
            <h1>Ordinamento Articoli</h1>
        </div>
    </header>
    <main>
        <table id="article-table"></table>
        <button id="save-btn" disabled onclick="saveOrder()">Salva ordine</button>
    </main>
</body>
</html>
