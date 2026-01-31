<?php

header("Content-Type: application/json");

require_once __DIR__ . "/../../DBMS/GameDBMS/ModifyTableDBMS.php";

    function checkPOINT($username,$points){
        // se l'utente ha fatto un nuovo record, ne aggiorno il punteggio nella tabella degli utenti
        if(ModifyTableDBMS :: checkPoint($username,$points)){
            ModifyTableDBMS :: updateRecord($username,$points);
            //mando un messaggio di successo
            echo json_encode(["success" => true, "message" => "aggiornamento avvenuto correttamente"]);
        }
        // mando un mesasggio di errore
        else{
            echo json_encode(["success" => false, "message" => "aggiornamento fallito"]);
        }
        
    }

    function DBMSInstructions(){
        $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
        // se non ci sono dati o i dati sono null o false, lancio un messaggio di errore
        if(!$data || !isset($data["username"],$data["points"])){
            echo json_encode(["success" => false, "error" => "Dati mancanti"]);
            return;
        }
        //altrimenti chiamo il metodo checkpoint
        $username = $data["username"];
        $points = (int)$data["points"];
        checkPOINT($username,$points);
    }

    DBMSInstructions();
?>