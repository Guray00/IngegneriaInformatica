<!DOCTYPE html>
<html>
	<head>
	<meta charset="utf-8">
	<title>Memory</title>
		<link rel="stylesheet" href="css/style.css">
		<script type="text/javascript" src="js/memory.js"></script>
	</head>
	<body onload="ready()">	
		<h4>Punteggio: <span id="score">0</span></h4>
		<div id="container">
		<?php
			for ($value=0; $value<50; $value++) {
				print trim("<div class='square' id='".$value."'>".$value."</div>");
			}
		?>
		</div>
	</body>
</html>