<?php 
require_once(realpath(dirname(__FILE__)) . '/../classi/EsameLaureando.php');

class EsameLaureandoTest { // è una classe molto semplice 

    public function test(){
        try {
            $x = new EsameLaureando;
            $x->nomeEsame = "nome esame";
            $y = $x->nomeEsame;
            if ($y != "nome esame") echo "EsameLaureando: errore.  ";

        } catch (\Throwable $th) {
            echo "EsameLaureando: errore.  ".$th;
        }

        console_log("EsaameLaureando: test eseguito");
        echo "ESAME LAUREANDO: TUTTI I TEST ESEGUITI";
    }
}
?>