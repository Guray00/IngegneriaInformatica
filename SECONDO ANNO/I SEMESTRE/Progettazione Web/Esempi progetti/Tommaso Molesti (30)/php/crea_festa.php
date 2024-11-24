<?php
require_once "check.php";
require_once "dbaccess.php";
$errore = 0;

if (!isset($_SESSION["id"])) {
    header("Location: login.php");
    exit();
}

if (isset($_POST['crea_festa']) && isset($_POST['name'])) {
    $name = $_POST['name'];
    $import_magazzino = isset($_POST['import_magazzino']) ? $_POST['import_magazzino'] : null;
    
    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if (mysqli_connect_errno()) {
        die(mysqli_connect_error());
    }

    $user_id = $_SESSION["id"];
    $waiters_code = "";

    function generateWaitersCode() {
        return substr(str_shuffle("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"), 0, 8);
    }

    do {
        // Genera un codice per i camerieri finché non è diverso da quelli già esistenti in altre feste
        $waiters_code = generateWaitersCode();
        $check_query = "SELECT id FROM parties WHERE waiters_code = ?";
        if ($stmt = mysqli_prepare($connection, $check_query)) {
            mysqli_stmt_bind_param($stmt, 's', $waiters_code);
            mysqli_stmt_execute($stmt);
            mysqli_stmt_store_result($stmt);
            $exists = mysqli_stmt_num_rows($stmt) > 0;
            mysqli_stmt_close($stmt);
        } else {
            die("Errore nella preparazione della query: " . mysqli_error($connection));
        }
    } while ($exists);

    // Inserisce la festa
    $query = "INSERT INTO parties (user_id, name, waiters_code) VALUES (?, ?, ?)";
    if ($statement = mysqli_prepare($connection, $query)) {
        mysqli_stmt_bind_param($statement, 'iss', $user_id, $name, $waiters_code);
        if (mysqli_stmt_execute($statement)) {
            $new_party_id = mysqli_insert_id($connection);

            if (!empty($import_magazzino)) {
                // Prende gli articoli dal magazzino della festa selezionata
                $import_query = "SELECT name, price, sort_index FROM articles WHERE party_id = ?";
                if ($import_stmt = mysqli_prepare($connection, $import_query)) {
                    mysqli_stmt_bind_param($import_stmt, 'i', $import_magazzino);
                    mysqli_stmt_execute($import_stmt);
                    $import_result = mysqli_stmt_get_result($import_stmt);

                    // Li inserisce dentro al magazzino della festa appena creata con quantità 0 e senza tracking
                    $insert_query = "INSERT INTO articles (party_id, name, price, quantity, tracking_quantity, sort_index) VALUES (?, ?, ?, 0, 1, ?)";
                    while ($article = mysqli_fetch_assoc($import_result)) {
                        if ($insert_stmt = mysqli_prepare($connection, $insert_query)) {
                            mysqli_stmt_bind_param($insert_stmt, 'issi', $new_party_id, $article['name'], $article['price'], $article['sort_index']);
                            mysqli_stmt_execute($insert_stmt);
                            mysqli_stmt_close($insert_stmt);
                        } else {
                            die("Errore durante la duplicazione degli articoli: " . mysqli_error($connection));
                        }
                    }
                    mysqli_stmt_close($import_stmt);
                } else {
                    die("Errore nella preparazione della query di importazione: " . mysqli_error($connection));
                }
            }

            header("Location: dashboard.php?party_id=" . $new_party_id);
            exit();
        } else {
            $errore = 1;
        }
        mysqli_stmt_close($statement);
    } else {
        die("Errore nella preparazione della query: " . mysqli_error($connection));
    }

    mysqli_close($connection);
}

if ($errore) {
    header("Location: index.php");
    exit();
}

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if (mysqli_connect_errno()) {
    die(mysqli_connect_error());
}

$user_id = $_SESSION["id"];
$other_parties = [];
// Prende la lista di tutte le feste dell'utente
$other_parties_query = "SELECT id, name FROM parties WHERE user_id = ?";

if ($stmt = mysqli_prepare($connection, $other_parties_query)) {
    mysqli_stmt_bind_param($stmt, 'i', $user_id);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    while ($row = mysqli_fetch_assoc($result)) {
        $other_parties[] = $row;
    }
    mysqli_stmt_close($stmt);
} else {
    die("Errore nella preparazione della query per recuperare altre feste: " . mysqli_error($connection));
}

mysqli_close($connection);
?>

<!DOCTYPE html>
<html lang='it'>
<head>
    <title>Crea festa</title>
    <link rel="stylesheet" href="../css/crea_festa.css">
    <link rel="icon" href="../assets/favicon.ico" type="image/ico">
    <script src="../js/crea_festa.js"></script>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
    <header>
        <?php require_once "profile.php"; require_once "back_dashboard.php"; require_once "admin_protected.php"; ?>
    </header>
    <main>
        <h1>Crea Festa</h1>
        <form id="crea_festa" action="crea_festa.php" method="post" onsubmit="return confirmImport();">
            
            <div class="info-container">
                <label for="name">Nome: </label>
                <input type="text" id="name" name="name" class="input-field" required>
            </div>
            
            <?php if (count($other_parties) > 0): ?>
            <div class="select-container">
                <label for="import_magazzino">Importa magazzino da festa esistente: </label>
                <select id="import_magazzino" name="import_magazzino" class="select-field">
                    <option value="">Seleziona una festa: </option>
                    <?php foreach ($other_parties as $party): ?>
                        <option value="<?php echo htmlspecialchars($party['id']); ?>">
                            <?php echo htmlspecialchars($party['name']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <?php endif; ?>

            <input type="submit" id="create-btn" name="crea_festa" value="Crea">
        </form>
    </main>
</body>
</html>


