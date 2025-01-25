<?php
// Se non riesco a capire il ruolo, o se comunque il ruolo non è admin, butto fuori l'utente
if(!isset($_SESSION["role"]) || $_SESSION["role"] != "admin") {
    header("location: not_authorized.php");
}
?>