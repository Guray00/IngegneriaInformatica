<?php
require_once __DIR__ ."/../../../DBMS/UserDBMS/SignUp/SignUpDBMS.php";
header('Content-Type: application/json; charset=utf-8');

function signup(){
    $data = json_decode(file_get_contents("php://input"),true);//recupero pacchetto ricevuto da javascript
    if( $data && isset($data["username"], $data["password"], $data["question"], $data["answer"]) 
        && trim($data["username"]) !== "" && trim($data["password"]) !== "" && trim($data["question"]) !== "" 
        && trim($data["answer"]) !== ""){
        
            $username = $data["username"];
            $password = $data["password"];
            $domanda = $data["question"];
            $risposta = $data["answer"];

            //inserimento del giocatore nella tabella Player e lancio del messaggio positivo
            if(SignUpDBMS::insertPlayer($username,$password,$domanda,$risposta)){ 
                echo json_encode(["success" => true, "message" => "iscrizione avvenuta con successo"]);
                exit;
            }
            else{
                echo json_encode(["success" => false, "message" => "username già esistente; per cortesia, provare con un altro"]);
                exit;
            }
        }

    // QUESTO È IL BLOCCO MANCANTE: Gestione del fallimento di validazione iniziale
    echo json_encode(["success" => false, "message" => "Dati mancanti o non validi."]);
    exit;
}

signup();


?>