<?php

$url = "index.php";

/*
 * Se il metodo non è POST rimando l'utente alla pagina
 * index.php aggiungendo una query string in cui 
 * la chiave error è associata a un messaggio di errore
 */
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    $message = $_SERVER["REQUEST_METHOD"] . " metodo non valido";
    $url = $url . "?error=" . $message;
    header('Location: ' . $url);
    exit;
}


/*
 * Controlla che tutti i campi siano presenti e che abbiano una lunghezza maggiore di zero
 * Nel caso di campi assenti o con lunghezza pari a zero
 * rimando l'utente alla pagina index.php aggiungendo una query string
 * in cui la chiave error è associata a un messaggio di errore
 */
if (!isset($_POST["nome"]) || !isset($_POST["cognome"]) || !isset($_POST["date"]) || 
    strlen($_POST["nome"]) == 0 || strlen($_POST["cognome"]) == 0 || strlen($_POST["date"]) == 0 ){
    // Messaggio di errore    
    $message = "Compilare tutti gli elementi del form";
    // Aggiungo la query string con il messaggio di errore
    $url = $url . "?error=" . $message;
    // Aggiungo nella query string le coppie chiave-valore 
    // corrispondenti ai parametri già specificati dall'utente
    // in modo da poter riempire nuovamente il form
    if (isset($_POST["nome"]) && strlen($_POST["nome"]) != 0){
        $url = $url . "&nome=" . $_POST["nome"];
    }
    if (isset($_POST["cognome"]) && strlen($_POST["cognome"]) != 0){
        $url = $url . "&cognome=" . $_POST["cognome"];
    }
    if (isset($_POST["date"]) && strlen($_POST["date"]) != 0){
        $url = $url."&date=" . $_POST["date"];
    }
    // Redirige il client al nuovo url
    header('Location: '.$url);
    exit;
}

/*
 * Arrivati a questo punto abbiamo raccolto tutti i dati necessari
 * per il calcolo del codice fiscale
 */
$nome=$_POST["nome"];
$cognome=$_POST["cognome"];
$date=$_POST["date"];

/*
 * Il codice fiscale viene generato mediante una funzione apposita
 */ 
$codiceFiscale = generacodicefiscale($nome, $cognome, $date);

/*
 * Rimando l'utente alla pagina iniziale index.php
 * aggiungendo una query string con il risultato
 */ 
$url = $url . "?codiceFiscale=" . $codiceFiscale;
header('Location: ' . $url);

/*
 * Calcola il codice fiscale a partire da nome, cognome e data
 */ 
function generacodicefiscale($nome, $cognome, $date) {
   
    // genera la prima parte a partire dal cognome
    $codice = generaCodiceNomeCognome($cognome);
    // genera la seconda parte a partire dal cognome
    $codice = $codice . generaCodiceNomeCognome($nome);
    // genera l'ultima parte a partire dalla data
    $codice = $codice . substr($date, 2, 2) . getmonth(substr($date, 5, 2)) . substr($date, strlen($date)-2, 2);
    // restituisce il risultato
    return $codice;
}

/*
 * Restituisce le prime tre consonanti del cognome
 * Se non ci sono abbastanza consonanti allora inserisce anche delle vocali
 * Se non ci sono neanche abbastanza vocali inserisce delle 'X'
 */
function generaCodiceNomeCognome($c){
    // Converto in lettere maiuscole
    $c = strtoUpper($c);
    // Separo le vocali dalle consonanti
    $consonanti = [];
    $vocali = [];

    for ($i=0; $i<strlen($c); $i++){
        switch ($c[$i]){
            case "A": case "E": case "I": case "O": case "U":
                array_push($vocali, $c[$i]);
                break;
            case "B": case "C": case "D" : case "F": case "G": 
            case "H": case "J": case "K": case "L": case "M": 
            case "N": case "P": case "Q": case "R": case "S": 
            case "T": case "V": case "W": case "X": case "Y": case "Z":
                array_push($consonanti, $c[$i]);
                break;
        }
    }
    
    if (count($consonanti) >= 3)
        return $consonanti[0] . $consonanti[1] . $consonanti[2];
    
    $code = implode('', $consonanti);
    for ($i=0; $i<=3 - strlen($code); $i++){
        if (count($vocali) > 0)
            $code = $code . array_shift($vocali);
        else
            $code = $code . "X";
    }

    return $code;
}

function getmonth($month){
    $alfabetoMesi = array( 'A', 'B', 'C', 'D', 'E','H', 'L', 'M', 'P', 'R',
                       'S', 'T');
    $m = (int) $month;
    return $alfabetoMesi[$month-1];
}
?>
