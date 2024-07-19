<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    try {

        if(isset($_POST['lo']) && isset($_POST['lp']) && isset($_POST['rp'])){

            $lo = $_POST['lo'];
            $lp = $_POST['lp'];
            $rp = $_POST['rp'];

            //Update della partita con sconfitta a tavolino sul DB
            if(!$lo){
                $sql = "UPDATE login_session SET DataLogout = current_timestamp(),DataLogin=DataLogin WHERE User='$lp' AND DataLogout IS NULL;
                        UPDATE game_session SET StartTime=StartTime,PointDiff = -16,Helps = 0,Errors = 0,EndTime = current_timestamp() WHERE User ='$lp' AND EndTime IS NULL; 
                        UPDATE game_session SET StartTime=StartTime,PointDiff = 10,Helps = 3,Errors = 0,EndTime = current_timestamp() WHERE User ='$rp' AND EndTime IS NULL;";
            }
            else
            {
                $sql = "UPDATE login_session SET DataLogout = current_timestamp(),DataLogin=DataLogin WHERE User='$rp' AND DataLogout IS NULL;
                        UPDATE game_session SET StartTime=StartTime,PointDiff = 10,Helps = 3,Errors = 0,EndTime = current_timestamp() WHERE User ='$lp' AND EndTime IS NULL; 
                        UPDATE game_session SET StartTime=StartTime,PointDiff = -16,Helps = 0,Errors = 0,EndTime = current_timestamp() WHERE User ='$rp' AND EndTime IS NULL;";
            }
    
            $result = $pdo->prepare($sql);
            $result->execute();
        }
        else
            {
                throw new Exception('Nothing received');
            }
    }
    catch (PDOException | Exception $e){
        $response = [
            'logout'   => false,
            'message' => 'Logout failed',
            'error'  => $e->getMessage()
        ];

        echo json_encode($response);
    }

    $connection->close();
    $pdo = null;

?>