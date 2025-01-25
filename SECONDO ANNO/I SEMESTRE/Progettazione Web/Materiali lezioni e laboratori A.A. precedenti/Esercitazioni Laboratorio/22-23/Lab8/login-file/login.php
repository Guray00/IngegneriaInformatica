<!DOCTYPE html>
<html lang="it-IT">
<head>
  <meta charset="utf-8">
  <title>LOGIN</title>
</head>
<body>


<?php

	function verifica($nome, $password) {
		$f = fopen("users.txt", "r");
		while($riga = fgets($f)){
			$comp = explode(" ", $riga);
			if(trim($comp[0]) == $nome && trim($comp[1])==$password) {
				fclose($f);
				return true;
			}
		}
		fclose($f);
		return false;
	}
	
	if (isset($_GET['username']) && isset($_GET['password'])) {
		if (verifica($_GET['username'], $_GET['password'])) {
			print "LOGIN AVVENUTO CON SUCCESSO";
		} else {
			print "LOGIN ERRATO";
		}		
	}

?>


</body>

</html>