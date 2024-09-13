<?php

require_once "controllo.php";
require_once "dbaccess.php";
//questa pagina è visualizzabile solo da giocatori
if(!isset($_SESSION['Ruolo'])||($_SESSION["Ruolo"]!=2)){
   
    header("location: accedi.php");
}

define("REGEXNOME", "/[A-Za-z' ]{2,20}/");

$notornei=false;
$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                if(mysqli_connect_errno())
                    die(mysqli_connect_error());

$query = "select distinct(Torneo) from partita where (Squadra1 is null and Squadra1dapartita is null )or ( Squadra2 is null and Squadra2dapartita is null) ";
$resulttorneo = mysqli_query($connection, $query);
if(!mysqli_num_rows($resulttorneo))
    $notornei=true;


//controllo se è stata sottomessa una richiesta di fondazione squadra 

if(isset($_POST["torneo"])&&isset($_POST["fonda"])&&isset($_POST["nome"])){

    $torneo = $_POST["torneo"];
    $nome = $_POST["nome"];
    //controllo le regex
    if(preg_match(REGEXNOME, $nome)){
        $code= rand(0, 1000);
        $codice = password_hash($code, PASSWORD_BCRYPT);
        $query = "insert into squadra (Nome, Torneo, Capitano, Codice) values (?, ?, ".$_SESSION["UID"].", '$codice')";
        // creo la squadra
        if($statement = mysqli_prepare($connection, $query)){
            mysqli_stmt_bind_param($statement, 'ss',$nome, $torneo);
            mysqli_stmt_execute($statement);
            $query = "select Id from squadra where Nome=? and Torneo =? and Capitano =".$_SESSION['UID'];
            if($statement = mysqli_prepare($connection, $query)){
                mysqli_stmt_bind_param($statement, 'ss',$nome, $torneo);
                mysqli_stmt_execute($statement);
                $result = mysqli_stmt_get_result($statement);
                $row = mysqli_fetch_assoc($result);
                $idsquadra = $row['Id'];
                //aggiorno il torneo
                $query = "update `partita` p set `Squadra1`=$idsquadra where p.Id in (
                select p1.Id from partita p1 where (p1.Squadra1 is null and p1.Squadra1dapartita is null and p1.Torneo = ? ) 
                ) limit 1;";
                if($statement = mysqli_prepare($connection, $query)){
                    mysqli_stmt_bind_param($statement, 's', $torneo);
                    mysqli_stmt_execute($statement);
                    //cerco prima un posto libero nella fase successiva come prima squadra; se non lo trovo lo cerco come seconda squadra
                    if(!mysqli_stmt_affected_rows($statement)){
                        $query = "update `partita` p set `Squadra2`=$idsquadra where p.Id in (
                            select p1.Id from partita p1 where (p1.Squadra2 is null and p1.Squadra2dapartita is null and p1.Torneo = ? ) 
                        ) limit 1;";
                        if($statement = mysqli_prepare($connection, $query)){
                            mysqli_stmt_bind_param($statement, 's', $torneo);
                            mysqli_stmt_execute($statement);
                        }
                        else {
                            die(mysqli_connect_error());
                        }
                    }
                    //pongo il capitano tra i giocatori della squadra
                    $query = "insert into affiliazione (Giocatore, Squadra) values (".$_SESSION['UID'].", $idsquadra)";
                    mysqli_query($connection, $query);
                    header("location: squadrafondata.php?Codice=$code");                 
    
                 }
                else {
                    die(mysqli_connect_error());
                }
            }
            else {
                die(mysqli_connect_error());
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
            Volley World - Fonda Squadra
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/fondasquadra.js"></script>
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
            <form id="loginform" action="fondasquadra.php" method="post">
                <h2>
                    Fonda una Squadra
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label >Torneo: </label>
                        <label for="nome">Nome squadra: </label>
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
                       

                        
                        <input type="text" id='nome' <?php if($notornei) echo "readonly"; ?> name="nome" pattern="[A-Za-z' ]{2,20}">
                        

                    </div>

                </fieldset>
                
                <input type="submit" value="Invia" name="fonda">
                
            </form>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>