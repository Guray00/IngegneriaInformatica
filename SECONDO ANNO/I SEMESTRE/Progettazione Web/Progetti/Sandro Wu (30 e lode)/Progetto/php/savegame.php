<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";

$connection = new connectDB();
$pdo = $connection->getPDO();

try {

    if (!(isset($_SESSION['login']) && $_SESSION['login'] === true)) {
        throw new Exception('Not logged in');
    }

    $userid = $_SESSION['userid'];
    $gameid = $_POST['gameid'];
    $size = $_POST['size'];
    $komi = $_POST['komi'];
    $players = $_POST['players']; // <--------------------------------------------------------

    $players = json_decode($players);
    $gameid = json_decode($gameid);

    if($gameid){
        $query = "select 1 from Game where ID = ? and Account = ?";
        $stmt = $pdo->prepare($query);
        $stmt->execute([$gameid, $userid]);
        if ($stmt->rowCount() == 0){
            $gameid = null;
        }
    }

    // if not registered, create a new game id
    if (!$gameid) {
        $query = "insert into Game(Account, BoardSize, Komi, Black, White) value (?,?,?,?,?)";
        $stmt = $pdo->prepare($query);
        $stmt->execute([$userid, $size, $komi, $players[0], $players[1]]);

        $query = "select LAST_INSERT_ID()";
        $stmt = $pdo->prepare($query);
        $stmt->execute();

        $res = $stmt->fetch(PDO::FETCH_NUM);
        $gameid = $res[0];
    }

    $moves = $_POST['moves'];
    $moves = json_decode($moves);
    $step = 1;
    $player = null;
    $cell = null;

    $query = "replace into Move(Game, Step, Player, Cell) values (?,?,?,?);";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(1, $gameid);
    $stmt->bindParam(2, $step);
    $stmt->bindParam(3, $player);
    $stmt->bindParam(4, $cell);

    $pdo->beginTransaction();
    foreach ($moves as $move) {
        $cell = $move[0];
        $player = $move[1];

        $stmt->execute();

        $step++;
    }

    $query = "delete from Move where Game = ? and Step >= ?;";
    $stmt = $pdo->prepare($query);
    $stmt->execute([$gameid, $step]);

    $pdo->commit();


    $response = [
        'gameid' => $gameid,
        'success' => true
    ];
} catch (PDOException | Exception $e) {

    $response = [
        'gameid' => $gameid,
        'success' => false,
        'error' => $e->getMessage()
    ];
}

// $response += [
//     'post' => $_POST,
//     'session' => $_SESSION
// ];

echo json_encode($response);

$connection->close();
$pdo = null;
