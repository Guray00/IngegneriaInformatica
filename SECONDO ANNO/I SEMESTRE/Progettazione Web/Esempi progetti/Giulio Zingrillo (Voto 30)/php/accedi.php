<?php
   
    $regexusr = "/[A-Za-z0-9_]{4,10}/";
    $regexppw = "/[A-Za-z0-9'$'+'@]{4,16}/";
    $errore = false;

    //verifico se è stata sottomessa una richiesta di login
    if(isset($_POST['login'])&&isset($_POST['username'])&&isset($_POST['password'])){
   
        $username = $_POST['username'];
        $password = $_POST['password'];
        //verifico i dati anche lato server
        if(preg_match($regexusr, $username)&&preg_match($regexppw, $password)){
             // mi connetto al db
             require "dbaccess.php";
             $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
             if(mysqli_connect_errno())
                 die(mysqli_connect_error());
 
             
 
             //preparo lo statement e accedo al db
 
             $query = "select * from utente where Username=?;";
             if($statement = mysqli_prepare($connection, $query)){
                 mysqli_stmt_bind_param($statement, 's', $username);
         
                 mysqli_stmt_execute($statement);
                 $result = mysqli_stmt_get_result($statement);
                 if(mysqli_num_rows($result)===0){
                    $errore = true;
                    
                 }
                     
                 else{
                    $row =mysqli_fetch_assoc($result);
                    $hash=$row['Password'];
                    if(password_verify($password, $hash)){
                        require_once "controllo.php";
                        //imposto le variabili di sessione
                        $_SESSION["UID"] = $row['Id'];
                        $_SESSION["Nome"] = $row['Nome'];
                        $_SESSION["Cognome"] = $row['Cognome'];
                        $_SESSION["Username"] = $row['Username'];
                        $_SESSION["Ruolo"] = $row['Ruolo'];


                    
                        header("location: index.php");
                    }
                    else $errore = true;

                 }
                     
                     
         
             }
             else {
                 die(mysqli_connect_error());
             }
        }
        else{
            echo "<script>window.alert('La richiesta è in un formato non corretto')</script>";
        }
            
           


    }

?>

<!-- Giulio Zingrillo - Progetto di Progettazione Web - Gennaio 2024 -->
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            Volley World - Accedi
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/login.js"></script>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="author" content="Giulio Zingrillo">
        <meta name="description" content="A volleyball competition manager">
        <meta name="generator" content="VSCode">
        <meta name="keywords" content=" Volley">
        
         
    </head>
    <body onload="init()">
        <header>
            
        <a href="index.php" id='linkheader'><div>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
                <h1>Volley World</h1>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
            
            </div>
</a>
            <br>
            <h2>
                Spazio al gioco
            </h2>
        </header>
        <main>
            <form id="loginform" action="accedi.php" method="post">
                <h2>
                    Bentornato!
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label for="username">Username: </label>
                        <label for="password">Password: </label>
                    </div>
                    <div id="inputlogin">
                        <input type="text" id="username" name="username" pattern="[A-Za-z0-9_]{4,10}">
                        <input type="password" id="password" name="password" pattern="[A-Za-z0-9'$'+'@]{4,16}">
                        

                    </div>

                </fieldset>
                <?php
            
                if($errore)
                    echo '<p id="errorelogin">Lo username o la password non sono corretti. Si prega di riprovare.</p>';
                
                ?>
                <input type="submit" value="Accedi" name="login">
                <br>
                <a href="registrazione.php"> Non hai ancora un account? Registrati qui.</a>
            </form>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>