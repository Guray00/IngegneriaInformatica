<?php
include "dbparams.php";

$intestazione = <<<EOD
<!DOCTYPE html>
    <html>
        <head>
        <title>Lista</title>
        <link rel='stylesheet' href='stile.css'>
        </head>
        <body>
            <table>
                <tr><th>Matricola</th><th>Nome</th><th>Cognome</th></tr>
EOD;

$chiusura = <<<EOD
            </table>
        </body> 
    </html>
EOD;

function riga($m, $n, $c) {
    $r = "<tr>";
    $r .="<td>$m</td><td>$n</td><td>$c</td>";
    $r .= "</tr>";
    return $r;
}

try {
    $pdo = new PDO(CONN_STRING, USER, PWD);

    $check = "SELECT * from iscritti";
    $result = $pdo->query($check);
    echo $intestazione;
    while($row = $result->fetch()) {
        $m = $row["matricola"];
        $n = $row["nome"];
        $c = $row["cognome"];
        echo riga($m, $n, $c);
    }
    echo $chiusura;
    $pdo = null;
} catch(PDOException $e) {
    die($e->getMessage());
}