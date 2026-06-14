<?php
// renderizza al login nel caso l'utente provi ad accedere a pagine per cui serve l'accesso
session_start();
if (!isset($_SESSION['loggato']) || $_SESSION['loggato'] !== true) {
    header("Location: ../index.php");
    exit();
}
?>