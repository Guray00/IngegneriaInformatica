<?php
require_once __DIR__ . "/../includes/methods.php";
session_start();

if(!isset($_SESSION['accountID'])){
    apiError(403);
}

if(!isset($_SERVER['REQUEST_METHOD']) || $_SERVER["REQUEST_METHOD"] !== "POST" || !isset($_POST['filter'])){
    apiError(405);
}

$id = unserialize($_SESSION['accountID']);
$filter = json_decode($_POST['filter']);

if($filter !== null){
    if (!is_array($filter)){
        $filter = [$filter];
    }   
    $allItemType = getItemTypes();
    foreach($filter as $index => $el){
        if(!in_array($el, $allItemType)){
            unset($filter[$index]);
        }
        if(preg_match('/^obj_/', $el)){
            foreach($allItemType as $type){
                if(!in_array($type, NOT_OBJECT_TYPES))
                    $filter[]  = $type;
            }
        }
    }
    
    $filter = array_unique($filter);
}

$inventory = getInventory($id, $filter);

header('Content-Type: application/json');

echo json_encode($inventory);
?>