<?php
if (basename($_SERVER['PHP_SELF']) === 'methods.php'){
    pageError(403);
}

ini_set("display_errors", "0");
require_once __DIR__ . "/definitions.php";

// *** Funzioni che gestiscono Errori *** //

/**
 * Funzione che reindirizza un errore
 * @param string|int $errorCode Codice di errore da passare alla "errorPage.php"
 * @param string $prefix Percorso che porta alla "errorPage.php" [Default: ""]
 * @return never
 */
function pageError($errorCode, $prefix = ""){
    header("Location: " . $prefix . "errorPage.php?error_code=" . urlencode($errorCode));
    exit();
}

/**
 * Funzione che reindirizza un errore di un'API restituendo una risposta JSON standard.
 * @param int $errorCode Codice di errore HTTP [Default: 500]
 * @param string|null $message Messaggio di errore personalizzato [Default: null]
 * @return never
 */
function apiError($errorCode = 500, $message = null){
    if ($message === null){
        $message = match ($errorCode){
            400 => "Richiesta non valida",
            401 => "Non autorizzato",
            403 => "Accesso negato",
            404 => "Risorsa non trovata",
            500 => "Errore interno del server",
            default => "Errore Sconosciuto"
        };
    }

    error_log("Errore API [" . $errorCode . "]: " . $message);

    http_response_code($errorCode);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        "error" => true,
        "code" => $errorCode,
        "message" => $message
    ]);
    exit();
}

/**
 * Valida gli input dell'utente per i campi username, password e confermaPassword.
 * @param string|null $username Username da validare.
 * @param string|null $password Password da validare.
 * @param string|null $confirmPassword Conferma password da validare.
 * @return string Restituisce una stringa di errore se la validazione fallisce:
 *                - "invalid_username" se $username non corrisponde all'USERNAME_PATTERN
 *                - "invalid_password" se $password non corrisponde al PASSWORD_PATTERN
 *                - "password_mismatch" se $confirmPassword non corrisponde a $password
 *                Se tutti gli input sono validi restituisce una stringa vuota.
 */
function validateInputs($username, $password, $confirmPassword){
    if(is_null($username) || !preg_match(USERNAME_PATTERN, $username))
        return "invalid_username";

    if(is_null($password) || !preg_match(PASSWORD_PATTERN, $password))
        return "invalid_password";

    if(!empty($confirmPassword) && $confirmPassword !== $password)
            return "password_mismatch";

    return '';
}


/** 
 * Queste funzioni, in caso di errore, chiamano la funzione `apiError`, restituendo gli errori secondo lo standard
 */

/**
 * @deprec
 * ~Ritorna un elemento `Account` dato un username~
 * @param string $username username da cercare nel database
 * @return Account|null oggetto `Account` oppure null se non è stato trovato un account con quell'`$username`
 */
function getUserData($username){
    return null;
    // $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    // if($conn->connect_error)
    //     apiError(500, "Connessione al database fallita: " . $conn->connect_error);

    // $stmt = null;
    // $stmtPersonaggi = null;

    // try {
    //     $sql = "SELECT ID, Username, Monete, RefreshNegozio, ImmagineProfilo
    //             FROM Account
    //             WHERE Username = ?";
    //     $stmt = $conn->prepare($sql);
    //     $stmt->bind_param('s', $username);
    //     $stmt->execute();
    //     $result = $stmt->get_result();

    //     if($result->num_rows > 0){
    //         $userRow = $result->fetch_assoc();
    //         $dateTime = new DateTime($userRow['RefreshNegozio']);
    //         $user = new Account($userRow['ID'], $userRow['Username'], $userRow['Monete'], $dateTime, $userRow['ImmagineProfilo']);

    //         $sqlPersonaggi = "SELECT Nome, Proprietario, Elemento
    //                           FROM Personaggi
    //                           WHERE Proprietario = ?";
    //         $stmtPersonaggi = $conn->prepare($sqlPersonaggi);
    //         $stmtPersonaggi->bind_param('i', $userRow["ID"]);
    //         $stmtPersonaggi->execute();
    //         $resultPersonaggi = $stmtPersonaggi->get_result();

    //         while($personaggioRow = $resultPersonaggi->fetch_assoc()){
    //             $personaggio = new Personaggio(
    //                 $personaggioRow['Nome'],
    //                 $personaggioRow['Proprietario'],
    //                 $personaggioRow['Elemento']
    //             );
    //             $user->addPersonaggio($personaggio);
    //         }
    //         return $user;
    //     }
    //     else{
    //         // Nessun Account trovato
    //         return null;
    //     }
    // }
    // catch (Exception $e){
    //     apiError(500, "Errore in getUserData: " . $e->getMessage());
    // }
    // finally{
    //     if ($stmt) $stmt->close();
    //     if ($stmtPersonaggi) $stmtPersonaggi->close();
    //     $conn->close();
    // }
}


/**
 * Recupera l'inventario di un account dal database.
 * @param int $accountID ID dell'account
 * @param array|null $filter Array contenente i tipi degli oggetti da recuperare (opzionale)
 * @return array Array contenente gli item nell'inventario e la loro quantità
 */
function getInventory($accountID, $filter = null){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);
    }
    $stmtFilter = null;
    $stmt = null;
    try{
        $sql = "SELECT Item.*, Inventario.Quantita
                FROM Inventario
                    JOIN Item ON Inventario.Oggetto = Item.ID
                WHERE Inventario.Proprietario = ?;";

        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $accountID);
        $stmt->execute();
        $result = $stmt->get_result();

        $output = [];
        $output["MAX_SIZE"] = MAX_ITEMS;
        $inventory = [];
        while($row = $result->fetch_assoc()){
            if($filter !== null && !in_array($row['Tipologia'], $filter)){
                continue;
            }
            $inventory[] = $row;

        }

        $output["inventario"] = $inventory;

    return $output;
    }
    catch(Exception $e){
        apiError(500, "Errore durante il recupero dell'inventario: " . $e->getMessage());
    }
    finally {
        if($stmt)        $stmt->close();
        if($stmtFilter)  $stmtFilter->close();
        $conn->close();
    }
}

/**
 * Diminuisce la quantità di un oggetto nell'inventario di un account. Se la quantità raggiunge 0, l'oggetto viene rimosso.
 * @param int $itemId ID dell'oggetto
 * @param int $accountId ID dell'account
 * @param int|null $currentQuantity Quantità attuale dell'oggetto (se non fornita, viene recuperata dal database)
 * @param mysqli $conn Connessione al database passata per riferimento
 * @return int Quantità aggiornata
 */
function removeOneItem($itemId, $accountId, $currentQuantity, &$conn){
    if($conn->connect_error)
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);

    $stmtQuantity = null;
    $updateStmt = null;
    $deleteStmt = null;

    try{
        if(is_null($currentQuantity)){
            $sqlQuantity = "SELECT Quantita
                            FROM Inventario
                            WHERE Proprietario = ? AND Oggetto = ?";
            $stmtQuantity = $conn->prepare($sqlQuantity);
            $stmtQuantity->bind_param('ii', $accountId, $itemId);
            $stmtQuantity->execute();
            $result = $stmtQuantity->get_result();
            $quantityArr = $result->fetch_assoc();
            if(!$quantityArr){
                throw new Exception("Oggetto non trovato nell'Inventario");
            }

            $currentQuantity = $quantityArr["Quantita"];
        }
        $newQuantity = $currentQuantity - 1;

        if($newQuantity > 0){
            // Aggiorno la quantità
            $updateSql = "UPDATE Inventario SET Quantita = ? WHERE Oggetto = ? AND Proprietario = ?;";
            $updateStmt = $conn->prepare($updateSql);
            $updateStmt->bind_param("iii", $newQuantity, $itemId, $accountId);

            if(!$updateStmt->execute())
                throw new Exception("Errore nell'aggiornamento della quantità dell'oggetto con ID: ". $itemId . " per l'account: ". $accountId);
        }
        else {
            // Rimuovo l'oggetto dall'inventario
            $deleteSql = "DELETE FROM Inventario WHERE Oggetto = ? AND Proprietario = ?";
            $deleteStmt = $conn->prepare($deleteSql);
            $deleteStmt->bind_param("ii", $itemId, $accountId);
            if(!$deleteStmt->execute())
                throw new Exception("Errore nella rimozione dell'oggetto con ID: ". $itemId . " per l'account: ". $accountId);

        }

        return $newQuantity;
    }
    catch(Exception $e){
        apiError(500, "Errore durante la rimozione dell'oggetto:" . $e->getMessage());
    }
    finally {
        if($stmtQuantity)   $stmtQuantity->close();
        if($updateStmt)     $updateStmt->close();
        if($deleteStmt)     $deleteStmt->close();
    }
}

/**
 * Aggiunge uno o più oggetti all'inventario di un account, se c'è spazio disponibile.
 * @param int $itemId ID dell'oggetto da aggiungere
 * @param int $accountId ID dell'account
 * @param mysqli $conn Connessione al database passata per riferimento
 * @return int Quantità aggiornata dell'oggetto, o 0 se l'inserimento non è possibile
 */
function addOneItem($itemId, $accountId, &$conn): int{
    if($conn->connect_error)
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);

    $conn->begin_transaction();
    $stmtCount = null;
    $stmtQuantita = null;
    $updateStmt = null;
    $insertStmt = null;

    try {
        // Verifico lo spazio disponibile nell'inventario
        $sqlCount = "SELECT COUNT(*) AS dimensione
                     FROM Inventario
                     WHERE Proprietario = ?";
        $stmtCount = $conn->prepare($sqlCount);
        $stmtCount->bind_param('i', $accountId);
        $stmtCount->execute();
        $result = $stmtCount->get_result();
        $count= $result->fetch_assoc();


        if($count['dimensione'] + 1 == MAX_ITEMS){
            return 0;
        }

        // Recupero la quantità attuale dell'oggetto
        $sqlQuantita = "SELECT Quantita
                    FROM Inventario
                    WHERE Proprietario = ? AND Oggetto = ?";
        $stmtQuantita = $conn->prepare($sqlQuantita);
        $stmtQuantita->bind_param('ii', $accountId, $itemId);
        $stmtQuantita->execute();
        $result = $stmtQuantita->get_result();
        $currentQuantityArr = $result->fetch_assoc();

        $currentQuantity = $currentQuantityArr? $currentQuantityArr["Quantita"] : 0;
        $newQuantity = $currentQuantity + 1;


        if($currentQuantity > 0){
            // Oggetto presente, ne aggiorno la quantità
            $updateSql = "UPDATE Inventario SET Quantita = ? WHERE Oggetto = ? AND Proprietario = ?;";
            $updateStmt = $conn->prepare($updateSql);
            $updateStmt->bind_param("iii", $newQuantity, $itemId, $accountId);
            if(!$updateStmt->execute())
                throw new Exception("Errore durante l'aggiornamento della quantità dell'oggetto di ID: ". $itemId . " per l'account " . $accountId);

        }
        else{
            $insertSql = "INSERT INTO Inventario(Proprietario, Oggetto) VALUES (?, ?)";
            $insertStmt = $conn->prepare($insertSql);
            $insertStmt->bind_param("ii", $accountId, $itemId);
            if(!$insertStmt->execute())
                throw new Exception("Errore durante l'inserimento dell'oggetto di ID: ". $itemId . " per l'account " . $accountId);

        }

        $conn->commit();

        return $newQuantity;
    }
    catch (Exception $e){
        $conn->rollback();
        apiError(500, "Errore durante l'aggiunta dell'oggetto: " . $e->getMessage());
    }
    finally {
        if($stmtCount)      $stmtCount->close();
        if($stmtQuantita)   $stmtQuantita->close();
        if($updateStmt)     $updateStmt->close();
        if($insertStmt)     $insertStmt->close();
    }
}

/**
 * Aggiorna la quantità di monete di un account nel database.
 * @param int $accountId ID dell'account
 * @param int $amount Quantità di monete da aggiungere o sottrarre
 * @param mysqli $conn Connessione al database passata per riferimento
 * @return int Restituisce il numero di monete aggiunte o -1 in caso di errore
 */
function updateCoins($accountId, $amount, &$conn){
    if($conn->connect_error)
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);

    $conn->begin_transaction();
    $stmt = null;

    try{
        $updateCoinsSql = "UPDATE Account SET Monete = Monete + ? WHERE ID = ?";
        $stmt = $conn->prepare($updateCoinsSql);
        $stmt->bind_param("ii", $amount, $accountId);

        if(!$stmt->execute()){
            throw new Exception("Errore durante l'aggiornamento delle monete: " . $stmt->error);
        }

        if($stmt->affected_rows === 0){
            throw new Exception("Nessuna riga aggiornata. L'account ". $accountId ." potrebbe non esistere");
        }

        $conn->commit();
        return $amount;
    }
    catch (Exception $e){
        $conn->rollback();
        error_log("Errore in updateCoins: " . $e->getMessage());
        return -1;
    }
    finally{
        if($stmt)  $stmt->close();
    }
}

/**
 * Funzione API che vende un oggetto dell'account.
 * @param int $itemId ID dell'oggetto
 * @param int $accountId ID dell'account
 * @return array Contiene informazioni sull'esito della richiesta
 */
function sellItem($itemId, $accountId){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error)
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);

    $conn->begin_transaction();
    $stmt = null;

    try{
        // Recupero l'oggetto dall'Inventario
        $sql = "SELECT I.Quantita, It.Costo
                FROM Inventario I JOIN Item It ON I.Oggetto = It.ID
                WHERE I.Oggetto = ? AND I.Proprietario = ?;";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ii", $itemId, $accountId);

        $stmt->execute();
        $result = $stmt->get_result();
        $item = $result->fetch_assoc();

        if(!$item){
            // Oggetto non nell'inventario
            $conn->rollback();
            apiError(400, "Item non presente nell'Inventario!");
        }

        // Rimuovo l'oggetto
        $newQuantity = removeOneItem($itemId, $accountId,$item["Quantita"], $conn);

        // Aggiorno le monete ottenute
        $guadagno = updateCoins($accountId, floor($item['Costo'] / 2), $conn);

        if($guadagno === -1){
            throw new Exception("Errore durante l'aggiornamento delle monete", 400);
        }

        $conn->commit();
        return [
            "successo" => true,
            "guadagno" => $guadagno,
            "rimosso" => ($newQuantity === 0)
        ];
    }
    catch(Exception $e){
        $conn->rollback();
        error_log("Errore in sellItem: ". $e->getMessage());
        apiError($e->getCode(), $e->getMessage());
    }
    finally{
        if($stmt)   $stmt->close();
        $conn->close();
    }

}
/**
 * Funzione API che permette di acquistare un oggetto dal negozio.
 * @param int $itemId ID dell'oggetto da acquistare
 * @param int $accountId ID dell'account che effettua l'acquisto
 * @return array Esito dell'acquisto con eventuali dettagli o errori
 */
function buyItem($itemId, $accountId){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);

    if($conn->connect_error){
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);
    }

    $conn->begin_transaction();
    $stmtInShop = null;
    $stmtSpesa = null;

    try {
        // Verifico che l'oggetto sia presente nel negozio
        $sqlInShop = "SELECT N.Oggetto
                      FROM Negozio N
                      WHERE N.Proprietario = ? AND N.Oggetto = ?";
        $stmtInShop = $conn->prepare($sqlInShop);
        $stmtInShop->bind_param("ii", $accountId, $itemId);
        $stmtInShop->execute();
        $result = $stmtInShop->get_result();

        $item = $result->fetch_assoc();

        if(!$item){
            $conn->rollback();
            apiError(400, "Item non presente nel Negozio!");
        }

        // Recupero il costo
        $sqlGetPrice = "SELECT Costo
                        FROM Item
                        WHERE ID = ?";
        $stmtSpesa = $conn->prepare($sqlGetPrice);
        $stmtSpesa->bind_param('i', $itemId);

        $stmtSpesa->execute();
        $result = $stmtSpesa->get_result();
        $costo = $result->fetch_assoc();

        if(!$costo){
            throw new Exception("Costo dell'oggetto non trovato.", 400);
        }

        $spesa = -$costo["Costo"];
        if(updateCoins($accountId, $spesa, $conn) === -1){
            throw new Exception("Fondi insufficienti per completare l'acquisto", 400);
        }

        if(!addOneItem($itemId, $accountId, $conn)){
            throw new Exception("Spazio insufficente nell'invetario.", 400);
        }

        $conn->commit();
        return [
            "successo" => true,
            "spesa" => $spesa
        ];

    } catch (Exception $e){
        $conn->rollback();
        apiError($e->getCode(), $e->getMessage());
    }
    finally{
        if($stmtInShop) $stmtInShop->close();
        if($stmtSpesa)  $stmtSpesa->close();
        $conn->close();
    }
}

/**
 * Funzione che, dato un box, restituisce un array contenente oggetti estratti casualmente secondo le regole di gioco.
 * @param array $box Deve avere due campi: id e nome, entrambi riferiti alla box
 * @param int $accountId ID dell'account
 * @return array Esito dell'operazione con eventuali dettagli o errori
 */
function openBox($box, $accountId){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);
    }

    $stmtCount = null;
    $stmtGetItems = null;

    try{
        // Verifico lo spazio disponibile nell'inventario
        $sqlCount = "SELECT COUNT(*) AS conto FROM Inventario WHERE Proprietario = ?";
        $stmtCount = $conn->prepare($sqlCount);
        $stmtCount->bind_param('i', $accountId);
        $stmtCount->execute();
        $result = $stmtCount->get_result();
        $count= $result->fetch_assoc();

        if(!$count){
            throw new Exception("Immpossibile recuperare la dimensione dell'inventario. L'account ". $accountId ." potrebbe non esistere", 400);
        }

        $added = ($box["nome"] === "Box Comune")? 3 : 6;
        if($count["conto"] + $added >= MAX_ITEMS){
            return ["full" => true];
        }


        $conn->begin_transaction();

        // Recupero tutti gli oggetti disponibili tranne le box
        $sqlGetItems = "SELECT ID, Tipologia
                        FROM Item
                        WHERE Tipologia != 'box'
                        ORDER BY Tipologia";

        $stmtGetItems = $conn->prepare($sqlGetItems);
        $stmtGetItems->execute();
        $allItems = $stmtGetItems->get_result();

        $weapons = [];
        $armors = [];
        $potions = [];

        while($item = $allItems->fetch_assoc()){
            switch($item["Tipologia"]){
                case 'arma':
                    $weapons[] = $item["ID"];
                    break;
                case 'armatura':
                    $armors[] = $item["ID"];
                    break;
                case 'pozione':
                    $potions[] = $item["ID"];
                    break;
            }
        }

        $output = [];
        /* Box comuni:
        * - 5-10 monete
        * - 2 oggetti tra armi e armature
        * - 1 pozione
        */
        if($box["nome"] === "Box Comune"){
            $output["coins"] = mt_rand(MIN_COIN_COMMON, MAX_COIN_COMMON);
            $output[] = $potions[array_rand($potions)];
            $weapAndArms = array_merge($weapons, $armors);
            $output[] = $weapAndArms[array_rand($weapAndArms)];
            $output[] = $weapAndArms[array_rand($weapAndArms)];
        }
        /* Box Rare:
        * - 15-20 monete
        * - 2 armi
        * - 2 armature
        * - 2 pozioni
        */
        else if($box["nome"] === "Box Rara"){
            $output["coins"] = mt_rand(MIN_COIN_RARE, MAX_COIN_RARE);
            $output[] = $weapons[array_rand($weapons)];
            $output[] = $weapons[array_rand($weapons)];
            $output[] = $armors[array_rand($armors)];
            $output[] = $armors[array_rand($armors)];
            $output[] = $potions[array_rand($potions)];
            $output[] = $potions[array_rand($potions)];
        }

        if(updateCoins($accountId, $output["coins"], $conn) === -1){
            throw new Exception("Errore nell'aggiornamento delle monete", 400);
        }

        $itemsIDs = [];
        foreach($output as $key => $itemId){
            if(is_numeric($key)){
                if(addOneItem($itemId, $accountId, $conn))
                    $itemsIDs[] = $itemId;
            }
        }

        // Rimuovo la box
        $newBoxQuantity = removeOneItem($box["id"], $accountId, null, $conn);

        $conn->commit();
        return [
            "successo" => true,
            "guadagno" => $output["coins"],
            "rimosso"  => ($newBoxQuantity === 0),
            "itemsID"  => $itemsIDs
        ];
    }
    catch(Exception $e){
        $conn->rollback();
        error_log("Errore in openBox: ". $e->getMessage());
        apiError($e->getCode(), $e->getMessage());
    }
    finally{
        if($stmtCount)      $stmtCount->close();
        if($stmtGetItems)   $stmtGetItems->close();
        $conn->close();
    }
}

/**
 * Restituisce il negozio di un account, aggiornandolo se è passato sufficiente tempo dall'ultimo refresh.
 * @param int $accountId ID dell'account
 * @param DateTime $lastRefresh Data e ora dell'ultimo refresh
 * @return array Contiene gli item presenti nel negozio e il tempo rimanente al prossimo refresh
 */
function getShop($accountId, $lastRefresh){
    $currentTime = new DateTime("now");
    $tempoTrascorso = $currentTime->getTimestamp() - $lastRefresh->getTimestamp();
    if($tempoTrascorso < 0){
        apiError(400, "Tempo negativo rilevato (". $tempoTrascorso ."): il tempo trascorso non può essere negativo.");
    }

    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);
    }

    $stmtRecupero = null;
    try{
        // Recupero gli oggetti nel negozio
        $sql = "SELECT Item.*
                FROM Negozio
                    JOIN Item ON Negozio.Oggetto = Item.ID
                WHERE Proprietario = ?
                ORDER BY Item.ID";

        $stmtRecupero = $conn->prepare($sql);
        $stmtRecupero->bind_param('i', $accountId);
        $stmtRecupero->execute();
        $result = $stmtRecupero->get_result();

        $output = [];
        if($result->num_rows <  MAX_SHOP_ITEMS || $tempoTrascorso >= SHOP_TIMER_RESET_SECONDS){
            $output = refreshShop($accountId, $currentTime, $conn);
        }
        else{
            while($row = $result->fetch_assoc())
                $output[] = $row;
        }

        $remainingTime = getRemainingTime($currentTime, $lastRefresh);

        return [
            "output" => $output,
            "remainingTime" => $remainingTime
        ];
    }
    catch(Exception $e){
        error_log("Errore in getShop: ". $e->getMessage());
        apiError(500, "Errore durante il recupero del negozio: ". $e->getMessage());
    }
    finally{
        if($stmtRecupero)   $stmtRecupero->close();
        $conn->close();
    }
}

/**
 * Aggiorna il negozio di un account forzando il refresh degli oggetti disponibili.
 * @param int $id ID dell'account
 * @param DateTime $currentTime Timestamp dell'aggiornamento
 * @param mysqli $conn connessione al database passata per riferimento
 * @return array Contiene gli item attualmente nel negozio e il timestamp dell'aggiornamento
 */
function refreshShop($id, $currentTime, &$conn){
    if ($conn->connect_error){
        apiError(500, "Connessione al database fallita: " . $conn->connect_error);
    }

    $conn->begin_transaction();

    $stmtUpdate = null;
    $stmtDelete = null;
    $stmtItems = null;
    $stmtInsert = null;

    try {
        // Aggiornamento del RefreshNegozio
        $sqlUpdate = "UPDATE Account SET RefreshNegozio = ? WHERE ID = ?";
        $stmtUpdate = $conn->prepare($sqlUpdate);
        $formattedTime = $currentTime->format('Y-m-d H:i:s');
        $stmtUpdate->bind_param('si', $formattedTime, $id);
        if (!$stmtUpdate->execute())
            throw new Exception("Errore durante l'aggiornamento del timestamp di RefreshNegozio: " . $stmtUpdate->error);


        // Elimino il negozio attuale
        $sqlDelete = "DELETE FROM Negozio WHERE Proprietario = ?";
        $stmtDelete = $conn->prepare($sqlDelete);
        $stmtDelete->bind_param('i', $id);
        if (!$stmtDelete->execute())
            throw new Exception("Errore durante l'eliminazione degli oggetti dal negozio: " . $stmtDelete->error);

        // Recupero di MAX_SHOP_ITEMS item casuali
        $sqlItems = "SELECT * FROM Item ORDER BY RAND() LIMIT ?";
        $stmtItems = $conn->prepare($sqlItems);
        $maxItems = MAX_SHOP_ITEMS;
        $stmtItems->bind_param('i', $maxItems);
        if (!$stmtItems->execute())
            throw new Exception("Errore durante il recupero degli oggetti casuali: " . $stmtItems->error);
        $result = $stmtItems->get_result();

        $newShopItems = [];
        while ($row = $result->fetch_assoc()){
            $newShopItems[] = $row;
        }

        // Ordino gli item secondo l'ID, così da avere sempre lo stesso output quando le recupero
        usort($newShopItems, function($a, $b){
            return $a['ID'] <=> $b['ID'];
        });

        // Inserimento degli Item nel Negozio
        $sqlInsert = "INSERT INTO Negozio (Proprietario, Oggetto) VALUES (?, ?)";
        $stmtInsert = $conn->prepare($sqlInsert);
        foreach ($newShopItems as $item){
            $stmtInsert->bind_param('ii', $id, $item['ID']);
            if (!$stmtInsert->execute())
                throw new Exception("Errore durante l'inserimento di". $item["ID"] ." nel negozio: " . $stmtInsert->error);
        }

        $conn->commit();
        return [
            "updateTime" => $currentTime,
            "items" => $newShopItems
        ];
    } catch (Exception $e){
        $conn->rollback();
        error_log("Errore in refreshShop: ". $e->getMessage());
        apiError(500, "Errore durante il refresh del negozio: " . $e->getMessage());
    }
    finally{
        if($stmtUpdate) $stmtUpdate->close();
        if($stmtDelete) $stmtDelete->close();
        if($stmtItems)  $stmtItems->close();
        if($stmtInsert) $stmtInsert->close();
    }
}

/**
 * Calcola il tempo rimanente al refresh del negozio
 * @param DateTime $currentTime Timestamp di riferimento passato come riferimento
 * @param DateTime $shopRefresh Timestamp dell'ultimo refresh
 * @return array{minutes: string, seconds: string} Tempo rimanente in minuti e secondi nel formato a doppia cifra.
 */
function getRemainingTime(&$currentTime, $shopRefresh){
    $passedSeconds = ($currentTime->getTimestamp() - $shopRefresh->getTimestamp()) % SHOP_TIMER_RESET_SECONDS;

    $remainingSeconds = SHOP_TIMER_RESET_SECONDS - $passedSeconds;

    /*
    * Aggiorno il currentTime in modo "fittizio" per simulare il momento esatto
    * in cui sarebbe avvenuto l'aggiornamento del negozio, nel caso in cui non ci fossimo mai scollegati.
    * Risolvo anche il problema dei secondi persi durante la comunicazione con il server.
    */
    $currentTime->modify("-". $passedSeconds ." seconds");

    $minutes = intdiv($remainingSeconds, 60);
    $seconds = $remainingSeconds % 60;

    return [
        'minutes' => str_pad($minutes, 2, "0", STR_PAD_LEFT),
        'seconds' => str_pad($seconds, 2, "0", STR_PAD_LEFT)
    ];
}

/**
 * Recupera tutti gli `elementi` dal database, inclusi i relativi modificatori e percorsi.
 * @return array Ritorna i dati recuperati dal database.
 */
function getAllPG(){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        apiError(500, "Connessione al database fallita: ". $conn->connect_error);
    }

    $stmt = null;

    try{
        $sql = "SELECT *
                FROM Element";
        $stmt = $conn->prepare($sql);
        if(!$stmt->execute()){
            throw new Exception( $stmt->error);
        }

        $result = $stmt->get_result();

        $output = [];
        while($row = $result->fetch_assoc())
            $output[] = $row;

        return $output;

    }
    catch(Exception $e){
        apiError(500, "Errore nella funzione getAllPG: ". $e->getMessage());
    }
    finally{
        if($stmt)   $stmt->close();
        $conn->close();
    }
}

/**
 * Recupera dal database tutti i tipi validi
 * @throws Exception se ci sono problemi con la query
 * @return array contenente tutti gli `ItemTypes` contenuti nel database
 */
function getItemTypes(){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        apiError(500, "Connessione al database fallita: ". $conn->connect_error);
    }

    $stmt = null;

    try{
        $sql = "SELECT *
                FROM ItemType";
        $stmt = $conn->prepare($sql);
        if(!$stmt->execute()){
            throw new Exception( $stmt->error);
        }

        $result = $stmt->get_result();

        $output = [];
        while($row = $result->fetch_assoc())
            $output[] = $row['Nome'];

        return $output;

    }
    catch(Exception $e){
        apiError(500, "Errore nella funzione getItemTypes: ". $e->getMessage());
    }
    finally{
        if($stmt)   $stmt->close();
        $conn->close();
    }
}

/**
 * Funzione che seleziona un personaggio tra gli account non online al momento
 * @param int $accountToAvoid id dell'account che inizializza la battaglia, ergo quello dal quale non prendere i personaggi
 * @param int $livello indica il livello al quale cercare l'avversario. Verrà selezionato nel range `[1; $livello + 1]`
 * @return Personaggio|null personaggio estratto se presente, alrimenti `null`
 */
function getRandomPG($accountIdToAvoid, $livello){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        error_log("Connessione al database fallita: " . $conn->connect_error);
        pageError(500);
    }

    $stmt = null;
    try {
        $sql = "SELECT Nome, Proprietario, Elemento
                FROM Personaggi
                WHERE Proprietario <> ? 
                    AND Livello <= ?
                ORDER BY RAND() LIMIT 1";
        $stmt = $conn->prepare($sql);
        $upperLevel = $livello + 1;
        $stmt->bind_param('ii', $accountIdToAvoid, $upperLevel);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        if(!$row){
            return null;
        }
        $randomPG = new Personaggio($row["Nome"], $row['Proprietario'], null);
        
        return $randomPG;
    }
    finally {
        if($stmt) $stmt->close();
        $conn->close();
    }
}

/**
 * Questa funzione aggiorna i dati relativi allo stato dei personaggi e la data dell'ultimo turno per una battaglia specifica
 * @param array $battagliaInfo Array associativo preso per riferimento contenente le informazioni della battaglia
 * @param boolean|null $terminata `true` indica che ha vinto il personaggio1, `false` che ha vinto il perosnaggio2. Se non ha vinto nessuno da mantenere `null` [Default: `null`]
 * @throws Exception Se la connessione al database fallisce o se si verifica un errore durante l'update.
 * @return bool Restituisce `true` se l'aggiornamento è andato a buon fine.
 */
function updateGame(&$battagliaInfo, $terminata = null){
    $conn = new mysqli(DB_HOST, DB_USER, DB_PWD, DATABASE);
    if($conn->connect_error){
        throw new Exception("Connessione al database fallita: " . $conn->connect_error, 500);
    }

    $conn->begin_transaction();
    $stmt = null;
    try {
        // Prepara lo stato aggiornato dei personaggi
        $pg1 = unserialize($battagliaInfo['pg1']);
        $pg2 = unserialize($battagliaInfo['pg2']);
        $statoPersonaggi = [
            "pg1" => $pg1->getAll(),
            "pg2" => $pg2->getAll()
        ];
        $statoPersonaggiJson = json_encode($statoPersonaggi);

        $sql = ($terminata === null)?
			"UPDATE Combattimenti
			 SET StatoPersonaggi = ?, DataUltimoTurno = ?
			 WHERE Giocatore1_Nome = ? AND Giocatore1_Proprietario = ? AND Terminata = 0":
			"UPDATE Combattimenti
			 SET Vittoria_Giocatore1 = ?
             WHERE Giocatore1_Nome = ? AND Giocatore1_Proprietario = ? AND Terminata = 0";

        $stmt = $conn->prepare($sql);

        $dataUltimoTurno = unserialize($battagliaInfo['DataUltimoTurno'])->format('Y-m-d H:i:s');

		$types = ($terminata === null)? "sssi" : "isi";
		$vars  = ($terminata === null)? 
		[$statoPersonaggiJson, $dataUltimoTurno, $battagliaInfo['Giocatore1_Nome'], $battagliaInfo['Giocatore1_Proprietario']]:
		[$terminata, $battagliaInfo['Giocatore1_Nome'], $battagliaInfo['Giocatore1_Proprietario']];
		
        $stmt->bind_param($types, ...$vars);
            

        if(!$stmt->execute()){
            $conn->rollback();
            throw new Exception("Errore durante l'update della battaglia: " . $stmt->error, 500);
        }

		if($terminata !== null){
			$battagliaInfo['Vittoria_Giocatore1'] = $terminata;
			$battagliaInfo['Terminata'] = true;
			$battagliaInfo['DataUltimoTurno'] = null;
			$battagliaInfo['Turno_Giocatore1'] = null;
		}
        $conn->commit();
        return true;
    }
    finally {
        if($stmt) $stmt->close();
        $conn->close();
    }
}