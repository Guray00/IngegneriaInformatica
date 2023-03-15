<?php

require_once(realpath(dirname(__FILE__)) . '/console_log.php');

/**
 * @access public
 * @author Roberto
 */
class GestioneCarrieraStudente
{
    /**
     * @access public
     * @param int matricola
     * @return string
     * @ParamType matricola int
     * @ReturnType string
     */
    public function restituisciCarrieraStudente($matricola)
    {

        //$json_carriera =  file_get_contents('./data/'.$matricola."_esami.json");
        $json_carriera = file_get_contents(realpath(dirname(__FILE__)) . '/../data/' . $matricola . "_esami.json");
        //console_log("gestioneCarrieraStudente: json recuperato:".$json_carriera); troppo lungo

        return $json_carriera;
    }

    /**
     * @access public
     * @param int matricola
     * @return string
     * @ParamType matricola int
     * @ReturnType string
     */
    public static function restituisciAnagraficaStudente($matricola)
    {
        //prendo il json dal file
        $json_anagrafica = file_get_contents(realpath(dirname(__FILE__)) . '/../data/' . $matricola . "_anagrafica.json"); //i percorsi sono un casino
        //$json_anagrafica = file_get_contents( './data/'.$matricola."_anagrafica.json"); //non funziona sempre
        //$json_anagrafica = file_get_contents("C:/isw/xampp/htdocs/progetto/data/123456_anagrafica.json"); //funziona
        //$json_anagrafica = file_get_contents('/../data/'.$matricola."_anagrafica.json"); non funziona

        console_log("gestioneCarrieraStudente: json anagrafica recuperato:" . $json_anagrafica);

        return $json_anagrafica;
    }
}
