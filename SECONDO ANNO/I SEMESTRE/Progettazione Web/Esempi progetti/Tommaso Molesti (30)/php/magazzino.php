<?php
if (!isset($_GET['party_id'])) {
    header("location: index.php");
    exit();
}
?>
<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Magazzino</title>
    <link rel="stylesheet" href="../css/magazzino.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/magazzino.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; ?>
        <h1 id="title">Magazzino</h1>
    </header>
    <main>
    <?php
        require_once "check.php";
        require_once "admin_protected.php";
        require_once "dbaccess.php";

        $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
        if (mysqli_connect_errno()) {
            die(mysqli_connect_error());
        }

        $party_id = intval($_GET['party_id']);

        // Recupero le informazioni sulla festa corrente
        $party_query = "SELECT ended FROM parties WHERE id = ?";
        if ($party_statement = mysqli_prepare($connection, $party_query)) {
            mysqli_stmt_bind_param($party_statement, 'i', $party_id);
            mysqli_stmt_execute($party_statement);
            $party_result = mysqli_stmt_get_result($party_statement);
            $party = mysqli_fetch_assoc($party_result);
            mysqli_stmt_close($party_statement);

            $is_ended = $party['ended'];
        } else {
            die("Errore nella preparazione della query per il party: " . mysqli_error($connection));
        }

        // Eliminazione articolo
        if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['article_id']) && isset($_POST['party_id'])) {
            $article_id = $_POST['article_id'];
            $party_id = $_POST['party_id'];

            if (mysqli_connect_errno()) {
                die("Errore di connessione al database: " . mysqli_connect_error());
            }

            // Recupero gli articoli di quel tipo già ordinati
            $check_query = "SELECT * FROM articles_ordered WHERE article_id = ?";
            if ($check_statement = mysqli_prepare($connection, $check_query)) {
                mysqli_stmt_bind_param($check_statement, 'i', $article_id);
                mysqli_stmt_execute($check_statement);
                $check_result = mysqli_stmt_get_result($check_statement);

                if (mysqli_num_rows($check_result) > 0) {
                    // Non li posso cancellare dalla tabella altrimenti perderei le info degli ordini già fatti con quell'articolo
                    // Lo nascondo e basta
                    $update_query = "UPDATE articles SET removed = true WHERE id = ?";
                    if ($update_statement = mysqli_prepare($connection, $update_query)) {
                        mysqli_stmt_bind_param($update_statement, 'i', $article_id);
                        mysqli_stmt_execute($update_statement);
                        mysqli_stmt_close($update_statement);
                    } else {
                        die("Errore nella preparazione della query di aggiornamento: " . mysqli_error($connection));
                    }
                } else {
                    // Non ci sono ordini con quell'articolo, allora lo posso proprio cancellare dalla tabella
                    $delete_query = "DELETE FROM articles WHERE id = ?";
                    if ($delete_statement = mysqli_prepare($connection, $delete_query)) {
                        mysqli_stmt_bind_param($delete_statement, 'i', $article_id);
                        mysqli_stmt_execute($delete_statement);
                        mysqli_stmt_close($delete_statement);
                    } else {
                        die("Errore nella preparazione della query di eliminazione: " . mysqli_error($connection));
                    }
                }

                mysqli_stmt_close($check_statement);
            } else {
                die("Errore nella preparazione della query per controllare gli articoli ordinati: " . mysqli_error($connection));
            }

            mysqli_close($connection);
            header("Location: magazzino.php?party_id=" . $party_id);
            exit();
        }

        // Recupero tutti gli articoli del magazzino della festa corrente non rimossi
        $query = "SELECT * FROM articles WHERE party_id = ? AND removed IS false ORDER BY sort_index ASC;";
        if ($statement = mysqli_prepare($connection, $query)) {
            mysqli_stmt_bind_param($statement, 'i', $party_id);
            mysqli_stmt_execute($statement);
            $result = mysqli_stmt_get_result($statement);

            if (mysqli_num_rows($result) === 0) {
                echo "Nessun articolo";
            } else {
                echo '<table>';
                echo '<thead><tr>
                    <th>Nome</th>
                    <th>Prezzo</th>
                    <th>Giacenza</th>';
                if (!$is_ended) {
                    require_once "back_dashboard.php";
                    echo "<td></td>";
                }  
                echo "</tr></thead>";
                echo '<tbody>';
                while ($row = mysqli_fetch_assoc($result)) {
                    echo '<tr>';
                    echo '<td>' . htmlspecialchars($row["name"]) . '</td>';
                    echo '<td>' . htmlspecialchars($row["price"]) . ' €</td>';
                    echo '<td>';
                    if(isset($row["tracking_quantity"]) && $row["tracking_quantity"] == true) {
                        echo htmlspecialchars($row["quantity"]);
                    } else {
                        echo "Non tracciata";
                    }
                    echo '</td>';
                    
                    if (!$is_ended) {
                        echo '<td>';
                        echo '
                        <a href="modifica_articolo.php?party_id=' . $party_id . '&article_id=' . $row["id"] . '">
                            <img src="../assets/edit.svg" alt="Modifica" width="20" height="20">
                        </a>
                        <form action="" method="post" onsubmit="return confirmDelete();">
                            <input type="hidden" name="article_id" value="' . $row["id"] . '">
                            <input type="hidden" name="party_id" value="' . $party_id . '">
                            <button class="delete-button" type="submit">
                                <img class="delete-icon" src="../assets/delete.svg" alt="Elimina">
                            </button>
                        </form>
                        ';
                        echo '</td>';
                    }

                    echo '</tr>';
                }
                echo '</tbody>';
                echo '</table>';
            }

            if (!$is_ended) {
                echo "<a id='link-button' href='crea_articolo.php?party_id=" . str_replace(" ", "%20", $party_id) . "'>";
                echo "<p id='link-text'>+ Crea articolo</p>";
                echo "</a>";
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
