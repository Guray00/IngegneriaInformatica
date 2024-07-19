<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";

$connection = new connectDB();
$pdo = $connection->getPDO();

try {

    if (!(isset($_SESSION['login']) && $_SESSION['login'] === true)) {
        throw new Exception("Not logged in");
    }

    $gameid = $_POST['gameid'];

    $query = "Update Game set Shared = not Shared where ID = ? and Account = ?";
    $stmt = $pdo->prepare($query);   
    $stmt->execute([$gameid, $_SESSION['userid']]);


    $query = "Select Shared from Game where ID = ? and Account = ?";
    $stmt = $pdo->prepare($query);   
    $stmt->execute([$gameid, $_SESSION['userid']]);

    $result = $stmt->fetchColumn(0);

    $response = [
        'gameid' => $gameid,
        'shared' => $result
    ];
} catch (PDOException | Exception $e) {
    $response = [
        'gameid' => $gameid,
        'error'  => $e->getMessage()
    ];
}

// $response +=['post' => $_POST,'session' => $_SESSION];

echo json_encode($response);

$connection->close();
$pdo = null;
