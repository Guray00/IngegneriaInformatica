<?php
require_once "dbaccess.php";
session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if ($connection->connect_error) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => "DB connection failed"]);
    exit;
}

// JOIN per prendere anche l'username
$query = "SELECT g.graph_id, g.name, g.user_id, u.username, g.data, g.created_at
          FROM graphs g
          JOIN users u ON g.user_id = u.user_id
          ORDER BY g.created_at DESC";
$result = $connection->query($query);

$graphs = [];
while ($row = $result->fetch_assoc()) {
    $graphs[] = [
        "id" => $row["graph_id"],
        "name" => $row["name"],
        "author" => $row["username"],
        "data" => json_decode($row["data"], true),
        "created_at" => $row["created_at"]
    ];
}

echo json_encode(["status" => "ok", "graphs" => $graphs]);
$connection->close();
?>