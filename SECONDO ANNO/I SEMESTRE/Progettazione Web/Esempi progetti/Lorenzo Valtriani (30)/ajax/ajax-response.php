<?php
/*
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
*/
session_start();
require_once(__DIR__."/../config/config.php");

switch($_POST["id"]){
    case 1:
        // Permetti il percorso per ritrovare l'hash
        $cost = 10;
        $password = $_POST["password"]."&daghe&".$_POST["username"];
        $db = connect();
        $sql = "SELECT AG.IdAgenzia, AG.Password
                FROM Agenzia AG
                WHERE AG.Username = ?";
        $stmt = $db->prepare($sql);
        $stmt->bind_param("s", $_POST["username"]);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        if(count($row) != 0)  {
            if(password_verify($password, $row["Password"])){
              $_SESSION["username"] = $_POST["username"];
              $_SESSION["IdAgenzia"] = $row["IdAgenzia"];
            } else echo "CredenzialiErrate";
        }  else echo "CredenzialiErrate";
        break;
    case 2:
        $db = connect();
        $sql = "UPDATE Agenzia
                SET Colore1 = ?, Colore2 = ?, Nome = ?
                WHERE IdAgenzia = ?";
        $stmt = $db->prepare($sql);
        $stmt->bind_param("sssi", $_POST["colore1"], $_POST["colore2"], $_POST["nomeAgenzia"], $_SESSION["IdAgenzia"]);
        $stmt->execute();
        break;

    case 3:
        // Otteniamo i comuni rilevanti per l'agenzia e non: per ottenere un elenco di comuni per farci dei suggerimenti
        // al momento della ricerca nella form da parte dell'utente
        $c = connect();
        $QuerySQL= "SELECT LOWER(CO.Nome) AS Nome, IF(C0.IdComune IS NULL, 0, 1) AS InAgenzia, CO.FkProvincia AS Provincia,
                    	     PRO.Sigla AS SiglaProvincia
                    FROM Comune CO
                    	 LEFT OUTER JOIN
                         (
                          	SELECT DISTINCT AN.IdComune
                            FROM Annuncio AN
                            WHERE AN.IdAgenzia = ?
                         ) AS C0 ON C0.IdComune = CO.IdComune
                         INNER JOIN
                         Provincia PRO ON PRO.NomeProvincia = CO.FkProvincia
                     ORDER BY IF(C0.IdComune IS NULL, 0, 1) DESC";
        $stmt = $c->prepare($QuerySQL);
        $stmt->bind_param("i", $_POST["a"]);
        $stmt->execute();
        $result = $stmt->get_result();
        $comuni = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode($comuni);
        break;

    case 4:
        require_once(__DIR__."/../classes/Agenzia.php");
        require_once(__DIR__."/../classes/Annuncio.php");

        if($_POST["com"] == "") $Comuni = [];
        else $Comuni = explode("£", $_POST["com"]);
        // L'utente vuole fare una ricerca: vengono visualizzati gli annunci relativi alla ricerca
        $Agenzia = new Agenzia($_POST["a"]);    // Costruttore dell'Agenzia
        echo json_encode($Agenzia->GetAnnunciDaRicerca($Comuni, (int)$_POST["contr"],
                                (int)$_POST["imm"], (int)$_POST["pmin"], (int)$_POST["pmax"], $_POST["riservato"]));
        break;
    case 5:
        require_once(__DIR__."/../classes/Agenzia.php");

        $Agenzia = new Agenzia($_SESSION["IdAgenzia"]);
        $response = $Agenzia->NuovoAnnuncio($_POST);
        echo $response;
        break;
    case 6:
        require_once(__DIR__."/../classes/Agenzia.php");

        $Agenzia = new Agenzia($_SESSION["IdAgenzia"]);
        $DatiAnnuncio = $Agenzia->GetAnnuncio($_POST["rif"]);
        if($DatiAnnuncio == false){
          echo "NO";
        } else echo json_encode($DatiAnnuncio);
        break;
    case 7:
        require_once(__DIR__."/../classes/Agenzia.php");

        $Agenzia = new Agenzia($_SESSION["IdAgenzia"]);
        $response = $Agenzia->ModificaAnnuncio($_POST);
        echo $response;
        break;
        // Rimuovi foto dal database
    case 8:
        require_once(__DIR__."/../classes/Annuncio.php");

        $Annuncio = new Annuncio($_POST["idAnnuncio"]);
        $Annuncio->RimuoviFotoAnnuncioDataBase($_POST["idFoto"], $_POST["posizione"]);
        break;
    case 9:
        require_once(__DIR__."/../classes/Annuncio.php");

        $Annuncio = new Annuncio($_POST["idAnnuncio"]);
        $Annuncio->SetCopertinaDataBase($_POST["idFoto"], $_POST["posizione"]);
        break;
    case 10:
        $db = connect();
        $QuerySQL = "SELECT *
                     FROM Agenzia
                     WHERE Username = ?";
         $stmt = $db->prepare($QuerySQL);
         $stmt->bind_param("s", $_POST["username"]);
         $stmt->execute();
         $result = $stmt->get_result();
         $row = $result->fetch_assoc();
         if(count($row) == 0) {
           // Hashiamo la password [$password&daghe&$username] tramite l'algoritmo BCRYPT, con un costo di 10.
           // L'algoritmo ritornerà una password di 60 caratteri
           $cost = 10;
           $password = $_POST["psw"]."&daghe&".$_POST["username"];
           $password = password_hash($password, PASSWORD_BCRYPT, ["cost" => $cost]);
           // Inserire nel DB la nuova agenzia
           $QuerySQL = "INSERT INTO Agenzia(Nome, Username, Password)
                        VALUES (?, ?, ?)";
           $stmt = $db->prepare($QuerySQL);
           $stmt->bind_param("sss", $_POST["agenzia"], $_POST["username"], $password);
           $stmt->execute();
           echo "OK";
         }
         else echo "NO";
        break;
      case 11:
        unset($_SESSION["loggato"]);
        break;
}
?>
