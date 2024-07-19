<!DOCTYPE html>
<html lang="en-US">

<head>
    <meta charset="utf-8">
    <title> Social Memory </title>

    <link rel="stylesheet" href="../css/game.css">
    <link rel="stylesheet" href="../css/game_footer.css">
    <link rel="stylesheet" href="../css/left_player.css">
    <link rel="stylesheet" href="../css/right_player.css">

    <script src='../js/game.js'></script>

</head>

<body onload="setUp()">

    <div id='field'>
        <div id='leftPlayer'>
            <img id='leftTwentyFivePercent' src='../images/players/uncheckedTwentyFiveLeft.png' width="80" height="80" alt='Left TwentyFivePercent'>
            <img id='leftSwap' src='../images/players/uncheckedSwapLeft.png' width="80" height="80" alt='Left Swap'>
            <img id='leftTwice' src='../images/players/uncheckedTwiceLeft.png' width="80" height="80" alt='Left Twice'>
            <img id='leftProfile' src='../images/players/uncheckedStatsLeft.png' onclick="showProfile(0)" width="80" height="80" alt='Left Profile'>
            <img id='leftLogout' src='../images/players/uncheckedLogoutLeft.png' onclick="logOut(0)" width="80" height="80" alt='Left Logout'>
            <p id='leftName'> </p>
            <img id='leftScore' src='../images/scores/0Left.png' alt='Left Score' width="80" height="80">

        </div>

        <div id ='game'>

            <table id='gameField'>
            </table>

            <p id='turnPlayerReminder'> </p>

        </div>

        <div id='rightPlayer'>
            <img id='rightTwentyFivePercent' src='../images/players/uncheckedTwentyFiveRight.png' width="80" height="80" alt='Right TwentyFivePercent'>
            <img id='rightSwap' src='../images/players/uncheckedSwapRight.png' width="80" height="80" alt='Right Swap'>
            <img id='rightTwice' src='../images/players/uncheckedTwiceRight.png' width="80" height="80" alt='Right Twice'>
            <img id='rightProfile' src='../images/players/uncheckedStatsRight.png' onclick="showProfile(1)" width="80" height="80" alt='Right Profile'>
            <img id='rightLogout' src='../images/players/uncheckedLogoutRight.png' onclick="logOut(1)" width="80" height="80" alt='Right Logout'>
            <p id='rightName'> </p>
            <img id='rightScore' src='../images/scores/0Right.png' alt='Right Score' width="80" height="80">

        </div>
    
    </div>
    
    <footer id='navigationBar'>

        <img id='manual' src='../images/footer/uncheckedManual.png' onclick="showManual()" width="60" height="60" alt='Manual Button'>
        <img id='newGame' src='../images/footer/uncheckedPlayGame.png' onclick="playGame()" width="60" height="60" alt='Play Game Button'>
        <img id='exitGame' src='../images/footer/uncheckedExitGame.png' onclick="leaveGame()" width="60" height="60" alt='Exit Game Button'>
        <img id='logOutAll' src='../images/footer/uncheckedLogOutAll.png' onclick="logOutAll()" width="60" height="60" alt='Logout All Button'>

    </footer>

</body>

</html>