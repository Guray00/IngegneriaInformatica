<?php
   
    if(!isset($_GET['Codice']))
        header("location: index.php");
?>

<!-- Giulio Zingrillo - Progetto di Progettazione Web - Gennaio 2024 -->
<!DOCTYPE html>
<html lang='it'>
    <head>
        <title>
            Volley World - Torneo Creato
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
            
        <div>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
                <h1>Volley World</h1>
                <img src="../img/volleyball.png" class="iconapalla" alt="pallonedapallavolo">
            
            </div>
            <br>
            <h2>
                Spazio al gioco
            </h2>
        </header>
        <main>
            <div id='torneocreato'>
                <h1>
                    Torneo creato con successo!
                </h1>
                <div id='codice'>

                    <?php 
                        echo $_GET['Codice'];

                    ?>
                
                </div>
                <p>
                    Dai questo codice all'arbitro del torneo: gli servirà per inserire i rapporti delle partite.
                </p>
                <a id='backhome' href="index.php">
                Torna alla home
            </a>
            </div>
            
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>