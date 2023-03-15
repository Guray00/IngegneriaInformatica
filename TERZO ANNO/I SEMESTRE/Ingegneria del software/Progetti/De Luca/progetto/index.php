<!DOCTYPE html>
<head>
    <title>Progetto</title>
    <style type = "text/css">
        body{
            text-align: center;
            background-color: lightblue;
            font-size: larger;
        }
        button{
            color: white;
            background-color: rgb(0, 102, 139);
            padding: 0.5em;
            margin: 0.5em;
            border-radius: 5px;
        }
    </style>
</head>
<body >
    <h1> semplice interfaccia di prova </h1>


    <form action = "index.php" method = "get">

        <h1> Laureandosi 2 - Gestione Lauree </h1>
        <!-- campi  -->
        
        <p>Cdl:</p>
        <select name = "cdl"><!-- tutti quelli dei test  -->
            <option name = "cdl">T. Ing. Informatica</option>
            <option name = "cdl">M. Cybersecurity</option>
            <option name = "cdl">M. Ing. Elettronica</option>
            <option name = "cdl">T. Ing. Biomedica</option>
            <option name = "cdl">M. Ing. Biomedica, Bionics Engineering</option>
            <option name = "cdl">T. Ing. Elettronica</option>
            <option name = "cdl">T. Ing. delle Telecomunicazioni</option>
            <option name = "cdl">M. Ing. delle Telecomunicazioni</option>
            <option name = "cdl">M. Computer Engineering, Artificial Intelligence and Data Enginering</option>
            <option name = "cdl">M. Ing. Robotica e della Automazione"</option>
        </select>

        <br>

        <p>Matricole:</p>
        <textarea name = "matricole"></textarea>

        <br>

        <p>Data Laurea:</p>
        <input type = "date" name = "data_laurea"/>

        <br>
        <br>
        <br>

        <!-- bottoni  -->
        <button type = "submit">
            Crea Prospetti
        </button>
        <br>
        <a href = "/progetto/data/pdf_generati/"> Apri prospetti</a>
        <br>
        <button>Invia Prospetti (da implementare) </button>
        <br>
    </form>





    <?php
        /*
        require_once(realpath(dirname(__FILE__)) . '/classi/CarrieraLaureando.php');
        require_once(realpath(dirname(__FILE__)) . '/classi/ProspettoPdfLaureando.php');
        require_once(realpath(dirname(__FILE__)) . '/classi/ProspettoConSimulazione.php');
        require_once(realpath(dirname(__FILE__)) . '/classi/ProspettoPdfCommissione.php');

        //include('\progetto\CarrieraLaureando.php');
        $prospetto = new ProspettoPdfCommissione([123456,345678], "T. Ing. Informatica", "2018-04-18");
        $prospetto->GeneraProspettoCommissione();
        */

        require_once(realpath(dirname(__FILE__)) . '/classi/ProspettoPdfCommissione.php');
        require_once(realpath(dirname(__FILE__)) . '/classi/console_log.php');

        // il codice da eseguire in caso di post
    if (isset($_GET["matricole"])) {
        console_log("index: ricevuto cdl: " . $_GET["cdl"]);
        console_log("index: ricevute matricole: " . $_GET["matricole"]);
        console_log("index: ricevuta data: " . $_GET["data_laurea"]);

        $matricole_array = array_map("intval", explode(",", $_GET["matricole"])); //stringa in array di interi

        $prospetto = new ProspettoPdfCommissione($matricole_array, $_GET["cdl"], $_GET["data_laurea"]);
        $prospetto->GeneraProspettoCommissione();
        $prospetto->generaProspettiLaureandi();

        console_log("index: prospetti generati");
        echo "i prospetti sono stati generati";
    }

    ?>
</body>
