<?php
    if(!isset($_GET['party_id']))
        header("location: index.php");
?>
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>Ordini</title>
        <link rel="stylesheet" href="../css/ordini.css">
        <link rel="icon" href="../assets/favicon.ico" type="image/ico">
        <script src="../js/ordini.js"></script>
        <meta charset="UTF-8">
        <meta name="author" content="Tommaso Molesti">
        <meta name="description" content="Un software di gestione cassa per la tua sagra">
    </head>
    <body onload="inizializza()">
        <header>
            <?php
                require_once "profile.php";
                if(isset($_GET["type"]) && $_GET["type"] == "not_handled") {
                    echo "<h1 id='title'>Ordini</h1>";
                } else {
                    echo "<h1 id='title'>Tutti gli ordini</h1>";
                }
            ?>
        </header>
        <main>
        <?php
            require_once "check.php";
            require_once "dbaccess.php";

            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if(mysqli_connect_errno()) {
                die(mysqli_connect_error());
            }

            $party_id = $_GET['party_id'];
            $ended;
            // Recupero l'informazione per sapere se la festa è terminata o no
            $queryEnded = "SELECT ended FROM parties WHERE id = ?";
            if($stmtEnded = mysqli_prepare($connection, $queryEnded)) {
                mysqli_stmt_bind_param($stmtEnded, 'i', $party_id);
                mysqli_stmt_execute($stmtEnded);
                $resultEnded = mysqli_stmt_get_result($stmtEnded);

                if ($rowEnded = mysqli_fetch_assoc($resultEnded)) {
                    $ended = $rowEnded['ended'];
                }
                mysqli_stmt_close($stmtEnded);
            } else {
                die("Errore nella query di controllo: " . mysqli_error($connection));
            }

            if(!$ended) {
                require_once "back_dashboard.php";
            }

            if(isset($_GET["type"]) && $_GET["type"] == "not_handled") {
                // Recupero le informazioni degli ordini non ancora gestiti da camerieri
                $query = "SELECT * FROM orders WHERE party_id = ? AND waiter_id IS NULL;";
                if($statement = mysqli_prepare($connection, $query)) {
                    mysqli_stmt_bind_param($statement, 'i', $party_id);
                    mysqli_stmt_execute($statement);
                    $result = mysqli_stmt_get_result($statement);
    
                    if(mysqli_num_rows($result) === 0) {
                        echo "Tutti gli ordini sono stati gestiti.";
                    } else {
                        echo '<form method="POST" action="associa_ordine_cameriere.php">';
                        
                        echo '<button id="submit-btn" type="submit" disabled>Prendi in carico ordini</button>';
                        
                        echo '<table>';
                        echo '<thead><tr>
                            <th>Seleziona</th>
                            <th>Nome</th>
                            <th>Orario</th>
                            <th>Azioni</th>
                        <tr></thead>';
                        echo '<tbody>';
                        while($row = mysqli_fetch_assoc($result)) {
                            echo '<tr class="order-row">';
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
                        
                        echo '<input type="hidden" name="party_id" value="' . $party_id . '">';
                        echo '</form>';
                    }
    
                    mysqli_stmt_close($statement);
                } else {
                    die("Errore nella preparazione della query: " . mysqli_error($connection));
                }
    
                mysqli_close($connection);
            } else {
                // Recupero tutti gli ordini della festa corrente
                $query = "SELECT * FROM orders WHERE party_id = ?;";
                if($statement = mysqli_prepare($connection, $query)) {
                    mysqli_stmt_bind_param($statement, 'i', $party_id);
                    mysqli_stmt_execute($statement);
                    $result = mysqli_stmt_get_result($statement);
    
                    if(mysqli_num_rows($result) === 0) {
                        echo "Nessun ordine presente.";
                    } else {
                        
                        echo '<table>';
                        echo '<thead><tr>
                            <th>Ordine n°</th>
                            <th>Nome</th>
                            <th>Stato</th>
                            <th>Gestito da</th>
                            <th>Azioni</th>
                        <tr></thead>';
                        echo '<tbody>';

                        $status = "";

                        while($row = mysqli_fetch_assoc($result)) {
                            if($row["served_time"]) {
                                $status = "Servito";
                            } else if ($row["waiter_id"]){
                                $status = "Servizio in corso";
                            } else {
                                $status = "In attesa di servizio";
                            }

                            $waiter_email = "Non assegnato";
                            if ($row["waiter_id"]) {
                                $waiter_id = $row["waiter_id"];
                                // Recupero la mail del cameriere per mostrarla nella tabella
                                $waiter_query = "SELECT email FROM users WHERE id = ?";
                                
                                if ($waiter_stmt = mysqli_prepare($connection, $waiter_query)) {
                                    mysqli_stmt_bind_param($waiter_stmt, 'i', $waiter_id);
                                    mysqli_stmt_execute($waiter_stmt);
                                    $waiter_result = mysqli_stmt_get_result($waiter_stmt);
                                    
                                    if ($waiter_row = mysqli_fetch_assoc($waiter_result)) {
                                        $waiter_email = $waiter_row["email"];
                                    }
                                    mysqli_stmt_close($waiter_stmt);
                                }
                            }

                            echo '<tr class="order-row">';
                            echo '<td>#' . $row["order_counter"] . '</td>';
                            echo '<td>' . $row["name"] . '</td>';
                            echo '<td>' . $status . '</td>';
                            echo '<td>' . $waiter_email . '</td>';
                            echo '<td class="actions-row">';
                            echo '<a href="dettagli_ordine.php?party_id=' . $party_id . '&order_id=' . $row["id"] . '">';
                            echo '<img src="../assets/details.svg" alt="Dettagli" width="20" height="20">';
                            echo '</a>';
                            echo '<form method="POST" action="elimina_ordine.php" onsubmit="return confirmDelete(event);">';
                            echo '<input type="hidden" name="order_id" value="' . $row['id'] . '">';
                            echo '<input type="hidden" name="party_id" value="' . $party_id . '">';
                            if(!$ended) {
                                echo '
                                    <button class="delete-button" type="submit">
                                        <img class="delete-icon" src="../assets/delete.svg" alt="Elimina">
                                    </button>
                                ';
                            }
                            echo '</form>';
                            echo '</td>';

                            echo '</tr>';
                        }
                        echo '</tbody>';
                        echo '</table>';
                        
                        echo '<input type="hidden" name="party_id" value="' . $party_id . '">';
                    }
    
                    mysqli_stmt_close($statement);
                } else {
                    die("Errore nella preparazione della query: " . mysqli_error($connection));
                }
    
                mysqli_close($connection);
            }

        ?>
        </main>
    </body>
</html>
