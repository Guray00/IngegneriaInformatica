<?php
require_once "dbcreds.php";
session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // fetch user data
    $stmt = $connection->prepare("SELECT * FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // verify password
        if (password_verify($password, $user['password'])) {
            // fetch user's saves
            $savesStmt = $connection->prepare("SELECT * FROM saves WHERE user_id = ?");
            $savesStmt->bind_param("i", $user['user_id']);
            $savesStmt->execute();
            $savesResult = $savesStmt->get_result();

            $saves = [];
            while ($save = $savesResult->fetch_assoc()) {
                $saves[] = $save;
            }
            $savesStmt->close();

            // generate a session token
            $sessionToken = bin2hex(random_bytes(32));
            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['session_token'] = $sessionToken;

            setcookie("session_token", $sessionToken, time() + (86400 * 1), "/", "", false, true);

            echo json_encode([
                "status" => "success",
                "message" => "Login successful.",
                "user" => [
                    "id" => $user['user_id'],
                    "username" => $user['username'],
                    "saves" => $saves
                ],
                "session_token" => $sessionToken
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Invalid password."
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Username not found."
        ]);
    }

    $stmt->close();
}

$connection->close();
?>