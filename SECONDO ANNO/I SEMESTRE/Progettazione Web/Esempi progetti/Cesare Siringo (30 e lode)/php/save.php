<?php
require_once "dbcreds.php";

session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

if($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    $saveName = $data['save_name'];
    $saveData = $data['save_data'];
    $userId = $_SESSION['user_id'];

    if(!isset($_SESSION["user_id"]) || !isset($_SESSION["session_token"])) {
        echo json_encode([
            "status" => "error",
            "message" => "User not authenticated."
        ]);
        exit("User not authenticated.");
    }

    if($_SESSION["session_token"] !== $_COOKIE["session_token"]) {
        echo json_encode([
            "status" => "error",
            "message" => "Session token mismatch."
        ]);
        exit("Session token mismatch.");
    }

    $stmt = $connection->prepare("INSERT INTO saves (user_id, name, data) VALUES (?, ?, ?)");
    $stmt->bind_param("iss", $userId, $saveName, $saveData);
    if($stmt->execute()) {
        $saveId = $stmt->insert_id;
        $stmt->close();

        echo json_encode([
            "status" => "success",
            "message" => "Save created successfully.",
            "save_id" => $saveId
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Error creating save: " . $stmt->error
        ]);
    }
}

$connection->close();
?>