<?php

session_start();

if(!isset($_SESSION['accountID'], $_SESSION['currentPG_nome'])){
	pageError(403);
}

if(!isset($_SESSION['battaglia'])){
	header("Location: ./dashboard.php");
	exit;
}

$message = null;
if(isset($_SESSION['message'])){
	$message = $_SESSION['message'];
	unset($_SESSION['message']);
}

$errorMessage = null;
if(isset($_SESSION['errorMessage'])){
	$errorMessage = $_SESSION['errorMessage'];
	unset($_SESSION['errorMessage']);
}

$gameMessage = null;
if(isset($_SESSION['gameMessage'])){
	$gameMessage = $_SESSION['gameMessage'];
	unset($_SESSION['gameMessage']);
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Titles</title>
	<link rel="icon" href="./../../images/icon.svg" type="image/svg+xml" sizes="16x16" >
	<link rel="stylesheet" href="./../../css/global/style.css">
	<link rel="stylesheet" href="./../../css/pages/gamePage.css">
	<link rel="stylesheet" href="./../../css/components/personaggio.css">
	<link rel="stylesheet" href="./../../css/components/inventory.css">
	<script type="module" src="./../../js/pages/gamePage.js"></script>
	<script>
		const message = <?php echo json_encode($message)?>;
		const errorMessage = <?php echo json_encode($errorMessage)?>;
		const gameMessage = <?php echo json_encode($gameMessage)?>;
	</script>
	<meta charset="UTF-8">
</head>
<body>
	<header>
        <h1><i>Titles</i></h1>
        <aside>
            <button id="giveUpBtn">Arrenditi</button>
        </aside>
    </header>
	<main>
		<div id="imageContainer"></div>
		<aside class="actionSection">
			<div class="action-block">
				<div id="top-section" class="timer-section">
					<span id="timer">00:00</span>
				</div>
				<input type="radio" name="usingObj" id="input-obj_0" value="0" disabled hidden>
				<input type="radio" name="usingObj" id="input-obj_1" value="1" disabled hidden>
				<input type="radio" name="usingObj" id="input-obj_2" value="2" disabled hidden>
				<button id="actionBtn" class="" disabled></button>
				<div class="bag-section">
					<div class="item-container">
						<div id="obj_0" class="item-slot bag-item not-clickable">
						</div>
					</div>
					<div class="item-container">
						<div id="obj_1" class="item-slot bag-item not-clickable">
						</div>
					</div>
					<div class="item-container">
						<div id="obj_2" class="item-slot bag-item not-clickable">
						</div>
					</div>
				</div>
			</div>
		</aside>
	</main>
</body>
</html>