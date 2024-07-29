<?php
use LDAP\Result;

require_once(__DIR__."/Annuncio.php");
require_once(__DIR__."/../config/config.php");

class Agenzia {
    private $IdAgenzia = NULL;
    private $NomeAgenzia;
    private $Annunci;
    private $Permesso;      // 1: okay ha il sito, 0: no, non ha pagato
    private $Contratti;     // Titoli
    private $TipoImmobili;  // Sottotitoli
    private $NumeroAnnunciTrovati;
    private $LimiteAnnunciXPagina = 10;
    private $Colore1;
    private $Colore2;
    private $DEST_FOTO = "./foto/foto-annunci/";
    private $AllContratti = [];
    private $AllCategorie = [];
    private $AllComuni = [];
    private $AllClassiEnergetiche = [];

    # Dovremmo aggiustare la query per far si che non trovi duplicati
    public function __construct($IdAgenzia){
        $this->IdAgenzia = $IdAgenzia;
        $this->Permesso = 1;
        $StringaSQL = "CALL GetDatiAgenziaFromId(?)";
        $mysqli = connect();
        $stmt = $mysqli->prepare($StringaSQL);
        $stmt->bind_param("i", $IdAgenzia);
        $stmt->execute();
        $result = $stmt->get_result();

        // Creazione del Vettore Annunci che contiene elmenti della Classe Annuncio
        $Annunci = false;
        while($DatiAnnuncio = mysqli_fetch_assoc($result)){
            $Annunci = true;
            $this->Permesso = 1;
            $this->Colore1 = $DatiAnnuncio["Colore1"];
            $this->Colore2 = $DatiAnnuncio["Colore2"];
            $this->NomeAgenzia = $DatiAnnuncio["NomeAgenzia"];
            $this->Contratti[$DatiAnnuncio["IdContratto"]] = $DatiAnnuncio["Contratto"];
            $this->TipoImmobili[$DatiAnnuncio["IdCategoria"]] = $DatiAnnuncio["Categoria"];
            $this->Annunci[$DatiAnnuncio["IdAnnuncio"]] = new Annuncio($DatiAnnuncio);
        }
        $mysqli->close();

        if(!$Annunci) {
          // Ottenimento di questi dati tramite query
          $StringaSQL = "SELECT Colore1, Colore2, Nome AS NomeAgenzia
                       FROM Agenzia
                       WHERE IdAgenzia = ?";
          $mysqli = connect();
          $stmt = $mysqli->prepare($StringaSQL);
          $stmt->bind_param("i", $IdAgenzia);
          $stmt->execute();
          $result = $stmt->get_result();
          if($DatiAg = mysqli_fetch_assoc($result)){
            $this->Permesso = 1;
            $this->Colore1 = $DatiAg["Colore1"];
            $this->Colore2 = $DatiAg["Colore2"];
            $this->NomeAgenzia = $DatiAg["NomeAgenzia"];
          } else $this->Permesso = 0;
          $mysqli->close();
        } else {
          $StringaSQL = "CALL GetFotoAgenziaXAnnuncio(?);";
          $mysqli = connect();
          $stmt = $mysqli->prepare($StringaSQL);
          $stmt->bind_param("i", $IdAgenzia);
          $stmt->execute();
          $result = $stmt->get_result();

          while($FotoAnnuncio = mysqli_fetch_assoc($result)){
              $this->Annunci[$FotoAnnuncio["IdAnnuncio"]]->Foto[$FotoAnnuncio["Indice"]] = $this->DEST_FOTO.$FotoAnnuncio["IdFoto"].".jpg";
          }
          $mysqli->close();
        }
    }

    public function GetAnnunci(){
        return $this->Annunci;
    }

    public function GetIdAgenzia(){
        return $this->IdAgenzia;
    }

    public function GetNomeAgenzia(){
        return $this->NomeAgenzia;
    }

    public function GetPermesso(){
        return $this->Permesso;
    }

    public function GetColore1(){
        return $this->Colore1;
    }

    public function GetColore2(){
        return $this->Colore2;
    }

    public function GetContratti(){
        return $this->Contratti;
    }

    public function GetTipoImmobili(){
        return $this->TipoImmobili;
    }

    public function GetNumeroAnnunciTrovati(){
        return $this->NumeroAnnunciTrovati;
    }

    public function GetLimiteAnnunciXPagina(){
        return $this->LimiteAnnunciXPagina;
    }

    public function GetAllContratti(){
      if(count($this->AllContratti) == 0){
        $StringaSQL =
            "SELECT Nome AS Contratto, IdContratto
             FROM Contratto";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        while($Contratto = mysqli_fetch_assoc($result)){
          array_push($this->AllContratti, $Contratto);
        }
      }
      return $this->AllContratti;
    }

    public function GetAllCategorie(){
      if(count($this->AllCategorie) == 0){
        $StringaSQL =
            "SELECT Nome AS Categoria, IdCategoria
             FROM Categoria
             ORDER BY Nome ASC";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        while($Categoria = mysqli_fetch_assoc($result)){
          array_push($this->AllCategorie, $Categoria);
        }
      }
      return $this->AllCategorie;
    }

    public function GetAllComuni(){
      if(count($this->AllComuni) == 0){
        $StringaSQL =
            "SELECT C.Nome AS Comune, C.IdComune AS IdComune, P.Sigla AS SiglaProvincia
             FROM Comune C
                  INNER JOIN
                  Provincia P ON C.FkProvincia = P.NomeProvincia
             ORDER BY C.Nome ASC";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        while($Comune = mysqli_fetch_assoc($result)){
          array_push($this->AllComuni, $Comune);
        }
      }
      return $this->AllComuni;
    }

    public function GetAllClassiEnergetiche(){
      if(count($this->AllClassiEnergetiche) == 0){
        $StringaSQL =
            "SELECT Nome AS ClasseEnergetica, IdClasseEnergetica
             FROM ClasseEnergetica
             ORDER BY Nome ASC";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        while($Classe = mysqli_fetch_assoc($result)){
          array_push($this->AllClassiEnergetiche, $Classe);
        }
      }
      return $this->AllClassiEnergetiche;
    }

    public function AggiornaLogo($source, $destination){
      // Controllare se il file esiste
      // Se esiste Cancello
      if(file_exists($destination)) unlink($destination);
      // Inserire nel server
      return move_uploaded_file($source, $destination);
    }

    public function NuovoAnnuncio($An){
      // Campi Obbligatori
      $IdAgenzia = $this->IdAgenzia;
      $Riferimento = $An['Riferimento'];
      $IdContratto = $An['IdContratto'];
      $IdCategoria = $An['IdCategoria'];
      $IdComune = $An['IdComune'];
      $Titolo = $An['Titolo'];
      $Prezzo = $An['Prezzo'];
      $Descrizione = $An['Descrizione'];
      $IdClasseEnergetica = $An['IdClasseEnergetica'];

      if($this->RiferimentoEsistente($Riferimento)) return "Riferimento già presente!";

      // Campi non nulli
      $CampiNoNulli = "";
      $CampiNoNulli.= ($An['Indirizzo'] != "") ? ", Indirizzo" : "";
      $CampiNoNulli.= ($An['Localita'] != "") ? ", Localita" : "";
      $CampiNoNulli.= ($An['NumeroLocali'] != "") ? ", NumeroLocali" : "";
      $CampiNoNulli.= ($An['Superficie'] != "") ? ", Superficie" : "";
      $CampiNoNulli.= ($An['Ipe'] != "") ? ", Ipe" : "";
      $CampiNoNulli.= ($An['Bagni'] != "") ? ", Bagni" : "";
      $CampiNoNulli.= ($An['BoxAuto'] != "") ? ", BoxAuto" : "";
      $CampiNoNulli.= ($An['Balcone'] != "") ? ", Balcone" : "";
      $CampiNoNulli.= ($An['Mansarda'] != "") ? ", Mansarda" : "";
      $CampiNoNulli.= ($An['Cantina'] != "") ? ", Cantina" : "";
      $CampiNoNulli.= ($An['Arredato'] != "") ? ", Arredato" : "";
      $CampiNoNulli.= ($An['Giardino'] != "") ? ", Giardino" : "";
      $CampiNoNulli.= ($An['Ascensore'] != "") ? ", Ascensore" : "";
      $CampiNoNulli.= ($An['NumeroCamere'] != "") ? ", NumeroCamere" : "";

      $ValoriNoNulli = "";
      $ValoriNoNulli.= ($An['Indirizzo'] != "") ? ", \"".$An['Indirizzo']."\"" : "";
      $ValoriNoNulli.= ($An['Localita'] != "") ? ", \"".$An['Localita']."\"" : "";
      $ValoriNoNulli.= ($An['NumeroLocali'] != "") ? ", ".$An['NumeroLocali'] : "";
      $ValoriNoNulli.= ($An['Superficie'] != "") ? ", ".$An['Superficie'] : "";
      $ValoriNoNulli.= ($An['Ipe'] != "") ? ", ".$An['Ipe'] : "";
      $ValoriNoNulli.= ($An['Bagni'] != "") ? ", ".$An['Bagni'] : "";
      $ValoriNoNulli.= ($An['BoxAuto'] != "") ? ", ".$An['BoxAuto'] : "";
      $ValoriNoNulli.= ($An['Balcone'] != "") ? ", ".$An['Balcone'] : "";
      $ValoriNoNulli.= ($An['Mansarda'] != "") ? ", ".$An['Mansarda'] : "";
      $ValoriNoNulli.= ($An['Cantina'] != "") ? ", ".$An['Cantina'] : "";
      $ValoriNoNulli.= ($An['Arredato'] != "") ? ", ".$An['Arredato'] : "";
      $ValoriNoNulli.= ($An['Giardino'] != "") ? ", ".$An['Giardino'] : "";
      $ValoriNoNulli.= ($An['Ascensore'] != "") ? ", ".$An['Ascensore'] : "";
      $ValoriNoNulli.= ($An['NumeroCamere'] != "") ? ", ".$An['NumeroCamere'] : "";

      $An["Prezzo"] = number_format(floatval($An["Prezzo"]), 0, ",", " ");
      if($An["Superficie"] != "") $An["Superficie"] = number_format(floatval($An["Superficie"]), 0, ",", " ");
      if($An["Ipe"] != "") $An["Ipe"] = number_format(floatval($An["Ipe"]), 0, ",", " ");

      $StringaSQL =
          "INSERT INTO Annuncio
            (
              IdAgenzia, Riferimento, IdContratto, IdCategoria, IdComune, Titolo, Prezzo, Descrizione, IdClasseEnergetica
              $CampiNoNulli
            )
          VALUES
            (
              $IdAgenzia, \"$Riferimento\", $IdContratto, $IdCategoria, $IdComune, \"$Titolo\", $Prezzo, \"$Descrizione\",
              $IdClasseEnergetica $ValoriNoNulli
            );";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        return "OK";
    }

    public function ModificaAnnuncio($An){
        // Campi Obbligatori
        $IdAgenzia = $this->IdAgenzia;
        $IdAnnuncio = $An["IdAnnuncio"];
        $RiferimentoVecchio = $An['RiferimentoVecchio'];
        $Riferimento = $An['Riferimento'];
        $IdContratto = $An['IdContratto'];
        $IdCategoria = $An['IdCategoria'];
        $IdComune = $An['IdComune'];
        $Titolo = $An['Titolo'];
        $Prezzo = $An['Prezzo'];
        $Descrizione = $An['Descrizione'];
        $IdClasseEnergetica = $An['IdClasseEnergetica'];

        if($this->RiferimentoEsistente($Riferimento, "Modifica", $IdAnnuncio) === "Già presente") return "Riferimento già presente!";

        // Campi non nulli
        $CampiNoNulli = "";
        $CampiNoNulli.= ($An['Indirizzo'] != "") ? ", Indirizzo = '".$An['Indirizzo']."'" : "";
        $CampiNoNulli.= ($An['Localita'] != "") ? ", Localita = '".$An['Localita']."'" : "";
        $CampiNoNulli.= ($An['NumeroLocali'] != "") ? ", NumeroLocali = ".$An['NumeroLocali'] : "";
        $CampiNoNulli.= ($An['Superficie'] != "") ? ", Superficie = ".$An['Superficie'] : "";
        $CampiNoNulli.= ($An['Ipe'] != "") ? ", Ipe = ".$An['Ipe'] : "";
        $CampiNoNulli.= ($An['Bagni'] != "") ? ", Bagni = ".$An['Bagni'] : "";
        $CampiNoNulli.= ($An['BoxAuto'] != "") ? ", BoxAuto = ".$An['BoxAuto'] : "";
        $CampiNoNulli.= ($An['Balcone'] != "") ? ", Balcone = ".$An['Balcone'] : "";
        $CampiNoNulli.= ($An['Mansarda'] != "") ? ", Mansarda = ".$An['Mansarda'] : "";
        $CampiNoNulli.= ($An['Cantina'] != "") ? ", Cantina = ".$An['Cantina'] : "";
        $CampiNoNulli.= ($An['Arredato'] != "") ? ", Arredato = ".$An['Arredato'] : "";
        $CampiNoNulli.= ($An['Giardino'] != "") ? ", Giardino = ".$An['Giardino'] : "";
        $CampiNoNulli.= ($An['Ascensore'] != "") ? ", Ascensore = ".$An['Ascensore'] : "";
        $CampiNoNulli.= ($An['NumeroCamere'] != "") ? ", NumeroCamere = ".$An['NumeroCamere'] : "";

        $An["Prezzo"] = number_format(floatval($An["Prezzo"]), 0, ",", " ");
        if($An["Superficie"] != "") $An["Superficie"] = number_format(floatval($An["Superficie"]), 0, ",", " ");
        if($An["Ipe"] != "") $An["Ipe"] = number_format(floatval($An["Ipe"]), 0, ",", " ");

        $mysqli = connect();
        $StringaSQL = "SET foreign_key_checks = 0;";
        $result = mysqli_query($mysqli, $StringaSQL);

        $StringaSQL =
            "UPDATE Annuncio
             SET Riferimento = '$Riferimento', IdContratto = $IdContratto, IdCategoria = $IdCategoria, IdComune = $IdComune,
                 Titolo = '$Titolo', Prezzo = $Prezzo, Descrizione = '$Descrizione', IdClasseEnergetica = $IdClasseEnergetica
                 $CampiNoNulli
             WHERE IdAgenzia = $IdAgenzia AND Riferimento = '$RiferimentoVecchio';
            ";

          $result = mysqli_query($mysqli, $StringaSQL);
          if($result){
            $this->Annunci[$An["IdAnnuncio"]] = new Annuncio($An["IdAnnuncio"]);
            $StringaSQL = "SET foreign_key_checks = 1;";
            $result = mysqli_query($mysqli, $StringaSQL);
            return "OK";
          }
          $StringaSQL = "SET foreign_key_checks = 1;";
          $result = mysqli_query($mysqli, $StringaSQL);
          return "Errore Query!";
    }

    public function GetAnnuncio($Riferimento){
      $key = $this->RiferimentoEsistente($Riferimento);
      if($key == false) return false;
      return $this->ConvertAnnuncioIntoArray($key);
    }

    private function RiferimentoEsistente($Riferimento, $Mod = "Nuovo", $IdAnnuncio = NULL){
      if($Mod == "Nuovo") {
        if(count($this->Annunci) != 0) {
          foreach ($this->Annunci as $key => $Annuncio) {
            if($Annuncio->GetRif() == $Riferimento) return $key;
          }
        }
        // Cercare nel database:
        $IdAgenzia = $this->IdAgenzia;
        $StringaSQL =
          "SELECT IdAnnuncio
           FROM Annuncio
           WHERE Riferimento = '$Riferimento' AND IdAgenzia = $IdAgenzia;";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        if($Annuncio = mysqli_fetch_assoc($result)) {
          $this->Annunci[$Annuncio["IdAnnuncio"]] = new Annuncio($Annuncio["IdAnnuncio"]);
          return $Annuncio["IdAnnuncio"];
        }
        return false;

      } else if($Mod = "Modifica") {
        $RifNonCambia = false;
        foreach ($this->Annunci as $key => $Annuncio) {
          if($Annuncio->GetRif() == $Riferimento){
            if($Annuncio->GetIdAnnuncio() == $IdAnnuncio) {
              $RifNonCambia = true;
              continue;
            }
            return "Già presente";
          }
        }
        if($RifNonCambia) return true;
        // Cercare nel database:
        $IdAgenzia = $this->IdAgenzia;
        $StringaSQL =
          "SELECT IdAnnuncio
           FROM Annuncio
           WHERE Riferimento = '$Riferimento' AND IdAgenzia = $IdAgenzia;";

        $mysqli = connect();
        $result = mysqli_query($mysqli, $StringaSQL);
        if($Annuncio = mysqli_fetch_assoc($result)) {
          $this->Annunci[$Annuncio["IdAnnuncio"]] = new Annuncio($Annuncio["IdAnnuncio"]);
          return "Già presente";
        }
        return $Riferimento;
      }
    }

    private function ConvertAnnuncioIntoArray($IdAnnuncio){
      $AnnuncioArray = array(
         "IdAnnuncio" => $this->Annunci[$IdAnnuncio]->GetIdAnnuncio(),
         "IdAgenzia" => $this->Annunci[$IdAnnuncio]->GetIdAgenzia(),
         "Rif" => $this->Annunci[$IdAnnuncio]->GetRif(),
         "Contratto" => $this->Annunci[$IdAnnuncio]->GetContratto(),
         "IdContratto" => $this->Annunci[$IdAnnuncio]->GetIdContratto(),
         "Categoria" => $this->Annunci[$IdAnnuncio]->GetCategoria(),
         "IdCategoria" => $this->Annunci[$IdAnnuncio]->GetIdCategoria(),
         "Titolo" => $this->Annunci[$IdAnnuncio]->GetTitolo(),
         "Descrizione" => $this->Annunci[$IdAnnuncio]->GetDescrizione(),
         "Prezzo" => $this->Annunci[$IdAnnuncio]->GetPrezzo(),
         "MetriQuadri" => $this->Annunci[$IdAnnuncio]->GetMetriQuadri(),
         "IdComune" => $this->Annunci[$IdAnnuncio]->GetIdComune(),
         "Comune" => $this->Annunci[$IdAnnuncio]->GetComune(),
         "SiglaProvincia" => $this->Annunci[$IdAnnuncio]->GetSiglaProvincia(),
         "Indirizzo" => $this->Annunci[$IdAnnuncio]->GetIndirizzo(),
         "Localita" => $this->Annunci[$IdAnnuncio]->GetLocalita(),
         "Foto" => $this->Annunci[$IdAnnuncio]->GetFoto(),
         "ClasseEnergetica" => $this->Annunci[$IdAnnuncio]->GetClasseEnergetica(),
         "IdClasseEnergetica" => $this->Annunci[$IdAnnuncio]->GetIdClasseEnergetica(),
         "Ipe" => $this->Annunci[$IdAnnuncio]->GetIpe(),
         "NumeroLocali" => $this->Annunci[$IdAnnuncio]->GetNumeroLocali(),
         "NumeroBagni" => $this->Annunci[$IdAnnuncio]->GetNumeroBagni(),
         "NumeroCamere" => $this->Annunci[$IdAnnuncio]->GetNumeroCamere(),
         "BoxAuto" => $this->Annunci[$IdAnnuncio]->GetBoxAuto(),
         "Balcone" => $this->Annunci[$IdAnnuncio]->GetBalcone(),
         "Mansarda" => $this->Annunci[$IdAnnuncio]->GetMansarda(),
         "Cantina" => $this->Annunci[$IdAnnuncio]->GetCantina(),
         "Arredato" => $this->Annunci[$IdAnnuncio]->GetArredato(),
         "Giardino" => $this->Annunci[$IdAnnuncio]->GetGiardino(),
         "Ascensore" => $this->Annunci[$IdAnnuncio]->GetAscensore()
      );
      return $AnnuncioArray;
    }

    /**
     * Funzione che ritorna gli annunci dell'agenzia specificata che soddisfano le condizioni inviate per parametro
     *
     * @param array $Comune
     * @param integer $Contratto
     * @param integer $TipoImmobile
     * @param integer $PrezzoMin
     * @param integer $PrezzoMax
     * @param string $Riservato ["false": se non voglio gli Info In agenzia, "true": altrimenti]
     * @return array Annuncio[]
     */
    public function GetAnnunciDaRicerca(array $Comuni, int $Contratto, int $TipoImmobile, int $PrezzoMin, int $PrezzoMax, string $Riservato){
        $Annunci = $this->GetAnnunci(); //Tutti gli annunci dell'agenzia
        $AnnunciCondizioneEsatta = array();
        foreach($Annunci as $key => $Annuncio){
            // Controllo Prezzo
            if($Annuncio->GetPrezzo() != "Info In Agenzia" && $Annuncio->GetPrezzo() != 0){
                if($Annuncio->GetPrezzo() < $PrezzoMin && $PrezzoMin != NULL) continue;
                if($Annuncio->GetPrezzo() > $PrezzoMax && $PrezzoMax != NULL) continue;
            } else if($Riservato == "false") continue;

            // Controllo Contratto e Categoria
            if($Annuncio->GetIdContratto() != $Contratto && $Contratto != NULL) continue;
            if($Annuncio->GetIdCategoria() != $TipoImmobile && $TipoImmobile != NULL) continue;
            // Controllo Comune

            if(!empty($Comuni)) {
                $ComuneAnnuncio = strtolower($Annuncio->GetComune());
                if(array_search($ComuneAnnuncio, $Comuni) === FALSE) continue;
            }
            // Trasforma Prezzo
            if($Annuncio->GetPrezzo() == "Info In Agenzia" || $Annuncio->GetPrezzo() == 0) {
                $Annuncio->SetPrezzo("Info In Agenzia");
            } else {
                $Prezzo = number_format($Annuncio->GetPrezzo(), 0, ",", " ");
                $Annuncio->SetPrezzo("&euro; ".$Prezzo);
            }
            array_push($AnnunciCondizioneEsatta, (array) $Annuncio);
        }
        $this->NumeroAnnunciTrovati = count($AnnunciCondizioneEsatta);
        return $AnnunciCondizioneEsatta;
    }
}

?>
