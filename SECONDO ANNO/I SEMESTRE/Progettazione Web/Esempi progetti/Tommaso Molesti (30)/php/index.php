<?php
// Abilita il buffer di output per permettere reindirizzamenti come header("Location: dashboard_cameriere.php")
// senza causare errori di intestazioni già inviate, gestendo tutto l'output prima di inviarlo al client
ob_start();

require_once "check.php";
require_once "dbaccess.php";

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if (mysqli_connect_errno()) {
    die(mysqli_connect_error());
}

function displayAdminView($connection) {
    // Recupero tutte le feste create dall'utente admin
    $query = "SELECT * FROM parties WHERE user_id = ? ORDER BY created_at;";
    $user_id = $_SESSION["id"];
    echo "
    <div class='header-container'>
        <h1>Lista feste</h1>
    </div>
    ";

    if ($statement = mysqli_prepare($connection, $query)) {
        mysqli_stmt_bind_param($statement, 'i', $user_id);
        mysqli_stmt_execute($statement);
        $result = mysqli_stmt_get_result($statement);

        echo "<div id='lista-feste-container'>";
        if (mysqli_num_rows($result) === 0) {
            echo "Nessuna festa";
        } else {
            while ($row = mysqli_fetch_assoc($result)) {
                echo "<div class='festa-line'>";
                if(isset($row["ended"]) && $row["ended"] == 1) {
                    echo "<a class='festa-wrapper' href='resoconto.php?party_id=" . $row["id"] . "'>" . htmlspecialchars($row["name"]) . "</a>";
                } else {
                    echo "<a class='festa-wrapper' href='dashboard.php?party_id=" . $row["id"] . "'>" . htmlspecialchars($row["name"]) . "</a>";
                }
                
                echo "<form method='POST' action='eliminazione_festa.php' onsubmit='return confermaEliminazione();'>";
                echo "<input type='hidden' name='party_id' value='" . $row["id"] . "'>";
                echo "<button type='submit' class='delete-button'>";
                echo "<img class='delete-icon' src='../assets/delete.svg' alt='Pulsante di cancellazione' />";
                echo "</button>";
                echo "</form>";
                echo "</div>";
                
            }

            
        }
        echo "<a id='link-button' href='crea_festa.php'>";
        echo "<p id='link-text'>+ Crea nuova festa</p>";
        echo "</a>";
        echo "</div>";

        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }
}


function displayWaiterView($connection) {
    if (isset($_SESSION["party_id"])) {
        header("Location: dashboard_cameriere.php?party_id=" . $_SESSION["party_id"]);
        exit();
    } else {
        echo "
        <div class='header-container'>
            <h1>Entra in una festa</h1>
        </div>
        ";

        if (isset($_POST['enter_party']) && isset($_POST['waiters_code'])) {
            $waiters_code = $_POST['waiters_code'];

            // Recupero la festa che ha il waiters_code uguale a quello inserito dal cameriere
            $query = "SELECT * FROM parties WHERE waiters_code = ?";
            if ($statement = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement, 's', $waiters_code);
                mysqli_stmt_execute($statement);
                $result = mysqli_stmt_get_result($statement);

                if (mysqli_num_rows($result) > 0) {
                    $row = mysqli_fetch_assoc($result);
                    $party_id = $row['id'];

                    $waiter_id = $_SESSION['id'];
                    // Aggiorno users per associare il cameriere alla festa
                    $update_query = "UPDATE users SET party_id = ? WHERE id = ?";

                    if ($update_statement = mysqli_prepare($connection, $update_query)) {
                        mysqli_stmt_bind_param($update_statement, 'ii', $party_id, $waiter_id);
                        if (mysqli_stmt_execute($update_statement)) {
                            $_SESSION['party_id'] = $party_id;
                            header("Location: dashboard_cameriere.php?party_id=" . $party_id);
                            exit();
                        } else {
                            echo "Errore durante l'aggiornamento del party_id: " . mysqli_error($connection);
                        }
                        mysqli_stmt_close($update_statement);
                    } else {
                        die("Errore nella preparazione della query di aggiornamento: " . mysqli_error($connection));
                    }
                } else {
                    echo "Codice non valido. Riprova.";
                }

                mysqli_stmt_close($statement);
            } else {
                die("Errore nella preparazione della query: " . mysqli_error($connection));
            }
        }

        echo '
        <form action="index.php" method="post">
            <h3 for="waiters_code">Inserisci il codice della festa (8 caratteri):</h3>
            <input id="input-field" type="text" id="waiters_code" name="waiters_code" maxlength="8" required><br />
            <input id="join-btn" type="submit" value="Entra" name="enter_party">
        </form>';
    }
}

function displayHome() {
    echo "
        <a id='login-btn' href='login.php'>Area riservata</a>
        <div id='hero-section'>
            <h1>Benvenuto/a nel software di gestione cassa per la tua Sagra!</h1>
            <p>Organizza e gestisci la tua sagra con facilit&agrave;: monitora gli ordini, assegna compiti al personale e tieni traccia delle vendite.</p>
            <a href='../html/guida.html' id='guide-button'>Inizia da qui !</a>
        </div>
        <h2 id='features-title'>Funzionalit&agrave; principali</h2>
        <section id='features-section'>
            <div class='feature'>
                <img src='../assets/orders.svg' alt='Icona gestione ordini'>
                <h3>Gestione degli Ordini</h3>
                <p>Gestisci ogni ordine in modo preciso e veloce, con uno storico completo per una supervisione efficiente.</p>
            </div>
            <div class='feature'>
                <img src='../assets/realtime.svg' alt='Icona monitoraggio in tempo reale'>
                <h3>Monitoraggio in Tempo Reale</h3>
                <p>Visualizza gli ordini e il loro stato in tempo reale, per un'esperienza d'uso senza intoppi.</p>
            </div>
            <div class='feature'>
                <img src='../assets/team.svg' alt='Icona gestione team'>
                <h3>Gestione del Team</h3>
                <p>Assegna i compiti ai camerieri e organizza il personale con facilit&agrave;.</p>
            </div>
        </section>
        <footer id='main-footer'>
            <p>Progetto di Progettazione Web - Tommaso Molesti - Novembre 2024</p>
        </footer>
    ";
}
?>
<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Pagina Principale</title>
    <link rel="stylesheet" href="../css/index.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/index.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
<main>
<?php
    if (isset($_SESSION["role"]) && $_SESSION["role"] == "admin") {
        require_once "profile.php";
        displayAdminView($connection);
    } else if (isset($_SESSION["role"]) && $_SESSION["role"] == "waiter") {
        require_once "profile.php";
        displayWaiterView($connection);
    } else {
        displayHome();
    }

    mysqli_close($connection);
    ob_end_flush();
?>
</main>
</body>
</html>
