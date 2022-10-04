<?php

function connect(){
  $DB_HOST ='localhost';
	$DB_USER ='root';
	$DB_PASS ='';
	$DB_DB ='sitoagenzie';
	$link = mysqli_connect($DB_HOST,$DB_USER ,$DB_PASS,$DB_DB);
	if (!$link) {
		print"Error: Unable to connect to MySQL." . PHP_EOL;
		print"Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
		print"Debugging error: " . mysqli_connect_error() . PHP_EOL;
		return null;
	}else{
		if (!mysqli_set_charset($link, "utf8")) {
		    printf("Error loading character set utf8: %s\n", mysqli_error($link));
		    exit();
		}
		return $link;
	}
}
?>
