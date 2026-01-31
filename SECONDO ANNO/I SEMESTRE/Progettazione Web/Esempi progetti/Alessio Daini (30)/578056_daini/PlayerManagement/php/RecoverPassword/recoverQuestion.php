<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ ."/../../../DBMS/UserDBMS/RecoverPassword/RecoverPasswordDBMS.php";

function recoverQuestion($data){
    //messaggio di fallimento nel caso in cui username è vuoto
    if(!$data || !isset($data["username"]) || trim($data["username"]) === ""){
        echo json_encode(["success" => false, "message" => "Nessun username ricevuto"]);
        exit;
    }

    //username ricevuto dal dato
    $username = $data["username"];
    //elementi della riga
    $row = RecoverPasswordDBMS::findQuestionAnswer($username);
    //codifica in json di risposta negativa
    if(!$row){
        echo json_encode(["success"=> false, "message" => "Utente non trovato"]);
        return;
    }
    //domanda
    $question = $row["question"];

    //in codifica json la risposta giusta con tanto di info
    echo json_encode(["success" => true, "question" => $question]);

}

function waitPacket(){
    $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
    recoverQuestion($data);
}

waitPacket();

?>