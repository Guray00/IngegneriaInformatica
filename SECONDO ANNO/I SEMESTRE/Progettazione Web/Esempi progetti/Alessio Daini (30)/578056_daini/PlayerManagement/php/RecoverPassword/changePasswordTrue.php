<?php
header('Content-Type: application/json');
require_once __DIR__ . "/../../../DBMS/UserDBMS/RecoverPassword/RecoverPasswordDBMS.php";

function askPassword($data){

    if(!$data || !isset($data["username"],$data["password"])){
        echo json_encode(["success" => false, "message" => "Username o domanda non correttamente ricevute"]);
        exit;
    }  
    
    $password = $data["password"];
    $username = $data["username"];
    //aggiornamento della password per l'utente
    if(RecoverPasswordDBMS::updatePassword($username,$password)){
       echo json_encode(["success" => true, "message" => "Password cambiata"]);
    }else{
        echo json_encode(["success" => false, "message" => "Impossibile cambiare la password"]);
    }
    
}


function waitPacketPassword(){
    $data = json_decode(file_get_contents("php://input"),true); // decodifica dal pacchetto mandato da javascript
    askPassword($data);
}

waitPacketPassword();

?>