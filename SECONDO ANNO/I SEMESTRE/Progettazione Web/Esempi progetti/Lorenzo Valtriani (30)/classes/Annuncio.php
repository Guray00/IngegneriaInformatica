<?php
    class Annuncio {
        private $IdAnnuncio;
        private $IdAgenzia;
        private $Rif;
        private $Contratto;     // Id_Titolo modificato
        private $IdContratto;
        private $Categoria;   // Categoria, con testo
        private $IdCategoria;
        private $Titolo;
        private $Descrizione;
        private $Prezzo;
        private $MetriQuadri;
        private $CodiceIstat;
        private $Comune;
        private $IdComune;
        private $SiglaProvincia;
        private $Indirizzo;
        private $Localita;
        public $Foto;          // Array contenente foto
        private $ClasseEnergetica;
        private $IdClasseEnergetica;
        private $Ipe;
        private $NumeroLocali;
        private $NumeroBagni;
        private $NumeroCamere;
        private $BoxAuto;
        private $Balcone;
        private $Mansarda;
        private $Cantina;
        private $Arredato;
        private $Giardino;
        private $Ascensore;
        private $Errore;
        private $PATH_FOTO = "./foto/foto-annunci/";
        private $NO_FOTO;

        /**
         *  @param []String $DatiAnnuncio
         */
        public function __construct($DatiAnnuncio){
            $this->NO_FOTO = $this->PATH_FOTO."no-foto.jpg";
            if(is_array($DatiAnnuncio)){
                $this->CopyIntoAnnuncio($DatiAnnuncio);
            }else if(is_int($DatiAnnuncio) || is_string($DatiAnnuncio)){
                $StringaSQL = "CALL GetDatiAnnuncioFromId(?)";
                $mysqli = connect();
                $stmt = $mysqli->prepare($StringaSQL);
                $stmt->bind_param("i", $DatiAnnuncio);
                $stmt->execute();
                $result = $stmt->get_result();
                $Annuncio = mysqli_fetch_assoc($result);
                if(empty($Annuncio)) {
                    $this->Errore = 1;
                    return;
                }
                $mysqli->close();
                $this->CopyIntoAnnuncio($Annuncio);

                $StringaSQL ="SELECT F.IdFoto, F.IdAnnuncio,
                                      (ROW_NUMBER() OVER (PARTITION BY F.IdAnnuncio ORDER BY F.Posizione ASC) -1) AS Indice
                              FROM annuncio A
                                   INNER JOIN
                                   foto F ON A.IdAnnuncio = F.IdAnnuncio
                              WHERE F.IdAnnuncio = ?
                              ORDER BY F.Posizione ASC;";

                $mysqli = connect();
                $stmt = $mysqli->prepare($StringaSQL);
                $stmt->bind_param("i", $DatiAnnuncio);
                $stmt->execute();
                $result = $stmt->get_result();
                while($FotoAnnuncio = mysqli_fetch_assoc($result)){
                    $this->Foto[$FotoAnnuncio["Indice"]] = $this->PATH_FOTO.$FotoAnnuncio["IdFoto"].".jpg";
                }
                $mysqli->close();
            }
        }

        private function CopyIntoAnnuncio($DatiAnnuncio){
            $this->IdAnnuncio = $DatiAnnuncio["IdAnnuncio"];
            $this->IdAgenzia = $DatiAnnuncio["IdAgenzia"];
            $this->Rif = $DatiAnnuncio["Rif"];
            $this->Contratto = $DatiAnnuncio["Contratto"];
            $this->IdContratto = $DatiAnnuncio["IdContratto"];

            if(strpos($DatiAnnuncio["Categoria"], "vani") !== FALSE) $this->Categoria = "Appartamento di ".$DatiAnnuncio["Categoria"];
            else $this->Categoria = $DatiAnnuncio["Categoria"];
            $this->IdCategoria = $DatiAnnuncio["IdCategoria"];

            $this->Titolo = $DatiAnnuncio["Titolo"];
            $this->Descrizione = $DatiAnnuncio["Descrizione"];
            // Operazioni sul Prezzo
            if($DatiAnnuncio["Prezzo"] != "&euro;0") $this->Prezzo = $DatiAnnuncio["Prezzo"];
            else $this->Prezzo = "Info in Agenzia";

            $this->MetriQuadri = $DatiAnnuncio["MetriQuadri"];
            $this->CodiceIstat = $DatiAnnuncio["CodiceIstat"];
            $this->Comune = $DatiAnnuncio["Comune"];
            $this->IdComune = $DatiAnnuncio["IdComune"];
            $this->SiglaProvincia = $DatiAnnuncio["SiglaProvincia"];
            $this->Indirizzo = $DatiAnnuncio["Indirizzo"];
            $this->Localita = $DatiAnnuncio["Localita"];
            $this->ClasseEnergetica = $DatiAnnuncio["ClasseEnergetica"];
            $this->IdClasseEnergetica = $DatiAnnuncio["IdClasseEnergetica"];
            $this->Ipe = $DatiAnnuncio["Ipe"];
            $this->NumeroBagni = $DatiAnnuncio["NumeroBagni"];
            $this->NumeroCamere = $DatiAnnuncio["NumeroCamere"];
            $this->BoxAuto = $DatiAnnuncio["BoxAuto"];
            $this->Balcone = $DatiAnnuncio["Balcone"];
            $this->Mansarda = $DatiAnnuncio["Mansarda"];
            $this->Cantina = $DatiAnnuncio["Cantina"];
            $this->Arredato = $DatiAnnuncio["Arredato"];
            $this->Giardino = $DatiAnnuncio["Giardino"];
            $this->Ascensore = $DatiAnnuncio["Ascensore"];
            $this->NumeroLocali = $DatiAnnuncio["NumeroLocali"];
        }

      /* presa dal manuale di php https://www.php.net/manual/en/function.imagecrop.php */
      private function RitagliaFoto($source, $destination){
            // tagliare la foto secondo il lato più corto a quadrato
            $im = imagecreatefromjpeg($source);
            $size = min(imagesx($im), imagesy($im));
            $im2 = imagecrop($im, ['x' => 0, 'y' => 0, 'width' => $size, 'height' => $size]);
            if ($im2 !== FALSE) {
                imagepng($im2, $destination);
                imagedestroy($im2);
                return true;
            }
            imagedestroy($im);
            return false;
        }

        public function CaricaFotoServer($Source, $Destination){
          return $this->RitagliaFoto($Source, $Destination);
        }

        public function InserisciFotoDataBase(){
          $IdAnnuncio = $this->IdAnnuncio;
          $StringaSQL =
            " SELECT COUNT(*) + 1 AS NumeroElenco
              FROM Foto
              WHERE IdAnnuncio = $IdAnnuncio
            ";

          $mysqli = connect();
          $result = mysqli_query($mysqli, $StringaSQL);
          $NumeroElenco = mysqli_fetch_assoc($result)["NumeroElenco"];
          $mysqli->close();

          $StringaSQL =
            "INSERT INTO Foto (IdAnnuncio, Posizione) VALUES ($IdAnnuncio, $NumeroElenco)";

          $mysqli = connect();
          $result = mysqli_query($mysqli, $StringaSQL);
          return mysqli_insert_id($mysqli);
        }

        public function RimuoviFotoAnnuncioDataBase($idFoto, $Posizione){
          $IdAnnuncio = $this->IdAnnuncio;
          // Cancello la riga
          $StringaSQL =
            "DELETE FROM Foto
             WHERE IdFoto = $idFoto;";
          $mysqli = connect();
          mysqli_query($mysqli, $StringaSQL);

          // Abbasso di uno la posizione a tutte le foto di posizione superiore
          $StringaSQL =
            "UPDATE Foto
             SET Posizione = Posizione - 1
             WHERE IdAnnuncio = $IdAnnuncio AND Posizione > $Posizione;";

          mysqli_query($mysqli, $StringaSQL);
          $mysqli->close();
          // Rimuovere la foto dal server
          if(file_exists(__DIR__."/../foto/foto-annunci/".$idFoto.".jpg")){
              unlink(__DIR__."/../foto/foto-annunci/".$idFoto.".jpg");
          }
        }

        public function SetCopertinaDataBase($idFoto, $Posizione){
          $IdAnnuncio = $this->IdAnnuncio;
          // Alzare di uno la posizione a tutte le foto di posizione inferiore
          $StringaSQL =
            "UPDATE Foto
             SET Posizione = Posizione + 1
             WHERE IdAnnuncio = $IdAnnuncio AND Posizione < $Posizione;";

          $mysqli = connect();
          mysqli_query($mysqli, $StringaSQL);

          // Setta ad 1 la Posizione della foto
          $StringaSQL =
            "UPDATE Foto
             SET Posizione = 1
             WHERE IdFoto = $idFoto;";

          mysqli_query($mysqli, $StringaSQL);
          $mysqli->close();
        }

        public function GetFotoCopertina(){
            if(count($this->Foto) == 0) return $this->NO_FOTO;
            return $this->Foto[0];
        }

        /* Get e Setter */
        public function GetIdAnnuncio(){
            return $this->IdAnnuncio;
        }

        public function GetIdAgenzia(){
            return $this->IdAgenzia;
        }

        public function GetRif(){
            return $this->Rif;
        }

        public function GetContratto(){
            return $this->Contratto;
        }

        public function GetIdContratto(){
            return $this->IdContratto;
        }

        public function GetCategoria(){
            return $this->Categoria;
        }

        public function GetIdCategoria(){
            return $this->IdCategoria;
        }

        public function GetTitolo(){
            return $this->Titolo;
        }

        public function GetDescrizione(){
            return $this->Descrizione;
        }

        public function GetPrezzo(){
            return $this->Prezzo;
        }

        // Non serve forse
        public function GetPrezzoHome(){
            $Prezzo = $this->GetPrezzo();
            if($Prezzo == "Info In Agenzia" || $Prezzo == 0) {
                echo "Info In Agenzia";
                return;
            }
            $Prezzo = number_format($Prezzo, 0, ",", " ");
            echo "&euro; ".$Prezzo;
        }

        public function GetMetriQuadri(){
            return $this->MetriQuadri;
        }

        public function GetCodiceIstat(){
            return $this->CodiceIstat;
        }

        public function GetComune(){
            return $this->Comune;
        }

        public function GetIdComune(){
            return $this->IdComune;
        }

        public function GetSiglaProvincia(){
            return $this->SiglaProvincia;
        }

        public function GetIndirizzo(){
            return $this->Indirizzo;
        }

        public function GetLocalita(){
            return $this->Localita;
        }

        public function GetFoto(){
            return $this->Foto;
        }

        public function GetClasseEnergetica(){
            return $this->ClasseEnergetica;
        }

        public function GetIdClasseEnergetica(){
            return $this->IdClasseEnergetica;
        }

        public function GetIpe(){
            return $this->Ipe;
        }

        public function GetErrore(){
            return $this->Errore;
        }

        public function GetIpeUnit(){
            return $this->IpeUnit;
        }

        public function GetNumeroLocali(){
            return $this->NumeroLocali;
        }

        public function GetNumeroBagni(){
            return $this->NumeroBagni;
        }

        public function GetNumeroCamere(){
            return $this->NumeroCamere;
        }

        public function GetBoxAuto(){
            return $this->BoxAuto;
        }

        public function GetBalcone(){
            return $this->Balcone;
        }

        public function GetMansarda(){
            return $this->Mansarda;
        }

        public function GetCantina(){
            return $this->Cantina;
        }

        public function GetArredato(){
            return $this->Arredato;
        }

        public function GetGiardino(){
            return $this->Giardino;
        }

        public function GetAscensore(){
            return $this->Ascensore;
        }

        public function SetPrezzo($Prezzo){
            $this->Prezzo = $Prezzo;
        }

        public function SetComune($Comune){
            $this->Comune = $Comune;
        }
    }
?>
