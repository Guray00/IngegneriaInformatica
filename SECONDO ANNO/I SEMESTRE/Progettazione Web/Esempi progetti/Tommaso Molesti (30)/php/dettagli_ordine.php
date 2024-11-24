<?php
    if(!isset($_GET['party_id']) || !isset($_GET['order_id']))
        header("location: index.php");
?>
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            Dettagli ordine
        </title>
        <link rel="stylesheet" href="../css/dettagli_ordine.css">
        <link rel="icon" href="../assets/favicon.ico" type="image/ico">
        <meta charset="UTF-8">
        <meta name="author" content="Tommaso Molesti">
        <meta name="description" content="Un software di gestione cassa per la tua sagra">
    </head>
    <body>
        <header>
            <h1 id="title">Dettagli ordine</h1>
        </header>
        <main>
        <?php
            require_once "check.php";
            require_once "dbaccess.php";
            require_once "profile.php";
            require_once "back_dashboard.php";

            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if(mysqli_connect_errno()) {
                die(mysqli_connect_error());
            }

            $party_id = $_GET['party_id'];
            $order_id = $_GET['order_id'];
            
            // Recupero i dati dell'ordine
            $query = "SELECT * FROM orders WHERE party_id = ? AND id = ?;";
            
            // Recupero per ogni articolo nell'ordine : il nome, prezzo e la quantità
            $query2 = "
                SELECT A.name, A.price, AO.quantity
                FROM orders O
                INNER JOIN articles_ordered AO ON O.id = AO.order_id
                INNER JOIN articles A ON A.id = AO.article_id
                WHERE O.party_id = ? AND O.id = ?
                ORDER BY A.sort_index ASC;
            ";


            if($statement1 = mysqli_prepare($connection, $query)) {
                mysqli_stmt_bind_param($statement1, 'ii', $party_id, $order_id);
                mysqli_stmt_execute($statement1);
                $result = mysqli_stmt_get_result($statement1);

                if(mysqli_num_rows($result) === 0) {
                    echo "Nessun ordine trovato.";
                } else {
                    $row = mysqli_fetch_assoc($result);
                    echo '<h3>Nome : ' . htmlspecialchars($row["name"]) . '</h3>';
                }

                if($statement2 = mysqli_prepare($connection, $query2)) {
                    mysqli_stmt_bind_param($statement2, 'ii', $party_id, $order_id);
                    mysqli_stmt_execute($statement2);
                    $result = mysqli_stmt_get_result($statement2);
    
                    if(mysqli_num_rows($result) === 0) {
                        echo "Nessun articolo trovato.";
                    } else {
                        $total_order = 0;
                        echo '<table>';
                        echo '<thead><tr>
                            <th>Articolo</th>
                            <th>Prezzo Unitario (€)</th>
                            <th>Quantit&agrave; ordinata</th>
                            <th>Totale (€)</th>
                        <tr></thead>';
                        echo '<tbody>';
                        while($row = mysqli_fetch_assoc($result)) {
                            $article_total = $row["price"] * $row["quantity"];
                            $total_order += $article_total;
                            
                            echo '<tr>';
                            echo '<td>' . htmlspecialchars($row["name"]) . '</td>';
                            echo '<td>' . number_format($row["price"], 2) . '</td>';
                            echo '<td>' . htmlspecialchars($row["quantity"]) . '</td>';
                            echo '<td>' . number_format($article_total, 2) . '</td>';
                            echo '</tr>';
                        }
                        echo '</tbody>';
                        echo '</table>';

                        echo '<h3>Totale : €' . number_format($total_order, 2) . '</h3>';

                        // Recupero la mail del cameriere e il tempo che ci ha messo per servire l'ordine
                        $query3 = "
                            SELECT W.email, O.waiter_handled_time, O.served_time, 
                                TIMESTAMPDIFF(MINUTE, O.ordered_time, O.served_time) AS served_minutes
                            FROM orders O
                            INNER JOIN users W ON O.waiter_id = W.id
                            WHERE O.party_id = ? AND O.id = ?;
                        ";

                        if ($statement3 = mysqli_prepare($connection, $query3)) {
                            mysqli_stmt_bind_param($statement3, 'ii', $party_id, $order_id);
                            mysqli_stmt_execute($statement3);
                            $result = mysqli_stmt_get_result($statement3);

                            if (mysqli_num_rows($result) === 0) {
                                echo "<div>Nessuna informazione sul cameriere trovata.</div>";
                            } else {
                                $row = mysqli_fetch_assoc($result);
                                
                                echo '<div>';
                                if (is_null($row["waiter_handled_time"])) {
                                    echo '<p>Stato : In attesa di servizio</p>';
                                } elseif (!is_null($row["waiter_handled_time"]) && is_null($row["served_time"])) {
                                    echo '<p>Servito da : ' . htmlspecialchars($row["email"]) . '</p>';
                                    echo '<p>Stato : Servizio in corso</p>';
                                } else {
                                    echo '<p>Servito da : ' . htmlspecialchars($row["email"]) . '</p>';
                                    echo '<p>Servito in : ' . htmlspecialchars($row["served_minutes"]) . ' minuti</p>';
                                }
                                echo '</div>';
                            }

                            mysqli_stmt_close($statement3);
                        } else {
                            die("Errore nella preparazione della query: " . mysqli_error($connection));
                        }
                    }
    
                    mysqli_stmt_close($statement2);
                } else {
                    die("Errore nella preparazione della query: " . mysqli_error($connection));
                }

                mysqli_stmt_close($statement1);
            } else {
                die("Errore nella preparazione della query: " . mysqli_error($connection));
            }

            mysqli_close($connection);
        ?>
        </main>
    </body>
</html>
