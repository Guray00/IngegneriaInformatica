
<!-- Giulio Zingrillo - Progetto di Progettazione Web - Gennaio 2024 -->
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            Volley World - Pagina Principale
        </title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="icon" href="../icons/volleyball.ico" type="image/ico">
        <script src="../js/index.js" ></script>
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
            
             
            <div>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
                <h1>Volley World</h1>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
            
            </div>
            <br>
            <h2>
                Spazio al gioco
            </h2>
            <?php

            if(isset($_SESSION["Ruolo"])&&$_SESSION["Ruolo"]==0) echo '
            <nav id = "pannelloadmin">
                <a id="tuttitornei" href="#" class="current-position"
                >Tutti i tornei</a>
                <a id="creatorneo" href="creatorneo.php"
                >Crea torneo</a>
                
            </nav>
            ';

            else if((isset($_SESSION["Ruolo"]))&&$_SESSION["Ruolo"]==1) echo
            
            "
           
            <a id='arbitratorneo' href='arbitraggio.php'>
                Arbitra Torneo
                </a>
        
        ";

            else if(isset($_SESSION["Ruolo"])&&$_SESSION["Ruolo"]==2) echo '
            <nav id = "pannellogiocatore">
                <a id="tuttitornei" href="#" class="current-position"
                >Tutti i tornei</a>
                <a id="fondasquadra" href="fondasquadra.php"
                >Fonda Squadra</a>
                <a id="partecipaasquadra" href="partecipaasquadra.php"
                >Partecipa a Squadra</a>
                <a id="certificati" href="certificati.php"
                >Certificato medico</a>
                
            </nav>
            ';
            

            ?>
        </header>
        <main >
            <a href='../html/guida.html' id='linkguida'>Guida</a>
            <?php
                require_once "controllo.php";
                require_once "dbaccess.php";

                $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                if(mysqli_connect_errno())
                    die(mysqli_connect_error());
                //elenco i tornei, ordinandoli per numero di partite
                $query = "select Torneo, COUNT(distinct Id) as Partite from partita group by Torneo order by Partite desc;";

                if($result = mysqli_query($connection, $query)){
                    $contatore=0;
                    while($row = mysqli_fetch_assoc($result)){
                        if($contatore==0){
                            echo "<div id='grigliaseltorneo'>";
                            echo "<div id='selezionatorneo'>";
                            echo "Seleziona un torneo:";
                            echo "</div>"; 
                            echo "</div>"; 
                        }
                        echo "<div class='grigliatorneo'>";
                        echo "<a href='torneo.php?id=".str_replace(" ", "%20", $row["Torneo"])."&display=0'>";
                        
                        
                        echo "<div class='torneo'>";
                        
                        echo "<span class='nometorneo'>";
                        echo  $row['Torneo'];
                        echo "</span>";
                        echo "<span class='numerosquadre'>";
                        echo $row['Partite']." partite";
                        echo "</span>";
                        echo "</div>";
                        echo "</a>";
                        echo "</div>";
                        $contatore= $contatore+1;
                    }
                    if(!$contatore){
                        echo "<div id='notornei'>";
                        echo "Al momento non è in corso nessun torneo.<br>Consulta questa pagina per rimanere aggiornato.";
                        echo "</div>";
                    }
                   
                        

                }
                else {
                    die(mysqli_connect_error());
                }


            ?>
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>