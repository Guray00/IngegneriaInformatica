<?php
require_once "check.php";
$party_id = isset($_GET['party_id']) ? $_GET['party_id'] : null;
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <title>Back dashboard</title>
    <link rel="stylesheet" href="../css/back_dashboard.css">
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>
<!-- Redirect su dashboard diverse in base al tipo di utente -->
<?php if (isset($_SESSION['id'])): ?>
    <?php if (isset($_SESSION['role']) && $_SESSION['role'] === 'waiter'): ?>
        <a id='back-dashboard-button' href='dashboard_cameriere.php?party_id=<?php echo urlencode($party_id); ?>'>
            <p id='back-dashboard-text'>Torna alla dashboard</p>
        </a>
    <?php else: ?>
        <a id='back-dashboard-button' href='dashboard.php?party_id=<?php echo urlencode($party_id); ?>'>
            <p id='back-dashboard-text'>Torna alla dashboard</p>
        </a>
    <?php endif; ?>
<?php endif; ?>
</body>
</html>
