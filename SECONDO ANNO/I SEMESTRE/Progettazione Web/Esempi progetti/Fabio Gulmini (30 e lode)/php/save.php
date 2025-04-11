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

    $board = $data["board"];
    $board_name = $data["name"];
    $user_id = $_SESSION["user_id"];

    // Check if session_token exists in cookie or in session
    if (!isset($_SESSION["user_id"]) || !isset($_SESSION["token"])) {
        header("HTTP/1.1 401 Unauthorized");
        exit("You must log in to save a board.");
    }

    // check if the provided token matches the session token for the given user
    if ($_SESSION["token"] !== $_COOKIE["session_token"]) {
        header("HTTP/1.1 401 Unauthorized");
        exit("Invalid session token");
    }
    // Prepare the SQL statement
    $query = $connection->prepare(
        "INSERT INTO boards (name, user_id, repr) VALUES (?, ?, ?)"
    );
    $query->bind_param("sis", $board_name, $_SESSION["user_id"], $board);

    $query->execute();

    if ($query->affected_rows > 0) {
        $board_id = $query->insert_id;

        // Fetch the creation timestamp
        $timestamp_query = $connection->prepare(
            "SELECT creation_timestamp FROM boards WHERE board_id = ?"
        );
        $timestamp_query->bind_param("i", $board_id);
        $timestamp_query->execute();
        $timestamp_result = $timestamp_query->get_result();
        $timestamp_row = $timestamp_result->fetch_assoc();

        echo json_encode([
            "status" => "ok",
            "data" => [
                "board_name" => $board_name,
                "user_id" => $_SESSION["user_id"],
                "board" => $board,
                "board_id" => $board_id,
                "timestamp" => $timestamp_row["creation_timestamp"],
            ],
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to save board",
        ]);
    }

    // Close the database connection
    $connection->close();
}

?>
