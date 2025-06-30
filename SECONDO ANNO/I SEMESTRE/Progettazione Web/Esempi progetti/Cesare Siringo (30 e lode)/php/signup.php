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

    // Check if username already exists
    $stmt = $connection->prepare("SELECT * FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode([
            "status" => "error",
            "message" => "Username already exists. Please choose another."
        ]);
    } else {
        // Insert new user
        $stmt = $connection->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
        $stmt->bind_param("ss", $username, $hashedPassword);

        if ($stmt->execute()) {
            // get user ID of the newly created user
            $userId = $stmt->insert_id;
            $saves = [];
            // generate a session token
            $sessionToken = bin2hex(random_bytes(32));
            $_SESSION['user_id'] = $userId;
            $_SESSION['session_token'] = $sessionToken;

            setcookie("session_token", $sessionToken, time() + (86400 * 1), "/", "", false, true);

            echo json_encode([
                "status" => "success",
                "message" => "User created successfully.",
                "user" => [
                    "id" => $userId,
                    "username" => $username,
                    "saves" => $saves
                ],
                "session_token" => $sessionToken
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Error creating user: " . $stmt->error
            ]);
        }
    }

    $stmt->close();
}

$connection->close();
?>