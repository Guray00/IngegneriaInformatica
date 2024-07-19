<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    try{
        $sql = "SELECT User FROM login_session WHERE DataLogout IS NULL ORDER BY DataLogin";
        $result = $pdo->prepare($sql);
        $result->execute();

        $lftUsr = $result->fetch(pdo::FETCH_ASSOC);
        $rgtUsr = $result->fetch(pdo::FETCH_ASSOC);

        $response = [
            'lp' => $lftUsr['User'],
            'rp' => $rgtUsr['User']
        ];
    }
    catch(PDOException | Exception $e){
        $response = "notGood";
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>