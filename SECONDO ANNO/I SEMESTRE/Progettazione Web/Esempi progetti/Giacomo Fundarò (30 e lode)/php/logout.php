<?php
session_start();
session_unset();
session_destroy();
setcookie("session_token", "", time() - 3600, "/");
echo json_encode(["status" => "success"]);
?>