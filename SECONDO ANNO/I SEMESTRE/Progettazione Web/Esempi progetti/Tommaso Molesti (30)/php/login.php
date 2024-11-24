<?php
require_once "back_landing.php";
$errore = false;

if(isset($_POST['login']) && isset($_POST['email']) && isset($_POST['password'])){
    $email = $_POST['email'];
    $password = $_POST['password'];

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

    if (!$errore) {
        require_once "dbaccess.php";
        $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
        if(mysqli_connect_errno())
            die(mysqli_connect_error());

        // Recupero le informazioni sull'utente
        $query = "SELECT * FROM users WHERE email=?;";
        if($statement = mysqli_prepare($connection, $query)){
            mysqli_stmt_bind_param($statement, 's', $email);
            mysqli_stmt_execute($statement);
            $result = mysqli_stmt_get_result($statement);

            if(mysqli_num_rows($result) === 0){
                $errore = true;
            } else {
                $row = mysqli_fetch_assoc($result);
                $hash = $row['password'];

                if(password_verify($password, $hash)){
                    require_once "check.php";
                    $_SESSION["id"] = $row['id'];
                    $_SESSION["email"] = $row['email'];
                    $_SESSION["role"] = $row['role'];
                    $_SESSION["party_id"] = $row['party_id'];

                    header("location: index.php");
                } else {
                    $errore = true;
                }
            }
        } else {
            die(mysqli_connect_error());
        }
    }
}
?>

<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>Accedi</title>
        <link rel="stylesheet" href="../css/login.css">
        <script src="../js/login.js"></script>
        <link rel="icon" href="../assets/favicon.ico" type="image/ico">
        <meta charset="UTF-8">
        <meta name="author" content="Tommaso Molesti">
        <meta name="description" content="Un software di gestione cassa per la tua sagra">
    </head>
    <body onload="init()">
        <div id="left">
            <form action="login.php" method="post">
                <h1>Cassa Sagra</h1>
                <h2>Login</h2>
                <div class="login-row">
                    <label for="email">Email</label>
                    <input type="text" id="email" name="email" placeholder="esempio@gmail.com" value="<?php echo isset($email) ? $email : ''; ?>" pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
                </div>
                <div class="login-row">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="•••••••" pattern="[A-Za-z0-9'$'+'@]{4,16}">
                </div>
                <?php
                    if($errore)
                        echo '<p id="error-msg">Email o password non corretta.</p>';
                ?>
                <input id="login-btn" type="submit" value="Accedi" name="login">
                <br>
                <p id="not-account">Non hai ancora un account? 
                    <a id="create-account" href="registration.php"> Crea account.</a>
                </p>
            </form>
        </div>
        <div id="right">
            <img id="image" src="../assets/main.svg" alt="Icona di Login">
        </div>
    </body>
</html>
