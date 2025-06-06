<?php
session_start();
require_once __DIR__ . "/../includes/methods.php";

if(!isset($_SESSION['accountID'])){
    pageError(403);
}


$message = null;
if(isset($_SESSION["message"])){
    $message = $_SESSION["message"];
    unset($_SESSION["message"]);
}

$errorMessage = null;
if(isset($_SESSION["errorMessage"])){
    $errorMessage = $_SESSION["errorMessage"];
    unset($_SESSION["errorMessage"]);
}

$account = null;
$id = unserialize($_SESSION['accountID']);
try {
	$account = new Account($id, true);
} 
catch (Exception $e) {
	error_log("Errore durante il recupero dell'account in dashboard.php: " . $e->getMessage());
	pageError($e->getCode());
}

$user = $account->getAll();

$characterList = "";
foreach ($user["personaggi"] as $i => $character){
    $PG = $character->getAll();
    $characterList .= "<div id='". $PG["nome"] ."' class='character-item'>\n";
    $characterList .= "<div class='pg-info-block'>\n<img src='./../../". $PG["pathImmagine"] ."' alt='Immagine Personaggio'>\n";
    $characterList .= "<p class='pg-name-box'>" . $PG["nome"] . "</p>\n</div>\n";
    $characterList .= "<div class='pg-lvl-block'>\n";
    $characterList .= "<p class='pg-lvl-info'>Livello: " .$PG['livello'] ."</p>\n";
    $characterList .= "<div class='pg-exp-bar'>\n<div class='pg-exp-points' style='width: ". $PG['exp'] * 100 / Personaggio::MAX_EXP . "%'>";
    $characterList .= "</div>\n</div>";
    $characterList .= "</div>\n</div>";
}

$addCharacterButton = (count($user["personaggi"]) != Account::MAX_NUM_PERSONAGGI)? 
'<div id="add-character" style="grid-row: span '. 5 - count($user["personaggi"]).'">Aggiungi un personaggio</div>':
" ";
            
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Titles - Dashboard</title>
    <link rel="icon" href="./../../images/icon.svg" type="image/svg+xml" sizes="16x16" >
    <link rel="stylesheet" href="./../../css/global/style.css">
    <link rel="stylesheet" href="./../../css/pages/dashboard.css">
    <link rel="stylesheet" href="./../../css/components/inventory.css">
    <link rel="stylesheet" href="./../../css/components/shop.css">
    <link rel="stylesheet" href="./../../css/components/menu.css">
    <script type="module" src="./../../js/pages/dashboard.js"></script>
    <script>
        const USERNAME = "<?php echo $user["username"]?>";
        const message = <?php echo json_encode($message)?>;
        const errorMessage = <?php echo json_encode($errorMessage)?>;
    </script>
</head>
<body>
    <header>
        <h1><i>Titles</i></h1>
        <aside>
            <form action="../handlers/logout.php" method="POST">
                <button type="submit">Logout</button>
            </form>
        </aside>
    </header>
    <div class="content">
        <div class="top-section">
            <img draggable="false" id="menu" src="./../../images/menu.svg" alt="menu item" class="clickable">
            <div class="user-info">
                <div class="user-pic">
                    <img id="userPic" draggable="false" src="./../../<?php echo $user['immagineProfilo']; ?>" alt="Profile Pic">
                </div>
                <div class="username-box">
                    <p><?php echo $user['username'];?></p>
                </div>
            </div> 
            <div class="coin-display">
                <img draggable="false" src="./../../images/coin.svg" alt="coin image">
                <span id="coin-count"><?php echo $user['monete']; ?></span>
            </div>
        </div>
        <main class="main-section">
            <aside class="character-list" style="grid-template-rows: repeat(<?php echo count($user["personaggi"])?>, 3em) 1fr;">
                <?php echo $characterList; ?>
                <?php echo $addCharacterButton; ?>
            </aside>
            <aside class="button-container">
                <div id="inventory-btn" class="button inventory-button">
                    <img draggable="false" src="./../../images/inventoryPic.svg" alt="Immagine Inventario">
                    <p>Inventario</p>
                </div> 
                <div id="shop-btn" class="button shop-button">
                    <img draggable="false" src="./../../images/shopPic.svg" alt="Immagine Shop">
                    <p>Negozio</p>
                </div> 
            </aside>
        </main>
    </div>
    <div id="menuModule" class="module"></div>
    <div id="inventoryModule" class="module"></div>
    <div id="shopModule" class="module"></div>
</body>
</html>