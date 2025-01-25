<?php

require_once "controllo.php";
require_once "dbaccess.php";
//questa pagina è visualizzabile solo da giocatori
if(!isset($_SESSION['Ruolo'])||($_SESSION["Ruolo"]!==2)){
   
    header("location: accedi.php");
}




//controllo se è stata sottomesso un certificato 

if(isset($_POST["sottometticertificato"])&&isset($_POST["scadenza"])&&($_FILES['certificato']["tmp_name"]!="")){
    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if(mysqli_connect_errno())
        die(mysqli_connect_error());
    $scadenza = $_POST["scadenza"];
    $filedamettere = base64_encode(file_get_contents($_FILES["certificato"]["tmp_name"]));
    $query = "insert into certificato (Scadenza, Giocatore, Contenuto) values (?,".$_SESSION["UID"].",? )";
    if($statement = mysqli_prepare($connection, $query)){
        
        mysqli_stmt_bind_param($statement, 'ss', $scadenza, $filedamettere);
        mysqli_stmt_send_long_data($statement, 20000, $filedamettere);
        mysqli_stmt_execute($statement);
        
    }
    else {
        die(mysqli_connect_error());
    }
}

?>



<!-- Giulio Zingrillo - Progetto di Progettazione Web - Gennaio 2024 -->
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            Volley World - Gestione Certificati
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
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
        <?php
                    require_once "visualizzanome.php";
                ?>
            
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
            <form id="loginform" action="certificati.php" enctype="multipart/form-data" method="post">
                <h2>
                    Carica un certificato medico
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label for="certificato">Certificato: </label>
                        <label for="scadenza">Scadenza: </label>
                    </div>
                    <div id="inputlogin">
                        <input type="file"  id="certificato" name="certificato" >
                        <input type="date" id="scadenza" name="scadenza" value="2024-01-30" required >
                        

                    </div>

                </fieldset>
                

               
                <input type="submit" value="Invia" name="sottometticertificato">
                
            </form>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>