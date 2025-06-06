<?php
require_once __DIR__ . "/../includes/methods.php";

session_start();

if(!isset($_SERVER['REQUEST_METHOD']) || basename($_SERVER['HTTP_REFERER']) !== 'dashboard.php'){
	pageError("403");
}
if (!isset($_SESSION['accountID'])){
	pageError("401");
}


$account = null;
$accountId = unserialize($_SESSION['accountID']);
try {
	$account = new Account($accountId, true);
} 
catch (Exception $e) {
	terminateChangeError($e->getMessage(), $e->getCode());
}

$conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
if($conn->connect_error){
	terminateChangeError("connection_failed", 500);
}

$logout = true;
$stmtCheck = null;
$stmtUpdate = null;

$conn->begin_transaction();
try{
	if(isset($_POST['username'])){
		// Cambio username
		$logout = false;
		$newUsername = $_POST['username'];

		$errorType = validateInputs($newUsername, VALID_PASSWORD, VALID_PASSWORD);

		if(!empty($errorType)){
			throw new Exception($errorType, 400);
		}

		// Verifico non sia uguale a quello attuale
		if($newUsername === $account->getUsername()){
			throw new Exception("username_same_as_current", 400);
		}

		$sqlCheck = "SELECT ID
					 FROM Account
					 WHERE Username = ?";

		$stmtCheck = $conn->prepare($sqlCheck);
		$stmtCheck->bind_param("s", $newUsername);
		if(!$stmtCheck->execute()){
			throw new Exception($stmtCheck->error, $stmtCheck->errno);
		}
		$result = $stmtCheck->get_result();

		if($result->num_rows > 0){
			throw new Exception("username_taken", 400);
		}


		$sqlUpdate = "UPDATE Account SET Username = ? WHERE ID = ?";

		$stmtUpdate = $conn->prepare($sqlUpdate);
		$stmtUpdate->bind_param("si", $newUsername, $accountId);
		if(!$stmtUpdate->execute()){
			throw new Exception($stmtUpdate->error, $stmtUpdate->errno);
		}

		$message = "Username aggiornato correttamente";
	}
	else if(isset($_POST['password']) && isset($_POST['confirmPassword'])){
		// Cambio Password
		$newPassword = $_POST['password'];
		$confirmPassword = $_POST['confirmPassword'];

		$errorType = validateInputs(VALID_USERNAME, $newPassword, $confirmPassword);

		if(!empty($errorType)){
			throw new Exception($errorType, 400);
		}

		// Verifico non sia uguale a quella attuale
		$sqlCheck = "SELECT Password
					 FROM Account
					 WHERE ID = ?";

		$stmtCheck = $conn->prepare($sqlCheck);
		$stmtCheck->bind_param('i', $accountId);
		if(!$stmtCheck->execute()){
			throw new Exception($stmtCheck->error);
		}
		$result = $stmtCheck->get_result();

		$currentPassword = $result->fetch_assoc();

		if(password_verify($newPassword, $currentPassword["Password"])){
			terminateChangeError("password_same_as_current", 400);
		}

		$hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);

		$sqlUpdate = "UPDATE Account SET Password = ? WHERE ID = ?";
		$stmtUpdate = $conn->prepare($sqlUpdate);
		$stmtUpdate->bind_param('si', $hashedPassword, $accountId);

		if(!$stmtUpdate->execute()){
			throw new Exception($stmtUpdate->error, $stmtUpdate->errno);
		}

		$message = "Password aggiornata correttamente. \n Effettuare nuovamente il login";
	}
	else if(isset($_POST['deleteCheck'])){
		// Elimina Account

		$password = $_POST['password'];

		$errorType = validateInputs(VALID_USERNAME, $password, $password);

		if(!empty($errorType)){
			throw new Exception($errorType, 400);
		}

		$sqlCheck = "SELECT Password
					 FROM Account
					 WHERE ID = ?";

		$stmtCheck = $conn->prepare($sqlCheck);
		$stmtCheck->bind_param('i', $accountId);
		if(!$stmtCheck->execute()){
			throw new Exception($stmtCheck->error);
		}
		$result = $stmtCheck->get_result();

		$currentPassword = $result->fetch_assoc();

		if(!password_verify($password, $currentPassword["Password"])){
			terminateChangeError("wrong_password_on_delete", 400);
		}

		$sqlDelete = "DELETE FROM Account WHERE ID = ?";
		$stmtDelete = $conn->prepare($sqlDelete);
		$stmtDelete->bind_param('i', $accountId);
		if (!$stmtDelete->execute()){
			throw new Exception($stmtDelete->error);
		}

		$message = "Account eliminato con successo";
	}
	else if(isset($_POST['newPic'])){
		// Cambia Icona dell'account
		$logout = false;
		$newPath = $_POST['newPic'];
		
		
		if($newPath === $account->getImmagineProfilo()){
			throw new Exception('image_same_as_current', 400);
		}

		$sqlUpdate = "UPDATE Account SET ImmagineProfilo = ? WHERE ID = ?";
		
		$stmtUpdate = $conn->prepare($sqlUpdate);
		$stmtUpdate->bind_param("si", $newPath, $accountId);
		if(!$stmtUpdate->execute()){
			throw new Exception($stmtUpdate->error, $stmtUpdate->errno);
		}

		$message = "Immagine cambiata con successo!";
	}
	else{
		throw new Exception("invalid_param", 400);
	}

	$conn->commit();
	terminateChange($logout,$message);
}
catch(Exception $e){
	$conn->rollback();
	terminateChangeError($e->getMessage(), $e->getCode());
}
finally{
	if($stmtCheck)	$stmtCheck->close();
	if($stmtUpdate)	$stmtUpdate->close();
	$conn->close();
}


/**
 * Termina il processo di cambio credenziali in caso di errore.
 * Imposta un messaggio di errore nella sessione, chiude la sessione e reindirizza alla dashboard.
 *
 * @param string $errorType Tipo di errore (chiave di ERROR_TYPES o messaggio personalizzato)
 * @param int $errorCode Codice di errore HTTP o personalizzato
 * @return void
 */
function terminateChangeError($errorType, $errorCode){
	error_log($errorType);

	$errorMessage = ERROR_TYPES[$errorType] ?? ERROR_TYPES['defualt'];

	$_SESSION['errorMessage'] = [
		"message" => $errorMessage,
		"errorCode" => $errorCode
	];

	session_write_close();
	header("Location: ./../pages/dashboard.php");
	exit();
}

/**
 * Termina il processo di cambio credenziali in caso di successo.
 * Imposta un messaggio di successo nella sessione, chiude la sessione e reindirizza alla dashboard o al logout.
 *
 * @param bool $logout Se true effettua il logout, altrimenti torna alla dashboard
 * @param string $message Messaggio di successo da mostrare all'utente
 * @return void
 */
function terminateChange($logout, $message){
	$direction = $logout? "./logout.php" : "./../pages/dashboard.php";

	$_SESSION["message"] = $message;
	session_write_close();
	header("Location: ". $direction);
	exit();
}
?>