<?php
require_once "check.php";
require_once "dbaccess.php";

if (!isset($_GET['party_id']) || !isset($_GET['article_id'])) {
    header("location: index.php");
    exit();
}

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if (mysqli_connect_errno()) {
    die("Connessione fallita: " . mysqli_connect_error());
}

$party_id = intval($_GET['party_id']);
$article_id = intval($_GET['article_id']);

// Recupero le info sull'articolo corrente
$query = "SELECT name, price, quantity, tracking_quantity FROM articles WHERE id = ? AND party_id = ?";
if ($statement = mysqli_prepare($connection, $query)) {
    mysqli_stmt_bind_param($statement, 'ii', $article_id, $party_id);
    mysqli_stmt_execute($statement);
    $result = mysqli_stmt_get_result($statement);

    if (mysqli_num_rows($result) === 0) {
        echo "Articolo non trovato.";
        exit();
    } else {
        $article = mysqli_fetch_assoc($result);
    }

    mysqli_stmt_close($statement);
} else {
    die("Errore nella preparazione della query: " . mysqli_error($connection));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'];
    $price = $_POST['price'];
    $quantity = $_POST['quantity'];
    $tracking_quantity = isset($_POST['tracking_quantity']) ? 1 : 0;

    // Aggiorno le info dell'articolo corrente
    $update_query = "UPDATE articles SET name = ?, price = ?, quantity = ?, tracking_quantity = ? WHERE id = ? AND party_id = ?";
    if ($update_stmt = mysqli_prepare($connection, $update_query)) {
        mysqli_stmt_bind_param($update_stmt, 'sdiiii', $name, $price, $quantity, $tracking_quantity, $article_id, $party_id);
        mysqli_stmt_execute($update_stmt);

        if (!mysqli_stmt_affected_rows($update_stmt) > 0) {
            echo "Nessuna modifica effettuata.";
        }

        mysqli_stmt_close($update_stmt);
        header("Location: magazzino.php?party_id=" . $party_id);
    } else {
        die("Errore nella preparazione della query di aggiornamento: " . mysqli_error($connection));
    }
}

mysqli_close($connection);
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Modifica Articolo</title>
    <link rel="stylesheet" href="../css/modifica_articolo.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; require_once "admin_protected.php"; ?>
    </header>
        <main>
        <h1 id="title">Modifica Articolo</h1>
        <form action="modifica_articolo.php?party_id=<?php echo $party_id; ?>&article_id=<?php echo $article_id; ?>" method="post">
        <div class="info-container">    
            <label for="name">Nome:</label>
            <input type="text" id="name" name="name" value="<?php echo htmlspecialchars($article['name']); ?>" required>
        </div>
        <div class="info-container">
            <label for="price">Prezzo (€):</label>
            <input type="number" id="price" name="price" step="0.01" value="<?php echo htmlspecialchars($article['price']); ?>" required>
        </div>
        <div class="info-container">
            <label for="quantity">Quantit&agrave;:</label>
            <input type="number" id="quantity" name="quantity" value="<?php echo htmlspecialchars($article['quantity']); ?>" required>
        </div>
        <div class="info-container">
            <label for="tracking_quantity">Tracking Quantit&agrave;:</label>
            <input class="checkbox" type="checkbox" id="tracking_quantity" name="tracking_quantity" <?php echo $article['tracking_quantity'] ? 'checked' : ''; ?>>
        </div>
            <input id="save-btn" type="submit" value="Salva modifiche">
        </form>
    </main>
</body>
</html>
