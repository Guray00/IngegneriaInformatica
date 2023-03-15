<!DOCTYPE html>
<head>
    <title>Test</title>
    <style type = "text/css">
       
	</style>
</head>
<body style = "background-color: lightgray" >

    <h1>Se ci sono degli errori, appariranno qua sotto:</h1>

    <?php
        
        require_once(realpath(dirname(__FILE__)) . '/EsameLaureandoTest.php');
        require_once(realpath(dirname(__FILE__)) . '/../classi/console_log.php');
        require_once(realpath(dirname(__FILE__)) . '/CarrieraLaureandoTest.php');
        require_once(realpath(dirname(__FILE__)) . '/CarrieraLaureandoInformaticaTest.php');

        // test di unità : nelle funzioni vengono chiamati i test delle singole unità

        $classe = new EsameLaureandoTest();
        $classe->test();
        $classe = new CarrieraLaureandoTest();
        $classe->test();
        $classe = new CarrieraLaureandoInformaticaTest();
        $classe->test();

        
        

    ?>
</body>