<?php

require_once __DIR__ . "/../DBMS.php";

class UserDBMS extends DBMS{

    // metodo per verificare se la password è presente
    protected static function findPassword($row,$password){
        foreach($row as $record){
            if(password_verify($password,$record["password"])) {
                //restituisco la id della password trovata
                return $record["passwordId"];
            }
        }
        return null;
    }

    protected static function insertPassword($password,$hashedPassword){
        
        //prima parte: cerco tutte le password
        $query = "SELECT * FROM Password";
        $statement = self::$pdo->prepare($query);
        $result = $statement->execute();
        $row = $statement->fetchAll(PDO::FETCH_ASSOC);
        
        $result = self::findPassword($row,$password); 
        // se non sono state trovate, ne inserisco una nuova
        if( $result === null){
            $query2 = "INSERT INTO Password(password) VALUES(?)";
            $statement = self::$pdo->prepare($query2);
            $result = $statement->execute([$hashedPassword]);
            return self::$pdo->lastInsertId();
        }else{
            return $result;
        }
    }

    // inserimento della tabella delle password associato al giocatore che si sta iscrivendo
    protected static function insertSecurity($playerId,$idPassword){
        //essendo che ho chiavi numeriche, posso attivare l'errore 23000
        $query = "INSERT INTO Security(playerId,passwordId) VALUES (?,?)";
        $statement = self::$pdo->prepare($query);
        try{
            $result = $statement->execute([$playerId,$idPassword]);
        }catch(PDOException $e){
            //con questo errore, evito l'inserimento di un utente con la stessa password
            if($e->getCode() !== "23000") throw $e;
        }
    } 

    // inserimento della password
    protected static function insertPasswordPlayer($playerId,$password,$hashedPassword){
        // se posso creo la nuova password in password. Nel caso possiamo comunque inserire nella tabella security la tabella che associa utente e password
        $idPassword = self::insertPassword($password,$hashedPassword);
        //inserimento in security
        self::insertSecurity($playerId,$idPassword);
    }

}
?>