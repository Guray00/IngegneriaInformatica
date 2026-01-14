<?php

require_once __DIR__ . "/../DBMS.php";

class PrintTableDBMS extends DBMS{
    
    //sistema di ranking
    public static function recordRanking(){
        self::connectDBMS();
        // Inizializza le variabili MySQL
        self::$pdo->exec("SET @rank := 0;");
        self::$pdo->exec("SET @prev_record := NULL;");
        $query = "
                    SELECT 
                    @rank := IF(@prev_record = record, @rank, @rank + 1) AS pos,
                    username,
                    @prev_record := record AS record
                    FROM (
                    SELECT username, record
                    FROM Player
                    ORDER BY record DESC
                    ) AS p;
                ";
        $statement = self::$pdo->prepare($query);
        $result = $statement->execute();
        $row = $statement->fetchAll(PDO::FETCH_ASSOC);
        return $row;
    }

    //funzione per restituire i migliori 20 performance dell'utente che ha loggato precedentemente
    public static function history($username){
        if($username === null) return null;
        self::connectDBMS();
        // ordiniamo la tabella per punteggio,data della partita, username del giocatore e se ha vinto o no in ordine decrescente
        $query = "
        SELECT 
            Player.username, 
            ScorePlayer.points, 
            DATE_FORMAT(ScorePlayer.playerDate, '%d/%m/%Y %H:%i:%s') AS date,
            IF(ScorePlayer.won IS TRUE, 'vinto', 'perso') AS won
        FROM Player 
        INNER JOIN ScorePlayer ON Player.id = ScorePlayer.playerId
        WHERE Player.username = ?
        ORDER BY ScorePlayer.points DESC, ScorePlayer.playerDate DESC, Player.username ASC, ScorePlayer.won DESC
        LIMIT 20;
    ";

        $statement = self::$pdo->prepare($query);
        $result = $statement->execute([$username]);
        
        if($result === null) return null;

        //restituisco il risultato delle righe della tabella
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);
        return $rows;
    }

}
?>