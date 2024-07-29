<?php
	session_start();

	// Codice eseguito la prima volta per generare 
	// le coppie di figure
	if (!isset($_SESSION['random'])) {
		// Crea un array che contiene i valori da 1 a 25 e poi
		// ancora da 1 a 25
		$array = array_merge(range(1, 25), range(1,25));
		// Mescola l'array
		shuffle($array);
		var_dump($array);
		// Memorizza l'array nella sessione
		$_SESSION['random'] = $array;
	}  

	// Il client ha fatto una richiesta in cui
	// ha fornito l'indice di una casella
	// Il server risponde dicendo che nella casella con 
	// tale id deve essere inserita l'immagine $val
	$val = $_SESSION['random'][$_GET['id']];
	echo $val;
?>