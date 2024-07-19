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

    $pdo->beginTransaction();

    $query = " delete from Game where ID = ? and Account = ?";
    $stmt = $pdo->prepare($query);   
    $stmt->execute([$gameid, $_SESSION['userid']]);
    $result = $stmt->rowCount();
    
    if($result){
        $query = "delete from Move where Game = ?";
        $stmt = $pdo->prepare($query);   
        $stmt->execute([$gameid]);
    }
    
    $pdo->commit();

    $response = [
        'gameid' => $gameid,
        'success' => $result
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
