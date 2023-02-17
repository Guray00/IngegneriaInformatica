<?php

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    $response = '';

    try {
        //Check sull'inseriemnto dell'account
        if(isset($_POST['pfl'])){
            $pfl = $_POST['pfl'];

            $sql = "SELECT  Password
                    FROM    Account
                    WHERE   Username = '$pfl';";

            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);

            $response = $row['Password'];
        }
        else{
            throw new Exception('No profiles found');
        }
    }
    catch(PDOException | Exception $e){
        $response = [
            'get_password'   => false,
            'message' => 'Get Failed',
            'error'  => $e->getMessage()
        ];
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>