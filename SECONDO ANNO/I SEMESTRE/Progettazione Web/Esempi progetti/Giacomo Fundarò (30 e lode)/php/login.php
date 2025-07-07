<?php
require_once "dbaccess.php";
session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);

if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    header('Content-Type: application/json');
    $username = $_POST["username"];
    $password = $_POST["password"];

    $query = $connection->prepare(
        "SELECT user_id, email, username, password FROM users WHERE username = ?"
    );
    $query->bind_param("s", $username);
    $query->execute();
    $result = $query->get_result();

    $login_success = false;
    $user = null;

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        if (password_verify($password, $user["password"])) {
            $login_success = true;
        }
    }

    if ($login_success) {
        $token = bin2hex(random_bytes(32));
        $_SESSION["user_id"] = $user["user_id"];
        $_SESSION["token"] = $token;

        setcookie(
            "session_token",
            $token,
            time() + 3600,
            "/",
            "",
            false,
            true
        );

        echo json_encode([
            "status" => "success",
            "message" => "Login successful.",
            "user" => [
                "user_id" => $user["user_id"],
                "username" => $user["username"],
                "email" => $user["email"],
            ],
            "token" => $token,
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Username o password non validi.",
        ]);
    }

    $query->close();
}

$connection->close();
?>