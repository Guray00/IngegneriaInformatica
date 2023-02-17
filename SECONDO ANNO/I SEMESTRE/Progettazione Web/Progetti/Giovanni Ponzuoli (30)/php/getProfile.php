<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection->getPD0();

    $dta = $tir = $scr = $gPL = $gWn = $wVs = $tVs = $lVs = '';

    try{

        //Check sull'inserimento del profilo e dell'avvresario
        if(isset($_POST['pr']) && isset($_POST['vs'])){

            $pfl = $_POST['pr'];
            $opp = $_POST['vs'];

            $sql = "SELECT  RegData,
                            Score
                    FROM    Account 
                    WHERE   Username = '$pfl'";
            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);
            $dta = $row['RegData'];
            $scr = $row['Score'];

            //Assegnazione livello in base allo score
            if ($scr < 150){
                $tir = 'Rookie';
            } else if($scr >= 150 && $scr < 325){
                $tir = 'Intermediate';
            } else if($scr >= 325 && $scr < 500){
                $tir = 'Expert';
            } else if($scr >= 500 && $scr < 725){
                $tir = 'Pro';
            } else if($scr >= 725 && $scr < 1000){
                $tir = 'All-Pro';
            } else{
                $tir = 'Legend';
            }

            // Partite Giocate Finite 
            $sql = "SELECT  COUNT(*)    AS gamesPlayed
                    FROM    game_session 
                    WHERE   User = '$pfl'
                            AND     EndTime IS NOT NULL;";
            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);
            $gPL = $row['gamesPlayed'];


            // Partite Vinte 
            $sql = "SELECT  COUNT(*)    AS gamesWon
                    FROM    game_session 
                    WHERE   User = '$pfl'
                            AND     EndTime IS NOT NULL
                            AND     PointDiff > 0;";
            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);
            $gWn = $row['gamesWon'];
            
            // Numero Partite Vinte contro l'avversario
            $sql = "SELECT  COUNT(*)    AS gamesWonVs
                    FROM    game_session    GS 
                    WHERE   GS.User = '$pfl'
                            AND     GS.EndTime IS NOT NULL
                            AND     GS.PointDiff > 0
                            AND     GS.StartTime            IN  (
                                                                SELECT      GS_.StartTime
                                                                FROM        game_session    GS_
                                                                WHERE       GS_.User = '$opp'
                                                                            AND     GS_.EndTime IS NOT NULL
                                                                );";
            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);
            $wVs = $row['gamesWonVs'];


            // Numero Partite Pareggiate contro l'avversario
            $sql = "SELECT  COUNT(*)    AS gamesTiedVs
                    FROM    game_session    GS 
                    WHERE   GS.User = '$pfl'
                            AND     GS.EndTime IS NOT NULL
                            AND     GS.PointDiff = 0
                            AND     GS.StartTime            IN  (
                                                                SELECT      GS_.StartTime
                                                                FROM        game_session    GS_
                                                                WHERE       GS_.User = '$opp'
                                                                            AND     GS_.EndTime IS NOT NULL
                                                                );";

            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);
            $tVs = $row['gamesTiedVs'];

            
            // Numero Partite Perse contro l'avversario
            $sql = "SELECT  COUNT(*)    AS gamesLostVs
                    FROM    game_session    GS 
                    WHERE   GS.User = '$pfl'
                            AND     GS.EndTime IS NOT NULL
                            AND     GS.PointDiff < 0
                            AND     GS.StartTime            IN  (
                                                                SELECT      GS_.StartTime
                                                                FROM        game_session    GS_
                                                                WHERE       GS_.User = '$opp'
                                                                            AND     GS_.EndTime IS NOT NULL
                                                                );";

            $result = $pdo->prepare($sql);
            $result->execute();

            $row = $result->fetch(pdo::FETCH_ASSOC);
            $lVs = $row['gamesLostVs'];
        }

        $response = [
            'profile' => $pfl,
            'opponent' => $opp,
            'joined' => $dta,
            'tier' => $tir,
            'score' => $scr,
            'played' => $gPL,
            'won' => $gWn,
            'playedVs' => $wVs + $tVs + $lVs,
            'wonVs' => $wVs,
            'tiedVs' => $tVs,
            'lostVs' => $lVs
        ];
    }
    catch(PDOException | Exception $e){
        $response = [
            'get_profile'   => false,
            'message' => 'Profile Failed',
            'error'  => $e->getMessage()
        ];
    }
    
    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>