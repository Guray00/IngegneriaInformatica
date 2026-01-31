<?php

require_once __DIR__ . "/../UserDBMS.php";

    class SignUpDBMS extends UserDBMS{
        
        // inserimento del giocatore
        public static function insertPlayer($username,$password,$domanda,$risposta){
            if($username === null || $password === null || $domanda === null || $risposta === null) return null;
            self::connectDBMS();
            //cripto la password
            $hashedPassword = password_hash($password,PASSWORD_BCRYPT); // questo è in formato hash
            $query = "INSERT INTO Player(username,password,question,answer) VALUES(?,?,?,?)";
            $statement = self::$pdo->prepare($query);
            try{
                $result = $statement->execute([$username,$hashedPassword,$domanda,$risposta]);
            }catch(PDOException $e){
                if($e->getCode() !== "23000") throw $e;
                // in caso di chiave dupplicata, annullo l'inserimento
                return false;
            }
            //se inserisco con successo il giocatore, inserisco la password dentro il sistema
            if($result){
                $playerId = self::$pdo->lastInsertId();
                self::insertPasswordPlayer($playerId,$password,$hashedPassword);
                return true;
            } else return false;
            
        }
    }
?>