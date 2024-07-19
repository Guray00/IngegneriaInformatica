<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection-> getPD0();

    try{
        //Check sul corretto inserimento dei parametri
        if(empty($_POST['usr'])){
            throw new Exception('Username is too short');
        }
        elseif(preg_match('/[A-Z]/',$_POST['usr'])){
            throw new Exception('Username must be lower case');
        }
        else{
            $usr = filter_input(INPUT_POST,'usr',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
        }

        if(empty($_POST['pwd'])) {
            throw new Exception('Password is too short');
        }
        else{
            $pwd = filter_input(INPUT_POST,'pwd',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
        }

        if($_POST['cpd'] !== $_POST['pwd']){
            throw new Exception('Password do not match');
        }
        else
        {
            $cpd = filter_input(INPUT_POST,'cpd',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
        }

        if(empty($_POST['qst']) || ($_POST['qst'] == 'Select your question')){
            throw new Exception('Select a question');
        }
        else{
            $qst = filter_input(INPUT_POST,'qst',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
        }

        if(empty($_POST['ans'])){
            throw new Exception('Answer is too short');
        }
        else{
            $ans = filter_input(INPUT_POST,'ans',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
        }

        //Aggiunta del nuovo utente sul DB
        $sql = "INSERT INTO Account VALUES ('$usr','$pwd','$qst','$ans',current_timestamp(),0)";
        $result = $pdo->prepare($sql);

        if($result->execute()){
            //Esecuzione avvenuta con successo e inserimento nel DB
            $sql = "INSERT INTO login_session(DataLogin,User) VALUES (current_timestamp(),'$usr')";
            $result = $pdo->prepare($sql);
            $result->execute();
        }
        else
        {
            throw new Exception('Signup failed');
        }
        
        $response = "Good";
    }
    catch (PDOException | Exception $e)
    {
        $e->getCode();
        if($e->getCode() == 23000){
            $response = 'User already exists';
        }else{
            $response = $e->getMessage();
        }
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>