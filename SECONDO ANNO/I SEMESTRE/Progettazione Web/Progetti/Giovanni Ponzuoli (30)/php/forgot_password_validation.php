<?php

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection-> getPD0();

    try{
            //Check sull'inserimento dei parametri
            if(empty($_POST['usr'])){
                throw new Exception('Username is too short');
            }
            else{
                $usr = filter_input(INPUT_POST,'usr',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
            }

            if(empty($_POST['ans'])){
                throw new Exception('Recovery answer is too short');
            }
            else{
                $ans = filter_input(INPUT_POST,'ans',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
            }

            //Check sulla correttezza della RecAnswer
            $sql = "SELECT  RecAnswer,
                            Password  
                    FROM    Account 
                    WHERE   Username = '$usr'";

            $result = $pdo->prepare($sql);
            $result->execute();
            $row = $result->fetch(PDO::FETCH_ASSOC);
            
            if($ans == $row['RecAnswer']){
                $response = [
                    'vld' => 1,
                    'pwd' => $row['Password']
                ];
            }
            else{
                throw new Exception('Wrong Answer');
            }
    }
    catch(PDOException | Exception $e){
        $response = [
            'vld' => 0,
            'msg' => $e->getMessage()
        ];
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>