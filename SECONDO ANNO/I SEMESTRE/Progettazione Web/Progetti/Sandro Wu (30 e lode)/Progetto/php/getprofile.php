<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";
$connection = new connectDB();
$pdo = $connection->getPDO();

try {

    if (!(isset($_SESSION['login']) && $_SESSION['login'] === true && isset($_SESSION['userid']))) {
        throw new Exception('Not logged in');
    }

    $query = "
        select ID, Shared, BoardSize, Black, White, CreatedTime
        from Game 
        where Account = ? 
        order by CreatedTime DESC
    ";

    $statement = $pdo->prepare($query);
    $statement->bindValue(1, $_SESSION['userid']);
    $statement->execute();

    $games = $statement->fetchAll(pdo::FETCH_ASSOC);

    $response = [
        'games' => $games
    ];
} catch (PDOException | Exception $e) {
    $response = [
        'error'  => $e->getMessage(),
    ];
}

// $response += ['post' => $_POST];

echo json_encode($response);

$connection->close();
$pdo = null;
