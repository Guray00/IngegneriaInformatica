<?php
   
    $regexusr = "/[A-Za-z0-9_]{4,10}/";
    $regexppw = "/[A-Za-z0-9'$'+'@]{4,16}/";
    $regexnome = "/[A-Za-z' ]{2,20}/";
    $regexruolo = "/(1|2)/";
    $errore = false;
    //verifico che sia stata sottomessa una richiesta di registrazione
    if(isset($_POST['registrati'])&&isset($_POST['username'])&&isset($_POST['password'])&&isset($_POST['nome'])&&isset($_POST['cognome'])&&isset($_POST["ruolo"])){
        //verifico i dati lato server
   
        $username = $_POST['username'];
        $password = $_POST['password'];
        $nome = $_POST['nome'];
        $cognome = $_POST['cognome'];
        $ruolo = $_POST['ruolo'];
        if(preg_match($regexusr, $username)&&preg_match($regexppw, $password)&&preg_match($regexnome, $nome)&&preg_match($regexnome, $cognome)&&preg_match($regexruolo, $ruolo)){
             // mi connetto al db
             require_once "dbaccess.php";
             $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
             if(mysqli_connect_errno())
                 die(mysqli_connect_error());
 
             
 
             //preparo lo statement e accedo al db
 
             $query = "select * from utente where Username=?;";
             if($statement = mysqli_prepare($connection, $query)){
                 mysqli_stmt_bind_param($statement, 's', $username);
         
                 mysqli_stmt_execute($statement);
                 $result = mysqli_stmt_get_result($statement);
                 if(mysqli_num_rows($result)!==0){
                    $errore = true;
                    //se esiste già un utente con quel nome, si verifica un errore
                 }
                     
                 else{
                    //creo l'utente e reindirizzo al login
                    $query = "insert into utente (Ruolo, Nome, Cognome, Username, Password) values (?, ?, ?, ?, ?)";
                    if($statement = mysqli_prepare($connection, $query)){
                        $password = password_hash($password, PASSWORD_BCRYPT);
                        mysqli_stmt_bind_param($statement, 'issss', $ruolo, $nome, $cognome, $username, $password);
                
                        mysqli_stmt_execute($statement);
                        header("location: accedi.php");
                    }
                 
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
            Volley World - Registrazione
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/registrazione.js"></script>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="author" content="Giulio Zingrillo">
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
            <form id="loginform" action="registrazione.php" method="post">
                <h2>
                    Benvenuto!
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label for="nome">Nome: </label>
                        <label for="cognome">Cognome: </label>
                        <label for="username">Username: </label>
                        <label for="password">Password: </label>
                        <label for="ruolo">Ruolo: </label>
                    </div>
                    <div id="inputlogin">
                        <input type="text" name="nome"  id='nome' pattern="[A-Za-z' ]{2,20}">
                        <input type="text" name="cognome" id='cognome' pattern="[A-Za-z' ]{2,20}">
                        <input type="text" name="username" id='username' pattern="[A-Za-z0-9_]{4,10}">
                        <input type="password" name="password" id='password' pattern="[A-Za-z0-9'$'+'@]{4,16}">
                        <select name="ruolo" id="ruolo">
                            <option value="1">Arbitro</option>
                            <option value="2">Giocatore</option>
                        </select>
                        

                    </div>

                </fieldset>
                <?php

                if($errore)
                    echo '<p id="errorelogin">Lo username selezionato è già utilizzato da un altro utente.</p>';
                
                ?>
                
                <input type="submit" value="Registrati" name="registrati">
                <br>
                <a href="accedi.php">Hai già un account? Accedi.</a>
            </form>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>