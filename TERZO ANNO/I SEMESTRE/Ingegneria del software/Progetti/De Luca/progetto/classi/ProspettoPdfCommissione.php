<?php

require_once(realpath(dirname(__FILE__)) . '/ProspettoConSimulazione.php');

/**
 * @access public
 * @author Roberto
 */
class ProspettoPdfCommissione
{
    /**
     * @AttributeType int[]
     */
    private $matricole = array();
    private $data_laurea;
    private $cdl;


    /**
     * @access public
     * @param int[] matricole
     * @param string dataLaurea
     * @ParamType matricole int[]
     * @ParamType dataLaurea string
     */
    public function ProspettoPdfCommissione(array $matricole, $cdl, $dataLaurea)
    {
        $this->matricole = $matricole;
        $this->cdl = $cdl;
        $this->data_laurea = $dataLaurea;
    }

    /**
     * @access public
     */
    public function GeneraProspettoCommissione()
    {
        $pdf = new FPDF();
        $font_family = "Arial";
        $pdf->AddPage();
        $pdf->SetFont($font_family, "", 14);
// --------  PRIMA PAGINA CON LA LISTA ---------------------
        $pdf->Cell(0, 6, $this->cdl, 0, 1, 'C');
        $pdf->Ln(2);
        $pdf->SetFont($font_family, "", 16);
        $pdf->Cell(0, 6, 'LISTA LAUREANDI', 0, 1, 'C');
        $pdf->Ln(5);
        $pdf->SetFont($font_family, "", 14);
        $width = 190 / 4;
        $height = 5;
        $pdf->Cell($width, $height, "COGNOME", 1, 0, 'C');
        $pdf->Cell($width, $height, "NOME", 1, 0, 'C');
        $pdf->Cell($width, $height, "CDL", 1, 0, 'C');
        $pdf->Cell($width, $height, "VOTO LAUREA", 1, 1, 'C');
        $pdf->SetFont($font_family, "", 12);
        for ($i = 0; $i < sizeof($this->matricole); $i++) {
            $pag_con_simulazione = new ProspettoConSimulazione($this->matricole[$i], $this->cdl, $this->data_laurea);
            $pdf = $pag_con_simulazione->aggiungiRiga($pdf);
        }

        // --------  PAGINE CON LA CARRIERA ---------------------
        // aggiungo la pagina di ogni laureando
        for ($i = 0; $i < sizeof($this->matricole); $i++) {
            $pag_con_simulazione = new ProspettoConSimulazione($this->matricole[$i], $this->cdl, $this->data_laurea);
            $pdf = $pag_con_simulazione->generaContenuto($pdf);
        }

        $percorso_output = "data\pdf_generati\\";
        $nome_file = "prospettoCommissione.pdf";
        $pdf->Output('F', $percorso_output . $nome_file);
    }

    public function generaProspettiLaureandi()
    {
        for ($i = 0; $i < sizeof($this->matricole); $i++) {
            $prospetto = new ProspettoPdfLaureando($this->matricole[$i], $this->cdl, $this->data_laurea);
            $prospetto->generaProspetto();
        }
    }
}
