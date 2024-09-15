<?php

require_once "dbaccess.php";

$connection = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);
                if(mysqli_connect_errno())
                    die(mysqli_connect_error());



class Partita  {
    public $giorno;
    public $mese;
    public $sommapunti;

}

if(!isset($_GET['torneo'])){
    echo "Bad Request";
}



else if(!isset($_GET['squadra'])){

    $elencopartite = [];
    $torneo = $_GET['torneo'];
    

    $query = "select (ifnull(Set1Squadra1, 0)+ifnull(Set2Squadra1, 0)+ifnull(Set3Squadra1, 0)+ifnull(Set1Squadra2, 0)+ifnull(Set2Squadra2, 0)+ifnull(Set3Squadra2, 0)) as Punti, day(Dataeora) as Giorno, month(Dataeora) as Mese from partita where Torneo=?";
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 's', $torneo);
        mysqli_stmt_execute($statement);
        $resultsquadra = mysqli_stmt_get_result($statement);
        while($rowsquadra = mysqli_fetch_assoc($resultsquadra)){
            $nuovapartita = new Partita;
            $nuovapartita->giorno=$rowsquadra['Giorno'];
            $nuovapartita->mese=$rowsquadra['Mese'];
            $nuovapartita->sommapunti=$rowsquadra['Punti'];
    
            array_push($elencopartite, $nuovapartita);
        }
        print json_encode(array("partite"=>$elencopartite));
    
    }
    else {
        die(mysqli_connect_error());
    }
        
}

else {
    $elencopartite = [];
    $squadra = $_GET['squadra'];
    $query = "select (ifnull(Set1Squadra1, 0)+ifnull(Set2Squadra1, 0)+ifnull(Set3Squadra1, 0)) as Punti, day(Dataeora) as Giorno, month(Dataeora) as Mese from partita where Squadra1=? union select (ifnull(Set1Squadra2, 0)+ifnull(Set2Squadra2, 0)+ifnull(Set3Squadra2, 0)) as Punti, day(Dataeora) as Giorno, month(Dataeora) as Mese from partita where Squadra2=?;";
    if($statement = mysqli_prepare($connection, $query)){
        mysqli_stmt_bind_param($statement, 'ss', $squadra, $squadra);
        mysqli_stmt_execute($statement);
        $resultsquadra = mysqli_stmt_get_result($statement);
        while($rowsquadra = mysqli_fetch_assoc($resultsquadra)){
            $nuovapartita = new Partita;
            $nuovapartita->giorno=$rowsquadra['Giorno'];
            $nuovapartita->mese=$rowsquadra['Mese'];
            $nuovapartita->sommapunti=$rowsquadra['Punti'];
    
            array_push($elencopartite, $nuovapartita);
        }
        print json_encode(array("partite"=>$elencopartite));
    
    }
    else {
        die(mysqli_connect_error());
    }
    
}
    
    







?>