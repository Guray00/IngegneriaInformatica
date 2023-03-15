<?php

namespace laureandosi;

class ReportPDFLaureando extends ReportPDF
{
    protected Laureando $laureando;
    protected ParametriConfigurazione $parametri_configurazione;

    /**
     * Aggiunge i dati anagrafici del laureando
     * @return void
     */
    private function aggiungiDatiAnagrafici(): void
    {
        $is_inf = is_a($this->laureando, LaureandoInformatica::class);

        $this->pdf->SetFontSize(10);

        $this->pdf->Rect($this->pdf->GetX(), $this->pdf->GetY(), $this->pdf->GetPageWidth() - 20, 5 * (5 + $is_inf));

        $this->pdf->Cell(60, 5, 'Matricola:', 0, 0);
        $this->pdf->Cell(0, 5, $this->laureando->matricola, 0, 1);
        $this->pdf->Cell(60, 5, 'Nome:', 0, 0);
        $this->pdf->Cell(0, 5, $this->laureando->nome, 0, 1);
        $this->pdf->Cell(60, 5, 'Cognome:', 0, 0);
        $this->pdf->Cell(0, 5, $this->laureando->cognome, 0, 1);
        $this->pdf->Cell(60, 5, 'Email:', 0, 0);
        $this->pdf->Cell(0, 5, $this->laureando->email, 0, 1);
        $this->pdf->Cell(60, 5, 'Data:', 0, 0);
        $this->pdf->Cell(0, 5, date_format($this->laureando->data_laurea, "Y-m-d"), 0, 1);
        if ($is_inf) {
            $this->pdf->Cell(60, 5, 'BONUS:', 0, 0);
            $this->pdf->Cell(0, 5, $this->laureando->getBonusINF() ? 'SI' : 'NO', 0, 1);
        }

        $this->pdf->Ln(1.5);
    }

    /**
     * Aggiunge la carriera del laureando (Esami)
     * @return void
     */
    private function aggiungiCarriera(): void
    {
        $is_inf = is_a($this->laureando, LaureandoInformatica::class);

        $this->pdf->SetFontSize(10);

        $this->pdf->Cell($this->pdf->GetPageWidth() - 10 * (5 + $is_inf), 5, 'ESAME', 1, 0, 'C');
        $this->pdf->Cell(10, 5, 'CFU', 1, 0, 'C');
        $this->pdf->Cell(10, 5, 'VOT', 1, 0, 'C');
        $this->pdf->Cell(10, 5, 'MED', 1, 0, 'C');
        if ($is_inf) {
            $this->pdf->Cell(10, 5, 'INF', 1, 0, 'C');
        }
        $this->pdf->Ln();

        $this->pdf->SetFontSize(8);

        foreach ($this->laureando->esami as $esame) {
            if ($esame->in_cdl) {
                $this->pdf->Cell($this->pdf->GetPageWidth()  - 10 * (5 + $is_inf), 4, $esame->nome, 1, 0);
                $this->pdf->Cell(10, 4, $esame->cfu, 1, 0, 'C');
                $this->pdf->Cell(10, 4, $esame->voto, 1, 0, 'C');
                $this->pdf->Cell(10, 4, $esame->in_avg ? 'X' : '', 1, 0, 'C');
                if ($is_inf) {
                    $this->pdf->Cell(10, 4, $esame->in_inf ? 'X' : '', 1, 0, 'C');
                }
                $this->pdf->Ln();
            }
        }

        $this->pdf->Ln(3.5);
    }

    /**
     * Aggiunge i parametri calcolati del laureando (Media, CFU, Bonus)
     * @return void
     */
    private function aggiungiParametriCalcolati(): void
    {
        $is_inf = is_a($this->laureando, LaureandoInformatica::class);

        $this->pdf->SetFontSize(10);

        $this->pdf->Rect($this->pdf->GetX(), $this->pdf->GetY(), $this->pdf->GetPageWidth() - 20, 20 + 10 * $is_inf);

        $this->pdf->Cell(80, 5, 'Media Pesata (M):', 0, 0);
        $this->pdf->Cell(0, 5, round($this->laureando->getMediaPesata(), 3), 0, 1);
        $this->pdf->Cell(80, 5, 'Crediti che fanno media (CFU):', 0, 0);
        $this->pdf->Cell(0, 5, $this->laureando->getCFUInAVG(), 0, 1);
        $this->pdf->Cell(80, 5, 'Crediti curriculari conseguiti:', 0, 0);
        $this->pdf->Cell(0, 5, $this->laureando->getCFU() . '/' .
            $this->parametri_configurazione::getCorsiDiLaurea()[$this->laureando->cdl]["tot-CFU"], 0, 1);
        if ($is_inf) {
            $this->pdf->Cell(80, 5, 'Voto di tesi (T):', 0, 0);
            $this->pdf->Cell(0, 5, 0, 0, 1);
        }
        $this->pdf->Cell(80, 5, 'Formula calcolo voto di laurea:', 0, 0);
        $voto_laurea = $this->parametri_configurazione::getCorsiDiLaurea()[$this->laureando->cdl]["voto-laurea"];
        $this->pdf->Cell(0, 5, $voto_laurea, 0, 1);
        if ($is_inf) {
            $this->pdf->Cell(80, 5, 'Media pesata esami INF:', 0, 0);
            $this->pdf->Cell(0, 5, $this->laureando->getMediaPesataInINF(), 0, 1);
        }
    }

    public function __construct(Laureando $laureando, \FPDF $pdf = null)
    {
        parent::__construct($pdf);
        $this->laureando = $laureando;
        $this->parametri_configurazione = ParametriConfigurazione::getInstance();
    }

    public function genera(): ReportPDFLaureando
    {
        $this->pdf->SetFont('Arial', '', 12);
        $this->pdf->AddPage();

        $cdl = defined('TEST') ?
            'TEST' :
            $this->parametri_configurazione::getCorsiDiLaurea()[$this->laureando->cdl]["cdl"];
        $this->pdf->Cell(0, 5, $cdl, 0, 1, 'C');
        $this->pdf->Cell(0, 5, 'CARRIERA E SIMULAZIONE DEL VOTO DI LAUREA', 0, 1, 'C');

        $this->aggiungiDatiAnagrafici();
        $this->aggiungiCarriera();
        $this->aggiungiParametriCalcolati();

        return $this;
    }
}
