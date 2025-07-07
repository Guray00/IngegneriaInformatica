<?php
require_once "dbaccess.php";

session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);

if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data["name"]) || !isset($data["data"])) {
        http_response_code(400);
        echo json_encode(["status" => "error", "message" => "Dati mancanti"]);
        exit;
    }

    if (!isset($_SESSION["user_id"]) || !isset($_SESSION["token"])) {
        http_response_code(401);
        exit("You must log in to save a graph.");
    }
    if ($_SESSION["token"] !== ($_COOKIE["session_token"] ?? null)) {
        http_response_code(401);
        exit("Invalid session token");
    }

    $graph_name = $data["name"];
    $user_id = $_SESSION["user_id"];
    $graph_data = json_encode($data["data"]);

    $query = $connection->prepare(
        "INSERT INTO graphs (name, user_id, data) VALUES (?, ?, ?)"
    );
    $query->bind_param("sis", $graph_name, $user_id, $graph_data);
    $query->execute();

    if ($query->affected_rows > 0) {
        $graph_id = $query->insert_id;

        $timestamp_query = $connection->prepare(
            "SELECT created_at FROM graphs WHERE graph_id = ?"
        );
        $timestamp_query->bind_param("i", $graph_id);
        $timestamp_query->execute();
        $timestamp_result = $timestamp_query->get_result();
        $timestamp_row = $timestamp_result->fetch_assoc();

        echo json_encode([
            "status" => "ok",
            "data" => [
                "graph_id" => $graph_id,
                "name" => $graph_name,
                "user_id" => $user_id,
                "created_at" => $timestamp_row["created_at"],
            ],
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to save graph",
        ]);
    }

    $connection->close();
}
?>