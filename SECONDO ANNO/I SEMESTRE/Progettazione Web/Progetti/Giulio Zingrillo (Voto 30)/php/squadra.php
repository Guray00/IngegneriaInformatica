<?php
    if(!$_GET["id"] )
        header("location: index.php");
    require "dbaccess.php";
    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if(mysqli_connect_errno())
        die(mysqli_connect_error());
    // recupero le informazioni sulla squadra, che deve esistere
    $query = "select s.Torneo, u.Nome as Nomecap, u.Cognome as Cognomecap, s.Nome from squadra s inner join utente u on u.Id = s.Capitano where s.Id=?;";
    $id = $_GET['id'];
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 'i', $id);

        mysqli_stmt_execute($statement);
        $result = mysqli_stmt_get_result($statement);
        if(mysqli_num_rows($result)==0)
            header("location: index.php");
        $row = mysqli_fetch_assoc($result);
            

    }
    else {
        die(mysqli_connect_error());
    }
    

?>
<!-- Giulio Zingrillo - Progetto di Progettazione Web - Gennaio 2024 -->
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            <?php
                echo $row['Nome'];
            ?>
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="author" content="Giulio Zingrillo">
        <meta name="description" content="A volleyball competition manager">
        <meta name="generator" content="VSCode">
        <meta name="keywords" content=" Volley">
        
        
    </head>
    <body>
        <header>
                <?php
                    require_once "visualizzanome.php";
                ?>
            
            
            <h1 id="nometorneo">
                <?php
                echo $row['Nome'];
                ?>
            </h1>
            
                <h2>

                <a href="index.php">
                Una Squadra Volley Word
                </a>
                    
                </h2>
            
           
                
        </header>
        <main>

        
            <div id='loginform'>
                <h2>
                    Scheda Squadra
                </h2>
                <a href='certificati.php'>
                    Non trovi il tuo nome di seguito? Carica un certificato medico valido.
</a>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label for="nome">Nome: </label>
                        <label for="torneo">Torneo: </label>
                        <label for="capitano">Capitano: </label>
                        <label for="giocatori">Giocatori: </label>
                       
                    </div>
                    <div id="inputlogin">
                        <span class='spanpartita'>
                        <?php
                            echo $row['Nome'];
                            ?>
                        </span>
                        <span class='spanpartita'>

                            <?php 
                               echo $row['Torneo'];
                            ?>
                        </span>
                        <span class='spanpartita'>
                            <?php 
                                echo $row['Nomecap']." ".$row['Cognomecap'];
                            ?>
                        </span>
                        <?php
                             $query = "select u.Nome, u.Cognome, max(c.Scadenza) as Scadenza from utente u inner join affiliazione a on u.Id = a.Giocatore inner join certificato c on c.Giocatore = u.Id where a.Squadra=? and c.Scadenza >= current_date group by u.Nome, u.Cognome;";
                             if($statement = mysqli_prepare($connection, $query)){
                                 mysqli_stmt_bind_param($statement, 'i', $id);
                                mysqli_stmt_execute($statement);
                                 $result = mysqli_stmt_get_result($statement);
                                 while($row = mysqli_fetch_assoc($result)){
                                    echo "<span class='spanpartita'>".$row["Nome"]." ".$row["Cognome"]."  </span><div class='scadenzacertificato'> Certificato medico fino al ".$row["Scadenza"]."</div>
                                ";
                                 }
                                     
                         
                             }
                             else {
                                 die(mysqli_connect_error());
                             }  
                        ?>

                        
                    </div>   
                        

                </fieldset>
            </div>
            
           
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>