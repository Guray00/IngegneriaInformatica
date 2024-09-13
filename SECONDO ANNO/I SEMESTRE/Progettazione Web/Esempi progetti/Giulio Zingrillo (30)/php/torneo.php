<?php
    //controllo che la richiesta abbia la forma dovuta
    if(!$_GET["id"] || !isset($_GET["display"])||intval($_GET["display"])>2)
        header("location: index.php");
    require "dbaccess.php";
    $connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
    if(mysqli_connect_errno())
        die(mysqli_connect_error());
    // recupero i dati sul torneo, che deve esistere
    $query = "select Torneo from partita where Torneo=?;";
    $id = $_GET['id'];
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 's', $id);

        mysqli_stmt_execute($statement);
        $result = mysqli_stmt_get_result($statement);
        if(mysqli_num_rows($result)==0)
            header("location: index.php");
            

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
                echo $_GET["id"];
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
                echo $_GET['id'];
                ?>
            </h1>
            
                <h2>

                <a href="index.php">
                Un torneo Volley Word
                </a>
                    
                </h2>
            <!-- Modifico la nav in base alla posizione corrente -->
            <nav id="pannellostandard">
                <a id="linkclassifica" href=<?php
                echo "'torneo.php?id=".$_GET['id']."&display=0'";
                if($_GET['display']=="0")
                    echo " class = 'current-position'";
                ?>>Classifica</a>
                <a id="linkcalendario" href=<?php
                echo "'torneo.php?id=".$_GET['id']."&display=1'";
                if($_GET['display']=="1")
                    echo " class = 'current-position'";
                ?>>Calendario</a>
                <a id="linkstatistiche" href=<?php
                echo "'torneo.php?id=".$_GET['id']."&display=2'";
                if($_GET['display']=="2")
                    echo " class = 'current-position'";
                ?>>Statistiche</a>
            </nav>
                
        </header>
        <main>

        <?php
        
            switch ($_GET['display']){
                case '0':
                    //classifica: recupero le squadre del torneo e relative vittorie
                    $query = "with vincitrici as (
                        SELECT s.Id as Squadra, s.Nome as Nome, COUNT(*) as Vittorie
                        from squadra s 
                        INNER JOIN
                        partita p
                        ON ((s.Id = p.Squadra1 AND p.Vince1=1) OR (s.Id = p.Squadra2 AND p.Vince1=0)) 
                        where s.Torneo = ?
                        group by s.Id 
                        ), 
                    nonvincitrici as (
                        select Id, Nome, 0 as Vittorie
                        from squadra s
                        where not exists (
                            select * from vincitrici where Squadra = s.Id
                            ) and 
                        s.Torneo= ? ),
                        unione as (
                        select * from vincitrici union select * from nonvincitrici)
                        
                        select * from unione order by Vittorie DESC, Nome;";
                    $contatore = 0;

                    if($statement = mysqli_prepare($connection, $query)){
                        mysqli_stmt_bind_param($statement, 'ss', $id, $id);
                
                        mysqli_stmt_execute($statement);
                    }
                    else {
                        die(mysqli_connect_error());
                    }

                    if($result = mysqli_stmt_get_result($statement)){
                        echo "<table id='classifica'>
                        <tr>
                            <th>N°</th>
                            <th>Squadra</th>
                            <th>Partite Vinte</th>
                        </tr>";
                        //inserisco le squadre nella classifica

                        while($row = mysqli_fetch_assoc($result)){
                            $contatore++;
                            echo "<tr><td>$contatore</td><td><a href='squadra.php?id=".$row['Squadra']."'> ".$row['Nome']."</a></td><td>".$row['Vittorie']."</td></tr>";
                            
                        }
                        echo "</table>";
                    }

                    if(!$contatore){
                        echo "<div id='notornei'>";
                        echo "Al momento non ci sono squadre iscritte al torneo.<br>Consulta questa pagina per rimanere aggiornato.";
                        echo "</div>";
                    }
                    
                    
                    
                    break;

                case '1':
                    //calendario
                    //seleziono prima e ultima partita del calendario allo scopo di costruire la tabella. In fase di creazione del torneo non è possibile avere due partite lo stesso giorno
                    $query = "select min(Dataeora) as Minimo, max(Dataeora) +interval 1 day as Massimo from partita where Torneo = ?;";
                    
                    if($statement = mysqli_prepare($connection, $query)){
                        mysqli_stmt_bind_param($statement, 's', $id);
                
                        mysqli_stmt_execute($statement);
                    }
                    else {
                        die(mysqli_connect_error());
                    }

                    if($result = mysqli_stmt_get_result($statement)){
                        echo "
                        <div id='legenda'>
                            <div id='blu'>
                                Partite da giocare
                            </div>
                            <div id='verde'>
                                Partite giocate
                            </div>
                            <div id='nero'>
                                Giorno libero
                            </div> 
                        </div>";
                        echo "<table id='calendario'><tr>";
                        $row = mysqli_fetch_assoc($result);
                        $begin = new DateTime($row['Minimo']);
                        $end = new DateTime($row['Massimo']);

                        $interval = DateInterval::createFromDateString('1 day');
                        $period = new DatePeriod($begin, $interval, $end);
                        $colonne=0;

                        foreach ($period as $dt) {
                            if($colonne==7){
                                $colonne = 0;
                                echo "</tr><tr>";
                            }
                            //genero e riempio il calendario
                            $query = "select p.Id as Id, s1.Nome as Squadra1, s2.Nome as Squadra2, p.Vince1 from partita p left join squadra s1 on s1.Id = p.Squadra1 left join squadra s2 on s2.Id = p.Squadra2  where year(Dataeora)=20".$dt->format('y')." and month(Dataeora)=".$dt->format('m')." and day(Dataeora)=".$dt->format('d')." and p.Torneo = ?";
                            if($statement = mysqli_prepare($connection, $query)){
                                mysqli_stmt_bind_param($statement, 's', $id);
                        
                                mysqli_stmt_execute($statement);
                            }
                            else {
                                die(mysqli_connect_error());
                            }
                            $result = mysqli_stmt_get_result($statement);
                            $numrows = mysqli_num_rows($result);
                            $row = mysqli_fetch_assoc($result);
                            if($numrows && is_null($row["Vince1"]) )
                                echo "<td class='dagiocare'><a href='partita.php?id=".$row["Id"]."'>";
                            elseif($numrows&&!is_null($row["Vince1"]))
                                echo "<td class='giocata'><a href='partita.php?id=".$row["Id"]."'>";
                            else echo "<td class='nopartite'>";
                            echo "<span class='datacalendario'>".$dt->format('d-m')."</span>";
                            echo "<br><br>";
                            if($numrows){
                                $squadra1 = (is_null($row['Squadra1'])?"?":$row['Squadra1']);
                                $squadra2 = (is_null($row['Squadra2'])?"?":$row['Squadra2']);
                                echo "<div class='squadracalendario'>".$squadra1."</div> VS <span class='squadracalendario'>".$squadra2."</span>";
                                echo "</a>"; 
                            }
                                
                                                          
                            
                            echo "</td>";
                            
                            $colonne++;
                        }
                        echo "</tr>";
                        echo "</table>";
                        
                    }
                    

                    break;
                    

                    case '2':
                        //statistiche
                        echo "
                        <form id='loginform' >
                        
                        <fieldset class='field'>
                            <div id='etichettelogin'>
                                <label for='filtrasquadra'>Filtra: </label>
                            
                            </div>
                            <div id='inputlogin'>
                                <select id='filtrasquadra' name='filtrasquadra' >
                                    <option value='' selected>Tutto il torneo</option>";
                                    $query = "select Nome, Id from squadra where Torneo=?";
                                    if($statement = mysqli_prepare($connection, $query)){
                                        mysqli_stmt_bind_param($statement, 's', $id);
                                
                                        mysqli_stmt_execute($statement);
                                    }
                                    else {
                                        die(mysqli_connect_error());
                                    }
                
                                    
                                    $resultsquadra = mysqli_stmt_get_result($statement);
                                    
                                    while($rowsquadra = mysqli_fetch_assoc($resultsquadra)){
                                        echo "<option value='".$rowsquadra['Id']."'>".$rowsquadra['Nome']."</option>";
                                    }

                                    
                                    


                                echo "</select>
               
                            </div>
        
                        </fieldset>
                    </form>
                   
                    <canvas   width= '1000' height= '500'>
                                    Per visualizzare questo contenuto è necessario disporre di canvas.
                                </canvas>

                    <script>

                                function loadfromservice(squadra){
                                    let stringa= '';
                                    if(squadra!==''){
                                        stringa = '&squadra='+squadra;
                                    }
                                   
                                    fetch('backendstatistiche.php?torneo=$id'+stringa)
                                    .then(res => res.json())
                                    .then(data => {
                                            stampasucanvas(data);
                                        }
                                    );
                                }

                                function stampasucanvas(data){

                                    
                                
                                    let ampiezza = 1000/data.partite.length;
                                    const canvas = document.querySelector('canvas');
                                    const context = canvas.getContext('2d');
                                    context.clearRect(0, 0, canvas.width, canvas.height);
                                    let counter = 0;
                                    context.save();

                                    context.font = '40px Inter';
                                    context.fillStyle = 'white';
                                    context.textAlign = 'center';
                                    context.fillText('Punti per partita', 500,70);
                                    let maxpunti = 0;
                                    let start = 0.3;
                                    if(data.partite.length<=4){
                                        start = 0.5;
                                    }


                                    for(let i of data.partite){
                                        context.font = '20px Serif';
                                        context.fillStyle= 'white';
                                        context.textAlign='left';
                                        
                                        context.fillText(i.giorno+'-'+i.mese, ampiezza*start +ampiezza*counter, 450);
                                        if(i.sommapunti>maxpunti) maxpunti = i.sommapunti;
                                        counter++;
                                        
                                        
                                    }

                                    counter = 0;
                                    

                                    for(let i of data.partite){
                                        
                                        context.fillStyle= 'blue';
                                        
                                        context.fillRect(ampiezza*counter+ampiezza*0.1,  400- 280*i.sommapunti/maxpunti, ampiezza*0.8, 280*i.sommapunti/maxpunti);
                                        context.fillStyle= 'white';
                                        context.font = '30px Serif';
                                        context.fillText(i.sommapunti, ampiezza*start+ampiezza*counter, 200);
                                        counter++;
                                        
                                        
                                    }



                                    context.restore();


                                    
                                }

                                function cambiagrafico(e){
                                    
                                    loadfromservice(e.target.value);
                                }

                                    function init(){
                                        loadfromservice('');
                                        document.getElementById('filtrasquadra').addEventListener('change', cambiagrafico);
                                    }

                                    init();

                                </script>
                        ";
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