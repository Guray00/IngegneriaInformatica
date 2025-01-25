<?php

require_once "connectDB.php";

$connection = new connectDB();
$pdo = $connection->getPDO();

try {
    $query = "
                select Game.ID, BoardSize, Account.Username, CreatedTime
                from Game inner join Account on Account.ID = Game.Account
                where Shared = 1
                order by Game.ID desc
             ";
    $stmt = $pdo->prepare($query);
    $stmt->execute();
    $games = $stmt->fetchAll(pdo::FETCH_ASSOC);

    $response = [
        'games' => $games
    ];
} catch (PDOException $e) {
    $response = [
        'error'  => $e->getMessage()
    ];
}

echo json_encode($response);

$connection->close();
$pdo = null;
