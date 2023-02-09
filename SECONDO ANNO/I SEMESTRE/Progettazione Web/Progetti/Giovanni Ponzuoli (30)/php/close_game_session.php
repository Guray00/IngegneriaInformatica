<?php

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    try {

        if(isset($_POST['lp']) && isset($_POST['rp']) && isset($_POST['lPo']) && isset($_POST['rPo']) && isset($_POST['lHe']) && isset($_POST['rHe']) && isset($_POST['lEr']) && isset($_POST['rEr'])){

            $lp = $_POST['lp'];
            $rp = $_POST['rp'];
            $lPo = $_POST['lPo'];
            $rPo = $_POST['rPo'];
            $lHe = $_POST['lHe'];
            $rHe = $_POST['rHe'];
            $lEr = $_POST['lEr'];
            $rEr = $_POST['rEr'];

            $sql = "UPDATE game_session SET PointDiff = '$lPo' - '$rPo',Helps = '$lHe',Errors = '$lEr',StartTime = StartTime,EndTime = current_timestamp() WHERE User ='$lp' AND EndTime IS NULL; 
                    UPDATE game_session SET PointDiff = '$rPo' - '$lPo',Helps = '$rHe',Errors = '$rEr',StartTime = StartTime,EndTime = current_timestamp() WHERE User ='$rp' AND EndTime IS NULL;"; 

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
            'game_closed'   => false,
            'message' => 'Exit failed',
            'error'  => $e->getMessage()
        ];

        echo json_encode($response);
    }

    $connection->close();
    $pdo = null;
?>