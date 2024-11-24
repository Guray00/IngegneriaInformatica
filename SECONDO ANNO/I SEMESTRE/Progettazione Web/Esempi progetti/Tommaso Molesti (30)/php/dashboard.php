<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/dashboard.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <main>
        <?php
            require_once "check.php";
            require_once "dbaccess.php";
            require_once "admin_protected.php";
            require_once "back_home.php";

            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if(mysqli_connect_errno()) {
                die(mysqli_connect_error());
            }

            if(isset($_SESSION["role"]) && $_SESSION["role"] == "admin") {
                // Prende le informazioni sulla festa corrente
                $query = "SELECT * FROM parties WHERE user_id = ? AND id = ?;";
                $user_id = $_SESSION["id"];
                $party_id = $_GET['party_id'];

                if($statement = mysqli_prepare($connection, $query)) {
                    mysqli_stmt_bind_param($statement, 'ii', $user_id, $party_id);
                    mysqli_stmt_execute($statement);
                    $result = mysqli_stmt_get_result($statement);

                    if(mysqli_num_rows($result) === 0) {
                        header("location: index.php");
                        exit();
                    } else {
                        $row = mysqli_fetch_assoc($result);
                        echo "<div id='header-container'>";
                        echo '<h1>' . htmlspecialchars($row["name"]) . '</h1>';
                        echo "</div>";
                                        
                        echo "<a id='link-button' href='impostazioni.php?party_id=" . str_replace(" ", "%20", $party_id) . "'>";
                        echo "<p id='link-text'>Impostazioni</p>";
                        echo "</a>";
                    }

                    mysqli_stmt_close($statement);
                } else {
                    die("Errore nella preparazione della query: " . mysqli_error($connection));
                }

                // Prende tutti gli articoli relativi a quella festa
                $query = "SELECT * FROM articles WHERE party_id = ? AND removed IS false ORDER BY sort_index ASC;";
                $articles_found = false;
                echo "<div id='main-wrapper'>";
                if($statement = mysqli_prepare($connection, $query)) {
                    mysqli_stmt_bind_param($statement, 'i', $party_id);
                    mysqli_stmt_execute($statement);
                    $result = mysqli_stmt_get_result($statement);

                    echo "<div id='right'>";
                    if(mysqli_num_rows($result) === 0) {
                        echo "<p>Nessun articolo trovato</p>";
                    } else {
                        $articles_found = true;
                        while ($row = mysqli_fetch_assoc($result)) {
                            $quantity = $row["quantity"];
                            $tracking_quantity = $row["tracking_quantity"];
                            $sort_index = strval($row["sort_index"]);
                            $disabled="false";
                            $class = "";
                            $onclick = "";
                            if (!$tracking_quantity) {
                                $class = "high";
                            } else {
                                if ($quantity == 0) {
                                    $disabled = "true";
                                } elseif ($quantity <= 10) {
                                    $class = "low";
                                } elseif ($quantity <= 20) {
                                    $class = "medium";
                                } else {
                                    $class = "high";
                                }
                            }

                            if ($quantity == 0 && $tracking_quantity) {
                                $disabled = "disabled";
                            } else {
                                $disabled = "";
                                $onclick = 'onclick="addToList('.$row["id"].', \''.$row["name"].'\', \''.$row["price"].'\', \''.$quantity.'\', \''.$tracking_quantity.'\', \''.$sort_index.'\')"';
                            }
                            
                            echo '<button id="article-'.$row["id"].'" class="article-info-container '.$class.'" '.$disabled.' '.$onclick.'>' . htmlspecialchars($row["name"]);
                            
                            if ($quantity > 0 && $quantity <= 20) {
                                echo ' (' . $quantity . ')';
                            }
                            
                            echo '</button>';
                            
                            
                        }
                        echo "</div>";                
                    }                    

                    mysqli_stmt_close($statement);
                } else {
                    die("Errore nella preparazione della query: " . mysqli_error($connection));
                }

                if ($articles_found) {
                    ?>
                    <div id="left">
                        <div id="selected-articles">
                            <h3>Articoli Selezionati:</h3>
                            <table id="article-table"></table>
                        </div>
                        
                        <div id="bottom-form">
                            <h3 id="total"></h3>
                            <form id="adding-form" method="POST" action="">
                                <input type="hidden" id="selectedArticlesInput" name="selectedArticles">
                                <input oninput="onNameChange()" type="text" required id="order_name" name="order_name" placeholder="Nome ordine">
                                <button disabled type="submit" id="aggiungi-btn">Inserisci ordine</button>
                            </form>
                        </div>
                    </div>
                    <?php
                }
                echo "</div>";
            } else {
                header("location: index.php");
            }

            if ($_SERVER["REQUEST_METHOD"] == "POST") {
                if (isset($_POST['selectedArticles']) && !empty($_POST['selectedArticles'])) {
                    $selectedArticlesJson = $_POST['selectedArticles'];
                    $selectedArticles = json_decode($selectedArticlesJson, true);
                    $party_id = $_GET['party_id'];
                    $order_name = $_POST['order_name'];
            
                    $errorMessages = [];
            
                    // Controllo in più lato server per far si che non si ordini più roba di quel che è in magazzino
                    // In teoria è inutile, ma comunque un utente scaltro potrebbe sempre abilitare il bottone
                    foreach ($selectedArticles as $article) {
                        $article_id = $article['id'];
                        $requested_quantity = $article['quantity'];

                        // Controllo dal magazzino quanti erano gli articoli rimanenti
                        $check_query = "SELECT quantity, name, tracking_quantity FROM articles WHERE id = ? AND party_id = ?";
                        if ($check_statement = mysqli_prepare($connection, $check_query)) {
                            mysqli_stmt_bind_param($check_statement, 'ii', $article_id, $party_id);
                            mysqli_stmt_execute($check_statement);
                            $result = mysqli_stmt_get_result($check_statement);

                            if ($row = mysqli_fetch_assoc($result)) {
                                $available_quantity = $row['quantity'];
                                $article_name = $row['name'];
                                $tracking_quantity = $row['tracking_quantity'];

                                if ($tracking_quantity && $requested_quantity > $available_quantity) {
                                    $errorMessages[] = "Hai ordinato $requested_quantity $article_name, ma ne rimangono solo $available_quantity.";
                                }
                            }

                            mysqli_stmt_close($check_statement);
                        }
                    }

            
                    if (!empty($errorMessages)) {
                        echo "<script>alert('" . implode("\\n", $errorMessages) . "');</script>";
                    } else {
                        // Recupera il numero massimo degli ordini della festa corrente
                        $max_order_counter_query = "SELECT MAX(order_counter) AS max_order_counter FROM orders WHERE party_id = ?";
                        if ($counter_statement = mysqli_prepare($connection, $max_order_counter_query)) {
                            mysqli_stmt_bind_param($counter_statement, 'i', $party_id);
                            mysqli_stmt_execute($counter_statement);
                            $result = mysqli_stmt_get_result($counter_statement);
                            $max_order_counter = 0;
            
                            if ($row = mysqli_fetch_assoc($result)) {
                                $max_order_counter = $row['max_order_counter'];
                            }
                            mysqli_stmt_close($counter_statement);
                        }
            
                        $new_order_counter = $max_order_counter + 1;
            
                        // Inserisce l'ordine
                        $add_order_query = "INSERT INTO orders (party_id, name, order_counter) VALUES (?, ?, ?)";
                        if ($add_order_statement = mysqli_prepare($connection, $add_order_query)) {
                            mysqli_stmt_bind_param($add_order_statement, 'isi', $party_id, $order_name, $new_order_counter);
                            if (mysqli_stmt_execute($add_order_statement)) {
                                $order_id = mysqli_insert_id($connection);
            
                                foreach ($selectedArticles as $article) {
                                    $article_id = $article['id'];
                                    $quantity = $article['quantity'];
                                    $tracking_quantity = $article['tracking_quantity'];
            
                                    if ($tracking_quantity) {
                                        // Aggiorna la quantità nel magazzino
                                        $update_query = "UPDATE articles SET quantity = quantity - ? WHERE id = ? AND party_id = ?";
                                        if ($update_statement = mysqli_prepare($connection, $update_query)) {
                                            mysqli_stmt_bind_param($update_statement, 'iii', $quantity, $article_id, $party_id);
                                            mysqli_stmt_execute($update_statement);
                                            mysqli_stmt_close($update_statement);
                                        }
                                    }
            
                                    // Aggiorna anche la tabella articles_ordered
                                    $insert_ordered_query = "INSERT INTO articles_ordered (article_id, order_id, party_id, quantity) VALUES (?, ?, ?, ?)";
                                    if ($insert_ordered_statement = mysqli_prepare($connection, $insert_ordered_query)) {
                                        mysqli_stmt_bind_param($insert_ordered_statement, 'iiii', $article_id, $order_id, $party_id, $quantity);
                                        mysqli_stmt_execute($insert_ordered_statement);
                                        mysqli_stmt_close($insert_ordered_statement);
                                    }
                                }
            
                                header("Location: dashboard.php?party_id=" . $party_id);
                            } else {
                                echo "Errore durante l'inserimento dell'ordine: " . mysqli_error($connection);
                            }
                            mysqli_stmt_close($add_order_statement);
                        }
                    }
                    exit();
                }
            }

            mysqli_close($connection);
        ?>
    </main>
</body>
</html>
