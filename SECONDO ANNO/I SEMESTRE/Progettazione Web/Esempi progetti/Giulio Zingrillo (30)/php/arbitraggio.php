<?php

require_once "controllo.php";
require_once "dbaccess.php";
//la pagina è visualizzabile solo da arbitri
if(!isset($_SESSION['Ruolo'])||($_SESSION["Ruolo"]!==1)){
   
    header("location: accedi.php");
}
$notornei=false;
$errore=false;
$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                if(mysqli_connect_errno())
                    die(mysqli_connect_error());
//individuo i tornei ancora da arbitrare
$query = "select * from arbitraggio where Arbitro is null";
$resulttorneo = mysqli_query($connection, $query);
if(!mysqli_num_rows($resulttorneo))
    $notornei=true;

//controllo se è stata sottomessa una richiesta di arbitraggio 

if(isset($_POST["torneo"])&&isset($_POST["arbitra"])&&isset($_POST["codice"])){
    $torneo = $_POST["torneo"];
    $codice = $_POST["codice"];
    //verifico se il codice inserito è corretto
    $query = "select Codice from arbitraggio where Torneo=?";
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 's', $torneo);
        mysqli_stmt_execute($statement);
        $result = mysqli_stmt_get_result($statement);
        $row = mysqli_fetch_assoc($result);
        if(password_verify($codice, $row["Codice"])){
            $query = "update arbitraggio set Arbitro =? where Torneo=?";
            if($statement = mysqli_prepare($connection, $query)){
                mysqli_stmt_bind_param($statement, 'is', $_SESSION["UID"], $torneo);
                mysqli_stmt_execute($statement);
                //se la richiesta di arbitraggio ha successo, si viene reindirizzati alla pagina principale, come riportato nel form
                header("location: index.php");
            }
            else {
                die(mysqli_connect_error());
            }
        }
        else 
            $errore = true;
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
            Volley World - Arbitraggio
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/arbitraggio.js"></script>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="author" content="Giulio Zingrillo">
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
            <form id="loginform" action="arbitraggio.php" method="post">
                <h2>
                    Gestione Arbitraggi
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label >Torneo: </label>
                        <label for="codicearbitro">Codice: </label>
                    </div>
                    <div id="inputlogin">
                        <?php
                            if($notornei)
                                echo "<span id='notorneidisponibili'>Nessun torneo disponibile</span>";
                            else {
                                echo ' <select name="torneo" id="torneoarbitraggio">';
                                while($row = mysqli_fetch_assoc($resulttorneo)){
                                    echo "<option value='".$row['Torneo']."'>".$row['Torneo']."</option>";
                                }
                                echo "</select>";
                            } 
                        ?>
                       

                        
                        <input type="number" id="codicearbitro" <?php if($notornei) echo "readonly ";?>name="codice" min='0' max='1000'>
                        

                    </div>

                </fieldset>
                <p id='infoarbitraggio'>
                    In caso di successo, si sarà reindirizzati alla pagina principale.
                </p>
                <?php

                if($errore)
                    echo '<p id="errorelogin">Nessuna corrispondenza. Si prega di riprovare.</p>';
                
                ?>

                <input type="submit" value="Invia" name="arbitra">
                
            </form>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>