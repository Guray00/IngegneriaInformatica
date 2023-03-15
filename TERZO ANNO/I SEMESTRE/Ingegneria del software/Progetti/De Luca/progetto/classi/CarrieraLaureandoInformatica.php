<?php

require_once(realpath(dirname(__FILE__)) . '/CarrieraLaureando.php');
require_once(realpath(dirname(__FILE__)) . '/console_log.php');

/**
 * @access public
 * @author Roberto
 */
class CarrieraLaureandoInformatica extends CarrieraLaureando
{
    /**
     * @AttributeType string
     */
    private $dataImmatricolazione;
        // in realtà è un anno

    /**
     * @access public
     * @return double
     * @ReturnType double
     */
    private $MediaEsamiInformatici;
    private $dataLaurea;
//aaaa-mm-gg
    private $bonus = "NO";

    public function __construct($matricola, $cdl_in, $dataLaurea)
    {
        console_log("CarieraLaureandoInformatica: costruzione");
        parent::__construct($matricola, $cdl_in);
        $this->dataLaurea = $dataLaurea;
// devo procurarmi la data di iscrizione
        $gcs = new GestioneCarrieraStudente();
        $carriera_json = $gcs->restituisciCarrieraStudente($matricola);
        $carriera = json_decode($carriera_json, true);
        $this->dataImmatricolazione = $carriera["Esami"]["Esame"][0]["ANNO_IMM"];
        console_log("CarieraLaureandoInformatica: immatricolazione nell'anno:" . $this->dataImmatricolazione);
//devo togliere dalla media l'esame più basso se ho il bonus

        $fine_bonus = ($this->dataImmatricolazione + 4) . ("-05-01");
        console_log("CarieraLaureandoInformatica:fine bonus: " . $fine_bonus);
        if ($dataLaurea < $fine_bonus) {
            $this->bonus = "SI";
            $voto_min = 33;
            $indice_min = 0;

            for ($i = 0; $i < sizeof($this->esami); $i++) {
                $esame = $this->esami[$i];
                if ($esame->faMedia == 1 && $esame->votoEsame < $voto_min) {
                    $voto_min = $esame->votoEsame;
                    $indice_min = $i;
                }
            }

            $this->esami[$indice_min]->faMedia = 0;
            console_log("CarieraLaureandoInformatica: bonus si");
        }

        //settare gli esami informatici
        //$e_info = file_get_contents("./data/esami_informatici.json");
        $e_info = file_get_contents(realpath(dirname(__FILE__)) . '/../data/esami_informatici.json');
        $esami_info = json_decode($e_info, true);

        for ($i = 0; $i < sizeof($this->esami); $i++) {
            if (in_array($this->esami[$i]->nomeEsame, $esami_info["nomi_esami"])) {
                $this->esami[$i]->informatico = 1;
            }
        }

        //calcolare la media degli esami informatici
        $this->MediaEsamiInformatici = $this->calcolaMediaEsamiInformatici();
// aggiornare la media degli esami
        $this->calcola_media();
    }
    /**
     * @access public
     * @return double
     * @ReturnType double
     */
    public function getMediaEsamiInformatici()
    {
        return $this->MediaEsamiInformatici;
    }
    private function calcolaMediaEsamiInformatici()
    {
        $somma = 0;
        $numero = 0;
        for ($i = 0; $i < sizeof($this->esami); $i++) {
//console_log("CarieraLaureandoInformatica: esame per la media: nome: ".$this->esami[$i]->nomeEsame." fa media: ".$this->esami[$i]->faMedia);
            if ($this->esami[$i]->faMedia == 1) {
                $somma += intval($this->esami[$i]->votoEsame) ;
                $numero++;
            }
        }
        console_log("CarieraLaureandoInformatica: media degli esami informatici: " . $somma / $numero);
        return $somma / $numero;
    }



    /**
     * @return mixed
     */
    public function getBonus()
    {
        return $this->bonus;
    }
}
