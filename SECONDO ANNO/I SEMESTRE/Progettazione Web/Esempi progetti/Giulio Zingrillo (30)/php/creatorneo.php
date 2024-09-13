<?php 

    require_once "controllo.php";
    //la pagina è visualizzabile da soli amministratori
    if(!isset($_SESSION['Ruolo'])||($_SESSION["Ruolo"]!==0)){
       
        header("location: accedi.php");
    }



    $regexnome = "/[A-Za-z' ]{2,20}/";
    $regexnsquadre = "/(2|4|8|16)/";
 

    $errore = false;
    //verifico se è stata sottomessa una richiesta di creazione torneo
    if(isset($_POST['crea'])&&isset($_POST['nome'])&&isset($_POST['numerosquadre'])&&isset($_POST['inizio'])&&isset($_POST['campo'])&&isset($_POST['partitesettimana'])){
       
   
        $nome = $_POST['nome'];
        $numerosquadre = $_POST['numerosquadre'];
        $inizio = $_POST['inizio'];
        $campo = $_POST['campo'];
        $orapartite = $_POST['orapartite'];
        $partitesettimana = $_POST['partitesettimana'];
        $inizio = date_create($inizio);
        $datacorrente = date('d-m-Y', time());
        $datacorrente= date_create($datacorrente);


        
         //verifico i dati lato server
        if(preg_match($regexnome, $nome)&&preg_match($regexnsquadre, $numerosquadre)&&date_diff($inizio, $datacorrente)->days>0&&$partitesettimana>0&&$partitesettimana<8&&preg_match($regexnome, $campo)){
             // mi connetto al db
             require "dbaccess.php";
             $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
             if(mysqli_connect_errno())
                 die(mysqli_connect_error());
 
             
 
             //preparo lo statement e accedo al db
 
             $query = "select * from partita where Torneo=?;";
             if($statement = mysqli_prepare($connection, $query)){
                 mysqli_stmt_bind_param($statement, 's', $nome);
         
                 mysqli_stmt_execute($statement);
                 $result = mysqli_stmt_get_result($statement);
                 if(mysqli_num_rows($result)!==0){
                    $errore = true;
                    // se esiste già un torneo con questo nome, restituisco errore.
                 }
                     
                 else{
                    //Inserisco il torneo nella tabella 'arbitraggio' e genero il codice da fornire all'arbitro
                    $query = "insert into arbitraggio (Torneo, Codice) values (?, ?)";
                    if($statement = mysqli_prepare($connection, $query)){
                        $code= rand(0, 1000);
                        $codice = password_hash($code, PASSWORD_BCRYPT);

                        mysqli_stmt_bind_param($statement, 'ss', $nome, $codice);
                
                        mysqli_stmt_execute($statement);                 
                    }
                    else {
                        die(mysqli_connect_error());
                    }
                    //configuro le variabili per la creazione del torneo
                    $giorno = $inizio;
                    $contatore = $partitesettimana;
                    $giorniresidui = 7-$partitesettimana;

                    for($n = $numerosquadre; $n>1; $n=$n/2){
                        //creo le partite della prima fase del torneo
                        if($n==$numerosquadre){
                            for($i = 0; $i<$numerosquadre/2; $i++){
                                $query = "insert into partita (Dataeora, Luogo, Torneo) values (?, ?, ?)";
                                if($statement = mysqli_prepare($connection, $query)){
                                    $dataeora = $giorno->format('Y-m-d')." ".$orapartite;
            
                                    mysqli_stmt_bind_param($statement, 'sss', $dataeora, $campo, $nome);
                            
                                    mysqli_stmt_execute($statement);                 
                                }
                                else {
                                    die(mysqli_connect_error());
                                }
                                //aggiorno la data
                                $contatore--;
                                date_modify($giorno, "+1 day");
                                if(!$contatore){
                                    $contatore=$partitesettimana;
                                    date_modify($giorno, ("+ ".$giorniresidui." day"));
                                }

                            }
                            continue;
                        }
                        //creo le partite delle altre fasi, in cui competono i vincitori della fase precedente
                        $query = "select Id from partita where Torneo =? order by Dataeora desc limit ".$n;
                        echo $query;
                        if($statement = mysqli_prepare($connection, $query)){
                            mysqli_stmt_bind_param($statement, 's', $nome);
                            mysqli_stmt_execute($statement);
                            $result = mysqli_stmt_get_result($statement);
                            while($row = mysqli_fetch_assoc($result)){
                                $squadra1 = $row['Id'];
                                $row = mysqli_fetch_assoc($result);
                                $squadra2 = $row['Id'];
                                
                                $query = "insert into partita (Dataeora, Luogo, Torneo, Squadra1dapartita, Squadra2dapartita) values (?, ?, ?, $squadra1, $squadra2)";
                                echo $query;
                                if($statement = mysqli_prepare($connection, $query)){
                                    $dataeora = $giorno->format('Y-m-d')." ".$orapartite;
            
                                    mysqli_stmt_bind_param($statement, 'sss', $dataeora, $campo, $nome);
                            
                                    mysqli_stmt_execute($statement);                 
                                }
                                else {
                                    die(mysqli_connect_error());
                                }
                                //aggiorno la data
                                $contatore--;
                                date_modify($giorno, "+1 day");
                                if(!$contatore){
                                    $contatore=$partitesettimana;
                                    date_modify($giorno, ("+ ".$giorniresidui." day"));
                                }
                            }
                        }
                        else{
                            die(mysqli_connect_error());
                        }

                    }
                    //se tutto va a buon fine, reindirizzo alla pagina dedicata
                    header("location: torneocreato.php?Codice=".$code);
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
            Volley World - Crea un torneo
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/creatorneo.js" ></script>
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
            
             
            <div>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
                <h1>Volley World</h1>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
            
            </div>
            <br>
            <h2>
                Spazio al gioco
            </h2>
           

            
            <nav id = "pannelloadmin">
                <a id="tuttitornei" href="index.php" 
                >Tutti i tornei</a>
                <a id="creatorneo" href="#" class="current-position"
                >Crea torneo</a>
                
            </nav>
      
            

            ?>
        </header>
        <main >
            
        <form id="loginform" action="creatorneo.php" method="post">
                <h2>
                    Configura il nuovo torneo
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label for="nome">Nome:  </label>
                        <label for="numerosquadre">Numero di squadre: </label>
                        <label for="inizio">Data di inizio:</label>
                        <label for="partitesettimana">Partite a settimana: </label>
                        <label for="orapartite">Ora delle partite:</label>
                        <label for="campo">Campo:</label>
                        
                    </div>
                    <div id="inputcrea">
                        <input type="text" name="nome" id="nome" pattern="[A-Za-z' ]{2,20}">
                        <select name="numerosquadre" id="numerosquadre">
                            <option value="2">2</option>
                            <option value="4">4</option>
                            <option value="8">8</option>
                            <option value="16">16</option>
                        </select>
                        <input type="date" id="inizio" name="inizio" required value="2024-01-30">
                        <input type="number" id="partitesettimana" name="partitesettimana" value="2" min="1" max ="7" required>
                        <input type="time" id="orapartite" name="orapartite" value="00:00" required>
                        <input type="text" id="campo" name="campo" pattern="[A-Za-z' ]{2,20}">
                       
                        

                    </div>

                </fieldset>
                <?php
                    if($errore)
                    echo '<p id="errorelogin">Esiste già un torneo con lo stesso nome.</p>';
                
                ?>
                

                
                
                <input type="submit" value="Crea" name="crea">
                
            </form>
                
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>