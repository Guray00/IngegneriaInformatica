<?php

require_once __DIR__ . "/../../DBMS/GameDBMS/PrintTableDBMS.php";

function start(){
    $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
    if(!$data || !isset($data["username"])){
        echo json_encode(["success" => false, "message" => "dati mancanti"]);
    }else{
        // se i dati ci sono, possiamo stampare il risultato della tabella che contiene la cronologia dei 20 risultati migliore dell'utente
        $username = $data["username"];
        $usernameVet = [];
        $pointsVet = [];
        $dateVet = [];
        $wonVet = [];
        $results = [$usernameVet,$pointsVet,$dateVet,$wonVet];
        
        $results = PrintTableDBMS::history($username); // all'interno del vettore inseriamo i risultati dell'interrogazione
        
        //messaggio di errore
        if($results === null){ 
            echo json_encode(["success" => false, "message" => "fallimento istruzione"]);
            exit;
        }        

        //messaggio di successo e mandiamo al client in record della tabella
        echo json_encode(["success" => true, "history" => $results, "message" => "interrogazione avvenuta con successo"]);

        exit;
    }

}

start();

?>