<?php

require_once __DIR__ . "/../UserDBMS.php";

    class RecoverPasswordDBMS extends UserDBMS{
        
        // aggiornamento password
        public static function updatePassword($username,$password){
            if($username === null || $password === null) return false;
            self::connectDBMS();
            // mi trovo l'id dell'utente
            $id = self::findIdPlayer($username);
            if($id === null) return false;
            //per lo stesso utente trovo più password
            $query = "SELECT P.password FROM Security S NATURAL JOIN Password P WHERE S.playerId = ?";
            $statement = self::$pdo->prepare($query);
            $result = $statement->execute([$id]);
            //cerco di vedere se ci sono password 
            $row = $statement->fetchAll(PDO::FETCH_ASSOC);
            foreach($row as $record){
                // a questo punto verifico con password_verify che la password in chiaro sia uguale a quello che è salvato nella tabella hashata
                if($record && password_verify($password,$record["password"])){
                    return false;
                }
            }

            //possiamo dire che non abbiamo trovato l'utente con la password corrente, quindi posso aggiornarlo
            $sql = "UPDATE Player SET password = ? WHERE username = ?";
            $statement2 = self::$pdo->prepare($sql);
            $hashedPassword = password_hash($password,PASSWORD_BCRYPT);
            $result2 = $statement2->execute([$hashedPassword,$username]);
            if($result2){
                //inserisco la password eventualmente nella tabella password e nella tabella security
                $idPassword = self::insertPassword($password,$hashedPassword);
                self::insertSecurity($id,$idPassword);
                return true;
            }
            
            return false; 
        }

        // trovare la risposta per il recupero password
        public static function findQuestionAnswer($username){
            if($username === null) return null;
            self::connectDBMS();
            $query = "SELECT question FROM Player WHERE username = ?";
            $result = self::$pdo->prepare($query);
            $result->execute([$username]);
            $row = $result->fetch(PDO::FETCH_ASSOC);
            return $row;
        }

        // verificare la domanda, dato lo username, per il recupero la password
        public static function checkQuestion($username){
            if($username === null) return null;
            self::connectDBMS();
            $query = "SELECT answer FROM Player WHERE username = ?";
            $result = self::$pdo->prepare($query);
            $result->execute([$username]);
            $row = $result->fetch(PDO::FETCH_ASSOC);
            return $row;
        }

    }
?>