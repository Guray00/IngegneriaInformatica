<?php

require_once __DIR__ . "/../DBMS.php";

class ModifyTableDBMS extends DBMS{

    //funzione per inserire il risultato della partita
    public static function insertMatch($username,$points,$date,$won){
        if($username === null || $points === null || $date === null || $won === null) return false;
        self::connectDBMS();

        $id = self::findIdPlayer($username);
        if($id === null) return false;
        $query = "INSERT INTO scorePlayer (playerId,points,playerDate,won) VALUES(?,?,?,?)";
        $statement = self::$pdo->prepare($query);
        $boolResult = ($won)? (int)1:(int)0;
        $result = $statement->execute([$id,$points,$date,$boolResult]);
        return true;
    }

    //funzione per verificare se c'è stato un nuovo record
    public static function checkPoint($username,$points){
        if($username === null || $points === null) return null;
        self::connectDBMS();
        $query = "SELECT record FROM Player WHERE username = ?";
        $statement = self::$pdo->prepare($query);
        $result = $statement->execute([$username]);
        $row = $statement->fetch(PDO::FETCH_ASSOC);
        if(!$row) return null;
        $pointsDBMS = $row["record"];
        if($points > $pointsDBMS) return true;
        else return false;
    }

    //funzione per aggiornare il record dell'utente
    public static function updateRecord($username,$points){
        if($username === null || $points === null) return;
        self::connectDBMS();
        $query = "UPDATE Player SET record = ? WHERE username = ?";
        $statement = self::$pdo->prepare($query);
        $result = $statement->execute([$points,$username]);
    }

}

?>