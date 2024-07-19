<?php
include "dbparams.php";


/*
 * Per eseguire SQL injection, inserire nel campo nome la seguente stringa
 * a', 'b', 1); truncate table iscritti;#
 * 
 * che quando usata nell'INSERT produce
 * INSERT INTO iscritti (nome, cognome, matricola) VALUES ('a', 'b', 1); truncate table iscritti;#...
 */


$nome = $_POST["nome"];
$cognome = $_POST["cognome"];
$matricola = $_POST["matricola"];

if(empty($nome) || empty($cognome) || empty($matricola)) {
    echo paginaConMessaggio("Inserire tutti i valori");
    die(1);
}
if(!matricolaValida($matricola)) {
    echo paginaConMessaggio("Il numero di matricola deve essere formato da 6 cifre");
    die(1);
}

try {
    $pdo = new PDO(CONN_STRING, USER, PWD);

    $check = "SELECT COUNT(*) from iscritti WHERE matricola=$matricola";
    $result = $pdo->query($check);
    $count = $result->fetchColumn();
    if($count == 1) {
        echo paginaConMessaggio("C'è già un iscritto con lo stesso numero di matricola");
        exit(1);
    }
    $cmd = "INSERT INTO iscritti (nome, cognome, matricola) VALUES ('$nome', '$cognome', $matricola)";
    echo $cmd;
    $count = $pdo->exec($cmd);
    if($count == 1) {
        echo paginaConMessaggio("Inserito con successo");
    } else {
        echo paginaConMessaggio("Non inserito");
    }
    $pdo = null;
} catch(PDOException $e) {
    echo paginaConMessaggio("Non inserito");
    die($e->getMessage());
}


function paginaConMessaggio($messaggio) {
    $r = "<!DOCTYPE html><html><head><title>Lista</title><link rel='stylesheet' href='stile.css'></head><body><p>";
    $r .= $messaggio;
    $r .= "</p></body></html>";
    return $r;
}

function matricolaValida($m) {
    return preg_match('/^[0-9]{6}$/', $m);
}