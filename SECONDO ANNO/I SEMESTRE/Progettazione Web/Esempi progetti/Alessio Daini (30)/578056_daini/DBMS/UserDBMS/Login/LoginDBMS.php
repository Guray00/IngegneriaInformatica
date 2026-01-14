<?php

require_once __DIR__ . "/../UserDBMS.php";

    class LoginDBMS extends UserDBMS{
        // per il login
        public static function findUser($username,$password){
            if($username === null || $password === null) return null;
            self::connectDBMS();
            $query = "SELECT password FROM Player WHERE username = ?";
            $statement = self::$pdo->prepare($query);
            $result = $statement->execute([$username]);
            $row = $statement->fetch();
            if($row && password_verify($password, $row["password"])){
                return true;
            }
            else return false;
        }
    }
?>