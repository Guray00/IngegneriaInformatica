<?php
// api/config.php
header('Content-Type: application/json; charset=utf-8');

// configure database connection
$DB_HOST = '127.0.0.1';
$DB_NAME = 'baldacci_673006';
$DB_USER = 'root';
$DB_PASS = '';
$dsn = "mysql:host=$DB_HOST;dbname=$DB_NAME;charset=utf8mb4";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false
];

try {
    // creazione prepared statement
    $pdo = new PDO($dsn, $DB_USER, $DB_PASS, $options);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => '[config.php]: DB connection error',
        'error' => $e->getMessage()
    ]);
    exit;
}
?>