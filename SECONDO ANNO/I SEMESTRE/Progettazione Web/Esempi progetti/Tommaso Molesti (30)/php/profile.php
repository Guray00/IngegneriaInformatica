<?php
require_once "check.php";
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <link rel="stylesheet" href="../css/profile.css">
    <script src="../js/profile.js"></script>
    <title>Profilo</title>
    <meta charset="UTF-8">
    <meta name="author" content="Tommaso Molesti">
    <meta name="description" content="Un software di gestione cassa per la tua sagra">
</head>
<body>

<div id="profile-container">
    <?php if (isset($_SESSION['id'])): ?>
        <div id="profile-icon-container" onclick="toggleMenu()">
            <img id="profile-icon" src="../assets/profile.svg" alt="Profilo" width="30" height="30">
        </div>

        <div id="profile-menu" class="hidden">
            <div id="user-email"><?= htmlspecialchars($_SESSION['email']); ?></div>
            <a href="logout.php" id="logout">
                <img src="../assets/logout.svg" alt="Logout" width="20" height="20">
                <span>Esci</span>
            </a>
        </div>
    <?php endif; ?>
</div>

</body>
</html>
