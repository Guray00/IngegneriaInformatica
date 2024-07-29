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
    
            //Check sull'esistenza dell'user inserito
            $sql = "SELECT COUNT(*) AS regUsr FROM Account WHERE Username = '$usr'";
            $result = $pdo->prepare($sql);
            $result->execute();
            $row = $result->fetch(pdo::FETCH_ASSOC);
            
            if($row['regUsr']){
                $response = "Good";
            }
            else{
                throw new Exception('User does not exists');
            }
    }
    catch(PDOException | Exception $e){
        $response = $e->getMessage();
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>