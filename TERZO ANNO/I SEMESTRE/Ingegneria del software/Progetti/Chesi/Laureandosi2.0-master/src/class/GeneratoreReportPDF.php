<?php

namespace laureandosi;

class GeneratoreReportPDF
{
    private static GeneratoreReportPDF $instance;

    private function __construct()
    {
    }

    public static function getInstance(): GeneratoreReportPDF
    {
        if (!isset(self::$instance)) {
            require_once("ReportPDF.php");
            require_once("ReportPDFLaureando.php");
            require_once("ReportPDFCommissione.php");

            self::$instance = new GeneratoreReportPDF();
        }
        return self::$instance;
    }


    /**
     * Genera il report PDF per il laureando
     * @param Laureando $laureando
     * @return ReportPDFLaureando
     */
    public static function generaReportPDFLaureando(Laureando $laureando): ReportPDFLaureando
    {
        $report = new ReportPDFLaureando($laureando);
        return $report->genera();
    }

    /**
     * Genera il report PDF per la Commissione
     * @param array $laureandi
     * @return ReportPDFCommissione
     */
    public static function generaReportPDFCommissione(array $laureandi): ReportPDFCommissione
    {
        $report = new ReportPDFCommissione($laureandi);
        return $report->genera();
    }
}
