<?php

// DB: WU
// Account (ID, Username, Hash, Question, Answer)
// Game (ID, BoardSize, Account)
// Move (Game, Step, Player, Move)

class connectDB{
    public $pdo;

    function __construct(){
        try {
            $connString = "mysql:host=127.0.0.1;dbname=WU";
            $user = "root";
            $pass = "";
            
            $this->pdo = new PDO($connString, $user, $pass, array(
                PDO::ATTR_PERSISTENT => false
            ));

        } catch (PDOException $e) {

			$response = ['error' => $e->getMessage()];
			die(json_encode($response));
			
        }
    }

    function getPDO(){
        return $this->pdo;
    }

    function close(){
        $this->pdo = null;
    }
}

?>
