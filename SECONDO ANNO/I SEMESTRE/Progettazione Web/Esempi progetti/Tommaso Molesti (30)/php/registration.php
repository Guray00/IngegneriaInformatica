<?php
    require_once "back_landing.php";
    $errore = false;
    if(isset($_POST['registration'])&&isset($_POST['email'])&&isset($_POST['password'])&&isset($_POST["role"])){
        
        $email = $_POST['email'];
        $password = $_POST['password'];
        $role = $_POST['role'];

        $regexp_email = "/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/";
        if (!preg_match($regexp_email, $email)) {
            echo "<script>window.alert('Formato email non valido.')</script>";
            $errore = true;
        }

        $regexp_pwd = "/^[A-Za-z0-9'$'+'@]{4,16}$/";
        if (!preg_match($regexp_pwd, $password)) {
            echo "<script>window.alert('La password deve essere lunga tra 4 e 16 caratteri e contenere solo lettere, numeri o i simboli '$', '@'.')</script>";
            $errore = true;
        }

        if(!$errore) {
            require_once "dbaccess.php";
            $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
            if(mysqli_connect_errno())
                die(mysqli_connect_error());
    
            // Controllo se ci sono altri utenti con la stessa email che sono già registrati
            $query = "SELECT * FROM users WHERE email=?;";
            if($statement = mysqli_prepare($connection, $query)){
                mysqli_stmt_bind_param($statement, 's', $email);
        
                mysqli_stmt_execute($statement);
                $result = mysqli_stmt_get_result($statement);
                if(mysqli_num_rows($result)!==0){
                    $errore = true;
                }
                    
                else{
                    // Inserisco l'utente nel database
                    $query = "INSERT INTO users (role, email, password) VALUES (?, ?, ?)";
                    if($statement = mysqli_prepare($connection, $query)){
                        $hash = password_hash($password, PASSWORD_BCRYPT);
    
                        mysqli_stmt_bind_param($statement, 'sss', $role, $email, $hash);
                
                        mysqli_stmt_execute($statement);
                        header("location: login.php");
                    }
                }
                
            }
            else {
                die(mysqli_connect_error());
            }
        }

    }
?>

<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            Registrazione
        </title>
        <link rel="stylesheet" href="../css/registration.css">
        <link rel="icon" href="../assets/favicon.ico" type="image/ico">
        <script src="../js/registration.js"></script>
        <meta charset="UTF-8">
        <meta name="author" content="Tommaso Molesti">
        <meta name="description" content="Un software di gestione cassa per la tua sagra">
    </head>
    <body onload="init()">
        <div id="left">
            <form id="loginform" action="registration.php" method="post">
                <h1>Cassa Sagra</h1>
                <h2>
                    Registrazione
                </h2>
                <div class="registration-row">
                    <label for="email">Email: </label>
                    <input type="text" name="email" id='email' placeholder="esempio@gmail.com" pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
                </div>
                <div class="registration-row">
                    <label for="password">Password: </label>
                    <input type="password" name="password" id='password' placeholder="•••••••" pattern="[A-Za-z0-9'$'+'@]{4,16}">
                    </div>
                <div class="registration-row">
                    <label for="role">Ruolo: </label>
                    <select name="role" id="role">
                        <option value="admin">Admin</option>
                        <option value="waiter">Cameriere</option>
                    </select>
                </div>
                <?php
                    if($errore)
                        echo '<p id="error-msg">L\'email selezionata è gi&agrave; utilizzata da un altro utente.</p>';
                ?>
                <input id="registration-btn" type="submit" value="Registrati" name="registration">
                <br>
                <p id="already-account">Hai gi&agrave; un account? 
                    <a id="sign-in" href="login.php"> Accedi.</a>
                </p>
            </form>
        </div>
        <div id="right">
            <img id="image" src="../assets/main.svg" alt="Icona di Login">
        </div>
    </body>
</html>