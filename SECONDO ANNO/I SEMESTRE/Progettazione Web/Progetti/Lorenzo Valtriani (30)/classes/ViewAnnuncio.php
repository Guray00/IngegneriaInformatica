<?php

require_once(__DIR__."/Annuncio.php");

class ViewAnnuncio extends Annuncio {

    private $MaxFotoPagina = 4;

    public function __construct($IdAnnuncio){
        parent::__construct($IdAnnuncio);
    }

    public function getFotoCopertina(){
        echo parent::GetFotoCopertina();
    }

    public function getFoto(){
        $Photos = parent::GetFoto();
        $NumFoto = count($Photos);

        if($NumFoto == 1) return;
        if($NumFoto > $this->MaxFotoPagina) {
            echo '<span id="prev" style="visibility: hidden"><span onclick="Prev()"><</span></span>';
        }

        for($i=0; $i<count($Photos); $i++){
            if($i < $this->MaxFotoPagina) {
                if($i == 0) echo "<span class='foto'><img src=".$Photos[$i]." style='border: 1px solid black; visibility: visible;' onload='FotoSecondarieCaricate(this)' onclick='SetPrincipale(this)'></span>";
                else echo "<span class='foto'><img src=".$Photos[$i]." style='visibility: visible;' onload='FotoSecondarieCaricate(this)' onclick='SetPrincipale(this)'></span>";
            }
            else echo "<span class='foto' style='display: none'><img src=".$Photos[$i]." onclick='SetPrincipale(this)'></span>";
        }

        if($NumFoto > $this->MaxFotoPagina) {
            echo '<span id="next"><span onclick="Next()">></span></span>';
        }
    }

    public function getTitolo(){
        $Contratto = parent::GetContratto();
        $Indirizzo = parent::GetIndirizzo();
        $Localita = parent::GetLocalita();
        $Comune = parent::GetComune();
        $Provincia = parent::GetSiglaProvincia();
        $Categoria = parent::GetCategoria();

        $Titolo = $Contratto;
        if($Categoria != "Altro") $Titolo .= " ".$Categoria;
        if($Indirizzo == NULL && $Localita != $Comune && $Localita != NULL){
            $Titolo .= " a $Localita";
        } else if($Indirizzo != NULL) {
            $Titolo .= " in $Indirizzo";
        }
        $Titolo .= ", $Comune ($Provincia)";
        echo $Titolo;
    }

    public function GetPrezzo(){
        $Prezzo = parent::GetPrezzo();
        if($Prezzo == "Info In Agenzia" || $Prezzo == 0) {
            echo $Prezzo;
            return;
        }
        $Prezzo = number_format($Prezzo, 0, ",", " ");
        echo "&euro; ".$Prezzo;
    }

    public function GetDescrizione(){
        $Descrizione = "<i>[Rif: ".parent::GetRif()."]</i></br>";
        $Descrizione .= parent::GetDescrizione();
        echo $Descrizione;
    }

    public function GetCaratteristiche(){
        $this->ViewContratto(parent::GetContratto());
        $this->ViewCategoria(parent::GetCategoria());
        $this->ViewPrezzo(parent::GetPrezzo());
        $this->ViewNumeroLocali(parent::GetNumeroLocali());
        $this->ViewSuperficie(parent::GetMetriQuadri());
        $this->ViewClasseEnergetica(parent::GetClasseEnergetica());
        $this->ViewServizi(parent::GetNumeroBagni());
        $this->ViewCamere(parent::GetNumeroCamere());
        $this->ViewBoxAuto(parent::GetBoxAuto());
        $this->ViewBalcone(parent::GetBalcone());
        $this->ViewMansarda(parent::GetMansarda());
        $this->ViewCantina(parent::GetCantina());
        $this->ViewGiardino(parent::GetGiardino());
        $this->ViewAscensore(parent::GetAscensore());
        $this->ViewArredato(parent::GetArredato());
    }

    public function GetPosizione(){
        $Str = "";
        if($this->GetIndirizzo() != FALSE) $Str = $Str.$this->GetIndirizzo()."<br>";
        else if($this->GetLocazione() != FALSE) $Str = $Str.$this->GetLocazione();
        if($Str != "") echo "<h3>Posizione:</h3>".$Str;
    }

    public function GetIndirizzo(){
        $Indirizzo = parent::GetIndirizzo();
        if(!is_null($Indirizzo)){
            return "<h4>".$Indirizzo."</h4>";
        }
        return false;
    }

    private function GetLocazione(){
        $Localita = parent::GetLocalita();
        $Comune = parent::GetComune();
        $Provincia = parent::GetSiglaProvincia();

        $Str = "";
        if(!is_null($Localita) && $Localita != "") $Str.= $Localita.", ";
        if(!is_null($Comune) && $Comune != "") $Str.= $Comune.", ";
        if(!is_null($Provincia) && $Provincia != "") $Str.= $Provincia;
        if($Str == "") return false;
        else return "<h4>".$Str."</h4>";
    }

    /**
     * Function that returns HTML code respect two input param
     *
     * @param [string] $nome Nome della caratteristica
     * @param [string] $dato Valore della caratteristica
     * @return void
     */
    private function ViewCaratteristica($nome, $dato){
        echo '<div class="sotto-blocco">
                <h4 class="nomea-caratt">'.$nome.':</h4>
                <h4 class="val-caratt">'.$dato.'</h4>
              </div>';
    }

    // funzioni per l'echo delle singole caratteristiche
    private function ViewContratto($Contratto){
        $this->ViewCaratteristica("CONTRATTO", $Contratto);
    }

    private function ViewCategoria($Categoria){
        $this->ViewCaratteristica("TIPOLOGIA", $Categoria);
    }

    private function ViewPrezzo($Prezzo){
        if($Prezzo != "Info In Agenzia" && $Prezzo != 0) {
            $Prezzo = number_format($Prezzo, 0, ",", " ");
            $this->ViewCaratteristica("PREZZO", "&euro; ".$Prezzo);
        } else $this->ViewCaratteristica("PREZZO", "Info In Agenzia");
    }

    private function ViewNumeroLocali($Locali){
        if(is_null($Locali) || $Locali == "") return;
        $this->ViewCaratteristica("LOCALI", $Locali);
    }

    private function ViewSuperficie($Superficie){
        if(is_null($Superficie) || $Superficie == "") return;
        $this->ViewCaratteristica("SUPERFICIE", $Superficie." m<span class='sup'>2</span>");
    }

    private function ViewClasseEnergetica($Classe){
        if(is_null($Classe) || $Classe == "") return;
        $this->ViewCaratteristica("CLASSE ENERGETICA", $Classe);
    }

    private function ViewIpe($Ipe, $Unit){
        if(is_null($Ipe) || $Ipe == 0) return;
        if(strpos("*", $Unit) === FALSE){
            $this->ViewCaratteristica("IPE", $Ipe." ".$Unit);
        } else {
            $Unit = explode("*", $Unit);
            $this->ViewCaratteristica("IPE", $Ipe." ".$Unit[0]."/".$Unit[1]);
        }
    }

    private function ViewServizi($Servizi){
        if(is_null($Servizi) || $Servizi == 0) return;
        $this->ViewCaratteristica("SERVIZI", $Servizi);
    }

    private function ViewCamere($Camere){
        if(is_null($Camere) || $Camere == 0) return;
        $this->ViewCaratteristica("CAMERE", $Camere);
    }

    private function ViewBoxAuto($Auto){
        if(is_null($Auto) || $Auto == 0) return;
        $this->ViewCaratteristica("BOX AUTO", "S&Igrave;");
    }

    private function ViewBalcone($Balcone){
        if(is_null($Balcone) || $Balcone == 0) return;
        $this->ViewCaratteristica("BALCONE", "S&Igrave;");
    }

    private function ViewMansarda($Mansarda){
        if(is_null($Mansarda) || $Mansarda == 0) return;
        $this->ViewCaratteristica("MANSARDA", "S&Igrave;");
    }

    private function ViewCantina($Cantina){
        if(is_null($Cantina) || $Cantina == 0) return;
        $this->ViewCaratteristica("CANTINA", "S&Igrave;");
    }

    private function ViewArredato($Arredato){
        if(is_null($Arredato) || $Arredato == 0) return;
        $this->ViewCaratteristica("ARREDATO", "S&Igrave;");
    }

    private function ViewGiardino($Giardino){
        if(is_null($Giardino) || $Giardino == 0) return;
        $this->ViewCaratteristica("GIARDINO", "S&Igrave;");
    }

    private function ViewAscensore($Ascensore){
        if(is_null($Ascensore) || $Ascensore == 0) return;
        $this->ViewCaratteristica("ASCENSORE", "S&Igrave;");
    }
}


?>
