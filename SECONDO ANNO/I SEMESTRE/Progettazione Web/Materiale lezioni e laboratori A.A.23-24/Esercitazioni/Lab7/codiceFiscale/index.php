<!DOCTYPE html>
<html>
	<head  lang="it">
		<meta charset="utf-8">
		<title>Genera il tuo codice fiscale</title>
		
		<style>
			fieldset{
				float:left;
				width: fit-content;
				padding: 1em;
				margin: 0.3em;
			}
			.buttons {
				padding: 0.6em 0em;
				width: 7em;
				border-radius: 15px;
				text-align: center;
				font-size: 1em;
				font-weight: bold;
				margin: 2em 1em 2em 1em;
			}
			.errore{
				color:red;
			}
			.success{
				color:darkGreen;
				font-size: 2em;
				font-weight: bold;
			}
			#avanti{color: green;}
			#reset{color: darkorange;}
		</style>
	</head>
	<body>
		<?php
			if (isset($_GET["error"])){
				print "<p class='errore'>".$_GET["error"]. "</p>";
			}
			if (isset($_GET["codiceFiscale"])){
				print "<p class='success'>ECCO IL TUO CODICE FISCALE: ".$_GET["codiceFiscale"]. "</p>";
			}
			if (isset($_GET["nome"])){
				$nome=$_GET["nome"];
			}
			if (isset($_GET["cognome"])){
				$cognome=$_GET["cognome"];
			}
			if (isset($_GET["date"])){
				$date=$_GET["date"];
			}
		?>
		<form  method="post" action="generaCodice.php">
			
			<fieldset name="dati_personali">
				<legend>Dati personali</legend>
			
					<label>
						Nome: *<br>
					</label>
					<input name="nome" size="15" type="text" placeholder="Es: Mario" value = "<?php echo (isset($nome))?$nome:'';?>" ><br>
					
					<label>
						Cognome: *<br>					
					</label>
					<input name="cognome" size="15" type="text" placeholder="Es: Rossi" value = "<?php echo (isset($cognome))?$cognome:'';?>" ><br>
		
					<label>
						Data di Nascita:<br>
					</label>
					<input name="date" type="date" value = "<?php echo (isset($date))?$date:'';?>" ><br>
					
					<input type="submit" class="buttons" id="avanti">
					<input type="reset" class="buttons" id="reset">
			</fieldset>	
		</form>
	</body>

</html>