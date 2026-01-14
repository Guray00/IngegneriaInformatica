<?php

header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . "/../../../DBMS/UserDBMS/RecoverPassword/RecoverPasswordDBMS.php";

function checkCorrectAnswer($data){
    //messaggio di fallimento nel caso in cui username è vuoto
    if(!$data || !isset($data["username"]) || trim($data["username"]) === ""){
        echo json_encode(["success" => false,"message" => "Nessun username ricevuto"]);
        exit;
    }
    
    $username = $data["username"];
    $row = RecoverPasswordDBMS:: checkQuestion($username);
    //codifica in json di risposta negativa
    if(!$row){
        echo json_encode(["success"=> false, "message" => "Utente non trovato"]);
        return;
    }

    $answer = $data["answer"];
    //in codifica json la risposta giusta con tanto di info
    if($answer == $row["answer"]){
        echo json_encode(["success" => true, "message" => "Risposta giusta"]);
    }else{
        echo json_encode(["success" => false, "message" => "Risposta errata"]);
    }
    

}

function waitRequest(){
    $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
    checkCorrectAnswer($data);
}


waitRequest();
?>