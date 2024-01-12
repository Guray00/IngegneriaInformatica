<?php

require_once "controllo.php";
require_once "dbaccess.php";

if(!isset($_SESSION['Ruolo'])||($_SESSION["Ruolo"]!==2)){
   
    header("location: accedi.php");
}
$nosquadre=false;
$errore = false;
$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                if(mysqli_connect_errno())
                    die(mysqli_connect_error());
//recupero una lista delle squadre
$query = "select * from squadra";
$resulttorneo = mysqli_query($connection, $query);
if(!mysqli_num_rows($resulttorneo))
    $nosquadre=true;

//controllo se è stata sottomessa una richiesta di partecipazione 

if(isset($_POST["squadra"])&&isset($_POST["partecipa"])&&isset($_POST["codice"])){
    $squadra = $_POST["squadra"];
    $codice = $_POST["codice"];
    //recupero il codice e controllo sia uguale, con  hash, a quello fornito
    $query = "select Codice from squadra where Id=?";
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 'i', $squadra);

        mysqli_stmt_execute($statement);
        $result = mysqli_stmt_get_result($statement);
        $row = mysqli_fetch_assoc($result);
        if(password_verify($codice, $row["Codice"])){
            $query = "insert into affiliazione (Giocatore, Squadra) values (".$_SESSION["UID"].", ?)";
            if($statement = mysqli_prepare($connection, $query)){
                mysqli_stmt_bind_param($statement, 'i',  $squadra);
                mysqli_stmt_execute($statement);
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
            Volley World - Partecipa a Squadra
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/partecipaasquadra.js"></script>
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
            <form id="loginform" action="partecipaasquadra.php" method="post">
                <h2>
                    Unisciti a una Squadra
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label >Squadra: </label>
                        <label for="codicepersquadra">Codice: </label>
                    </div>
                    <div id="inputlogin">
                        <?php
                            if($nosquadre)
                                echo "<span>Nessuna squadra</span>";
                            else {
                                echo ' <select name="squadra" id="torneoarbitraggio">';
                                while($row = mysqli_fetch_assoc($resulttorneo)){
                                    echo "<option value='".$row['Id']."'>".$row['Nome']."</option>";
                                }
                                echo "</select>";
                            } 
                        ?>
                       

                        
                        <input type="number" <?php if($nosquadre) echo "readonly"; ?> id="codicepersquadra" name="codice" min='0' max='1000'>
                        

                    </div>

                </fieldset>
                <p id='infoarbitraggio'>
                    In caso di successo, si sarà reindirizzati alla pagina principale.
                </p>
                <?php

                if($errore)
                    echo '<p id="errorelogin">Nessuna corrispondenza. Si prega di riprovare.</p>';
                
                ?>
                <input type="submit" value="Invia" name="partecipa">
                
            </form>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>