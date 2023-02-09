<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    try{
        //Check sull'inserimento degli utenti da inserire
        if(isset($_POST['lp']) && isset($_POST['rp']))
        {
            $sql = "INSERT INTO game_session(User,StartTime) VALUES('". $_POST['lp'] . "', CURRENT_TIMESTAMP()),('" . $_POST['rp']. "', CURRENT_TIMESTAMP());";
            $result = $pdo->prepare($sql);
            $result->execute();
        }
    }
    catch (PDOException | Exception $e){
            $response = [
                'game_created'   => false,
                'message' => 'Creation failed',
                'error'  => $e->getMessage()
            ];
    
            echo json_encode($response);
    }

    $connection->close();
    $pdo = null;
?>