<?php 

    if(session_status() === PHP_SESSION_NONE){
        session_start();
    }

    require_once '../config/database.php';

    $connection = new cncDB();
    $pdo = $connection-> getPD0();

    $lftUsr = $lftPwd = $rgtUsr = $rgtPwd = '';
    $lftUsrErr = $lftPwdErr = $rgtUsrErr = $rgtPwdErr = '';

    try{
        //Check sulla corretta validazione del form selezionato
        if(isset($_POST['ont'])){
            
            $ont = $_POST['ont'];

            if(!$ont){
                //Check sul corretto inserimento dei parametri
                if(empty($_POST['usr'])){
                    throw new Exception('Username is too short');
                }
                else{
                    $lftUsr = filter_input(INPUT_POST,'usr',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
                }

                if(empty($_POST['pwd'])) {
                    throw new Exception('Password is too short');
                }
                else{
                    $lftPwd = filter_input(INPUT_POST,'pwd',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
                }

                    //Check sull'esistenza dell'user nel DB
                    $sql = "SELECT COUNT(*) AS regUsr FROM Account WHERE Username = '$lftUsr'";
                    $result = $pdo->prepare($sql);
                    $result->execute();
                    $row = $result->fetch(pdo::FETCH_ASSOC);

                    if($row['regUsr']){

                        $sql = "SELECT Username FROM Account WHERE Username = '$lftUsr'";
                        $result = $pdo->prepare($sql);
                        $result->execute();
                        $usrChk = $result->fetch(pdo::FETCH_ASSOC);
                    
                        if($usrChk['Username'] !== null){
        
                            $sql = "SELECT Password FROM Account WHERE Username = '$lftUsr'";
                            $result = $pdo->prepare($sql);
                            $result->execute();
                            $pwdChk = $result->fetch(pdo::FETCH_ASSOC);

                            //Check sulla corretta immissione della password di conferma
                            if($lftPwd === $pwdChk['Password']){
                                
                                $sql = "INSERT INTO login_session(DataLogin,User) VALUES (current_timestamp(),'$lftUsr')";
                                $result = $pdo->prepare($sql);

                                if($result->execute()){
                                    $response = 'Good';
                                }
                            }
                            else {
                                throw new Exception('Incorrect Password');
                            }   
                        }
                        else{
                            throw new Exception('Login failed');
                        }            
                    }
                    else{
                        throw new Exception('User does not exists');
                    }
            }
            else{
                //Check sul corretto inserimento dei parametri
                if(empty($_POST['usr'])){
                    throw new Exception('Username is too short');
                }
                else{
                    $rgtUsr = filter_input(INPUT_POST,'usr',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
                }

                if(empty($_POST['pwd'])) {
                    throw new Exception('Password is too short');
                }
                else{
                    $rgtPwd = filter_input(INPUT_POST,'pwd',FILTER_SANITIZE_FULL_SPECIAL_CHARS);
                }

                //Check sull'esistenza dell'user nel DB
                $sql = "SELECT COUNT(*) AS regUsr FROM Account WHERE Username = '$rgtUsr'";
                $result = $pdo->prepare($sql);
                $result->execute();
                $row = $result->fetch(pdo::FETCH_ASSOC);

                if($row['regUsr']){
                
                    $sql = "SELECT Username FROM Account WHERE Username = '$rgtUsr'";
                    $result = $pdo->prepare($sql);
                    $result->execute();
                    $usrChk = $result->fetch(pdo::FETCH_ASSOC);
                    
                    //Check sulla corretta immissione della password di conferma

                    if($usrChk['Username'] !== null){
                        
                        $sql = "SELECT Password FROM Account WHERE Username = '$rgtUsr'";
                        $result = $pdo->prepare($sql);
                        $result->execute();
                        $pwdChk = $result->fetch(pdo::FETCH_ASSOC);

                        if($rgtPwd === $pwdChk['Password']){
                            //Add row to the DB
                            $sql = "INSERT INTO login_session(DataLogin,User) VALUES (current_timestamp(),'$rgtUsr')";
                            $result = $pdo->prepare($sql);

                            if($result->execute()){
                                $response = 'Good';
                            }
                        }
                        else{
                            throw new Exception('Incorrect Password');
                        }
                    }else {
                        throw new Exception('Login failed');
                    }            
                }
                else{
                    throw new Exception('User does not exist');
                }
            }
        }
    }   
    catch(PDOException | Exception $e){
        $e->getCode();
        if($e->getCode() == 45000){
            $response = 'User already logged in';
        }else{
            $response = $e->getMessage();
        }
    }

    echo json_encode($response);

    $connection->close();
    $pdo = null;

?>