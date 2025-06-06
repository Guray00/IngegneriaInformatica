<?php
session_start();
session_unset();
require_once __DIR__ . "/../includes/methods.php";

if(!isset($_SERVER['REQUEST_METHOD']) || $_SERVER["REQUEST_METHOD"] !== "POST"){
    pageError("403");
}

$username = $_POST["username"] ?? '';
$password = $_POST["password"] ?? '';
$confirmPassword = $_POST["confirmPassword"] ?? '';

$isLogin = empty($confirmPassword);

$stmtSearch = null;
$stmtInsert = null;

try{
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        throw new Exception("connection_failed", 500);
    }

    $errorType = validateInputs($username, $password, $confirmPassword);
    if(!empty($errorType)){
        throw new Exception($errorType, 400);
    }

    if($isLogin){
        // Login
        $sql = "SELECT *
                FROM Account
                WHERE Username = ?";
        $stmtSearch = $conn->prepare($sql);
        $stmtSearch->bind_param("s", $username);
        $stmtSearch->execute();
        $result = $stmtSearch->get_result();

        if($result->num_rows === 0){
            throw new Exception("username_not_found", 404);
        }

        $data = $result->fetch_assoc();
        $id = $data['ID'];
        $hashedPassword = $data['Password'];

        if(!password_verify($password, $hashedPassword)){
            throw new Exception("wrong_password", 401);
        }

        startSession($id);
    }
    else{
        // Sign Up
        $sql = "SELECT ID
                FROM Account
                WHERE Username = ?";

        $stmtSearch = $conn->prepare($sql);
        $stmtSearch->bind_param("s", $username);
        $stmtSearch->execute();
        $result = $stmtSearch->get_result();

        if($result->num_rows !== 0){
            throw new Exception("username_taken", 409);
        }

        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

        $sqlInsert = "INSERT INTO Account (Username, Password) VALUES (?, ?)";

        $stmtInsert = $conn->prepare($sqlInsert);

        $stmtInsert->bind_param("ss", $username, $hashedPassword);

        if(!$stmtInsert->execute()){
            throw new Exception("registration_failed", 500);
        }

        $id = $conn->insert_id;

        startSession($id);
    }
}
catch(Exception $e){
    $errorType = $e->getMessage();
    $login = [
        'message' => ERROR_TYPES[$errorType] ?? ERROR_TYPES['default'],
        'errorcode' => $e->getCode(),
        'isLogin' => $isLogin
    ];

    $_SESSION['loginError'] = $login;

    error_log("Errore login [" .$login['errorcode'] ."]: " . $login['message']);
    if($login['message'] === ERROR_TYPES['default']){
		error_log("Messaggio originale: " . $errorType);
	}
    
    http_response_code($login['errorcode']);
    header("Location: ./../../index.php");
    exit;
}
finally{
    if($stmtSearch)   $stmtSearch->close();
    if($stmtInsert)   $stmtInsert->close();
    $conn->close();
}

/**
 * Funzione che inizializza la sessione e reindirizza alla `dashboard.php`
 * @param int $id id dell'account
 * @return never
 */
function startSession($id){
    $_SESSION['accountID'] = serialize($id);

    header("Location: ./../pages/dashboard.php");
    exit;
}