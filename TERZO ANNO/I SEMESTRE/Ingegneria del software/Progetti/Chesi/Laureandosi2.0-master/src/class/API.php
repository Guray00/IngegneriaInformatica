<?php

namespace laureandosi;

class API
{
    private static ParametriConfigurazione $parametri_configurazione;
    private static GeneratoreReportPDF $generatore_report;
    private static GestoreInvioEmail $gestore_invio_email;
    private static string $report_path = ABSPATH . DIRECTORY_SEPARATOR . 'report';
    private static API $instance;

    private function __construct()
    {
    }

    public static function getInstance(): API
    {
        if (!isset(self::$instance)) {
            require_once("ParametriConfigurazione.php");
            require_once("Laureando.php");
            require_once("LaureandoInformatica.php");
            require_once("GeneratoreReportPDF.php");
            require_once("GestoreInvioEmail.php");

            self::$parametri_configurazione = ParametriConfigurazione::getInstance();
            self::$generatore_report = GeneratoreReportPDF::getInstance();
            self::$gestore_invio_email = GestoreInvioEmail::getInstance();
            self::$instance = new API();
        }
        return self::$instance;
    }

    public static function GETCorsiDiLaurea(): ?string
    {
        if ($_SERVER["REQUEST_METHOD"] == "GET") {
            $val = array_values(self::$parametri_configurazione::getCorsiDiLaurea());

            for ($i = 0; $i < count($val); $i++) {
                $val[$i] = array_filter(
                    $val[$i],
                    function ($key) {
                        return $key == "cdl" || $key == "cdl-short";
                    },
                    ARRAY_FILTER_USE_KEY
                );
            }
            http_response_code(200);
            return json_encode($val);
        }
        http_response_code(405);
        return null;
    }

    public static function POSTCreaReport(string $json): ?string
    {
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $data = json_decode($json, true);

            if (isset($data["test"]) && $data["test"] == true) {
                define("TEST", true);
            }

            $path = join(DIRECTORY_SEPARATOR, array(
                self::$report_path,
                $data["data_laurea"],
                $data["corso_laurea"],
            ));

            if (!file_exists($path)) {
                mkdir($path, 0777, true);
            }

            $laureandi = array();
            try {
                foreach ($data["matricole"] as $matricola) {
                    $matricola = (int) $matricola;
                    $corso_laurea = $data["corso_laurea"];
                    $data_laurea = date_create($data["data_laurea"]);

                    $laureando = $corso_laurea != "t-inf" ?
                        new Laureando($matricola, $corso_laurea, $data_laurea) :
                        new LaureandoInformatica($matricola, $corso_laurea, $data_laurea);

                    self::$generatore_report::generaReportPDFLaureando($laureando)->salva(
                        $path . DIRECTORY_SEPARATOR . $laureando->matricola . '.pdf'
                    );

                    $laureandi[] = $laureando;
                }
                self::$generatore_report::generaReportPDFCommissione($laureandi)->salva(
                    $path . DIRECTORY_SEPARATOR . 'all.pdf'
                );
                http_response_code(201);
                return json_encode(array("message" => count($laureandi) . " report creati con successo."));
            } catch (\Exception $e) {
                http_response_code(400);
                return json_encode(array("message" => "ERRORE: " . $e->getMessage()));
            }
        }
        http_response_code(405);
        return null;
    }

    public static function GETApriReport(): ?string
    {
        if ($_SERVER["REQUEST_METHOD"] == "GET") {
            $corso_laurea = $_GET["corso_laurea"];
            $data_laurea = $_GET["data_laurea"];

            $file = join(DIRECTORY_SEPARATOR, array(
                self::$report_path,
                $data_laurea,
                $corso_laurea,
                'all.pdf'
            ));

            if (file_exists($file)) {
                header('Content-type: application/pdf');
                header('Content-Disposition: inline; filename="all.pdf"');
                header('Content-Transfer-Encoding: binary');
                header('Content-Length: ' . filesize($file));
                header('Accept-Ranges: bytes');
                readfile($file);

                http_response_code(200);
                return json_encode(array("message" => "Report aperto con successo."));
            } else {
                http_response_code(404);
                return json_encode(array("message" => "ERRORE: Il report non esiste."));
            }
        }
        http_response_code(405);
        return null;
    }

    public static function POSTInviaReport(string $json): ?string
    {
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $data = json_decode($json, true);

            if (isset($data["test"]) && $data["test"] == true) {
                define("TEST", true);
            }
            $data_laurea = $data["data_laurea"];
            $corso_laurea = $data["corso_laurea"];
            $matricola = (int)$data["matricola"];

            $report_path = join(DIRECTORY_SEPARATOR, array(
                self::$report_path,
                $data_laurea,
                $corso_laurea,
            ));

            if (!file_exists($report_path)) {
                http_response_code(404);
                return json_encode(array("message" => "ERRORE: È necessario prima generare i report."));
            }

            if (!file_exists($report_path . DIRECTORY_SEPARATOR . $matricola . '.pdf')) {
                http_response_code(404);
                return json_encode(array(
                    "message" => "ERRORE: Il report del laureando $matricola non è stato ancora generato."
                ));
            }

            $laureando = new Laureando($matricola, $corso_laurea, date_create($data_laurea));
            try {
                if (!self::$gestore_invio_email::inviaEmail($laureando, $report_path)) {
                    http_response_code(409);
                    return json_encode(array("message" => "Report già inviato al laureando $matricola."));
                }
            } catch (\Exception $e) {
                http_response_code(500);
                return json_encode(array("message" => "ERRORE: " . $e->getMessage()));
            }

            http_response_code(200);
            return json_encode(array("message" => "Report inviato al laureando $matricola."));
        }
        http_response_code(405);
        return null;
    }
}
