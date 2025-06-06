<?php
    session_start();
    session_unset();
    session_destroy();

    require_once __DIR__ . "/../includes/methods.php";

    if(!isset($_GET['error_code'])){
        pageError("403");
    }
    $errorCode = $_GET['error_code'];
    switch($errorCode){
        case "401":
            $title = '401 Unauthorized';
            $paragrafo = "Devi essere loggato per poter accedere a questa pagina.";
            $bottone = "Torna alla <i>home page</i> per il login.";
            break;
        case '403':
            $title = '403 Forbidden';
            $paragrafo = "Non hai il permesso di accedere a questa pagina.";
            $bottone = "Ritorna alla <i>home page</i>";
            break;
        case '500':
            $title = '500 Internal Server Error';
            $paragrafo = "Ci scusiamo per il disagio, ma il server non è al momento disponibile.</p><p> Per favore, provare più tardi.";
            $bottone = "Ritorna alla <i>home page</i>";
            break;
        case '400': default:
            $title = '400 Bad Request';
            $paragrafo = "La richiesta è stata formulata male o non è valida.";
            $bottone ="Torna alla <i>home page</i>";
    }
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $title;?></title>
    <link rel="icon" href="./../../images/icon.svg" type="image/svg+xml" sizes="16x16" >
    <link rel="stylesheet" href="./../../css/global/style.css">
    <link rel="stylesheet" href="./../../css/pages/errorPage.css">
</head>
<body>
    <header style="flex-direction:column">
        <h1><?php echo $title; ?></h1>
    </header>
    <div class="dialog-message">
        <main>
            <p><?php echo $paragrafo;?></p>
            <a href="./../../index.php"><button><?php echo $bottone;?></button></a>
        </main>
    </div>
</body>
</html>
