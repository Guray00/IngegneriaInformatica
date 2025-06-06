<?php
session_start();

$message = null;
if(isset($_SESSION["message"]))
	$message = $_SESSION["message"];

session_unset();
session_destroy();

session_start();
if($message)
	$_SESSION["message"] = $message;

session_write_close();
header("Location: ./../../index.php");
exit();

?>