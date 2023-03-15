<?php

require_once(realpath(dirname(__FILE__)) . '/../classi/CarrieraLaureando.php');

class CarrieraLaureandoTest{

    public function test(){
        $this->test_costruttore();
        $this-> test_media();
        $this-> test_crediti_cfm();
        $this->test_crediti();
        echo nl2br("\r\nCARRIERA LAUREANDO: TUTTI I TEST ESEGUITI");  
        
    }

    function test_costruttore(){
        // test con dati precisi : si ha a disposizione il risultato corretto e si verifica che il programma lo calcoli bene 
        //--------------   test persona 1 ----------------------- 
        $cl = new CarrieraLaureando("123456", "T. Ing. Informatica");

        $expected = 123456;
        $result =$cl->matricola;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;

        $expected = "GIANLUIGI";
        $result =$cl->nome;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;

        $expected = "DONNARUMMA";
        $result =$cl->cognome;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        $expected = "nome.cognome@studenti.unipi.it";
        $result =$cl->email;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        $expected = "ELETTROTECNICA";
        $result =$cl->esami[0]->nomeEsame;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
        
        $expected = 26;
        $result =$cl->esami[0]->votoEsame;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        $expected = 1;
        $result =$cl->esami[0]->faMedia;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        //--------------   test persona 2 ----------------------- 
        $cl = new CarrieraLaureando("234567", "M. Ing. Elettronica");

        $expected = 234567;
        $result =$cl->matricola;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;

        $expected = "ALESSANDRO";
        $result =$cl->nome;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;

        $expected = "BASTONI";
        $result =$cl->cognome;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        $expected = "nome.cognome@studenti.unipi.it";
        $result =$cl->email;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        $expected = "NANOELETTRONICA E FOTONICA";
        $result =$cl->esami[0]->nomeEsame;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
        
        $expected = 20;
        $result =$cl->esami[0]->votoEsame;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        $expected = 1;
        $result =$cl->esami[0]->faMedia;
        if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    
        console_log("test per il costruttore di carriera laureando eseguiti");


    }

    function test_media(){
        

        $x1= new CarrieraLaureando("123456","T. Ing. Informatica");
        $x2= new CarrieraLaureando("234567","M. Ing. Elettronica");
        $x3= new CarrieraLaureando("345678","T. Ing. Informatica");
        $x4= new CarrieraLaureando("456789","M. Ing. delle Telecomunicazioni");    
        $x5= new CarrieraLaureando("567890","M. Computer Engineering, Artificial Intelligence and Data Enginering");

        // test con valori approssimati per vedere se la media è plausibile. possono essere applicati a qualsiasi laureando
        if($x1->restituisciMedia() < 18 || $x1->restituisciMedia() >33 ||
        $x2->restituisciMedia() < 18 || $x2->restituisciMedia() >33 ||
        $x3->restituisciMedia() < 18 || $x3->restituisciMedia() >33 ||
        $x4->restituisciMedia() < 18 || $x4->restituisciMedia() >33 ||
        $x5->restituisciMedia() < 18 || $x5->restituisciMedia() >33 
        ) echo "CarrieraLaureando: errore nel calcolo delle medie : non sono nel range [18-33]";

        console_log("test: media: " . $x1->restituisciMedia());
        console_log("test: media: " . $x2->restituisciMedia());
        console_log("test: media: " . $x3->restituisciMedia());
        console_log("test: media: " . $x4->restituisciMedia());
        console_log("test: media: " . $x5->restituisciMedia());

        // test specifici conoscendo il risultato
        if($x1->restituisciMedia() < 23 || $x1->restituisciMedia() >24) echo "Carriera Laureando : media1 errata:" . $x1->restituisciMedia();
        if($x2->restituisciMedia() < 24 || $x2->restituisciMedia() >25) echo "Carriera Laureando : media2 errata:" . $x2->restituisciMedia();
        if($x3->restituisciMedia() < 25 || $x3->restituisciMedia() >26) echo "Carriera Laureando : media3 errata:" . $x3->restituisciMedia();
        if($x4->restituisciMedia() < 32 || $x4->restituisciMedia() >33) echo "Carriera Laureando : media4 errata:" . $x4->restituisciMedia();
        if($x5->restituisciMedia() < 24 || $x5->restituisciMedia() >25) echo "Carriera Laureando : media5 errata:" . $x5->restituisciMedia();

    }


    function test_crediti_cfm(){

        $x1= new CarrieraLaureando("123456","T. Ing. Informatica");
        $x2= new CarrieraLaureando("234567","M. Ing. Elettronica");
        $x3= new CarrieraLaureando("345678","T. Ing. Informatica");
        $x4= new CarrieraLaureando("456789","M. Ing. delle Telecomunicazioni");    
        $x5= new CarrieraLaureando("567890","M. Computer Engineering, Artificial Intelligence and Data Enginering");

        
        if($x1->creditiCheFannoMedia() != 174) echo "Carriera Laureando1 : crediti che fanno media errati: ricevuto" . $x1->creditiCheFannoMedia();
        if($x2->creditiCheFannoMedia() != 102) echo "Carriera Laureando2 : crediti che fanno media errati: ricevuto" . $x2->creditiCheFannoMedia();
        if($x3->creditiCheFannoMedia() != 174) echo "Carriera Laureando3 : crediti che fanno media errati: ricevuto" . $x3->creditiCheFannoMedia(); // ancora senza bonus
        if($x4->creditiCheFannoMedia() !=  96) echo "Carriera Laureando4 : crediti che fanno media errati: ricevuto" . $x4->creditiCheFannoMedia();
        if($x5->creditiCheFannoMedia() != 102) echo "Carriera Laureando5 : crediti che fanno media errati: ricevuto" . $x5->creditiCheFannoMedia();

    }

    function test_crediti(){

        $x1= new CarrieraLaureando("123456","T. Ing. Informatica");
        $x2= new CarrieraLaureando("234567","M. Ing. Elettronica");
        $x3= new CarrieraLaureando("345678","T. Ing. Informatica");
        $x4= new CarrieraLaureando("456789","M. Ing. delle Telecomunicazioni");    
        $x5= new CarrieraLaureando("567890","M. Computer Engineering, Artificial Intelligence and Data Enginering");

        
        if($x1->creditiCurricolariConseguiti() != 177) echo "Carriera Laureando1 : crediti errati: ricevuto" . $x1->creditiCurricolariConseguiti();
        if($x2->creditiCurricolariConseguiti() != 102) echo "Carriera Laureando2 : crediti errati: ricevuto" . $x2->creditiCurricolariConseguiti();
        if($x3->creditiCurricolariConseguiti() != 177) echo "Carriera Laureando3 : crediti errati: ricevuto" . $x3->creditiCurricolariConseguiti(); // ancora senza bonus
        if($x4->creditiCurricolariConseguiti() !=  96) echo "Carriera Laureando4 : crediti errati: ricevuto" . $x4->creditiCurricolariConseguiti();
        if($x5->creditiCurricolariConseguiti() != 120) echo "Carriera Laureando5 : crediti errati: ricevuto" . $x5->creditiCurricolariConseguiti();

    }

}
/*
function tes(){
    $expected = ;
    $result =;
    if($expected != $result) echo "CarrieraLaureando : errore: expected:" . $expected . " recived:" . $result;
    else console_log("");
}
*/

?>

