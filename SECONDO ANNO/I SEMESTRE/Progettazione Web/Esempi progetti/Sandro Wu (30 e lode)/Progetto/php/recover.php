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
    $confirm = $_POST['confirm'];

    if (!$username) {
        throw new Exception("Incorrect credentials");
    }
    
    $query = "  
                select Question, Answer
                from Account 
                where Username = ? 
                limit 1
             ";
    $statement = $pdo->prepare($query);
    $statement->bindValue(1, $username);
    $statement->execute();

    if ($statement->rowCount() == 0) {
        // No account with this username
        throw new Exception("Incorrect credentials");
    } else {
        $account = $statement->fetch(pdo::FETCH_ASSOC);

        $response = [
            'recover'  => true,
            'step' => $_POST['step']
        ];

        switch ($_POST['step']) {

            case "getQuestion":
                $response += ['question' => $account['Question']];
                break;

            case "verify":
                if ($_POST['answer'] != $account['Answer']) {
                    throw new Exception("Incorrect credentials");
                }
                break;

            case "changePassword":
                if(strlen($password) < 5){
                    throw new Exception("Password too short!");
                }
                if($password != $confirm){
                    throw new Exception("Wrong Confirm field");
                }
                $query = "  
                            update Account 
                            set Hash = ?
                            where Username = ?
                        ";
                $statement = $pdo->prepare($query);
                $statement->bindValue(1, password_hash($password, PASSWORD_BCRYPT));
                $statement->bindValue(2, $username);
                $statement->execute();

                if (isset($_SESSION['login']) && $_SESSION['username'] == $username) {
                    session_destroy();
                }
                break;
        }
    }
} catch (PDOException | Exception $e) {
    $response = [
        'recover'  => false,
        'error'  => $e->getMessage(),
    ];
}

// debug
// $response += ['post' => $_POST];

echo json_encode($response);

$connection->close();
$pdo = null;
