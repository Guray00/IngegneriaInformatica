<?php

//questa classe è stata svolta alla fine e non testata

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once(realpath(dirname(__FILE__)) . '/ProspettoPdfLaureando.php');
require_once(realpath(dirname(__FILE__) . '/../../../../lib/PHPmailer/src/Exception.php'));
require_once(realpath(dirname(__FILE__) . '/../../../../lib/PHPmailer/src/PHPmailer.php'));
require_once(realpath(dirname(__FILE__) . '/../../../../lib/PHPmailer/src/SMTP.php'));


/**
 * @access public
 * @author Roberto
 */
class InvioPDFLaureandi {
	/**
	 * @AttributeType int[]
	 */
	private $matricole;
	/**
	 * @AssociationType ProspettoPdfLaureando
	 * @AssociationMultiplicity 1
	 */
	public $unnamed_ProspettoPdfLaureando_;

	/**
	 * @access public
	 */
	public function InvioPDFLaureandi() {
		for ($i = 0; $i < sizeof($this->matricole); $i++) {
            $prospetto = new ProspettoPdfLaureando($this->matricole[$i], $this->cdl, $this->data_laurea);
            $this->inviaProspetto( $prospetto->carrieraLaureando);
        }
	}

	/**
	 * @access public
	 * @param int matricola
	 * @ParamType matricola int
	 */
	public function inviaProspetto($studente_carriera) {
		$messaggio = new PHPmailer();

		$messaggio = new PHPmailer();
		$messaggio->IsSMTP();
		$messaggio->Host = "mixer.unipi.it";
		$messaggio->SMTPSecure = "tls";
		$messaggio->SMTPAuth = false;
		$messaggio->Port = 25;

		$messaggio->From='no-reply-laureandosi@ing.unipi.it';
		$messaggio->AddAddress($studente_carriera->email);
		$messaggio->Subject='Appello di laurea in Ing. TEST- indicatori per voto di laurea';
		$messaggio->Body=stripslashes('Gentile laureando/laureanda,
		Allego un prospetto contenente: la sua carriera, gli indicatori e la formula che la commissione adopererà per determinare il voto di laurea.
		La prego di prendere visione dei dati relativi agli esami.
		In caso di dubbi scrivere a: ...
		
		Alcune spiegazioni:
		- gli esami che non hanno un voto in trentesimi, hanno voto nominale zero al posto di giudizio o idoneita\', in quanto non contribuiscono al calcolo della media ma solo al numero di crediti curriculari;
		- gli esami che non fanno media (pur contribuendo ai crediti curriculari) non hanno la spunta nella colonna MED;
		- il voto di tesi (T) appare nominalmente a zero in quanto verra\' determinato in sede di laurea, e va da 18 a 30.
		
		 Cordiali saluti
		 Unità Didattica DII');
		

		$messaggio->AddAttachment("data\\" . $studente_carriera->matricola . "-prospetto.pdf");

		if(!$messaggio->Send()){ 
		echo $messaggio->ErrorInfo; 
		}else{ 
		echo 'Email inviata correttamente!';
		}

		$messaggio->SmtpClose();
		unset($messaggio);
	}
		
?>