<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once "connectDB.php";

$connection = new connectDB();
$pdo = $connection->getPDO();

try {

    // input checks
    $username = $_POST['username'];
    $password = $_POST['password'];

    // null values
    if(!($username && $password)){
        throw new Exception("Incorrect credentials");
    }

    $query = "  select ID, Hash 
                from Account 
                where Username = ? 
                limit 1
             ";
    $statement = $pdo->prepare($query);
    $statement->bindValue(1, $username);
    $statement->execute();

    // if no result from query, there is no account 
    if ($statement->rowCount() == 0) {
        throw new Exception("Incorrect credentials");
    } else {
        $account = $statement->fetch(pdo::FETCH_ASSOC);
        if (password_verify($password, $account['Hash'])) {

            $_SESSION['login'] = true;
            $_SESSION['userid'] = $account['ID'];
            $_SESSION['username'] = $username;

            $response = [
                'login'   => true,
                'user'    => $username,
                'message' => 'Logged in',
            ];

            // return to home
            // header('Location: ../index.php');
            // exit();
        } else {
            throw new Exception("Incorrect credentials");
        }
    }

} catch (PDOException | Exception $e){
    $response = [
        'login'   => false,
        'message' => 'Login failed',
        'error'  => $e->getMessage()
    ];
}

echo json_encode($response);

$connection->close();
$pdo = null;
