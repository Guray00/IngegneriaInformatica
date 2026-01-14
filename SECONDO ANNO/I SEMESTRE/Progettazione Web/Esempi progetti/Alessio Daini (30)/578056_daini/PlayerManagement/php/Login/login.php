<?php
require_once __DIR__ . "/../../../DBMS/UserDBMS/Login/LoginDBMS.php";
header('Content-Type: application/json; charset=utf-8');

//funzione per settare il cookie
function sendCookie($username){

    $scriptPath = $_SERVER['PHP_SELF']; // ".\578056_daini\PlayerManagement\php\Login\login.php
    
    $projectRoot = strstr($scriptPath, '/PlayerManagement', true); // ".\578056_daini"
    
    $path = $projectRoot . '/game';// ".\578056_daini\game"
    
    setcookie("username", $username, 0, $path);// settare il cookie nella cartella .\578056_daini\game, che scade all'uscita dal percorso
    
}

//funzione per il login
function login(){

    $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
    
    if($data && isset($data["username"],$data["password"]) && trim($data["username"]) !== "" && trim($data["password"]) !== ""){
        $username = $data["username"];
        $password = $data["password"];
    
        try{
            // se l'utente è stato trovato con username e password, setto il cookie e lancio un messaggio di successo
            if(LoginDBMS::findUser($username,$password)){
                sendCookie($username);
                echo json_encode(["success" => true, "message" => "utente identificato correttamente"]);
                exit;
            } else {
                // Login fallito
                echo json_encode(["success" => false, "message" => "Username o password errati"]);
                exit;
            }
    
        }catch(PDOException $e){
            echo json_encode(["success" => false, "message" => $e->getMessage()]);
            exit;
        }
    }

}

login();

?>
