<?php
    
    define('DBHOST','localhost'); //host user
    define('DBUSER','root'); // lo user
    define('DBPASS',''); // la password dello user
    define('DBNAME','daini_578056'); // nome del database, che deve già esistere
    
    class DBMS{
        
        protected static $connection = null;
        protected static $pdo = null;

        protected static function connectDBMS(){
            if (self::$pdo === null) {
                $dsn = "mysql:host=" . DBHOST . ";dbname=" . DBNAME . ";charset=utf8mb4";
                self::$pdo = new PDO($dsn, DBUSER, DBPASS);
                self::$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            }
        }


        //funzione di utilità per trovare l'id dato lo username dell'utente
        protected static function findIdPlayer($username){
            if($username === null) return null;
            self::connectDBMS();
            $query = "SELECT id FROM Player WHERE username = ?";
            $statement = self::$pdo->prepare($query);
            $result = $statement->execute([$username]);
            $row = $statement->fetch(PDO::FETCH_ASSOC);
            if(!$row) return null;
            $id = $row["id"];
            return $id;
        }

    }

?>