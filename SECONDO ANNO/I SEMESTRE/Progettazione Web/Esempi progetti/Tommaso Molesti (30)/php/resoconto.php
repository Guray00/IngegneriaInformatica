<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Resoconto</title>
    <link rel="stylesheet" href="../css/resoconto.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; require_once "admin_protected.php"; ?>
        <h1>Resoconto</h1>
    </header>
    <main>
        <?php
        $party_id = $_GET["party_id"];
        require_once "dbaccess.php";
        echo "<div id='pulsanti-container'>";
        echo "<a href='magazzino.php?party_id=" . str_replace(" ", "%20", $party_id) . "'>Magazzino</a>";
        echo "<a href='ordini.php?party_id=" . str_replace(" ", "%20", $party_id) . "'>Ordini</a>";
        echo "</div>";

        $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
        if (mysqli_connect_errno()) {
            die("Errore di connessione: " . mysqli_connect_error());
        }

        // Recupero le informazioni della festa corrente
        $party_info = "SELECT *  FROM parties WHERE id = ?";
        $party_info_statement = mysqli_prepare($connection, $party_info);
        if (!$party_info_statement) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($party_info_statement, 'i', $party_id);
        mysqli_stmt_execute($party_info_statement);
        $result = mysqli_stmt_get_result($party_info_statement);
        $ended = mysqli_fetch_assoc($result)['ended'];

        if(!$ended) {
            require_once "back_dashboard.php";
        } else {
            require_once "back_home.php";
        }

        // Calcolo il numero totale di ordini della festa corrente
        $total_orders_query = "SELECT COUNT(*) as total_orders FROM orders WHERE party_id = ?";
        $total_orders_stmt = mysqli_prepare($connection, $total_orders_query);
        if (!$total_orders_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($total_orders_stmt, 'i', $party_id);
        mysqli_stmt_execute($total_orders_stmt);
        $total_orders_result = mysqli_stmt_get_result($total_orders_stmt);
        $total_orders = mysqli_fetch_assoc($total_orders_result)['total_orders'];

        // Calcolo l'incasso totale, moltiplicando la quantità ordinata per il prezzo di ogni articolo
        $total_income_query = "
            SELECT SUM(AO.quantity * A.price) as total_income 
            FROM articles_ordered AO 
            INNER JOIN articles A ON AO.article_id = A.id 
            INNER JOIN orders O ON AO.order_id = O.id 
            WHERE O.party_id = ?";
        $total_income_stmt = mysqli_prepare($connection, $total_income_query);
        if (!$total_income_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($total_income_stmt, 'i', $party_id);
        mysqli_stmt_execute($total_income_stmt);
        $total_income_result = mysqli_stmt_get_result($total_income_stmt);
        $total_income = mysqli_fetch_assoc($total_income_result)['total_income'];

        // Calcolo il numero totale di articoli venduti per ogni articolo
        $sales_per_article_query = "
            SELECT A.name, SUM(AO.quantity) as total_sold 
            FROM articles_ordered AO 
            INNER JOIN articles A ON AO.article_id = A.id 
            INNER JOIN orders O ON AO.order_id = O.id 
            WHERE O.party_id = ? 
            GROUP BY A.name
            ORDER BY A.sort_index ASC";

        $sales_per_article_stmt = mysqli_prepare($connection, $sales_per_article_query);
        if (!$sales_per_article_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($sales_per_article_stmt, 'i', $party_id);
        mysqli_stmt_execute($sales_per_article_stmt);
        $sales_per_article_result = mysqli_stmt_get_result($sales_per_article_stmt);

        // Calcolo il tempo medio di attesa tra l'invio e il servizio degli ordini
        $avg_wait_time_query = "SELECT AVG(TIMESTAMPDIFF(MINUTE, ordered_time, served_time)) as avg_wait_time FROM orders WHERE party_id = ?";
        $avg_wait_time_stmt = mysqli_prepare($connection, $avg_wait_time_query);
        if (!$avg_wait_time_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($avg_wait_time_stmt, 'i', $party_id);
        mysqli_stmt_execute($avg_wait_time_stmt);
        $avg_wait_time_result = mysqli_stmt_get_result($avg_wait_time_stmt);
        $avg_wait_time = mysqli_fetch_assoc($avg_wait_time_result)['avg_wait_time'];

        // Calcolo l'ora del primo ordine effettuato durante la festa
        $first_order_query = "SELECT MIN(ordered_time) as first_order_time FROM orders WHERE party_id = ?";
        $first_order_stmt = mysqli_prepare($connection, $first_order_query);
        if (!$first_order_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($first_order_stmt, 'i', $party_id);
        mysqli_stmt_execute($first_order_stmt);
        $first_order_result = mysqli_stmt_get_result($first_order_stmt);
        $first_order_time = mysqli_fetch_assoc($first_order_result)['first_order_time'];

        // Calcolo l'ora dell'ultimo ordine effettuato durante la festa
        $last_order_query = "SELECT MAX(ordered_time) as last_order_time FROM orders WHERE party_id = ?";
        $last_order_stmt = mysqli_prepare($connection, $last_order_query);
        if (!$last_order_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($last_order_stmt, 'i', $party_id);
        mysqli_stmt_execute($last_order_stmt);
        $last_order_result = mysqli_stmt_get_result($last_order_stmt);
        $last_order_time = mysqli_fetch_assoc($last_order_result)['last_order_time'];

        // Calcolo l'intervallo medio di tempo tra un ordine e l'altro
        $orders_interval_query = "SELECT TIMESTAMPDIFF(MINUTE, MIN(ordered_time), MAX(ordered_time)) / COUNT(*) as order_interval FROM orders WHERE party_id = ?";
        $orders_interval_stmt = mysqli_prepare($connection, $orders_interval_query);
        if (!$orders_interval_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($orders_interval_stmt, 'i', $party_id);
        mysqli_stmt_execute($orders_interval_stmt);
        $orders_interval_result = mysqli_stmt_get_result($orders_interval_stmt);
        $order_interval = mysqli_fetch_assoc($orders_interval_result)['order_interval'];

        // Calcolo il numero medio di ordini gestiti per cameriere durante la festa
        $orders_per_waiter_query = "
            SELECT AVG(order_count) as avg_orders_per_waiter 
            FROM (
                SELECT waiter_id, COUNT(*) as order_count 
                FROM orders 
                WHERE party_id = ? 
                GROUP BY waiter_id
            ) as waiter_orders";
        $orders_per_waiter_stmt = mysqli_prepare($connection, $orders_per_waiter_query);
        if (!$orders_per_waiter_stmt) {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
        mysqli_stmt_bind_param($orders_per_waiter_stmt, 'i', $party_id);
        mysqli_stmt_execute($orders_per_waiter_stmt);
        $orders_per_waiter_result = mysqli_stmt_get_result($orders_per_waiter_stmt);
        $avg_orders_per_waiter = mysqli_fetch_assoc($orders_per_waiter_result)['avg_orders_per_waiter'];

        echo "<h2>Statistiche generali</h2>";
        echo '<table>';
        echo '<tr><td>Numero totale ordini</td><td>' . $total_orders . '</td></tr>';
        echo '<tr><td>Totale incasso</td><td>' . number_format($total_income, 2) . ' €</td></tr>';
        echo '<tr><td>Tempo medio di attesa</td><td>' . number_format($avg_wait_time, 2) . ' minuti</td></tr>';
        echo '<tr><td>Tempo primo ordine</td><td>' . $first_order_time . '</td></tr>';
        echo '<tr><td>Tempo ultimo ordine</td><td>' . $last_order_time . '</td></tr>';
        echo '<tr><td>Un ordine ogni</td><td>' . number_format($order_interval, 2) . ' minuti</td></tr>';
        echo '<tr><td>Media ordini evasi per cameriere</td><td>' . number_format($avg_orders_per_waiter, 2) . '</td></tr>';
        echo '</table>';

        echo "<h2>Vendite per ogni articolo</h2>";
        if (mysqli_num_rows($sales_per_article_result) > 0) {
            echo "
                <table>
                    <thead>
                    <th>Articolo</th>
                    <th>Venduti</th>
                    </thead>
                    <tbody>
            ";
            while ($row = mysqli_fetch_assoc($sales_per_article_result)) {
                echo "<tr>";
                echo "<td>{$row['name']}</td>";
                echo "<td>{$row['total_sold']}</li>";
                echo "</tr>";
            }
            echo "</tbody></table>";
        } else {
            echo "<p>Nessun ordine ancora effettuato.</p>";
        }
        mysqli_close($connection);
        ?>
    </main>
</body>
</html>
