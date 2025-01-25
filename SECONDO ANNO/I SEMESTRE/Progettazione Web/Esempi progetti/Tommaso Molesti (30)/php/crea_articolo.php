<?php
$errore = false;

$party_id = $_GET['party_id'];
$confirmation_message = "";

if (isset($_POST['crea_articolo']) && isset($_POST['name']) && isset($_POST['price'])) {
    $name = $_POST['name'];
    $quantity = $_POST['quantity'];
    $tracking_quantity = isset($_POST['tracking_quantity']) ? 1 : 0;
    $price = $_POST['price'];

    if (!$tracking_quantity) {
        $quantity = 0;
    }

    require_once "check.php";
    require_once "dbaccess.php";

    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    if (isset($_SESSION["role"]) && $_SESSION["role"] == "admin") {
        // Prendo il massimo sort_index degli articoli della festa corrente
        $maxSortIndexQuery = "SELECT MAX(sort_index) AS max_sort_index FROM articles WHERE party_id = ?";
        if ($maxStatement = mysqli_prepare($connection, $maxSortIndexQuery)) {
            mysqli_stmt_bind_param($maxStatement, 'i', $party_id);
            mysqli_stmt_execute($maxStatement);
            mysqli_stmt_bind_result($maxStatement, $max_sort_index);
            mysqli_stmt_fetch($maxStatement);
            mysqli_stmt_close($maxStatement);
        } else {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }

        // Aggiorno il sort_index
        $sort_index = $max_sort_index !== null ? $max_sort_index + 1 : 1;

        // Inserisco l'articolo
        $query = "INSERT INTO articles (party_id, name, quantity, tracking_quantity, price, sort_index) VALUES (?, ?, ?, ?, ?, ?)";
        if ($statement = mysqli_prepare($connection, $query)) {
            mysqli_stmt_bind_param($statement, 'isiidi', $party_id, $name, $quantity, $tracking_quantity, $price, $sort_index);
            
            if (!mysqli_stmt_execute($statement)) {
                die("Errore nell'esecuzione della query: " . mysqli_stmt_error($statement));
            } else {
                $confirmation_message = "Articolo creato con successo!";
            }
            
            mysqli_stmt_close($statement);
        } else {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
    } else {
        header("location: index.php");
        exit();
    }

    mysqli_close($connection);
}
?>


<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Crea articolo</title>
    <link rel="stylesheet" href="../css/crea_articolo.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; require_once "back_dashboard.php"; require_once "admin_protected.php"; ?>
    </header>
    <main>
        <h1>Crea Articolo</h1>
        <form id="crea_articolo" action=crea_articolo.php?party_id=<?php echo htmlspecialchars($_GET['party_id']); ?> method="post">
            <div class="info-container">
                <label for="name">Nome</label>
                <input class="input-field" type="text" id="name" name="name" required placeholder="Pasta al pomodoro" >
            </div>
            <div class="info-container">
                <label for="quantity">Quantit&agrave;</label>
                <input class="input-field" type="number" id="quantity" name="quantity" placeholder="5" >
            </div>
            <div class="info-container">
                <label for="price">Prezzo</label>
                <input class="input-field" type="number" id="price" name="price" step="any" min="0" required placeholder="5.00" >
            </div>
            <div class="info-container">
                <label for="tracking_quantity">Tracking quantit&agrave;</label>
                <input class="checkbox" type="checkbox" id="tracking_quantity" name="tracking_quantity">
            </div>
            <input id="create-btn" type="submit" value="Crea" name="crea_articolo">
            <div id="confirmation-message" >
                <?php echo $confirmation_message; ?>
            </div>
        </form>
    </main>
</body>
</html>
