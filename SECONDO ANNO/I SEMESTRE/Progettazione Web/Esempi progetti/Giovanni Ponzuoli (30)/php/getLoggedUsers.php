<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    try{
        $sql = "SELECT  COUNT(*)
                        AS lgdUsr
                FROM    login_session 
                WHERE   DataLogout IS NULL ORDER BY DataLogin;";
        $result = $pdo->prepare($sql);
        $result->execute();

        $lgd = $result->fetch(pdo::FETCH_ASSOC);

        $response = $lgd['lgdUsr'];
    }
    catch(PDOException | Exception $e){
        $response = [
            'login'   => false,
            'message' => 'Logout failed',
            'error'  => $e->getMessage()
        ];
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>