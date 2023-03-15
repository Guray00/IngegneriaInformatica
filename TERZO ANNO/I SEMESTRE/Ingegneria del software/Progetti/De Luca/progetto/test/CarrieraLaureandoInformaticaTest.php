<?php
require_once(realpath(dirname(__FILE__)) . '/../classi/CarrieraLaureandoInformatica.php');

class CarrieraLaureandoInformaticaTest{

    public function test(){
        $this->test_costruttore();
        $this->test_media_info();
        echo nl2br("\r\nCARRIERA LAUREANDO INFORMATICA: TUTTI I TEST ESEGUITI");  
    }

    function test_costruttore(){

        // test del calcolo del bonus 

        $x1= new CarrieraLaureandoInformatica("123456","T. Ing. Informatica","2025-05-05");
        $x2= new CarrieraLaureandoInformatica("345678","T. Ing. Informatica","2025-05-05");
        $x3= new CarrieraLaureandoInformatica("123456","T. Ing. Informatica","2017-05-05");
        $x4= new CarrieraLaureandoInformatica("345678","T. Ing. Informatica","2020-05-05");

        $expected = "NO";
        $result = $x1->getBonus();
        if($expected != $result) echo "CarrieraLaureandoInformatica : errore1: expected:" . $expected . " recived:" . $result;
        $expected = "NO";
        $result = $x2->getBonus();
        if($expected != $result) echo "CarrieraLaureandoInformatica : errore2: expected:" . $expected . " recived:" . $result;
        $expected = "SI";
        $result = $x3->getBonus();
        if($expected != $result) echo "CarrieraLaureandoInformatica : errore1: expected:" . $expected . " recived:" . $result;
        $expected = "SI";
        $result = $x4->getBonus();
        if($expected != $result) echo "CarrieraLaureandoInformatica : errore2: expected:" . $expected . " recived:" . $result;

        //test che il bonus venga applicato, ovvero che la media risulti diversa

        if ($x1->restituisciMedia() == $x3->restituisciMedia()) {
            echo "CarrieraLaureandoInformatica : errore laureando 1 nel bonus, la media non è cambiata";
        }
        if ($x2->restituisciMedia() == $x4->restituisciMedia()) {
            echo "CarrieraLaureandoInformatica : errore laureando 2 nel bonus, la media non è cambiata";
        }

        // controllare che la media con bonus sia corretta (ne ho solo una)
        
        if ($x4->restituisciMedia()< 25.5 || $x4->restituisciMedia() > 25.6 ) {
            echo "CarrieraLaureandoInformatica : errore laureando 2 nel bonus, la media non è corretta: recived " . $x4->restituisciMedia();
        }
        
    }

    function test_media_info(){
        $x1= new CarrieraLaureandoInformatica("123456","T. Ing. Informatica","2025-05-05");
        $x2= new CarrieraLaureandoInformatica("345678","T. Ing. Informatica","2020-05-05");

        // controllo che sia corretta
        if ($x1->getMediaEsamiInformatici()< 23.6 || $x1->getMediaEsamiInformatici() > 23.7 ) {
            echo "CarrieraLaureandoInformatica : errore laureando 1 nella media informatica: recived " . $x1->getMediaEsamiInformatici();
        }
        if ($x2->getMediaEsamiInformatici()< 25.7 || $x2->getMediaEsamiInformatici() > 25.8 ) {
            echo "CarrieraLaureandoInformatica : errore laureando 2 nella media informatica: recived " . $x2->getMediaEsamiInformatici();
        }
    }



}
?>