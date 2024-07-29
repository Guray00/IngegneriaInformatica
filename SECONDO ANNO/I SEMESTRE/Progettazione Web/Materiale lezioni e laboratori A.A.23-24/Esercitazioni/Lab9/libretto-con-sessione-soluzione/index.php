<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Libretto Universitario</title>
  <style>
    form, table, h1 {
        margin: 1em;
    }
    input, label {
        margin: 0.2em;
    }
  	form > label {
  		display: block;
  		float: left;
  		width: 70px;
  	}
    table {
        border: 1px black solid;
        border-collapse: collapse;
    }
    td,th {
        border: 1px black solid;
        padding: 0.3em;
    }
  </style>
</head>
<body>


<?php
    // Calcola la deviazione standard dei valori contenuti nell'array 
    function deviazioneStandard($arr) { 
        $n = count($arr); 
        $varianza = 0.0; 
        // Calcolo il valore medio 
        $media = array_sum($arr)/$n; 
        foreach($arr as $i) { 
            $varianza += pow(($i - $media), 2); 
        } 
        return (float) sqrt($varianza/$n); 
    }

    // Calcola il valore mediano
	function valoreMediano($v){
		sort($v);
		$indice = floor(count($v) / 2);
		return (count($v) % 2 != 0) ? 
            // numero di elementi e' dispari
            $v[$indice] : 
            // numero di elementi e' pari
            (($v[$indice-1]) + $v[$indice]) / 2;
	}


    // Crea, o recupera, la sessione
	session_start();

    // Se l'oggetto che contiene i voti non c'e' o se bisogna 
    // ricominciare da capo, allora creiamo un array vuoto
	if (!isset($_SESSION['voti']) || isset($_GET['riavvia']))  {
		$_SESSION['voti'] = array();
	} else if (isset($_GET['materia']) && isset($_GET['voto']))  {
        // Se sono presenti i dati materia e voto
        // li inserisco nell'oggetto sessione
		$voto = (int)$_GET['voto'];
		if ($voto >= 18 && $voto<=33) 
				$_SESSION['voti'][$_GET['materia']] = (int) $_GET['voto'];
			else 
				echo "Inserisci un numero tra 18 e 33";
	}

    // Stampa una tabella contenente le statistiche
    function stampaTabella(){
        $a=<<<FINE
        <table>
        <tr>
            <th>Statistica</th>
            <th>valore</th>
        </tr>
        <tr>
            <td>Media</td>
            <td>
        FINE;
        $b=<<<FINE
			</td>
		</tr>
		<tr>
			<td>Valore mediano</td>
			<td>
		FINE;
        $c=<<<FINE
            </td>
            </tr>
            <tr>
            <td>Deviazione Standard</td>
            <td>
        FINE;
        $d=<<<FINE
            </td>
            </tr>
        </table>
        FINE;
        echo $a;   
		echo round(array_sum($_SESSION['voti']) / count($_SESSION['voti']), 2);
        echo $b;
		echo valoreMediano($_SESSION['voti']);
        echo $c;
		printf("%.2f", deviazioneStandard($_SESSION['voti']));
        echo $d;
    }
?>

	<h1>Libretto</h1>
	<form action="index.php" method="GET">
		<label>Materia:</label><input name="materia" type="text" autofocus><br>
		<label>Voto:</label><input name="voto" type="text" ><br>
		<input type="submit" name="inserisci" value="Inserisci">
		<input type="submit" name="riavvia" value="Riavvia">
	</form>

	<table>
		<tr>
			<th>Materia</th>
			<th>Voto</th>
		</tr>
			<?php
				foreach ($_SESSION['voti'] as $key => $value) {
					print "<tr><td>".$key."</td><td>".$value."</td></tr>";
				}
				
			?>
	</table>

	<?php if (count($_SESSION['voti'])>0) 
        stampaTabella();
    ?>
</body>
</html>