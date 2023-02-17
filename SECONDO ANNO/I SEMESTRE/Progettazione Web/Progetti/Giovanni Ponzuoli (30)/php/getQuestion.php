<?php

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    $response = '';

    try {
        if(isset($_POST['usr'])){
            $usr = $_POST['usr'];

            $sql = "SELECT 	RQ.QuestionBody	AS Question
                    FROM 	account A
                            INNER JOIN 
                            recovery_question RQ 	    ON A.RecQuestion = RQ.QuestionID
                    WHERE 	A.Username = '$usr';";

            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);

            $response = $row['Question'];
        }
        else{
            throw new Exception('Question not found');
        }
    }
    catch(PDOException | Exception $e){
        $response = "notGood";
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>