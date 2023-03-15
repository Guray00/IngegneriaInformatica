<?php

namespace laureandosi;

/**
 * Report PDF per la Commissione contenente i report PDF dei laureandi con simulazione
 */
class ReportPDFCommissione extends ReportPDF
{
    private array $laureandi;

    public function __construct(array $laureandi)
    {
        require_once("ReportPDFLaureandoConSimulazione.php");
        parent::__construct();
        $this->laureandi = $laureandi;
    }

    public function genera(): ReportPDFCommissione
    {
        foreach ($this->laureandi as $laureando) {
            $report = new ReportPDFLaureandoConSimulazione($laureando, $this->pdf);
            $report->genera();
        }
        return $this;
    }
}
