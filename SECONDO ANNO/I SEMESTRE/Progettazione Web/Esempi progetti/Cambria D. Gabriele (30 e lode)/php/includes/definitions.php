<?php

if (basename($_SERVER['PHP_SELF']) === 'definitions.php'){
    require_once __DIR__ . "/methods.php";
    pageError(403);
}

define("DATABASE", "cambria_672642");
define("DB_HOST", "localhost:3306");
define("DB_USER", "root");
define("DB_PWD", "");


/**
 * Pattern per l'username dell'account: dai 3 ai 10 caratteri. Il primo lettera, gli altri lettera punti o underscore
 */
define('USERNAME_PATTERN', "/^[a-zA-Z][a-zA-Z0-9_.]{2,9}$/");
define("VALID_USERNAME", "User.0_");

//? source: https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
/**
 * Pattern per la password dell'account: da 8 a 15 caratteri, almeno una lettera maiuscola, una minuscola, un numero e un carattere speciale.
 */
define('PASSWORD_PATTERN', "/^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,15}$/");
//? endsource
define("VALID_PASSWORD", "Password1!");

/**
 * *Pattern per il nome del personaggio: solo lettere, da 3 a 10 caratteri
 */
define("PG_NAME_PATTERN", "/^[a-zA-Z][a-zA-Z]{2,9}$/");

/**
 * Definizione dei messaggi di errore utilizzati nell'applicazione
 */
define('ERROR_TYPES', [
    'invalid_username'          => "Username non valido. Deve iniziare con una lettera e avere tra 3 e 10 caratteri.",
    'username_taken'            => "Username già esistente.",
    'username_same_as_current'  => "Stai già utilizzando questo username.",
    'username_not_found'        => "L'username non esiste.",
    'invalid_password'          => "Password non valida. Deve contenere almeno 8 caratteri e non più di 15, una lettera maiuscola, una minuscola, un numero e un carattere speciale.",
    'password_mismatch'         => "Le password non corrispondono.",
    'wrong_password'            => "Password errata, ritenta.",
    'wrong_password_on_delete'  => "Password errata.\nAccount non eliminato.",
    'password_same_as_current'  => "La nuova password non deve essere uguale a quella attuale.",
    'registration_failed'       => "Registrazione fallita. Riprova.",
    'connection_failed'         => "Il server non è al momento disponibile.\nRiprovare tra un po'.",
    'invalid_param'             => "I parametri forniti non sono corretti.",
    'image_same_as_current'     => "Stai già utilizzando questa immagine",
    'update_failed'             => "C'è stato un problema durante l'aggiornamento.\nRiprova tra un po'.",
    'invalid_pg_name'           => "Nome non valido. Deve contenere solo lettere e avere tra i 3 a 10 caratteri.",
    'invalid_element'           => "L'elemento inserito non è un elemento valido",
    'full_PG'                   => "L'account ha già il numero massimo di Personaggi associati.\nPer crearne uno nuovo elimina uno vecchio",
    'pg_name_taken'             => "Questo account ha già un personaggio con questo nome!\nScelgine un altro",
    'pg_not_found'              => "Il personaggio che volevi eliminare non esiste",
    'pg_not_selected'           => "Non è stato fornito nessun personaggio valido sul quale agire",
    'upgrade_failed'            => "C'è stato un problema con l'aggiornamento.",
    'default'                   => "Errore generico, ci scusiamo per il disagio."
]);

/**
 * Quantità minima di monete delle box comuni
 */
define("MIN_COIN_COMMON", 5);

/**
 * Quantità massima di monete delle box comuni
 */
define("MAX_COIN_COMMON", 10);

/**
 * Quantità minima di monete delle box rare
 */
define("MIN_COIN_RARE", 15);

/**
 * Quantità massima di monete delle box rare
 */
define("MAX_COIN_RARE", 20);

/**
 * Numero massimo di Item diversi in un inventario
 */
define("MAX_ITEMS", 40);

/**
 * Numero massimo di Item diversi in un negozio
 */
define("MAX_SHOP_ITEMS", value: 10);

/**
 * Intervallo temporale del refresh del negozio (in secondi)
 */
define('SHOP_TIMER_RESET_SECONDS', value: 3*60);

/**
 * Contiene i tipi di oggetto che non possono essere inseriti nello zaino
 */
define("NOT_OBJECT_TYPES", ['arma', 'armatura', 'box']);

/**
 * Informazioni sull'account con riferimento ai personaggi
 */
class Account{
    const COINS_LVL_UP = 40;
    const MAX_NUM_PERSONAGGI = 5;
    private $id;
    private $username;
    private $monete;
    private $personaggi = [];
    private $shopRefresh;
    private $immagineProfilo;

    /**
     * Costruttore della classe Account. Dato un `$id` recupera le informazioni dell'account dal database.
     * Può anche recuperare informazioni riguardo ai personaggi dell'account
     * @param int $id id dell'account
     * @param boolean $getAlsoPG `true` recupera anche le informazioni sui personaggi, `false` no. [Default: `false`]
     * @throws Exception se ci sono degli errori nel recupero o nella creazione del personaggio.
     */
    public function __construct($id, $getAlsoPG = false){
        $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);

        $stmt = null;
        $stmtPersonaggi = null;
        try{
            if ($conn->connect_error){
                throw new Exception("Server non Disponibile", 500);
            }
            $sql = "SELECT ID, Username, Monete, RefreshNegozio, ImmagineProfilo
                FROM Account
                WHERE ID = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('i', $id);
            $stmt->execute();
            $result = $stmt->get_result();

            if($result->num_rows > 0){
                $userRow = $result->fetch_assoc();
                $dateTime = new DateTime($userRow['RefreshNegozio']);

                $this->fromArray($userRow['ID'], $userRow['Username'], $userRow['Monete'], $dateTime, $userRow['ImmagineProfilo']);

                if($getAlsoPG){
                    $sqlPersonaggi = "SELECT Nome, Proprietario, Elemento
                                    FROM Personaggi
                                    WHERE Proprietario = ?";
                    $stmtPersonaggi = $conn->prepare($sqlPersonaggi);
                    $stmtPersonaggi->bind_param('i', $this->id);
                    $stmtPersonaggi->execute();
                    $resultPersonaggi = $stmtPersonaggi->get_result();

                    while($personaggioRow = $resultPersonaggi->fetch_assoc()){
                        $personaggio = new Personaggio(
                            $personaggioRow['Nome'],
                            $personaggioRow['Proprietario'],
                            $personaggioRow['Elemento']
                        );
                        $this->addPersonaggio($personaggio);
                    }
                }
            }
            else{
                throw new Exception("L'account con l'ID fornito non esiste", 400);
            }
        }
        finally{
            if ($stmt) $stmt->close();
            if ($stmtPersonaggi) $stmtPersonaggi->close();
            $conn->close();
        }
    }

    /**
     * Funzione che crea un Account da un array, senza possibilità di inserire personaggi
     * @param int $id id dell'account
     * @param string $username username dell'account
     * @param int $monete quantità di monete dell'account
     * @param DateTime $shopRefresh data dello shopRefresh dell'account
     * @param string $immagineProfilo percorso dell'immagine profilo dell'account
     * @return void
     */
    public function fromArray($id, $username, $monete, $shopRefresh, $immagineProfilo){
        $this->id = $id;
        $this->username = $username;
        $this->monete = $monete;
        $this->shopRefresh = $shopRefresh;
        $this->immagineProfilo = $immagineProfilo;
    }

    /**
     * Recupero l'id dell'account
     * @return int id dell'account
     */
    public function getId(): int{
        return $this->id;
    }
    /**
     * Recupero l'username dell'account
     * @return string username dell'account
     */
    public function getUsername(): string{
        return $this->username;
    }
    /**
     * Recupero la quantità di monete dell'account
     * @return int quantità di monete dell'account
     */
    public function getMonete(): int{
        return $this->monete;
    }
    /**
     * Recupero quando il negozio è stato aggiornato l'ultima volta da parte dell'account
     * @return DateTime orario formattato dell'ultimo aggiornamento negozio
     */
    public function getShopRefresh(): DateTime{
        return $this->shopRefresh;
    }
    /**
     * Restituisce uno o tutti i personaggi in base al `$nome` fornito
     * @param string $name Nome del personaggio. Se non fornito restituisce tutti i personaggi (default: `null`)
     * @return Personaggio|Personaggio[]|null I tre casi avvengono:
     *          - `Personaggio[]` se `$name === null`
     *          - `Personaggio` se il perosnaggio con nome `$name` è presente
     *          - `null` se non è presente alcun personaggio con il `$name` fornito
     */
    public function getPersonaggi($name = null){
        if($name === null)
            return $this->personaggi;

        foreach ($this->personaggi as $pg){
            if($pg->getNome() === $name){
                return $pg;
            }
        }

        return null;
    }
    /**
     * Restituisce il percorso dell'immagine profilo dell'account.
     * @return string Percorso dell'immagine profilo
     */
    public function getImmagineProfilo(): string{
        return $this->immagineProfilo;
    }

    /**
     * Restituisce tutte le informazioni dell'account sotto forma di array associativo.
     * @return array{id: int, username: string, monete:int, personaggi: array, shopRefresh: DateTime, immagineProfilo: string} Array associativo con i dati dell'account
     */
    public function getAll(){
        return [
            'id'              => $this->id,
            'username'        => $this->username,
            'monete'          => $this->monete,
            'personaggi'      => $this->personaggi,
            'shopRefresh'     => $this->shopRefresh,
            'immagineProfilo' => $this->immagineProfilo
        ];
    }

    /**
     * Modifica la quantità di monete del personaggio
     * @param bool $spending se true indica che si sta spendendo, altrimenti che si sta guadagnando
     * @param int $amount indica il quantitativo di monete
     * @return bool Se true la funzione ha avuto effetto correttamente; false indica che `$amount` inteso come spesa è maggiore delle monete attualmente presenti nell'account
     */
    public function modifyCoins($spending, $amount){
        if($amount < 0)
            $amount = -$amount;
        if($spending){
            if($this->monete < $amount)
                return false;
            $this->monete -= $amount;
        }
        else{
            $this->monete += $amount;
        }
        return true;
    }

    /**
     * Aggiorna shopRefresh
     * @param DateTime $newTime nuovo Datetime, successivo al Datetime attuale
     * @return bool esito dell'aggiornamento
     */
    public function updateShopTimer($newTime){
        if($this->shopRefresh <= $newTime){
            $this->shopRefresh = $newTime;
            return true;
        }
        return false;
    }

    /**
     * Aggiorna l'username
     * @param string $newUsername nuovo username, diverso da quello attuale
     * @return bool esito dell'operazione
     */
    public function updateUsername($newUsername){
        if($this->username !== $newUsername){
            $this->username = $newUsername;
            return true;
        }

        return false;
    }

    /**
     * Aggiorna l'immagine Profilo
     * @param string $newPic path della nnuova immagine, diversa da quella attuale
     * @return bool esito dell'operazione
     */
    public function updateImmagineProfilo($newPic){
        if($this->immagineProfilo !== $newPic){
            $this->immagineProfilo = $newPic;
            return true;
        }
        return false;
    }

    /**
     * Aggiunge un personaggio all'account, accettando sia un oggetto Personaggio che i dati per crearne uno nuovo.
     * @param Personaggio|string $personaggio Nome del personaggio o oggetto Personaggio
     * @param string|null $elemento Elemento del personaggio (necessario solo se si passa il nome)
     * @return bool True se aggiunto, false se raggiunto il massimo
     */
    public function addPersonaggio($personaggio, $elemento = null){
        if(count($this->personaggi) >= self::MAX_NUM_PERSONAGGI)
            return false;

        if($personaggio instanceof Personaggio){
            $this->personaggi[] = $personaggio;
        } else {
            $this->personaggi[] = new Personaggio($personaggio, $this->id, $elemento);
        }
        usort($this->personaggi, function($a, $b){
            return $a->getNome() <=> $b->getNome();
        });
        return true;
    }

    /**
     * Aggiorna le statistiche di un `Personaggio` dell'account
     * @param string $nomePersonaggio nome del personaggio
     * @param int $newPF nuovo valore per la statistica `PF` del `Personaggio`
     * @param int $newFOR nuovo valore per la statistica `FOR` del `Personaggio`
     * @param int $newDES nuovo valore per la statistica `DES` del `Personaggio`
     * @return boolean `true` se l'aggiornamento è avvenuto correttamente, `false` altrimenti
     */
    public function upgradePgStats($nomePersonaggio, $newPF, $newFOR, $newDES){
        foreach($this->personaggi as $personaggio){
            if($personaggio->getNome() === $nomePersonaggio){
                $personaggio->upgradeStats($newPF, $newFOR, $newDES);
                return true;
            }
        }
        return false;
    }

    /**
     * Funzione che aggiorna i punti esperienza di un personaggio e ne gestisce il LVLUP
     * @param string $nomePersonaggio nome del personaggio
     * @param boolean $hasWon indica se il personaggio sta guadagnando esperienza da una vittoria o una sconfitta
     * @return int|null se l'aggiornamento ha avuto successo restituisce il numero di livelli guadagnati dal personaggio. Se il personaggio non esiste restituisce `null`
     */
    public function addPGExp($nomePersonaggio, $hasWon){
        $nLvlUp = null;
        foreach($this->personaggi as $pg){
            if($pg->getNome() === $nomePersonaggio){
                $nLvlUp = $pg->addExp($hasWon);
                if($nLvlUp > 0)
                    $this->modifyCoins(false, self::COINS_LVL_UP * $nLvlUp);
            }
        }
        return $nLvlUp;
    }
    /**
     * Aggiunge un item all'equipaggiamento di un `Personaggio` dell'account
     * @param string $nomePersonaggio nome del personaggio
     * @param int $itemId id dell'`Item` da aggiungere al personaggio
     * @return boolean `true` se l'aggiornamento è avvenuto correttamente, `false` altrimenti
     */
    public function equipItem($nomePersonaggio, $itemId){
        foreach($this->personaggi as $personaggio){
            if($personaggio->getNome() === $nomePersonaggio){
                $personaggio->equipItem($itemId);
                return true;
            }
        }
        return false;
    }

    /**
     * Rimuove un oggetto dall'inventario del personaggio specificato.
     * @param string $nomePersonaggio nome del personaggio sul quale effettuare l'azione
     * @param int $itemId id dell'oggetto da rimuovere
     * @param bool $moveToInventario indica se spostarlo nell'inventario o meno
     * @return boolean `true` se l'aggiornamento è avvenuto correttamente, `false` altrimenti
     */
    public function unequipPGItem($nomePersonaggio, $itemId, $moveToInventario = true){
        foreach($this->personaggi as $personaggio){
            if($personaggio->getNome() === $nomePersonaggio){
                $personaggio->unequipItem($itemId, $moveToInventario);
                return true;
            }
        }
        return false;
    }

    /**
     * Dato il nome di un personaggio dell'account e un personaggio di riferimento, rimuove dal personaggio dell'account tutti gli oggetti non presenti nell'altro, **senza inviarli all'inventario**.
     * @param string $nomePersonaggio nome del personaggio
     * @param Personaggio $pgRef personaggio di riferimento
     * @return bool `false` se il personaggio non appartiene a questo account o non sono stati rimossi oggetti, `true` se completa correttamente
     */
    public function unequipPGItem_onlyUsed($nomePersonaggio, $pgRef){
        $personaggio = null;
        foreach($this->personaggi as $pg){
            if($pg->getNome() === $nomePersonaggio){
                $personaggio = $pg;
                break;
            }
        }

        if($personaggio === null)
            return false;

        $removed = false;
    	$idOggettiPersonaggio = $personaggio->getOggettiIDs();
    	$idOggettiPgRef = $pgRef->getOggettiIDs();

	    $countPersonaggio = array_count_values($idOggettiPersonaggio);
	    $countPgRef = array_count_values($idOggettiPgRef);

        foreach($countPersonaggio as $id => $num){
            $numPgRef = isset($countPgRef[$id]) ? $countPgRef[$id] : 0;
            $diff = $num - $numPgRef;
            if($diff > 0){
                for($i = 0; $i < $diff; $i++){
                    $removed = true;
                    $this->unequipPGItem($nomePersonaggio, $id, false);
                }
            }
        }

        return $removed;
    }
    /**
     * Rimuove un Personaggio alla lista dei personaggi dell'account a partire dal nome
     * @param string $nomePersonaggio il nome del personaggio da rimuovere
     * @return bool Se true indica che l'eliminazione è accaduta correttamente; false se il personaggio non esiste tra quelli del giocatore
     */
    public function removePersonaggio($nomePersonaggio){
        foreach($this->personaggi as $key => $personaggio){
            if($personaggio->getNome() === $nomePersonaggio){
                if($personaggio->deleteFromDB()){
                    unset($this->personaggi[$key]);
                    return true;
                }
                return false;
            }
        }
        return false;
    }
};

/**
 * Caratteristiche e funzioni di un singolo personaggio
 * Per funzionare correttamente tutti i metodi **DEVONO ESSERE UTILIZZATI** in blocchy `try{}catch{}`
 */
class Personaggio{
    const MIN_FOR_DES = -10;
    const MAX_FOR_DES = 10;
    const MIN_HEALTH = 0;
    const MAX_EXP = 100;
    const EXP_WIN = 15;
    const EXP_LOSS = 5;
    const PU_LVL_UP = 3;
    const DAMAGE_LOOKUP = [
        -10 => 0, -9 => 0,
        -8 => 1, -7 => 1,
        -6 => 2, -5 => 2,
        -4 => 3, -3 => 3,
        -2 => 4, -1 => 4,
        +0 => 5, +1 => 5,
        +2 => 6, +3 => 6,
        +4 => 7, +5 => 7,
        +6 => 8, +7 => 8,
        +8 => 9, +9 => 9,
        +10 => 10
    ];

    const DODGE_LOOKUP = [
        -10 => 0, -9 => 0,
        -8 => 10, -7 => 10,
        -6 => 15, -5 => 15,
        -4 => 20, -3 => 20,
        -2 => 25, -1 => 25,
        +0 => 30, +1 => 30,
        +2 => 35, +3 => 35,
        +4 => 40, +5 => 40,
        +6 => 45, +7 => 45,
        +8 => 50, +9 => 50,
        +10 => 60
    ];

    const DEFAULT_PF = 50;
    const DEFAULT_FOR_DES = 0;
    const ZAINO_SIZE = 3;       // 3 + arma + armatura

    const DEFAULT_TURN_TIME = 30;
    private $pathImmagine;
    private $pathImmaginePG;
    private $nome;
    private $proprietario;
    private $FOR;
    private $currentFOR;
    private $damage;
    private $DES;
    private $currentDES;
    private $dodgingChance;
    private $PF;
    private $tmp_PF;
    private $elemento;
    private $prevaleSu;
    private $prevalsoDa;
    /// Informazioni complete sull'arma equipaggiata
    private $arma;
    /// Informazioni complete sull'armatura equipaggiata
    private $armatura;
    private $protezioneDanno;
    private $zaino = [];
    private $livello;
    private $exp;
    private $puntiUpgrade;

    /**
     * Costruttore della classe Personaggio.
     * Se il personaggio esiste già nel database, ne recupera i dati.
     * Altrimenti, crea un nuovo personaggio con i valori di default e lo salva nel database.
     *
     * @param string $nome Nome del personaggio.
     * @param int $proprietarioId ID del proprietario del personaggio.
     * @param string $elemento Elemento associato al personaggio. Viene preso in considerazione solo se il personaggio deve essere effettivamente creato, altrimenti è ignorato
     * @throws Exception Se il proprietario non esiste o se si verifica un errore durante l'inserimento o il recupero dei dati.
     */
    public function __construct($nome, $proprietarioId, $elemento = null){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);

        $proprietarioStmt = null;
        $personaggioStmt = null;
        $zainoStmt = null;

        try {
            if ($connectionDB->connect_error){
                throw new Exception("Server non Disponibile", 500);
            }
            $connectionDB->begin_transaction();

            // Verifico se il proprietario esiste
            $proprietarioCheckQuery = "SELECT * FROM Account WHERE ID = ?";
            $proprietarioStmt = $connectionDB->prepare($proprietarioCheckQuery);
            if (!is_numeric($proprietarioId)){
                $connectionDB->rollback();
                throw new Exception("Proprietario non esistente", 400);
            }

            $proprietarioStmt->bind_param('i', $proprietarioId);
            $proprietarioStmt->execute();
            $result = $proprietarioStmt->get_result();

            if ($result->num_rows === 0){
                $connectionDB->rollback();
                throw new Exception("Proprietario non esistente", 400);
            }

            // Verifico se il PG esiste già
            $personaggioCheckQuery = "SELECT P.*, E.PathImmagine, E.PathImmaginePG, E.PrevaleSu, E.PrevalsoDa
                                      FROM Personaggi P
                                        JOIN Element E ON P.Elemento = E.Nome
                                      WHERE P.Nome = ? AND P.Proprietario = ?";
            $personaggioStmt = $connectionDB->prepare($personaggioCheckQuery);
            $personaggioStmt->bind_param('si', $nome, $proprietarioId);
            $personaggioStmt->execute();
            $personaggioResult = $personaggioStmt->get_result();

            if ($personaggioResult->num_rows > 0){
                // Il PG esiste
                $personaggioData = $personaggioResult->fetch_assoc();

                $this->pathImmagine    = (string)$personaggioData['PathImmagine'];
                $this->pathImmaginePG  = (string)$personaggioData['PathImmaginePG'];
                $this->nome            = (string)$personaggioData['Nome'];
                $this->proprietario    = (int)$personaggioData['Proprietario'];
                $this->FOR             = (int)$personaggioData['Forza'];
                $this->DES             = (int)$personaggioData['Destrezza'];
                $this->PF              = (int)$personaggioData['PuntiVita'];
                $this->elemento        = (string)$personaggioData['Elemento'];
                $this->prevaleSu       = (string)$personaggioData['PrevaleSu'];
                $this->prevalsoDa      = (string)$personaggioData['PrevalsoDa'];
                $this->arma            = null;
                $this->armatura        = null;
                $this->livello         = (int)$personaggioData['Livello'];
                $this->exp             = (int)$personaggioData['PuntiExp'];
                $this->puntiUpgrade    = (int)$personaggioData['PuntiUpgrade'];
                $this->tmp_PF          = $this->PF;
                $this->currentFOR      = $this->FOR;
                $this->currentDES      = $this->DES;
                $this->damage          = self::DAMAGE_LOOKUP[$this->currentFOR];
                $this->dodgingChance   = self::DODGE_LOOKUP[$this->currentDES];
                $this->protezioneDanno = 0;

                // Prelevo le informazioni sull'arma
                if($personaggioData['Arma'] !== null){
                    $this->setArma($connectionDB, $personaggioData['Arma'], false);
                }
                // Prelevo le informazioni sull'armatura
                if($personaggioData['Armatura'] !== null){
                    $this->setArmatura($connectionDB, $personaggioData['Armatura'], false);
                }

                // Prelevo lo zaino
                $sqlZaino = "SELECT Z.Quantita, I.*
                             FROM Zaino Z
                                JOIN Item I ON Z.Oggetto = I.ID
                             WHERE Z.Personaggio = ? AND Z.Proprietario = ?";
                $zainoStmt = $connectionDB->prepare($sqlZaino);
                $zainoStmt->bind_param("si", $this->nome, $this->proprietario);

                $zainoStmt->execute();
                $zainoResult = $zainoStmt->get_result();

                while($item = $zainoResult->fetch_assoc()){
                    for($i = 0; $i < $item["Quantita"]; ++$i){
                        $tmp = $item;
                        unset($tmp["Quantita"]);
                        unset($tmp['Danno']);
                        unset($tmp['ProtezioneDanno']);
                        $this->zaino[] = $tmp;
                    }
                }
            }
            else {
                // Creo un nuovo PG
                $elementInfo = getElementInfo($elemento, $connectionDB);

                if(!$elementInfo){
                    $connectionDB->rollback();
                    throw new Exception("Elemento non valido: ". $elementInfo, 400);
                }

                $this->pathImmagine    = (string)$elementInfo['PathImmagine'];
                $this->pathImmaginePG  = (string)$elementInfo['PathImmaginePG'];
                $this->nome            = (string)$nome;
                $this->proprietario    = (int)$proprietarioId;
                $this->FOR             = (int)(self::DEFAULT_FOR_DES + $elementInfo["ModificatoreFor"]);
                $this->DES             = (int)(self::DEFAULT_FOR_DES + $elementInfo["ModificatoreDes"]);
                $this->PF              = (int)(self::DEFAULT_PF + $elementInfo["ModificatorePF"]);
                $this->elemento        = (string)$elementInfo['Nome'];
                $this->prevaleSu       = (string)$elementInfo['PrevaleSu'];
                $this->prevalsoDa      = (string)$elementInfo['PrevalsoDa'];
                $this->armatura        = null;
                $this->arma            = null;
                $this->livello         = 1;
                $this->exp             = 0;
                $this->puntiUpgrade    = self::PU_LVL_UP;
                $this->tmp_PF          = $this->PF;
                $this->currentFOR      = $this->FOR;
                $this->currentDES      = $this->DES;
                $this->damage          = self::DAMAGE_LOOKUP[$this->currentFOR];
                $this->dodgingChance   = self::DODGE_LOOKUP[$this->currentDES];
                $this->protezioneDanno = 0;

                $insertQuery = "INSERT INTO Personaggi (Nome, Proprietario, Forza, Destrezza, PuntiVita, Elemento, Armatura, Arma, Livello, PuntiExp, PuntiUpgrade)
                                VALUES (?, ?, ?, ?, ?, ?, NULL, NULL, 1, 0, ?)";
                $insertStmt = $connectionDB->prepare($insertQuery);
                $insertStmt->bind_param('siiiisi',
                     $this->nome,
                    $this->proprietario,
                           $this->FOR,
                           $this->DES,
                           $this->PF,
                           $this->elemento,
                           $this->puntiUpgrade);

                if (!$insertStmt->execute()){
                    $connectionDB->rollback();
                    throw new Exception("Errore durante l'inserimento del personaggio: " . $insertStmt->error, 500);
                }
                $insertStmt->close();
            }

            $connectionDB->commit();
        }
        finally {
            if ($proprietarioStmt)         $proprietarioStmt->close();
            if ($personaggioStmt)   $personaggioStmt->close();
            if ($zainoStmt)         $zainoStmt->close();
            $connectionDB->close();
        }
    }

    /**
     * Funzione che crea un personaggio a partire dai dati dell'array
     * @param array $data array contenente tutti i dati;
     * @return Personaggio
     */
    public static function fromArray($data){
        $pg = new Personaggio($data['nome'], $data['proprietario'], $data['elemento']);
        $pg->FOR = $data['FOR'];
        $pg->currentFOR = $data['currentFOR'];
        $pg->damage = $data['damage'];
        $pg->DES = $data['DES'];
        $pg->currentDES = $data['currentDES'];
        $pg->dodgingChance = $data['dodgingChance'];
        $pg->PF = $data['PF'];
        $pg->tmp_PF = $data['temp_PF'];
        $pg->elemento = $data['elemento'];
        $pg->prevaleSu = $data['prevaleSu'];
        $pg->prevalsoDa = $data['prevalsoDa'];
        $pg->armatura = $data['armatura'];
        $pg->arma = $data['arma'];
        $pg->zaino = $data['zaino'];
        $pg->livello = $data['livello'];
        $pg->exp = $data['exp'];
        $pg->puntiUpgrade = $data['puntiUpgrade'];
        $pg->pathImmagine = $data['pathImmagine'];
        $pg->pathImmaginePG = $data['pathImmaginePG'];
        $pg->protezioneDanno = $data['protezioneDanno'];
        return $pg;
    }
    /**
     * Funzione per aggiornare le statistiche del personaggio
     * @return void
     */
    private function setEquipmentStats(){
        $this->damage          = self::DAMAGE_LOOKUP[$this->currentFOR];
        $this->dodgingChance   = self::DODGE_LOOKUP[$this->currentDES];
        $this->protezioneDanno = 0;

        if($this->arma){
            $this->damage += $this->arma['Danno'];
        }

        if($this->armatura){
            $this->protezioneDanno += $this->armatura['ProtezioneDanno'];
        }
    }
    /**
     * Funzione privata che si occupa di equipaggiare un'arma e, eventualmente, aggiornare il database
     * @param mysqli $connectionDB connessione al database passare per riferimento
     * @param int|null $armaId id dell'arma da equipaggiare o `null` se si vuole rimuovere
     * @param boolean $updateDB Indica se aggiornare o meno il database con aggiornamento del campo. (Default `true`)
     * @return void
     */
    private function setArma(&$connectionDB, $armaId, $updateDB = true){
        if(($armaId === null && $this->arma === null) ||
            ($this->arma !== null && $armaId === $this->arma['ID']))
            return;

        $armaStmt = null;
        $updateStmt = null;
        try{
            if($updateDB){
                if ($armaId === null){
                    $sqlUpdate = "UPDATE Personaggi SET Arma = NULL WHERE Nome = ? AND Proprietario = ?";
                    $updateStmt = $connectionDB->prepare($sqlUpdate);
                    $updateStmt->bind_param("si", $this->nome, $this->proprietario);
                }
                else {
                    $sqlUpdate = "UPDATE Personaggi SET Arma = ? WHERE Nome = ? AND Proprietario = ?";
                    $updateStmt = $connectionDB->prepare($sqlUpdate);
                    $updateStmt->bind_param("isi", $armaId, $this->nome, $this->proprietario);
                }
                if(!$updateStmt->execute()){
                    throw new Exception("Errore durante l'equipaggiamento dell'arma", $updateStmt->errno);
                }
            }

            if ($this->arma){
                addToInventario($connectionDB, $this->proprietario, $this->arma['ID']);
                $this->currentFOR -= $this->arma['ModificatoreFor'];
                $this->currentDES -= $this->arma['ModificatoreDes'];
                $this->arma = null;
                $this->setEquipmentStats();
            }
            if($armaId){
                $sqlArma = "SELECT ID, Nome, Descrizione, Elemento, PathImmagine, Danno, ModificatoreFor, ModificatoreDes
                            FROM Item
                            WHERE ID = ?";

                $armaStmt = $connectionDB->prepare($sqlArma);
                $armaStmt->bind_param("i", $armaId);
                $armaStmt->execute();
                $armaResult = $armaStmt->get_result();

                $this->arma = $armaResult->fetch_assoc();

                if($this->arma['Elemento'] === $this->elemento)
                    $this->arma['Danno'] += 1;

                $preFOR = $this->currentFOR;
                $preDES = $this->currentDES;
                $this->currentFOR = max(self::MIN_FOR_DES, min(self::MAX_FOR_DES, $this->currentFOR + $this->arma['ModificatoreFor']));
                $this->currentDES = max(self::MIN_FOR_DES, min(self::MAX_FOR_DES, $this->currentDES + $this->arma['ModificatoreDes']));

                $this->setEquipmentStats();

                $this->arma['ModificatoreFor'] = $this->currentFOR - $preFOR;
                $this->arma['ModificatoreDes'] = $this->currentDES - $preDES;

            }
        }
        finally{
            if($armaStmt) $armaStmt->close();
            if($updateStmt) $updateStmt->close();
        }
    }
    /**
     * Funzione privata che si occupa di equipaggiare un'armatura e, eventualmente, aggiornare il database
     * @param mysqli $connectionDB connessione al database passare per riferimento
     * @param int|null $armaturaId id dell'armatura da equipaggiare o `null` se si vuole rimuovere
     * @param boolean $updateDB Indica se aggiornare o meno il database con aggiornamento del campo. (Default `true`)
     * @return void
     */
    private function setArmatura(&$connectionDB, $armaturaId, $updateDB = true){
        if(($armaturaId === null && $this->armatura === null) ||
            ($this->armatura !== null && $armaturaId === $this->armatura['ID']))
            return;

        $armaturaStmt = null;
        $updateStmt = null;
        try{
            if($updateDB){
                if ($armaturaId === null){
                    $sqlUpdate = "UPDATE Personaggi SET Armatura = NULL WHERE Nome = ? AND Proprietario = ?";
                    $updateStmt = $connectionDB->prepare($sqlUpdate);
                    $updateStmt->bind_param("si", $this->nome, $this->proprietario);
                } else {
                    $sqlUpdate = "UPDATE Personaggi SET Armatura = ? WHERE Nome = ? AND Proprietario = ?";
                    $updateStmt = $connectionDB->prepare($sqlUpdate);
                    $updateStmt->bind_param("isi", $armaturaId, $this->nome, $this->proprietario);
                }
                if(!$updateStmt->execute()){
                    throw new Exception("Errore durante l'equipaggiamento dell'arma", $updateStmt->errno);
                }
            }

            if ($this->armatura){
                addToInventario($connectionDB, $this->proprietario, $this->armatura['ID']);
                $this->currentFOR -= $this->armatura['ModificatoreFor'];
                $this->currentDES -= $this->armatura['ModificatoreDes'];
                $this->armatura = null;

                $this->setEquipmentStats();
            }
            if($armaturaId){
                $sqlArmatura = "SELECT ID, Nome, Descrizione, Elemento, PathImmagine, ProtezioneDanno, ModificatoreFor, ModificatoreDes
                                FROM Item
                                WHERE ID = ?";
                $armaturaStmt = $connectionDB->prepare($sqlArmatura);
                $armaturaStmt->bind_param("i", $armaturaId);
                $armaturaStmt->execute();
                $armaturaResult = $armaturaStmt->get_result();
                $this->armatura = $armaturaResult->fetch_assoc();

                if($this->armatura['Elemento'] === $this->elemento)
                    $this->armatura['ProtezioneDanno'] += 1;
                $preFOR = $this->currentFOR;
                $preDES = $this->currentDES;
                $this->currentFOR = max(self::MIN_FOR_DES, min(self::MAX_FOR_DES, $this->currentFOR + $this->armatura['ModificatoreFor']));
                $this->currentDES = max(self::MIN_FOR_DES, min(self::MAX_FOR_DES, $this->currentDES + $this->armatura['ModificatoreDes']));

                $this->setEquipmentStats();

                $this->armatura['ModificatoreFor'] = $this->currentFOR - $preFOR;
                $this->armatura['ModificatoreDes'] = $this->currentDES - $preDES;
            }
        }
        finally{
            if($armaturaStmt) $armaturaStmt->close();
            if($updateStmt) $updateStmt->close();
        }
    }

    /**
     * Funzione privata che si occupa di aggiungere un `Item` allo zaino se presente nell'Inventario di `$this->proprietario`, eventualmente aggiornando il database
     * @param mysqli $connectionDB connessione al database passata per riferimento
     * @param int $itemId id dell'`Item` da equipaggiare
     * @param boolean $updateDB Indica se aggiornare o meno il database con aggiornamento del campo. (Default `true`)
     * @return void
     */
    private function addToZaino(&$connectionDB, $itemId, $updateDB = true){
        $itemStmt = null;
        $zainoStmt = null;
        try{
            if(count($this->zaino) === self::ZAINO_SIZE){
                throw new Exception("Zaino già pieno, non puoi aggiungere altri oggetti", 400);
            }

            if($updateDB){

                $sqlZaino = "INSERT INTO Zaino (Personaggio, Proprietario, Oggetto, Quantita)
                             VALUES (?, ?, ?, 1)
                             ON DUPLICATE KEY UPDATE Quantita = Quantita + 1;";

                $zainoStmt = $connectionDB->prepare($sqlZaino);

                $zainoStmt->bind_param('sii', $this->nome, $this->proprietario, $itemId);
                if(!$zainoStmt->execute()){
                    throw new Exception("Problemi durante l'aggiornamento dello zaino di ". $this->nome ." dell'oggetto " . $itemId, 400);
                }
            }

            $sqlItem = "SELECT *
                        FROM Item
                        WHERE ID = ?";
            $itemStmt = $connectionDB->prepare($sqlItem);
            $itemStmt->bind_param('i', $itemId);
            $itemStmt->execute();
            $result = $itemStmt->get_result();

            $this->zaino[] = $result->fetch_assoc();
            unset($this->zaino['Danno']);
            unset($this->zaino['Elemento']);
            unset($this->zaino['ProtezioneDanno']);

            usort($this->zaino, function($a, $b){
                return $a['ID'] <=> $b['ID'];
            });
        }
        finally{
            if($itemStmt) $itemStmt->close();
            if($zainoStmt) $zainoStmt->close();
        }
    }

    /**
     * Funzione privata che si occupa di rimuovere un `Item` allo zaino se presente, eventualmente aggiornando il database
     * @param mysqli $connectionDB connessione al database passata per riferimento
     * @param int $itemId id dell'`Item` da rimuovere
     * @param boolean $updateDB Indica se aggiornare o meno il database con aggiornamento del campo. [Default `true`]
     * @param boolean $inserisciInInventario Indica se inserire o meno l'oggetto rimosso nell'inventario del proprietario. [Default `true`]
     * @return void
     */
    private function removeFromZaino(&$connectionDB, $itemId, $updateDB = true, $inserisciInInventario = true){
        $itemStmt = null;
        $zainoStmt = null;
        try{
            if(count($this->zaino) === 0){
                throw new Exception("Zaino vuoto, non puoi rimuovere alcun oggetto!", 400);
            }

            $found = [];
            for($index = 0; $index < count($this->zaino); $index++){
                if($this->zaino[$index] && $this->zaino[$index]['ID'] === $itemId){
                    $found[] = $index;
                    break;
                }
            }

            $nOccorrenze = count($found);
            if($nOccorrenze === 0){
                throw new Exception("Non possiedi questo oggetto!", 400);
            }

            if($updateDB){
                $sqlZaino = ($nOccorrenze > 1)?
                "UPDATE Zaino SET Quantita = Quantita - 1 WHERE Personaggio = ? AND Proprietario = ? AND Oggetto = ?":
                "DELETE FROM Zaino WHERE Personaggio = ? AND Proprietario = ? AND Oggetto = ?";

                $zainoStmt = $connectionDB->prepare($sqlZaino);

                $zainoStmt->bind_param('sii', $this->nome, $this->proprietario, $itemId);
                if(!$zainoStmt->execute()){
                    throw new Exception("Problemi durante la rimozione dallo zaino di ". $this->nome ." dell'oggetto " . $itemId, 400);
                }
            }

            if($inserisciInInventario)
                addToInventario($connectionDB, $this->proprietario, $itemId);

            unset($this->zaino[$found[0]]);
            $this->zaino = array_values($this->zaino);
        }
        finally{
            if($itemStmt) $itemStmt->close();
            if($zainoStmt) $zainoStmt->close();
        }

    }

    /**
     * Funzione che controla se il personaggio ha delle battaglie in corso
     * @param mysqli $connectionDB connessione al database passata per riferimento
     * @return bool `true` se ci sono, `false` altrimenti
     */
    private function hasOpenedBattles(&$connectionDB){
        $sqlBattaglie = "SELECT COUNT(*) AS Numero
                             FROM Combattimenti
                             WHERE Giocatore1_Nome = ? AND Giocatore1_Proprietario = ? AND Terminata = 0;";
        $battleStmt = $connectionDB->prepare($sqlBattaglie);
        $battleStmt->bind_param('si', $this->nome, $this->proprietario);
        $battleStmt->execute();
        $result = $battleStmt->get_result();
        $row = $result->fetch_assoc();
        $battleStmt->close();
        return $row['Numero'] > 0;
    }

    /**
     * Restituisce il nome del personaggio.
     * @return string Nome del personaggio
     */
    public function getNome(): string{
        return $this->nome;
    }
    /**
     * Restituisce l'ID del proprietario del personaggio.
     * @return int ID del proprietario
     */
    public function getProprietario(): int{
        return $this->proprietario;
    }
    /**
     * Restituisce il livello attuale del personaggio.
     * @return int Livello del personaggio
     */
    public function getLivello(): int{
        return $this->livello;
    }
    /**
     * Restituisce l'elemento associato al personaggio.
     * @return string Elemento del personaggio
     */
    public function getElemento(): string{
        return $this->elemento;
    }
    /**
     * Restituisce i punti ferita massimi e temporanei del personaggio.
     * @return array{PF: int, tmp_PF: int}
     */
    public function getAllPF(){
        return [
            "PF"        => $this->PF,
            "tmp_PF"   => $this->tmp_PF
        ];
    }
    /**
     * Restituisce gli ID di tutti gli oggetti presenti nello zaino del personaggio.
     * @return int[] Array di ID degli oggetti
     */
    public function getOggettiIDs(){
        $output = [];
        foreach($this->zaino as $item){
            $output[] = $item['ID'];
        }

        return $output;

    }
    /**
     * Restituisce nome e descrizione di un oggetto nello zaino dato il suo ID.
     * @param int $itemId ID dell'oggetto
     * @return array{Descrizione: string, Nome: string}|null Array con nome e descrizione o null se non trovato
     */
    public function getItemInfo($itemId){
        foreach($this->zaino as $item){
            if($item['ID'] === $itemId){
                return [
                    'Nome'          => $item['Nome'],
                    'Descrizione'   => $item['Descrizione']
                ];
            }
        }

        return null;
    }
    /**
     * Restituisce tutte le informazioni del personaggio sotto forma di array associativo.
     *
     * @return array{
     *     nome: string,                // Nome del personaggio
     *     proprietario: int,           // ID del proprietario
     *     FOR: int,                    // Valore di Forza
     *     currentFOR: int,             // Valore attuale di Forza
     *     damage: int,                 // Danno inflitto
     *     DES: int,                    // Valore di Destrezza
     *     currentDES: int,             // Valore attuale di Destrezza
     *     dodgingChance: float,        // Probabilità di schivata
     *     PF: int,                     // Punti Ferita
     *     temp_PF: int,                // Punti Ferita temporanei
     *     elemento: string,            // Elemento associato
     *     prevaleSu: string,           // Elemento su cui prevale
     *     prevalsoDa: string,          // Elemento da cui è prevalso
     *     armatura: array|null,        // Informazioni sull'armatura
     *     arma: array|null,            // Informazioni sull'arma
     *     zaino: array,                // Contenuto dello zaino
     *     livello: int,                // Livello del personaggio
     *     exp: int,                    // Esperienza accumulata
     *     puntiUpgrade: int,           // Punti disponibili per upgrade
     *     pathImmagine: string,        // Percorso dell'immagine
     *     pathImmaginePG: string,      // Percorso dell'immagine del personaggio
     *     protezioneDanno: int         // Valore di protezione dal danno
     * }
     */
    public function getAll(){
        return [
            'nome'            => $this->nome,
            'proprietario'    => $this->proprietario,
            'FOR'             => $this->FOR,
            'currentFOR'      => $this->currentFOR,
            'damage'          => $this->damage,
            'DES'             => $this->DES,
            'currentDES'      => $this->currentDES,
            'dodgingChance'   => $this->dodgingChance,
            'PF'              => $this->PF,
            'temp_PF'         => $this->tmp_PF,
            'elemento'        => $this->elemento,
            'prevaleSu'       => $this->prevaleSu,
            'prevalsoDa'      => $this->prevalsoDa,
            'armatura'        => $this->armatura,
            'arma'            => $this->arma,
            'zaino'           => $this->zaino,
            'livello'         => $this->livello,
            'exp'             => $this->exp,
            'puntiUpgrade'    => $this->puntiUpgrade,
            'pathImmagine'    => $this->pathImmagine,
            'pathImmaginePG'  => $this->pathImmaginePG,
            'protezioneDanno' => $this->protezioneDanno
        ];
    }
    /**
     * Restituisce le statistiche e l'equipaggiamento attuale del personaggio.
     * @return array{
     *     DAMAGE_LOOKUP: array,         // Tabella di lookup per il danno in base alla FOR
     *     DODGE_LOOKUP: array,          // Tabella di lookup per la schivata in base alla DES
     *     MIN_FOR_DES: int,             // Valore minimo per FOR e DES
     *     MAX_FOR_DES: int,             // Valore massimo per FOR e DES
     *     ZAINO_SIZE: int,              // Dimensione massima dello zaino
     *     FOR: int,                     // Valore attuale di Forza
     *     damage: int,                  // Danno inflitto attuale
     *     protezioneDanno: int,         // Valore di protezione dal danno
     *     DES: int,                     // Valore attuale di Destrezza
     *     dodgingChance: float,         // Probabilità di schivata attuale
     *     PF: int,                      // Punti Ferita massimi
     *     puntiUpgrade: int,            // Punti disponibili per upgrade
     *     arma: array|null,             // Informazioni sull'arma equipaggiata
     *     armatura: array|null,         // Informazioni sull'armatura equipaggiata
     *     zaino: array,                 // Contenuto dello zaino
     *     elementInfo: array{           // Informazioni sull'elemento del personaggio
     *         elementoPG: string,          // Elemento associato al personaggio
     *         prevaleSu: string,           // Elemento su cui prevale
     *         prevalsoDa: string           // Elemento da cui è prevalso
     *     }
     * }
     */
    public function getStatsAndEquipment(){
        return [
            'DAMAGE_LOOKUP'   => self::DAMAGE_LOOKUP,
            'DODGE_LOOKUP'    => self::DODGE_LOOKUP,
            'MIN_FOR_DES'     => self::MIN_FOR_DES,
            'MAX_FOR_DES'     => self::MAX_FOR_DES,
            'ZAINO_SIZE'      => self::ZAINO_SIZE,
            'FOR'             => $this->currentFOR,
            'damage'          => $this->damage,
            'protezioneDanno' => $this->protezioneDanno,
            'DES'             => $this->currentDES,
            'dodgingChance'   => $this->dodgingChance,
            'PF'              => $this->PF,
            'puntiUpgrade'    => $this->puntiUpgrade,
            'arma'            => $this->arma,
            'armatura'        => $this->armatura,
            'zaino'           => $this->zaino,
            'elementInfo'     => [
                'elementoPG'    => $this->elemento,
                'prevaleSu'     => $this->prevaleSu,
                'prevalsoDa'    => $this->prevalsoDa,
            ]
        ];
    }

    /**
     * Recupera dal database le immagini di prevalenza e debolezza dell'elemento del personaggio.
     * @throws Exception In caso di errore di connessione o query
     * @return array{prevaleSu: string, prevalsoDa: string}
     */
    public function getImmaginiPrevalenza(){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }

        $stmt = null;
        try {
            $sql = "SELECT
                (SELECT PathImmagine FROM Element WHERE Nome = ?) AS prevaleSu,
                (SELECT PathImmagine FROM Element WHERE Nome = ?) AS prevalsoDa";
            $stmt = $connectionDB->prepare($sql);
            $stmt->bind_param("ss", $this->prevaleSu, $this->prevalsoDa);
            if(!$stmt->execute()){
                throw new Exception("Errore nel recupero: " . $stmt->error);
            }
            $result = $stmt->get_result();
            $output = $result->fetch_assoc();
            return $output;
        } finally {
            if ($stmt) $stmt->close();
            $connectionDB->close();
        }
    }

    /**
     * Restituisce tutti gli oggetti utilizzabili secondo le seguenti regole:
     *  - Non restituisce oggetti cura se già full vita
     *  - Non restituisce solo oggetti FOR se la statistica è già al massimo
     *  - Non restituisce solo oggetti DES se la statistica è già al massimo
     * @return array|null contenente gli oggetti secondo questi filtri se presenti, `null` altrimenti
     */
    public function getOggettiUtilizzabili(){
        $oggetti = [];
        foreach ($this->zaino as $item){
            if ($item['RecuperoVita'] > 0 && $this->tmp_PF == $this->PF)
                continue;
            if ($item['ModificatoreFor'] > 0 && $item['ModificatoreDes'] == 0 && $this->currentFOR == self::MAX_FOR_DES)
                continue;
            if ($item['ModificatoreDes'] > 0 && $item['ModificatoreFor'] == 0 && $this->currentDES == self::MAX_FOR_DES)
                continue;
            $oggetti[] = $item;
        }

        return (count($oggetti) === 0)? null : $oggetti;
    }
    /**
     * @return array|null Restituisce l'oggetto con il miglior RecuperoVita (>0), oppure null.
     */
    public function getBestOggettoCura(){
        $best = null;
        $oggetti = $this->getOggettiUtilizzabili() ?? [];
        foreach ($oggetti as $item){
            if ($item['RecuperoVita'] > 0){
                if ($best === null || $item['RecuperoVita'] > $best['RecuperoVita']){
                    $best = $item;
                }
            }
        }
        return $best;
    }
    /**
     * @return array|null Restituisce l'oggetto con il miglior ModificatoreFor (>0), oppure null.
     */
    public function getBestOggettoFOR(){
        $best = null;
        $oggetti = $this->getOggettiUtilizzabili() ?? [];
        foreach ($oggetti as $item){
            if ($item['ModificatoreFor'] > 0){
                if ($best === null || $item['ModificatoreFor'] > $best['ModificatoreFor']){
                    $best = $item;
                }
            }
        }
        return $best;
    }
    /**
     * @return array|null Restituisce l'oggetto con il miglior ModificatoreDes (>0), oppure null.
     */
    public function getBestOggettoDES(){
        $best = null;
        foreach ($this->getOggettiUtilizzabili() as $item){
            if ($item['ModificatoreDes'] > 0){
                if ($best === null || $item['ModificatoreDes'] > $best['ModificatoreDes']){
                    $best = $item;
                }
            }
        }
        return $best;
    }


    /**
     * Aggiungo l'esperienza ed eventualemnte effettuo il lvlUP
     * @param bool $win Se l'esperienza guadagnata deriva da una vittoria (true) o da una sconfitta (false)
     * @throws Exception qual'ora ci fossero problemi di connessione al database
     * @return int Indica il numero di lvlUp effettuati
     */
    public function addExp($win){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }

        $livelliGuadagnati = 0;
        $stmt = null;
        try{
            $amount = $win? self::EXP_WIN : self::EXP_LOSS;

            $this->exp += $amount;

            $sql = "UPDATE Personaggi SET PuntiExp = ? WHERE Nome = ? AND Proprietario = ?";

            $stmt = $connectionDB->prepare($sql);
            $stmt->bind_param("isi", $this->exp, $this->nome, $this->proprietario);

            if(!$stmt->execute()){
                $this->exp -= $amount;
                throw new Exception("Errore nell'aggiornamento dei punti esperienza di " . $this->nome . " (proprietario" . $this->proprietario .")");
            }

            if($this->exp >= self::MAX_EXP){
                $livelliGuadagnati = intdiv($this->exp, self::MAX_EXP);
                $this->exp %= self::MAX_EXP;
                $this->livello += $livelliGuadagnati;
                $this->puntiUpgrade += self::PU_LVL_UP * $livelliGuadagnati;
            }

        }
        finally{
            if($stmt)   $stmt->close();
            $connectionDB->close();
        }

        return $livelliGuadagnati;
    }

    /**
     * Applica danno al personaggio, tenendo conto della protezione.
     * @param int $damage quantità di danno subito
     * @return int quantità di danno effettivamente subito calcolato come differenza con la protezione danno
     */
    private function takeDamage($damage){
        $totalDamage = $damage - $this->protezioneDanno;

        if($totalDamage <= 0)
            $totalDamage = 1;

        $this->tmp_PF -= $totalDamage;
        return $totalDamage;
    }

    /**
     * Effettua del danno ad un altro personaggio considerando tutte le meccaniche di elemento e allineamento armi/armature.
     * @param Personaggio $P Il personaggio da attaccare passato per riferimento.
     * @return array{
     *      colpito: bool,          // Indica se l'attacco ha colpito.
     *      dannoInflitto: int      // La quantità di danno inflitto.
     * }
     */
    public function attack(&$P){
        $prevalgo = $this->prevaleSu === $P->elemento;

        $damageToDeal = $this->damage + ($prevalgo? 1 : 0);
        $dodgingChanceP = ($P->dodgingChance / ($prevalgo? 2 : 1)) % 100;
        $randomNumber = random_int(1, 100);

        $esito = [
            'colpito' => false,
            'dannoInflitto' => 0,
        ];

        if($randomNumber >= $dodgingChanceP){
            $esito['colpito'] = true;
            $esito['dannoInflitto'] = $P->takeDamage($damageToDeal);
        }

        return $esito;
    }

    /**
     * Funzione per capire se un personaggio ha i `tmp_PF` minori o uguali a zero
     * @return bool `true` se il personaggio è morto, `false` altrimenti
     */
    public function isDead(){
        return $this->tmp_PF <= 0;
    }
    /**
     * Cura il personaggio
     * @param int $amount valore di cura del personaggio
     * @return bool se `true` indica che il personaggio ha guadagnato dei PF, altrimenti indica che il personaggio aveva già la vita al massimo
     */
    public function heal($amount){
        if($this->PF == $this->tmp_PF)
            return false;

        $this->tmp_PF = min($this->PF, $this->tmp_PF + $amount);

        return true;
    }
    /**
     * Funzione che si occupa di migliorare le statistiche del personaggio
     * @param int $newPF nuove statistiche per i PF
     * @param int $newFOR nuove statistiche per la FOR
     * @param int $newDES nuove statistiche per la DES
     * @return boolean `true` se l'aggiornamento viene effettuato, `false` altrimenti
     */
    public function upgradeStats($newPF, $newFOR, $newDES){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if ($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }
        try{
            if($this->hasOpenedBattles($connectionDB)){
                throw new Exception("Hai una battaglia in corso, non puoi migliorare le tue statistiche", 400);
            }
        }
        finally{
            $connectionDB->close();
        }


        if ($newFOR < self::MIN_FOR_DES || $newFOR > self::MAX_FOR_DES || $newFOR < $this->currentFOR){
            throw new Exception("Aggiornamento Fallito: Valore non ammissibile per la Forza: " . $newFOR, 400);
        }

        if ($newDES < self::MIN_FOR_DES || $newDES > self::MAX_FOR_DES || $newDES < $this->currentDES){
            throw new Exception("Aggiornamento Fallito: Valore non ammissibile per la Destrezza: " . $newDES, 400);
        }

        if ($newPF < $this->PF){
            throw new Exception("Aggiornamento Fallito: Valore non ammissibile per i Punti Ferita: ". $newPF, 400);
        }


        $usedPU = [];
        $usedPU["PF"] = $newPF - $this->PF;
        $usedPU["FOR"] = $newFOR - $this->currentFOR;
        $usedPU["DES"] = $newDES - $this->currentDES;
        $totalUsedPU = array_sum($usedPU);

        if($totalUsedPU > $this->puntiUpgrade){
            throw new Exception("Aggiornamento Fallito: Usati troppi Punti Upgrade (". $totalUsedPU . ") rispetto a quelli a disposizione (" . $this->puntiUpgrade . ")", 400);
        }

        $this->puntiUpgrade -= $totalUsedPU;
        $this->PF = $newPF;

        $this->FOR += $usedPU["FOR"];
        $this->currentFOR = $newFOR;

        $this->DES += $usedPU["DES"];
        $this->currentDES = $newDES;

        $this->tmp_PF = $this->PF;
        $this->setEquipmentStats();

        return $this->updateDB();
    }

    /**
     * Funzione che utilizza l'oggetto specificato tramite ID se presente nello zaino del personaggio.
     * Eventualmente aggiorna il database rimuovendo l'oggetto
     * @param string $itemId id dell'oggetto da utilizzare
     * @param boolean $updateDB se aggiornare o meno il database [Default: `false`]
     * @return boolean `true` se l'oggetto è stato trovato e utilizzato correttamente, `false` altrimenti
     */
    public function useItem($itemId, $updateDB = false){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if ($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }

        try{
            if (!is_numeric($itemId) || intval($itemId) != $itemId){
                $connectionDB->close();
                throw new Exception("ID oggetto non valido: deve essere un numero intero", 400);
            }
            $itemId = intval($itemId);

            $foundIndex = null;
            foreach ($this->zaino as $index => $oggetto){
                if ($oggetto['ID'] === $itemId){
                    $foundIndex = $index;
                    $item = $oggetto;
                    break;
                }
            }
            if ($foundIndex === null){
                return false;
            }

            $used = false;

            // Cura
            if (isset($item['RecuperoVita']) && $item['RecuperoVita'] > 0){
                if(!$this->heal($item['RecuperoVita'])){
                    throw new Exception("Sei già al massimo della vita!", 1010);
                }
                $used = true;
            }
            // Modifica FOR
            if (isset($item['ModificatoreFor']) && $item['ModificatoreFor'] != 0){
                $this->currentFOR = max(self::MIN_FOR_DES, min(self::MAX_FOR_DES, $this->currentFOR + $item['ModificatoreFor']));
                $used = true;
            }
            // Modifica DES
            if (isset($item['ModificatoreDes']) && $item['ModificatoreDes'] != 0){
                $this->currentDES = max(self::MIN_FOR_DES, min(self::MAX_FOR_DES, $this->currentDES + $item['ModificatoreDes']));
                $used = true;
            }

            $this->setEquipmentStats();

            $this->removeFromZaino($connectionDB, $itemId, $updateDB, false);
            return $used;
        }
        finally{
            $connectionDB->close();
        }
    }

    /**
     * Funzione che permette di equipaggiare un Oggetto al personaggio se presente nell'inventario di `$this->proprietario`.
     * A seconda del tipo dell'oggetto viene assegnata come `arma`, `armatura` o viene inserita in `$this->zaino` se vi è ancora spazio
     * @param int $itemId id dell'oggetto da inserire nell'inventario
     * @throws Exception per problemi con la comunicazione con il database, se `$this->proprietario` non possiede l'oggetto o se l'oggetto è di tipo `box`
     * @return bool 'true' se l'àaggiunta viene effettuata correttamente.
     */
    public function equipItem($itemId){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }
        $connectionDB->begin_transaction();
        $searchStmt = null;
        $inventoryStmt = null;
        try{
            if($this->hasOpenedBattles($connectionDB))
                throw new Exception("Hai una battaglia in corso, non puoi aggiungere oggetti all'inventario", 400);

            $sqlSearch = "SELECT Inventario.Quantita, Item.Tipologia
                          FROM Inventario
                            JOIN Item ON Inventario.Oggetto = Item.ID
                          WHERE Inventario.Proprietario = ? AND Inventario.Oggetto = ?";
            $searchStmt = $connectionDB->prepare($sqlSearch);
            $searchStmt->bind_param('ii', $this->proprietario, $itemId);
            $searchStmt->execute();
            $result = $searchStmt->get_result();

            if($result->num_rows === 0){
                throw new Exception("Non possiedi questo oggetto!", 400);
            }

            $resultArray = $result->fetch_assoc();

            $currentQuantity = $resultArray["Quantita"];
            $tipologia = $resultArray['Tipologia'];
            $newQuantity = $currentQuantity - 1;

            if($tipologia === "box"){
                throw new Exception("Non puoi equipaggiare una box al tuo personaggio", 400);
            }

            if($newQuantity > 0){
                $inventorySql = "UPDATE Inventario SET Quantita = ? WHERE Oggetto = ? AND Proprietario = ?;";
                $inventoryStmt = $connectionDB->prepare($inventorySql);
                $inventoryStmt->bind_param("iii", $newQuantity, $itemId, $this->proprietario);

                if(!$inventoryStmt->execute())
                    throw new Exception("Errore nell'aggiornamento della quantità dell'oggetto con ID: ". $itemId . ", per l'account: ". $this->proprietario . ", durante l'equipaggiamento al personaggio '" . $this->nome . "'");
            }
            else {
                $inventorySql = "DELETE FROM Inventario WHERE Oggetto = ? AND Proprietario = ?";
                $inventoryStmt = $connectionDB->prepare($inventorySql);
                $inventoryStmt->bind_param("ii", $itemId, $this->proprietario);
                if(!$inventoryStmt->execute())
                    throw new Exception("Errore nella rimozione dell'oggetto con ID: ". $itemId . " per l'account: ". $this->proprietario. ", durante l'equipaggiamento al personaggio '" . $this->nome . "'");

            }


            switch($tipologia){
                case 'arma':
                    $this->setArma($connectionDB, $itemId);
                    break;
                case 'armatura':
                    $this->setArmatura($connectionDB, $itemId);
                    break;
                default:
                    $this->addToZaino($connectionDB, $itemId);
            }

            $connectionDB->commit();
            return true;
        }
        catch(Exception $e){
            $connectionDB->rollback();

            throw $e;
        }
        finally{
            if($searchStmt)      $searchStmt->close();
            if($inventoryStmt)   $inventoryStmt->close();
        }
    }

    /**
     * Rimuove un'`item` dagli oggetti equipaggiati (arma, armatura o dallo zaino) e lo inserisce nell'inventario di `$this->proprietario`
     * @param int $itemId id dell'oggetto da inserire nell'inventario
     * @param boolean $moveToInventario indica se spostare l'oggetto nell'inventario del proprietario o meno [Default: `true`]
     * @throws Exception per problemi con
     * @return bool
     */
    public function unequipItem($itemId, $moveToInventario = true){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }
        $connectionDB->begin_transaction();
        $searchStmt = null;
        $inventoryStmt = null;

        try{
            if($this->hasOpenedBattles($connectionDB)){
                throw new Exception("Hai una battaglia in corso, non puoi rimuovere gli oggetti dall'inventario", 400);
            }

            $found = false;
            if($this->arma && $itemId === $this->arma['ID']){
                $found = true;
                $this->setArma($connectionDB, null);
            }
            else if($this->armatura && $itemId === $this->armatura['ID']){
                $found = true;
                $this->setArmatura($connectionDB, null);
            }
            else{
                foreach($this->zaino as $item){
                    if($itemId === $item['ID']){
                        $found = true;
                        $this->removeFromZaino($connectionDB, $itemId, true, $moveToInventario);
                        break;
                    }
                }
            }

            if(!$found){
                throw new Exception("Il personaggio " . $this->nome . "non ha questo oggetto equipaggiato!", 400);
            }


            $connectionDB->commit();
            return true;
        }
        catch(Exception $e){
            $connectionDB->rollback();

            throw $e;
        }
        finally{
            if($searchStmt)      $searchStmt->close();
            if($inventoryStmt)   $inventoryStmt->close();
        }
    }

    /**
     * FUnzione che recupera le informazioni sui match del `Personaggio` attuale
     * @throws Exception se ci sono stati problemi di connessione
     * @return array{inCorso: int, sconfitte: int, vittorie: int} contenente il numero di partite per categoria nel DB
     */
    public function getMatches(){
        $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($conn->connect_error){
            throw new Exception("Connessione al database fallita: " . $conn->connect_error, 500);
        }

        $stmt = null;
        try{
            $sql = "SELECT *
                    FROM Combattimenti
                    WHERE Giocatore1_Nome = ? AND Giocatore1_Proprietario = ?";

            $stmt = $conn->prepare($sql);
            $stmt->bind_param("si", $this->nome, $this->proprietario);

            if(!$stmt->execute()){
                throw new Exception("C'è stato un problema con il recupero delle informazioni", 500);
            }

            $result = $stmt->get_result();

            $output = [
                'vittorie' => 0,
                'sconfitte' => 0,
                'inCorso' => 0
            ];

            while($row = $result->fetch_assoc()){
                if($row['Vittoria_Giocatore1'] === null)
                    $output['inCorso']++;
                else if($row['Vittoria_Giocatore1'] === 1)
                    $output['vittorie']++;
                else
                    $output['sconfitte']++;
            }

            return $output;

        }
        finally{
            if($stmt)   $stmt->close();
            $conn->close();
        }

    }
    /**
     * Funzione che controlla se è presente una battaglia in corso per questo personaggio
     * @return array|null L'array contiene informazioni sulla battaglia, altrimenti `null`
     */
    public function getBattagliaInCorso(){
        $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($conn->connect_error){
            throw new Exception("Connessione al database fallita: " . $conn->connect_error, 500);
        }

        $conn->begin_transaction();
        $stmt = null;
        $stmtUpdate = null;
        try {
            $sql = "SELECT *
                    FROM Combattimenti
                    WHERE Giocatore1_Nome = ? AND Giocatore1_Proprietario = ? AND Terminata = 0
                    ORDER BY DataInizioBattaglia DESC LIMIT 1";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('si', $this->nome, $this->proprietario);
            $stmt->execute();
            $result = $stmt->get_result();
            $output = null;
            if($result && $result->num_rows > 0){
                $output = $result->fetch_assoc();
                $currentDateTime = new DateTime("now");
                $currentTimestamp = $currentDateTime->format('Y-m-d H:i:s');

                $sqlUpdate = "UPDATE Combattimenti SET DataUltimoTurno = ?
                              WHERE Giocatore1_Proprietario = ?
                                AND Giocatore1_Nome = ?
                                AND Terminata = 0 ";
                $stmtUpdate = $conn->prepare($sqlUpdate);
                $stmtUpdate->bind_param('sis', $currentTimestamp, $this->proprietario, $this->nome);
                if(!$stmtUpdate->execute()){
                    $conn->rollback();
                    throw new Exception("Problemi durante il recupero dell'ultima battaglia del personaggio " . $this->nome . "(proprietario ". $this->proprietario .")", 500);
                }

                $output["Turno_Giocatore1"] = false;
                $output["DataUltimoTurno"] = serialize($currentDateTime);

            }
            $conn->commit();
            return $output;
        }
        finally {
            if($stmt)       $stmt->close();
            if($stmtUpdate) $stmtUpdate->close();
            $conn->close();
        }
    }

    /**
     * Crea un'istanza del combattimento all'interno del DB e la restituisce
     * @param Personaggio $avversario riferimento al personaggio da affrontare
     * @throws Exception se ci sono problemi di connessione al database
     * @return array già formattato, pronto per poter essere usato come "battaglia"
     */
    public function creaCombattimento(&$avversario){
        $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        if($conn->connect_error){
            throw new Exception("Connessione al database fallita: " . $conn->connect_error, 500);
        }
        $conn->begin_transaction();
        $stmt = null;
        $selectStmt = null;
        try {
            $sql = "INSERT INTO Combattimenti
                (Giocatore1_Nome, Giocatore1_Proprietario, StatoPersonaggi)
                VALUES (?, ?, ?)";
            $stmt = $conn->prepare($sql);

            $turno = random_int(0, 9) % 2 === 0;
            $statoPersonaggi = [
                "pg1" => $this->getAll(),
                "pg2" => $avversario->getAll()
            ];
            $statoPersonaggiJson = json_encode($statoPersonaggi);

            $vars = [$this->nome, $this->proprietario, $statoPersonaggiJson];

            $stmt->bind_param('sis', ...$vars);
            if(!$stmt->execute()){
                throw new Exception("Errore durante la creazione del combattimento: " . $stmt->error, 500);
            }

            $sqlSelect = "SELECT *
                          FROM Combattimenti
                          WHERE Giocatore1_Nome = ? AND Giocatore1_Proprietario = ?
                            AND Terminata = 0";

            $selectStmt = $conn->prepare($sqlSelect);
            $selectStmt->bind_param('si', $this->nome, $this->proprietario);
            if(!$selectStmt->execute())
                throw new Exception("Errore durante il recupero del combattimento", 500);

            $result = $selectStmt->get_result();
            $battaglia = $result->fetch_assoc();
            $battaglia['Turno_Giocatore1'] = $turno;
            $battaglia['DataUltimoTurno'] = serialize(new DateTime($battaglia['DataUltimoTurno']));

            $conn->commit();
            return $battaglia;
        }
        catch(Exception $e){
            $conn->rollback();
            throw new Exception($e->getMessage(), $e->getCode());
        }
        finally {
            if($stmt)       $stmt->close();
            if($selectStmt) $selectStmt->close();
            $conn->close();
        }
    }

    /**
     * Aggiorna i dati del personaggio nel database
     * @return bool true se l'aggiornamento è avvenuto con successo, false altrimenti
     */
    private function updateDB(){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);

        if($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }

        $stmt = null;
        try {
            $query = "UPDATE Personaggi SET
                        Forza = ?,
                        Destrezza = ?,
                        PuntiVita = ?,
                        Livello = ?,
                        PuntiExp = ?,
                        PuntiUpgrade = ? WHERE Nome = ? AND Proprietario = ?";

            $stmt = $connectionDB->prepare($query);
            if (!$stmt){
                return false;
            }

            $types = 'iiiiiisi';
            $params = [$this->FOR, $this->DES, $this->PF, $this->livello, $this->exp, $this->puntiUpgrade, $this->nome, $this->proprietario];


            $stmt->bind_param($types,...$params);

            return $stmt->execute();
        }
        finally {
            if ($stmt)  $stmt->close();
            $connectionDB->close();
        }
    }
    /**
     * Rimuove il personaggio dal database e resetta tutti i suoi campi
     * @return bool true se l'eliminazione è avvenuta con successo, false altrimenti
     */
    public function deleteFromDB(){
        $connectionDB = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
        $connectionDB->begin_transaction();
        if($connectionDB->connect_error){
            throw new Exception("Connessione al database fallita: ". $connectionDB->connect_error, 500);
        }

        $stmt = null;
        try {
            // Prepare the update query
            $query = "DELETE FROM Personaggi WHERE Nome = ? AND Proprietario = ?";

            $stmt = $connectionDB->prepare($query);
            if (!$stmt){
                return false;
            }

            $stmt->bind_param('si',
                $this->nome,
                $this->proprietario
            );

            if($stmt->execute()){
                if($this->arma)
                    addToInventario($connectionDB, $this->proprietario, $this->arma['ID']);
                if($this->armatura)
                    addToInventario($connectionDB, $this->proprietario, $this->armatura['ID']);
                foreach($this->zaino as $item){
                    addToInventario($connectionDB, $this->proprietario, $item['ID']);
                }
                $this->protezioneDanno = null;
                $this->pathImmagine    = null;
                $this->pathImmaginePG  = null;
                $this->nome            = null;
                $this->proprietario           = null;
                $this->FOR             = null;
                $this->currentFOR      = null;
                $this->DES             = null;
                $this->currentDES      = null;
                $this->PF              = null;
                $this->tmp_PF          = null;
                $this->elemento        = null;
                $this->prevaleSu       = null;
                $this->prevalsoDa      = null;
                $this->armatura        = null;
                $this->arma            = null;
                $this->livello         = null;
                $this->exp             = null;
                $this->puntiUpgrade    = null;
                $this->damage          = null;
                $this->dodgingChance   = null;
                $this->zaino           = null;
                $connectionDB->commit();
                return true;
            }
            $connectionDB->rollback();
            return false;
        }
        finally {
            if ($stmt)  $stmt->close();
            $connectionDB->close();
        }
    }
}

/**
 * Recupera dal database le informazioni relative ai modificatori e debolezze di un elemento specificato.
 *
 * Questa funzione interroga il database per ottenere dettagli come i percorsi delle immagini, i modificatori
 * e le relazioni (ad esempio, punti di forza e debolezze) per un determinato elemento. Il nome dell'elemento
 * deve essere presente nel database.
 *
 * @param string $element Il nome dell'elemento di cui recuperare le informazioni. Deve corrispondere a un record nel database.
 * @param mysqli $conn Un riferimento alla connessione MySQLi attiva.
 *
 * @return array Un array associativo contenente le informazioni dell'elemento se l'operazione ha successo, oppure un messaggio di errore
 *               con la seguente struttura:
 *               - In caso di successo:
 *                 [
 *                   "PathImmagine" => string,  // Percorso dell'immagine dell'elemento.
 *                   "PathImmaginePG" => string, // Percorso dell'immagine PG dell'elemento.
 *                   "ModificatoreFor" => float, // Modificatore per la forza.
 *                   "ModificatoreDes" => float, // Modificatore per la destrezza.
 *                   "RecuperoVita" => float,  // Modificatore per i punti vita.
 *                   "PrevaleSu" => string,      // Elemento/i su cui questo elemento prevale.
 *                   "PrevalsoDa" => string      // Elemento/i da cui questo elemento è prevalso.
 *                 ]
 *               - In caso di errore:
 *                 [
 *                   "error" => true,
 *                   "message" => string // Descrizione dell'errore.
 *                 ]
 *
 * @throws Exception Se la connessione al database fallisce, la query fallisce o l'elemento non viene trovato.
 */
function getElementInfo($element, &$conn): array{
    $stmt = null;
    try{
        if($conn->connect_error){
            throw new Exception("Connessione al database fallita: ". $conn->connect_error, 500);
        }

        $sql = "SELECT *
            FROM Element
            WHERE Nome = ?";

        $stmt = $conn->prepare($sql);

        $stmt->bind_param("s", $element);
        if(!$stmt->execute()){
            throw new Exception( $stmt->error, 500);
        }

        $result = $stmt->get_result();

        if($result->num_rows === 0){
            throw new Exception("invalid_element", 400);
        }

        return $result->fetch_assoc();

    }
    finally{
        if($stmt)   $stmt->close();
    }
}

/**
 * Aggiunge un oggetto all'inventario del proprietario specificato.
 * @param mysqli& $conn Connessione al database passata per riferimento.
 * @param int $proprietarioId ID del proprietario dell'oggetto.
 * @param int $itemId ID dell'oggetto da aggiungere all'inventario.
 * @throws Exception nel caso di fallimento dell'inserimento
 * @return void
 */
function addToInventario(&$conn, $proprietarioId, $itemId){
    $sqlInventario = "INSERT INTO Inventario (Proprietario, Oggetto, Quantita)
                     VALUES (?, ?, 1)
                     ON DUPLICATE KEY UPDATE Quantita = Quantita + 1";
    $inventarioStmt = $conn->prepare($sqlInventario);
    $inventarioStmt->bind_param("ii", $proprietarioId, $itemId);
    if (!$inventarioStmt->execute()){
        throw new Exception("Errore durante l'aggiornamento dell'inventario per l'oggetto con ID: " . $itemId, $inventarioStmt->errno);
    }
    $inventarioStmt->close();
}