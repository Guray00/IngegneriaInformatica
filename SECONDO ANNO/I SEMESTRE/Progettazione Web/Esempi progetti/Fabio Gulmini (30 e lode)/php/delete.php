<?php
require_once "dbaccess.php";

session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);

if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Parse the JSON data
    $data = json_decode(file_get_contents("php://input"), true);

    $board_id = $data["board_id"];
    $user_id = $_SESSION["user_id"];

    // Check if session_token exists in cookie or in session
    if (!isset($_SESSION["user_id"]) || !isset($_SESSION["token"])) {
        header("HTTP/1.1 401 Unauthorized");
        exit("You must log in to delete a board.");
    }

    // check if the provided token matches the session token for the given user
    if ($_SESSION["token"] !== $_COOKIE["session_token"]) {
        header("HTTP/1.1 401 Unauthorized");
        exit("Invalid session token");
    }

    // Prepare the SQL statement
    $query = $connection->prepare(
        "DELETE FROM boards WHERE board_id = ? AND user_id = ?"
    );
    $query->bind_param("ii", $board_id, $_SESSION["user_id"]);

    $query->execute();

    if ($query->affected_rows > 0) {
        echo json_encode(["status" => "ok"]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to delete board",
        ]);
    }

    // Close the database connection
    $connection->close();
}

?>
