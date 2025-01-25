<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";

$connection = new connectDB();
$pdo = $connection->getPDO();

try {

    if ( !( isset($_SESSION['login']) && $_SESSION['login'] === true && isset($_SESSION['userid'])) ) {
        throw new Exception('Not logged in');
    }

    $query = "
                select ID, BoardSize, CreatedTime, Shared
                from Game 
                where Account = ?
                order by ID desc
             ";
    $stmt = $pdo->prepare($query);
    $stmt->execute([ $_SESSION['userid'] ]);

    $games = $stmt->fetchAll(pdo::FETCH_ASSOC);

    $response = [
        'games' => $games,
    ];

} catch (PDOException | Exception $e) {
    $response = [
        'error'  => $e->getMessage()
    ];
}

// $response += ['session' => $_SESSION];

echo json_encode($response);

$connection->close();
$pdo = null;
