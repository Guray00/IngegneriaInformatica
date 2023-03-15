<?php

namespace laureandosi;

/**
 * Classe astratta per la generazione di report PDF
 */
abstract class ReportPDF
{
    protected \FPDF $pdf;

    public function __construct(\FPDF $pdf = null)
    {
        require_once(join(DIRECTORY_SEPARATOR, array(dirname(__DIR__), 'lib', 'fpdf184', 'fpdf.php')));
        $this->pdf = is_null($pdf) ? new \FPDF('P', 'mm', 'A4') : $pdf;
    }

    /**
     * Salva il report PDF in un file
     * @param string $filename
     */
    public function salva(string $filename): void
    {
        $this->pdf->Output('F', $filename);
    }

    /**
     * Genera il report PDF
     * @return ReportPDF
     */
    abstract public function genera(): ReportPDF;
}
