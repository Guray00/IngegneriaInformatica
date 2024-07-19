<?php

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    try {

        if(isset($_POST['lp']) && isset($_POST['rp'])){

            $lp = $_POST['lp'];
            $rp = $_POST['rp'];

            $sql = "DELETE FROM game_session WHERE (User ='$lp' OR User = '$rp') AND EndTime IS NULL;"; 

            $result = $pdo->prepare($sql);
            $result->execute();
        }
        else
            {
                throw new Exception('Data is not enough');
            }
    }
    catch (PDOException | Exception $e){
        $response = [
            'game_deleted' => false,
            'message' => 'Exit failed',
            'error'  => $e->getMessage()
        ];

        echo json_encode($response);
    }

    $connection->close();
    $pdo = null;
?>