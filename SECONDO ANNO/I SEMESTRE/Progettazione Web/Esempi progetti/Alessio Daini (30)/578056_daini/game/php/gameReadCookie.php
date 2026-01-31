<?php

function receiveCookie(){
    if(isset($_COOKIE["username"])){
        echo json_encode(["success" => true,"username" => $_COOKIE["username"]]);
    }else{
        echo json_encode(["success" => false]);
    }
}

receiveCookie();

?>