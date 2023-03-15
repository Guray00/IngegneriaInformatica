<?php

//
require_once(realpath(dirname(__FILE__)) . '/ProspettoPdfLaureando.php');
require_once(realpath(dirname(__FILE__)) . '/GestioneCarrieraStudente.php');
require_once(realpath(dirname(__FILE__)) . '/EsameLaureando.php');
require_once(realpath(dirname(__FILE__)) . '/console_log.php');

/**
 * @access public
 * @author Roberto
 */
class CarrieraLaureando
{
    public $matricola;
    /**
     * @AttributeType int
     */

    public $nome;
    /**
     * @AttributeType string
     */
    public $cognome;
    /**
     * @AttributeType string
     */
    public $cdl;
    /**
     * @AttributeType string
     */
    public $email;
    /**
     * @AttributeType EsameLaureando[]
     */
    public $esami;
    /**
     * @AttributeType int
     */
    private $media;
    /** media pesata per cfu
     * @AttributeType string
     */
    private $formulaVotoLaurea;


    /**
     * CarrieraLaureando()
     * @access public
     * @param int matricola
     * @ParamType matricola int
     */
    public function __construct($matricola, $cdl_in)
    {

        console_log("CarrieraLaureando: creazione della classe per: " . $matricola);
        $this->matricola = $matricola;
// qui dovresti chiamare gcs per prendere tutti i dati
        $gcs = new GestioneCarrieraStudente();
        $anagrafica_json = $gcs->restituisciAnagraficaStudente($matricola);
        $carriera_json = $gcs->restituisciCarrieraStudente($matricola);
// qui prendo i dati di configurazione
        // m= media pesata, t = punti tesi, c = punti commissione
        //$con_s = file_get_contents("./data/formule_laurea.json");
        $con_s = file_get_contents(realpath(dirname(__FILE__)) . '/../data/formule_laurea.json');
        $configurazione_json = json_decode($con_s, true);
//popolare la classe
        console_log("CarrieraLaureando: popolare la classe per: " . $matricola);
        $anagrafica = json_decode($anagrafica_json, true);
        $this-> nome = $anagrafica["Entries"]["Entry"]["nome"];
        console_log("CarrieraLaureando: nome: " . $this->nome) ;
        $this-> cognome = $anagrafica["Entries"]["Entry"]["cognome"];
        $this-> email = $anagrafica["Entries"]["Entry"]["email_ate"];
        $this-> cdl = $cdl_in;
        console_log("CarrieraLaureando: cdl: " . $this->cdl) ;
        $this-> formulaVotoLaurea =  $configurazione_json[$this-> cdl]["formula"];
        console_log("CarrieraLaureando: formula: " . $this->formulaVotoLaurea) ;
// inserire tutti gli esami
        $carriera = json_decode($carriera_json, true);
        $this->esami = array();
            //console_log($carriera["Esami"]);

        for ($i = 0; $i < sizeof($carriera["Esami"]["Esame"]); $i++) {
//aggiungo il nuovo esame all'array di esami
            $esame = $this-> inserisci_esame($carriera["Esami"]["Esame"][$i]["DES"], $carriera["Esami"]["Esame"][$i]["VOTO"], $carriera["Esami"]["Esame"][$i]["PESO"], 1, 1);
            if ($esame != null && is_string($esame->nomeEsame)) {
                array_push($this->esami, $esame);
            }
        }

        //calcolare la media
        $this->calcola_media();
        console_log("CarrieraLaureando: media per cfu: " . $this->media);
    }

    /**
     * @access public
     * @return double
     * @ReturnType double
     */
    public function restituisciMedia()
    {
        return $this->media;
    }

    /**
     * @access public
     * @return int
     * @ReturnType int
     */
    public function creditiCheFannoMedia()
    {
        $crediti = 0;
        //console_log("carrieraLaureando: size of this-> esami :".sizeof($this->esami));
        for ($i = 0; sizeof($this->esami) > $i; $i++) {
            $crediti += ($this->esami[$i]->curricolare == 1 && $this->esami[$i]->faMedia == 1) ? $this->esami[$i]->cfu : 0;
        }
        return $crediti;
    }

    /**
     * @access public
     * @return int
     * @ReturnType int
     */
    public function creditiCurricolariConseguiti()
    {
        $crediti = 0;
        for ($i = 0; sizeof($this->esami) > $i; $i++) {
            if ($this->esami[$i]->nomeEsame != "PROVA FINALE" &&  $this->esami[$i]->nomeEsame != "LIBERA SCELTA PER RICONOSCIMENTI") {
                $crediti += ($this->esami[$i]->curricolare == 1) ? $this->esami[$i]->cfu : 0;
            }
        }
        return $crediti;
    }

    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function restituisciFormula()
    {
        return $this->formulaVotoLaurea;
    }

    private function inserisci_esame($nome, $voto, $cfu, $faMedia, $curricolare)
    {
        //console_log("CarrieraLaureando: inserimento esame:" . $nome . $voto . $cfu . $faMedia . $curricolare);
        if (
            $nome == "LIBERA SCELTA PER RICONOSCIMENTI" || $nome == "PROVA FINALE" || $nome ==  "TEST DI VALUTAZIONE DI INGEGNERIA"
            || $nome == "PROVA DI LINGUA INGLESE B2" || $voto == 0
        ) {
            $faMedia = 0;
        }
        // non metto esami con parametri malformati
        if ($nome != "TEST DI VALUTAZIONE DI INGEGNERIA" && $nome != null) {
            if ($voto == "30 e lode" || $voto == "30 e lode " || $voto == "30  e lode") {
// -_- ci hanno messo 2 spazi
                $voto = "33";
            }
            //console_log($voto);
            trim($voto);
//toglie gli spazi bianchi
            //trim($cfu);
            $esame = new EsameLaureando();
            $esame->nomeEsame = $nome;
            $esame->votoEsame = $voto;
            $esame->cfu = $cfu;
            $esame->faMedia = $faMedia;
            $esame->curricolare = $curricolare;
            return $esame;
        } else {
            return null;
        }
    }

    public function calcola_media()
    {
        $esami = $this->esami;
        $somma_voto_cfu = 0;
        $somma_cfu_tot = 0;

        for ($i = 0; $i < sizeof($esami); $i++) {
            if ($esami[$i]->faMedia == 1) {
//console_log("CarieraLaureando: esame per la media: nome: ".$this->esami[$i]->nomeEsame." fa media: ".$this->esami[$i]->faMedia);
                $somma_voto_cfu += intval($esami[$i]->votoEsame) * $esami[$i]->cfu;
//devi convertire il voto in un int prima
                $somma_cfu_tot += $esami[$i]->cfu;
            }
            //console_log($somma_voto_cfu);
        }
        $this->media = $somma_voto_cfu / $somma_cfu_tot;
        return $this->media;
    }
}
