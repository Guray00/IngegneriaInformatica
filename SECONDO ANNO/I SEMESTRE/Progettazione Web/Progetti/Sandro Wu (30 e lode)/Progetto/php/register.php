<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";
$connection = new connectDB();
$pdo = $connection->getPDO();

try {

    $keys = ['username', 'password', 'confirm', 'question', 'answer'];
    foreach ($keys as $key) {
        if($_POST[$key] == ''){
            throw new Exception("No input in $key field");
        }
    };

    if (!$_POST['username']) {
        throw new Exception("Incorrect credentials");
    }
    if(strlen($_POST['username']) < 4){
        throw new Exception("Username too short!");
    }
    if(strlen($_POST['password']) < 5){
        throw new Exception("Password too short!");
    }
    if($_POST['password'] != $_POST['confirm']){
        throw new Exception("Wrong Confirm field");
    }

    $query = "insert into Account (Username, Hash, Question, Answer) values (?,?,?,?)";

    $statement = $pdo->prepare($query);
    $statement->bindValue(1, $_POST['username']);
    $statement->bindValue(2, password_hash($_POST['password'], PASSWORD_BCRYPT));
    $statement->bindValue(3, $_POST['question']);
    $statement->bindValue(4, $_POST['answer']);
    $statement->execute();

    $query = "select LAST_INSERT_ID()";
    $statement = $pdo->prepare($query);
    $statement->execute();

    $id = $statement->fetch(PDO::FETCH_NUM);
    $id = $id[0];

    // Login
    $_SESSION['login'] = true;
    $_SESSION['userid'] = $id;
    $_SESSION['username'] = $_POST['username'];

    $response = [
        'register'=> true,
        'message' => 'Account registered',
    ];

} catch (PDOException | Exception $e) {
    $response = [
        'register'   => false,
        'message' => 'Registration failed',
        'error'  => $e->getMessage(),
    ];
}

// $response += ['post' => $_POST];

echo json_encode($response);

$connection->close();
$pdo = null;
