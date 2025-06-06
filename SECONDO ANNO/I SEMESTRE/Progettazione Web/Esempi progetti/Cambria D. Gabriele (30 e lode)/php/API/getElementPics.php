<?php
require_once __DIR__ . "/../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'])){
    apiError(403);
    exit;
}

$conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
if($conn->connect_error){
	apiError(500, "Connessione al database fallita: " . $conn->connect_error);
}

$stmt = null;

try{
	$sql = "SELECT PathImmagine
			FROM Element
			WHERE PathImmagine IS NOT NULL
			ORDER BY PathImmagine";
	
	$stmt = $conn->prepare($sql);
	if(!$stmt->execute()){
		throw new Exception($stmt->error);
	}

	$result = $stmt->get_result();
	$output = [];
	while($path = $result->fetch_assoc()){
		$output[] = $path['PathImmagine'];
	}

	$output[] = 'images/pics/default.svg';
}
catch(Exception $e){
	apiError(500, "Errore durante il recupero delle Immagini degli Elementi: " . $e->getMessage());
}
finally{
	if($stmt)	$stmt->close();
	$conn->close();
}

header('Content-Type: application/json');
echo json_encode($output);
?>