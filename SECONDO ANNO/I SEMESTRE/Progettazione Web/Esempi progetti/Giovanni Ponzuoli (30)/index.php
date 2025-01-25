<!DOCTYPE html>
<html lang="it">

<head>
    <meta charset="utf-8">
    <title> Social Memory </title>

    <link rel="stylesheet" href="./css/home.css">

    <script src="./js/home.js"></script>

</head>

<body onload="setUp()">

    <div id='interaction'>
        <p><img src='./images/backgrounds/Logo.png' alt='Social Memory Logo'></p>
        <p>
            <button id='intManual' onclick="showManual()"></button> <br>
            <button id='intRanking' onclick="showRanking()"></button> <br>
            <button id='playGame' onclick="window.location.href ='./php/login.php'">Play the game!</button>
        </p>
    </div>

    <div id="manual">
        <p><img src='./images/backgrounds/Manual.png' alt='Social Memory Manual'></p>

        <h2>Climb the Charts</h2>
        <p>
            Diventa il maestro del Social Memory scalando la classifica degli utenti. Sfida gli iscritti ad una partita testa a testa senza precedenti
        </p>

        <h2>Accounting</h2>
        <p>
            Accedi al gioco inserendo le tue credenziali User e Password,per la quale è messo a disposizione il recupero. Se invece non sei ancora iscritto passa alla pagina di Sign Up per ottenere il tuo profilo e sarai loggato automaticamente
        </p>
        <p>
            Il gioco è implementato considerando il monitor come se fosse il tavolo da gioco perciò verrà utilizzato il puntatore del mouse a turno per fare le selezioni. Non appena saranno loggati entrambi i giocatori si aprirà il terreno di gioco
            e la sfida avrà inizio clickando su <img src='./images/footer/checkedPlayGame.png' width="60" height="60" alt="Play Game Button">
        </p>
        <p>
            Una volta dentro alla schermata di gioco sarà comunque possibile resettare gli utenti loggati utilizzando il tasto <img src='./images/footer/checkedLogOutAll.png' width="60" height="60" alt="Log Out All Button"> ,il quale permette di fare
            il logout combinato di entrambi i giocatori
        </p>

        <h2> Ingame helps</h2>
        <p> Sono stati aggiunti 3 aiuti rispetto alla versione del memory classico, utilizzabili esclusivamente dal giocatore di turno una sola volta per partita:<br><br> 25% Choice : dopo aver scoperto una carta, la pressione del tasto <img src='./images/players/checkedTwentyFiveLeft.png'
                width="60" height="60" alt="25% Choice Button"> indica quattro caselle contrassegnandole in verde, delle quali una è la compagna della carta scoperta<br> Swap : dopo aver scoperto una carta, la pressione del tasto <img src='./images/players/checkedSwapLeft.png'
                width="60" height="60" alt="Swap Button"> indica due posizioni contrassegnate col colore giallo. La carta precedentemente selezionata viene scambiata di posto con l'altra indicata, permettendo inoltre al giocatore di turno di selezionare nuovamente
            la sua prima scelta
            <br> Double Turn : prima di scoprire una carta, la pressione del tasto <img src='./images/players/checkedTwiceLeft.png' width="60" height="60" alt="Double Turn Button">dichiara l'intenzione di svolgere due turni consecutivi. Ciò comporta che
            dopo il primo errore, il giocatore di turno rimane sempre lo stesso
        </p>

        <h2>Stats Section</h2>
        <p> Le funzionalità messe a disposizione dall'account permettono tramite l'apposito tasto <img src='./images/players/checkedStatsLeft.png' width="60" height="60" alt="Stats Button"> di conoscere lo storico delle proprie partite, ricercando anche nel
            database la cronologia dei match giocati contro l'avversario corrente</p>


        <h2>Leave the match</h2>
        <p>Sarà possibile all'interno della partita effettuare il logout attraverso l'apposito tasto <img src='./images/players/checkedLogoutLeft.png' width="60" height="60" alt="Logout Button"> al costo di perdere la stessa</p>
        <p>Il gioco mette a disposizione inoltre la possibilità di uscire di comune accordo dalla partita con il tasto <img src='./images/footer/checkedExitGame.png' width="60" height="60" alt="Exit Game Button"></p>
    </div>

    <div id="ranking">
        <p><img src='./images/backgrounds/Ranking.png' alt='Social Memory Ranking'></p>
        <table id='rank'>
            <thead>
                <tr>
                    <th></th>
                    <th>User</th>
                    <th>Tier</th>
                    <th>Score</th>
                </tr>
            </thead>

            <tbody>

                <?php 
            
                require_once './config/database.php';
            
                $connection = new cncDB();
                $pdo = $connection->getPD0();

                $sql = 'SELECT      * 
                        FROM        account 
                        ORDER BY    Score  DESC';
                $result = $pdo->prepare($sql);
                $result->execute();

                $qst = $result->fetchAll(pdo::FETCH_ASSOC);
                
                foreach($qst as $item):?>
                    <tr <?php
                            switch ($item) {
                                case $qst[0]:
                                    echo "class = 'firstPlayer'";
                                    break;
                                case $qst[1]:
                                    echo "class = 'secondPlayer'";
                                    break;
                                case $qst[2]:
                                    echo "class = 'thirdPlayer'";
                                    break;
                                default:
                                    echo "class = 'normalPlayer'";
                                    break;
                        }?>>    
                            <td <?php
                                    switch ($item) {
                                        case $qst[0]:
                                            echo "class = 'firstPlayer'";
                                            break;
                                        case $qst[1]:
                                            echo "class = 'secondPlayer'";
                                            break;
                                        case $qst[2]:
                                            echo "class = 'thirdPlayer'";
                                            break;
                                        default:
                                            echo "class = 'normalPlayer'";
                                            break;
                                }?>></td>  
                            <td><?php echo $item['Username']?></td> 
                            <td><?php 
                                    if ($item['Score'] < 150){
                                        echo 'Rookie';
                                    } else if($item['Score'] >= 150 && $item['Score'] < 325){
                                        echo 'Intermediate';
                                    } else if($item['Score'] >= 325 && $item['Score'] < 500){
                                        echo 'Expert';
                                    } else if($item['Score'] >= 500 && $item['Score'] < 725){
                                        echo 'Pro';
                                    } else if($item['Score'] >= 725 && $item['Score'] < 1000){
                                        echo 'All-Pro';
                                    } else{
                                        echo 'Legend';
                                    }
                                ?></td>
                            <td><?php echo $item['Score']?></td> 
                    </tr>                       
                <?php endforeach;

                $connection->close();
                $pdo = null;
                ?>
            </tbody>
        </table>
    </div>
</body>