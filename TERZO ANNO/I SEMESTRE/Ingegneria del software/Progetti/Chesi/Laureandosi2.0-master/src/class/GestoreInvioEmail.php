<?php

namespace laureandosi;

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class GestoreInvioEmail
{
    private static GestoreInvioEmail $instance;
    private static ParametriConfigurazione $parametri_configurazione;
    private static string $cache_filename = "stato_invio.json";

    private function __construct()
    {
    }


    public static function getInstance(): GestoreInvioEmail
    {
        if (!isset(self::$instance)) {
            require_once(
                join(DIRECTORY_SEPARATOR, array(dirname(__DIR__), 'lib', 'PHPMailer', 'src', 'PHPMailer.php'))
            );
            require_once(
                join(DIRECTORY_SEPARATOR, array(dirname(__DIR__), 'lib', 'PHPMailer', 'src', 'Exception.php'))
            );
            require_once(
                join(DIRECTORY_SEPARATOR, array(dirname(__DIR__), 'lib', 'PHPMailer', 'src', 'SMTP.php'))
            );
            require_once("ParametriConfigurazione.php");

            self::$parametri_configurazione = ParametriConfigurazione::getInstance();
            self::$instance = new GestoreInvioEmail();
        }
        return self::$instance;
    }

    /**
     * Carica le informazioni riguardanti gli invii delle email
     * @param string $report_path
     * @return array
     */
    private static function caricaCache(string $report_path): array
    {
        $cache_file = $report_path . DIRECTORY_SEPARATOR . self::$cache_filename;
        if (file_exists($cache_file)) {
            return json_decode(file_get_contents($cache_file), true);
        }
        return array();
    }

    /**
     * Salva le informazioni riguardanti gli invii delle email
     * @param string $report_path
     * @param array $cache
     * @return bool
     */
    private static function salvaCache(string $report_path, array $cache): bool
    {
        $cache_file = $report_path . DIRECTORY_SEPARATOR . self::$cache_filename;
        return file_put_contents($cache_file, json_encode($cache));
    }

    /**
     * Creazione dell'email da inviare
     * @param Laureando $laureando
     * @param string $report
     * @return PHPMailer
     */
    private static function creaEmail(Laureando $laureando, string $report): PHPMailer
    {
        $mail = new PHPMailer(true);
        $mail->isSMTP();
        $mail->Host = "mixer.unipi.it";
        $mail->Port = 25;
        $mail->SMTPSecure = "tls";
        $mail->SMTPAuth = false;

        $mail->CharSet = 'UTF-8';
        $mail->setLanguage('it', join(DIRECTORY_SEPARATOR, array(dirname(__DIR__), 'lib', 'PHPMailer', 'language')));
        $mail->setFrom('no-reply-laureandosi@ing.unipi.it', 'Laureandosi');
        $mail->AddAddress($laureando->email, $laureando->nome . ' ' . $laureando->cognome);
        $mail->AddAttachment($report, 'report.pdf');

        $mail->Subject = 'Appello di laurea in ' .
            self::$parametri_configurazione::getCorsiDiLaurea()[$laureando->cdl]['cdl'] .
            '- indicatori per voto di laurea';
        $mail->Body = self::$parametri_configurazione::getCorsiDiLaurea()[$laureando->cdl]['txt-email'];

        return $mail;
    }

    /**
     * Invio dell'email
     * @param Laureando $laureando
     * @param string $report_path
     * @throws \Exception
     * @return bool
     */
    public static function inviaEmail(Laureando $laureando, string $report_path): bool
    {
        $cache = self::caricaCache($report_path);
        if (
            array_key_exists((string)$laureando->matricola, $cache)
            && $cache[(string)$laureando->matricola] == true
        ) {
            // Email già inviata
            return false;
        }

        $mail = self::creaEmail($laureando, $report_path . DIRECTORY_SEPARATOR . $laureando->matricola . '.pdf');

        try {
            $cache[(string)$laureando->matricola] = $mail->send();
            // $cache[(string)$laureando->matricola] = true; // test
        } catch (Exception $e) {
            throw new \Exception($e->errorMessage());
        }
        self::salvaCache($report_path, $cache);
        return true;
    }
}
