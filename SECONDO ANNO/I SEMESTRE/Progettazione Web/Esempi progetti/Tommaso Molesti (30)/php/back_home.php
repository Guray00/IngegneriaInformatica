<?php
require_once "check.php";
$party_id = isset($_GET['party_id']) ? $_GET['party_id'] : null;
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <title>Back home</title>
    <link rel="stylesheet" href="../css/back_home.css">
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
<!-- Redirect diverso in base al tipo di utente -->
<?php if (isset($_SESSION['id'])): ?>
    <?php if (isset($_SESSION['role']) && $_SESSION['role'] === 'waiter'): ?>
        <a id='back-home-button' href='index.php?party_id=<?php echo urlencode($party_id); ?>'>
            <p id='back-home-text'>Torna alla home</p>
        </a>
    <?php else: ?>
        <a id='back-home-button' href='index.php'>
            <p id='back-home-text'>Torna alla home</p>
        </a>
    <?php endif; ?>
<?php endif; ?>
</body>
</html>
