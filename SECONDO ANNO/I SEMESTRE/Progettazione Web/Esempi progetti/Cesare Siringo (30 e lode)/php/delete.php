<?php
require_once "dbcreds.php";

session_start();

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

if($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    $saveId = $data['save_id'];
    $userId = $_SESSION['user_id'];

    // Check if user is authenticated
    if(!isset($_SESSION["user_id"]) || !isset($_SESSION["session_token"])) {
        echo json_encode([
            "status" => "error",
            "message" => "User not authenticated."
        ]);
    }

    // Verify session token matches
    if($_SESSION["session_token"] !== $_COOKIE["session_token"]) {
        echo json_encode([
            "status" => "error",
            "message" => "Session token mismatch."
        ]);
    }

    // Delete the save (only if it belongs to the current user)
    $stmt = $connection->prepare("DELETE FROM saves WHERE save_id = ? AND user_id = ?");
    $stmt->bind_param("ii", $saveId, $userId);

    if($stmt->execute()) {
        if($stmt->affected_rows > 0) {
            echo json_encode([
                "status" => "success",
                "message" => "Save deleted successfully."
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Save not found or you don't have permission to delete it."
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Error deleting save"
        ]);
    }

    $stmt->close();
}

$connection->close();
?>