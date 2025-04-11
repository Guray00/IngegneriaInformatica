<?php
require_once "dbaccess.php";
session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);

if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

// This login is purposefully verbose and therefore insecure:
// no information about the user's existence, nor the password
// correctness should be leaked

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];

    // SQL query to fetch user data
    $query = $connection->prepare(
        "SELECT user_id, email, username, password FROM users WHERE username = ?"
    );
    $query->bind_param("s", $username);
    $query->execute();

    $result = $query->get_result();

    if ($result->num_rows > 0) {
        // Fetch the user data
        $user = $result->fetch_assoc();

        // Check if password is correct before fetching boards
        if (password_verify($password, $user["password"])) {
            // Fetch user's boards
            $boards_query = $connection->prepare(
                "SELECT board_id, name, repr, creation_timestamp FROM boards WHERE user_id = ?"
            );
            $boards_query->bind_param("i", $user["user_id"]);
            $boards_query->execute();
            $boards_result = $boards_query->get_result();

            $boards = [];
            while ($board = $boards_result->fetch_assoc()) {
                $boards[] = [
                    "board_id" => $board["board_id"],
                    "name" => $board["name"],
                    "repr" => $board["repr"],
                    "timestamp" => $board["creation_timestamp"],
                ];
            }

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
                    "boards" => $boards,
                ],
                "token" => $token,
            ]);
        } else {
            // Incorrect password
            echo json_encode([
                "status" => "error",
                "message" => "Invalid password.",
            ]);
        }
    } else {
        // User not found
        echo json_encode([
            "status" => "error",
            "message" => "User not found.",
        ]);
    }

    $query->close();
}

$connection->close();
?>
