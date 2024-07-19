<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";

$connection = new connectDB();
$pdo = $connection->getPDO();

try {
    
    if ( !( isset($_SESSION['login']) && $_SESSION['login'] === true) ) {
        $query = "select * from Game where ID = ? and Shared = true";
        $stmt = $pdo->prepare($query);
    }else{
        $query = "select * from Game where ID = ? and (Account = ? or Shared = true)";
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(2,$_SESSION['userid']);
    }

    $gameid = $_POST['gameid'];
    $stmt->bindParam(1,$gameid);
    $stmt->execute();

    if ($stmt->rowCount() == 0){
        throw new Exception("No game found");
    }

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    $boardSize = $result['BoardSize'];
    $komi = $result['Komi'];
    $black = $result['Black'];
    $white = $result['White'];

    $query = "select Cell from Move where Game = ? order by Step";
    $stmt = $pdo->prepare($query);
    $stmt->execute([$gameid]);


    $moves = $stmt->fetchAll(PDO::FETCH_COLUMN);
    $response = [
        'gameid' => $gameid,
        'moves' => $moves,
        'size' => $boardSize,
        'komi' => $komi,
        'black' => $black,
        'white' => $white,
    ];

} catch (PDOException | Exception $e) {
    $response = [
        'gameid' => $gameid,
        'error'  => $e->getMessage()
    ];
}

echo json_encode($response);

$connection->close();
$pdo = null;
