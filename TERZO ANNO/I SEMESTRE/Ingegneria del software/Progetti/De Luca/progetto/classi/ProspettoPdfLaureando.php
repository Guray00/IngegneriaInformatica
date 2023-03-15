<?php

require_once(realpath(dirname(__FILE__)) . '/CarrieraLaureando.php');
require_once(realpath(dirname(__FILE__)) . '/CarrieraLaureandoInformatica.php');
require_once(realpath(dirname(__FILE__)) . '/console_log.php');
require_once(realpath(dirname(__FILE__)) . '/../lib/fpdf184/fpdf.php');

/**
 * @access public
 * @author Roberto
 */
class ProspettoPdfLaureando
{
    /**
     * @AttributeType CarrieraLaureando
     */
    protected $carrieraLaureando;
/**
     * @AttributeType int
     */
    protected $matricola;
/**
     * @AssociationType CarrieraLaureando
     * @AssociationMultiplicity 1
     * @AssociationKind Composition
     */
    protected $dataLaurea;




    public function __construct($matricola, $cdl_in, $data_laurea)
    {
        // questo dovrebbe essere il costruttore, che popola anche le classi dipendenti
        console_log("ProspettoPdfLaureando: costruzione per " . $matricola);
        if ($cdl_in != "INGEGNERIA INFORMATICA (IFO-L)" && $cdl_in != "T. Ing. Informatica") {
            $this->carrieraLaureando = new CarrieraLaureando($matricola, $cdl_in);
        } else {
            $this->carrieraLaureando = new CarrieraLaureandoInformatica($matricola, $cdl_in, $data_laurea);
        }
        $this->matricola = $matricola;
        $this->dataLaurea = $data_laurea;
    }

    /**
     * @access public
     * @return void
     * @ReturnType void
     */
    public function generaProspetto()
    {
        // genera il prospetto in pdf e lo salva in un percorso specifico
        // dati utili;
        $font_family = "Arial";
        $tipo_informatico = 0;
// indica se il laureando è informatico, viene modificato da solo

        console_log("ProspettoPdfLaureando: generare il prospetto per " . $this->matricola);
        $pdf = new FPDF();
        $pdf->AddPage();
        $pdf->SetFont($font_family, "", 16);
// --------------------- INTESTAZIONE : cdl e scritta prospetto --------------------------

        $pdf->Cell(0, 6, $this->carrieraLaureando->cdl, 0, 1, 'C');
// dimensioni, testo, bordo, a capo, align
        $pdf->Cell(0, 8, 'CARRIERA E SIMULAZIONE DEL VOTO DI LAUREA', 0, 1, 'C');
        $pdf->Ln(2);
// ------------------------------ INFORMAZIONI ANAGRAFICHE DELLO STUDENTE ------------------------------

        $pdf->SetFont($font_family, "", 9);
        $anagrafica_stringa = "Matricola:                       " . $this->matricola . //attenzione: quelli che sembrano spazi in realtà sono &Nbsp perché fpdf non stampa spazi
            "\nNome:                            " . $this->carrieraLaureando->nome .
            "\nCognome:                      " . $this->carrieraLaureando->cognome .
            "\nEmail:                             " . $this->carrieraLaureando->email .
            "\nData:                              " . $this->dataLaurea;
//aggiungere bonus if inf
        console_log("ProspettoPdfLaureando: classe del laureando: " . get_class($this->carrieraLaureando)) ;
        if (get_class($this->carrieraLaureando) == "CarrieraLaureandoInformatica") {
            $tipo_informatico = 1;
            $anagrafica_stringa .= "\nBonus:                            " . $this->carrieraLaureando->getBonus();
        }

        $pdf->MultiCell(0, 6, $anagrafica_stringa, 1, 'L');
//$pdf->Cell(0, 100 ,$anagrafica_stringa, 1 ,1, '');
        $pdf->Ln(3);
// spazio bianco

        // ------------------------------- INFORMAZIONI SUGLI ESAMI ----------------------------------------
        // 1 pag = 190 = 21cm con bordi di 1cm
        $larghezza_piccola = 12;
        $altezza = 5.5;
        $larghezza_grande = 190 - (3 * $larghezza_piccola);
        if ($tipo_informatico != 1) {
            $pdf->Cell($larghezza_grande, $altezza, "ESAME", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "CFU", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "VOT", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "MED", 1, 1, 'C');
        // newline
        } else {
            $larghezza_piccola -= 1;
            $larghezza_grande = 190 - (4 * $larghezza_piccola);
            $pdf->Cell($larghezza_grande, $altezza, "ESAME", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "CFU", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "VOT", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "MED", 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, "INF", 1, 1, 'C');
        // newline
        }

        $altezza = 4;
        $pdf->SetFont($font_family, "", 8);
        for ($i = 0; $i < sizeof($this->carrieraLaureando->esami); $i++) {
            $esame = $this->carrieraLaureando->esami[$i];
            $pdf->Cell($larghezza_grande, $altezza, $esame->nomeEsame, 1, 0, 'L');
            $pdf->Cell($larghezza_piccola, $altezza, $esame->cfu, 1, 0, 'C');
            $pdf->Cell($larghezza_piccola, $altezza, $esame->votoEsame, 1, 0, 'C');
            if ($tipo_informatico != 1) {
                $pdf->Cell($larghezza_piccola, $altezza, ($esame->faMedia == 1) ? 'X' : '', 1, 1, 'C');
            // newline
            } else {
                $pdf->Cell($larghezza_piccola, $altezza, ($esame->faMedia == 1) ? 'X' : '', 1, 0, 'C');
                $pdf->Cell($larghezza_piccola, $altezza, ($esame->informatico == 1) ? 'X' : '', 1, 1, 'C');
            }
        }
        $pdf->Ln(5);
// ------------------------------- PARTE RIASUNTIVA  ----------------------------------------
        $pdf->SetFont($font_family, "", 9);
        $string = "Media Pesata (M):                                                  " . $this->carrieraLaureando->restituisciMedia() .
            "\nCrediti che fanno media (CFU):                             " . $this->carrieraLaureando->creditiCheFannoMedia() .
            "\nCrediti curriculari conseguiti:                                  " . $this->carrieraLaureando->creditiCurricolariConseguiti() .
            "\nFormula calcolo voto di laurea:                               " . $this->carrieraLaureando->restituisciFormula();
        if ($tipo_informatico == 1) {
            $string .= "\nMedia pesata esami INF:                                        " . $this->carrieraLaureando->getMediaEsamiInformatici();
        }

        $pdf->MultiCell(0, 6, $string, 1, "L");
//$percorso_output =realpath(dirname(__FILE__)) . '\..\data\pdf_generati\\';
        $percorso_output = "data\pdf_generati\\";
        $nome_file = $this->matricola . "-prospetto.pdf";
        $pdf->Output('F', $percorso_output . $nome_file); // f significa scrivi su file. senza quello non funziona
    }

    public function getCarriera(){
        return $this->carrieraLaureando;
    }
}
