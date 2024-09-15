<?php
    $edit = false;
    if(!$_GET["id"] )
        header("location: index.php");
    require "dbaccess.php";
    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if(mysqli_connect_errno())
        die(mysqli_connect_error());
    //recupero le informazioni sulla partita
    $query = "select a.Arbitro as Arbitro, s1.Id as IdSquadra1,  s2.Id as IdSquadra2, p.Torneo as Torneo ,p.Id as Id, s1.Nome as Squadra1, s2.Nome as Squadra2, p.Vince1 as Vince1, p.Luogo as Luogo, p.Set1Squadra1 as Set1Squadra1, p.Set1Squadra2 as Set1Squadra2, p.Set2Squadra1 as Set2Squadra1, p.Set2Squadra2 as Set2Squadra2, p.Set3Squadra1 as Set3Squadra1, p.Set3Squadra2 as Set3Squadra2, p.Dataeora as Dataeora, p.Commenti as Commenti from partita p left join squadra s1 on s1.Id = p.Squadra1 left join squadra s2 on s2.Id = p.Squadra2  inner join arbitraggio a on a.Torneo = p.Torneo where p.Id=?";

   
    $id = $_GET['id'];
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 'i', $id);

        mysqli_stmt_execute($statement);
        $result = mysqli_stmt_get_result($statement);
        $row = mysqli_fetch_assoc($result);
        //la partita deve esistere
        if(mysqli_num_rows($result)==0)
            header("location: index.php");
        
        //verifico se chi visualizza la pagina è l'arbitro del torneo e se la partita è effettivamente giocabile
        require_once "controllo.php";

  
        

        if(isset($_SESSION['UID'])&&$_SESSION['UID']==$row['Arbitro']&&!is_null($row['Squadra1'])&&!is_null($row['Squadra2'])&&is_null($row['Vince1']))
            
            $edit = true; 
        
        
        //verifico se è stato sottomesso un rapporto
        if($edit&&isset($_POST['primoset1'])&&isset($_POST['secondoset1'])&&isset($_POST['terzoset1'])&&isset($_POST['primoset2'])&&isset($_POST['secondoset2'])&&isset($_POST['terzoset2'])&&isset($_POST['commenti'])&&isset($_POST['vincitore'])){
            
            $primoset1 = $_POST['primoset1'];
            $secondoset1 = $_POST['secondoset1'];
            $terzoset1 = $_POST['terzoset1'];
            $primoset2 = $_POST['primoset2'];
            $secondoset2 = $_POST['secondoset2'];
            $terzoset2 = $_POST['terzoset2'];
            $commenti = $_POST['commenti'];
            $vincitore = $_POST['vincitore'];
            
            $query = "update partita set Set1Squadra1 = ?, Set2Squadra1=?, Set3Squadra1=?, Set1Squadra2=?, Set2Squadra2=?, Set3Squadra2=?, Vince1=?, Commenti=? where Id=? ";
            if($statement = mysqli_prepare($connection, $query)){
                mysqli_stmt_bind_param($statement, 'iiiiiiisi', $primoset1, $secondoset1, $terzoset1, $primoset2, $secondoset2, $terzoset2, $vincitore, $commenti, $id);
        
                mysqli_stmt_execute($statement);
                //aggiorno le partite
                $squadravincitrice = ($vincitore)? $row['IdSquadra1']:$row['IdSquadra2'];
                $query = "update partita set Squadra1 = ".$squadravincitrice." where Squadra1dapartita=?";
                if($statement = mysqli_prepare($connection, $query)){
                    mysqli_stmt_bind_param($statement, 'i', $id);
            
                    mysqli_stmt_execute($statement);
                }
                else {
                    die(mysqli_connect_error());
                }
                $query = "update partita set Squadra2 = ".$squadravincitrice." where Squadra2dapartita=?";
                if($statement = mysqli_prepare($connection, $query)){
                    mysqli_stmt_bind_param($statement, 'i', $id);
            
                    mysqli_stmt_execute($statement);
                }
                else {
                    die(mysqli_connect_error());
                }
                
                //se il rapporto è stato sottomesso, aggiorno il form
                header("location: partita.php?id=".$id);
            }
            else {
                die(mysqli_connect_error());
            }
        }
       
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
                echo $row["Torneo"];
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
        <script src="../js/partita.js"></script>
        
        
    </head>
    <body onload="init()">
        <header>
                <?php
                    require_once "visualizzanome.php";
                ?>
            
            
            <h1 id="nometorneo">
                <a href="<?php echo "torneo.php?display=0&id=".str_replace(" ", "%20", $row["Torneo"]) ?>">
                <?php
                echo $row['Torneo'];
                ?>
                </a>
                
            </h1>
            
                <h2>

                <a href="index.php">
                Un torneo Volley Word
                </a>
                    
                </h2>
            
                
        </header>
        <main>

             
            <?php 
            if($edit)
                echo "<form action='partita.php?id=".$row['Id']."' method='post' id='loginform'>";
            else echo "<div id='loginform'>";
            ?> 
                <h2>
                    Rapporto Partita
                </h2>
                <fieldset class="field">
                    <div id="etichettelogin">
                        <label >Partita: </label>
                        <label >Torneo: </label>
                        <label >Data e ora: </label>
                        <label >Campo: </label>
                        <label for="primoset1">Primo Set: </label>
                        <label for="secondoset1">Secondo Set: </label>
                        <label for="terzoset1">Terzo Set: </label>
                        <label >Vincitore: </label>
                        <label for="commenti">Commenti: </label>
                    </div>
                    <div id="inputlogin">
                        <span class='spanpartita' id='nome'>
                        <?php
                            echo ((is_null($row['Squadra1']))?"-":$row['Squadra1'])." VS ".((is_null($row['Squadra2']))?"-":$row['Squadra2']);
                            ?>
                        </span>
                        <span class='spanpartita' id="torneodiappartenenza">

                            <?php 
                               echo $row['Torneo'];
                            ?>
                        </span>
                        <span class='spanpartita' id="dataeora">
                            <?php 
                                echo $row['Dataeora'];
                            ?>
                        </span>
                        <span class='spanpartita' id="campo">
                            <?php 
                               echo $row["Luogo"];
                            ?>
                        </span>
                        
                        <div class="set">
                            <input type="number" name="primoset1" id="primoset1" min="0" value="<?php          echo (is_null($row['Set1Squadra1']))?"-":$row['Set1Squadra1'];
                            ?>" <?php
                            if(!$edit) echo "readonly"; ?> >:
                            <input type="number" name="primoset2"  min="0" value="<?php
                                echo (is_null($row['Set1Squadra2']))?"-":$row['Set1Squadra2'];
                            ?>" <?php
                            if(!$edit) echo "readonly"; ?> >
                        </div>

                        <div class="set">
                            <input type="number" name="secondoset1" id="secondoset1" min="0" value="<?php
                                echo (is_null($row['Set2Squadra1']))?"-":$row['Set2Squadra1'];
                            ?>" <?php
                            if(!$edit) echo "readonly"; ?> >:
                            <input type="number" name="secondoset2" min="0" value="<?php
                                echo (is_null($row['Set2Squadra2']))?"-":$row['Set2Squadra2'];
                            ?>" <?php
                            if(!$edit) echo "readonly"; ?> >
                        </div>

                        <div class="set">
                            <input type="number" name="terzoset1" id="terzoset1" min="0" value="<?php
                                echo (is_null($row['Set3Squadra1']))?"-":$row['Set2Squadra1'];
                            ?>" <?php
                            if(!$edit) echo "readonly"; ?> >:
                            <input type="number" name="terzoset2" min="0" value="<?php
                                echo (is_null($row['Set3Squadra2']))?"-":$row['Set2Squadra2'];
                            ?>" <?php
                            if(!$edit) echo "readonly"; ?> >
                        </div>
                        
                        <?php
                        if(!$edit){
                            echo "<span id='partitanongiocata'>";
                            if(is_null($row['Vince1']))
                                echo "Partita non giocata";
                            else if($row['Vince1'])
                                echo $row['Squadra1'];
                            else echo $row['Squadra2'];
                            
                            echo "</span>";
                        }
                        else {
                            
                            echo "<select name='vincitore' id='vincitore'>
                                <option value='1'>".$row['Squadra1']."</option>
                                <option value ='0'>".$row['Squadra2']."</option>
                            </select>";
                        }
                            
                        ?>
                        

                        <textarea name="commenti" id="commenti" cols="30"  <?php
                        if(!$edit) echo "readonly"; ?>  rows="10">
                        
                        <?php
                            if(is_null($row['Commenti']))
                                echo "Nessun commento";
                            
                            else echo $row['Commenti'];
                        ?>

                        </textarea>

                    </div>
                       
                        

                </fieldset>

                <br><?php
                    if($edit)
                        echo '<input type="submit" value="Invia rapporto" name="rapporto" id="rapporto">';
                    ?>                        

                <?php 
            if($edit)
                echo "</form>";
            else echo "</div>";
            ?>
                
        </main>
        <footer>
            <small>
            Progetto finale di Progettazione Web | Professore: Alessio Vecchio - Studente: Giulio Zingrillo | Gennaio 2024
            </small>
        </footer>
    </body>
</html>