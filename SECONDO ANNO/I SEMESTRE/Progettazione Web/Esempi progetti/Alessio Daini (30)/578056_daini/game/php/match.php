<?php

header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ ."/../../DBMS/GameDBMS/ModifyTableDBMS.php";

function receivePackage(){
    $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
    if(!$data || !isset($data["username"],$data["points"],$data["date"],$data["won"])){
        echo json_encode(["success" => false, "message" => "richiesta pacchetto fallita"]);
        return [null,null,null,null];
    } 

    $username = $data["username"];
    $points = $data["points"];
    $date = $data["date"];
    $won = $data["won"];
    return[$username,$points,$date,$won];

}

function start(){
    $username = null;
    $points = null;
    $date = null;
    $won = null;
    [$username,$points,$date,$won] = receivePackage(); // ricevo il pacchetto dati dal client

    //in caso di errore lancio un messaggio che mi indica che il salvataggio non è avvenuto con successo
    if($points === null || $date === null || $username === null || $won === null){
        echo json_encode(["success" => false, "message" => "Non possono esserci username, points o date a null"]);
        exit;
    }

    // se riusciamo a salvare il risultato della partita, mandiamo il messaggio di successo
    if(ModifyTableDBMS::insertMatch($username,$points,$date,$won)){
        echo json_encode(["success" => true, "message" => "Aggiornamento risultato del match avvenuta con successo"]);
        exit;
    //altrimenti mandiamo un messaggio di fallimento
    }else{
        echo json_encode(["success" => false, "message" => "Impossibile aggiornare il risultato"]);
        exit;
    }

}

start();

?>