<?php

header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ ."/../../DBMS/GameDBMS/PrintTableDBMS.php";

function buildTable(){
    $vetResult = PrintTableDBMS::recordRanking();//ho un vettore di risultati
    //ora li restituisco
    echo json_encode(["success" => true,"rows" => $vetResult]);
    exit;
}

function waitPacket(){
    $data = json_decode(file_get_contents("php://input"),true);
    buildTable();
}

waitPacket();
?>