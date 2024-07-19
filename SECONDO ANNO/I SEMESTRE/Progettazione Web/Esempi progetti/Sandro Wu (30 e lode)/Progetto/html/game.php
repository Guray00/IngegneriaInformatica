<!DOCTYPE html>

<!-- Firefox 92.0.1 e Chrome 94.0.4606.61. -->

<html>

<head>
  <title>Simple Go Game</title>

  <link rel="stylesheet" href="../css/main.css" />
  <link rel="stylesheet" href="../css/topNavigation.css" />
  <link rel="stylesheet" href="../css/leftNavigation.css" />

  <style>
    main {
      display: flex;
    }

    .left {
      width: 60%;
    }

    main>section {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }

    #gameBox {
      background-color: rgb(220, 179, 92);
      background-image: url("../image-icon/kaya.jpg");
      width: fit-content;
      height: fit-content;
      border-radius: 20px;
    }

    #gameBox {
      width: min(95%, 80vh);
    }

    #gameBox canvas {
      width: 100%;
    }

    canvas:nth-of-type(2) {
      cursor: pointer;
    }

    #actionBar {
      display: flex;
      justify-content: space-around;
      width: 80%;
    }

    #actionBar button {
      width: 18%;

      background-color: #ebf3fa;
      border: 1px solid black;
      padding: 12px;
      margin: 10px 0;

      border-radius: 10px;

      font-size: medium;
      font-weight: bold;
      overflow: hidden;
    }

    .playerBox {
      border: 1px solid gray;
      width: 200px;

      margin-bottom: 10px;
      border-radius: 20px;

      box-shadow: 1px 1px 10px rgb(0, 0, 0, 0.2);

      text-align: center;
      white-space: nowrap;
    }

    .playerBox:nth-child(1) {
      background-color: rgb(0, 0, 0, 0.9);
      color: white;
    }

    .playerBox:nth-child(2) {
      background-color: white;
    }


    .playerBox p {
      font-size: large;
      font-style: italic;
      font-weight: 600;
    }

    .right button {
      padding: 8px 0;
      font-size: 1.1em;
      font-weight: 600;

      width: 100%;
      white-space: nowrap;

      border: 1px solid blanchedalmond;
      border-radius: 10px;
      margin-top: 15px;

      background-color: #2b89e1;
      color: white;
    }
  </style>

  <script src="../js/goBoardCanvas.js"></script>
  <script src="../js/goGameLogic.js"></script>
  <script src="../js/goGame.js"></script>
</head>

<body>
  <?php if (session_status() === PHP_SESSION_NONE) session_start(); ?>
  <?php include '../php/topNavigation.inc.php' ?>
  <?php include '../php/leftNavigation.inc.php' ?>

  <main>
    <section class="left">
      <div id="gameBox"></div>

      <section id="actionBar">
        <button style="font-size: large">&#171;</button>
        <button>&#9654;</button>
        <button style="font-size: large">&#187;</button>
        <button>UNDO</button>
        <button>PASS</button>
      </section>
    </section>

    <section class="right">
      <div class="playerBox">
        <p>Black</p>
        <p>User 1</p>
        <p></p>
      </div>

      <div class="playerBox">
        <p>White</p>
        <p>User 2</p>
        <p>Komi</p>
        <p></p>
      </div>

      <button onclick="saveGame()">Save game</button>
      <button onclick="changeShared()">Share / Set Private</button>
      <button onclick="deleteGame()">Delete game</button>
    </section>
  </main>

  <script>
    let go;
    document.body.onload = () => {
      // Default
      let boardSize = 13;
      let gameBox = document.getElementById("gameBox");
      go = new GoGame(gameBox, boardSize);

      const urlSearchParams = new URLSearchParams(window.location.search);
      const gameid = urlSearchParams.get("gameid");

      if (gameid) {
        go.loadFromDB(gameid);
      } else {
        go.loadFromSessionStorage();
      }

      // Set Buttons
      const buttons = document
        .getElementById("actionBar")
        .getElementsByTagName("button");
      const [back, play, next, undo, pass] = [...buttons];

      // Play button
      let playid = null;
      play.state = ["▶", "▶▶", "| |"]; // altern. charcode 9654 124 8201 or innerHTML &#9654; &vert; &thinsp;
      play.stateIndex = 0;

      play.onclick = () => {
        go.showNextStep();
        clearInterval(playid);

        play.stateIndex = (play.stateIndex + 1) % play.state.length;
        play.textContent = play.state[play.stateIndex];
        switch (play.stateIndex) {
          case 0:
            play.speed = 0;
            return;
          case 1:
            play.speed = 1500;
            break;
          case 2:
            play.speed = 1000;
            break;
        }

        playid = setInterval(() => {
          const islastmove = go.showNextStep();
          if (islastmove) {
            clearInterval(playid);
            play.stateIndex = 0;
            play.textContent = play.state[play.stateIndex];
          }
        }, play.speed);
      };
      back.onclick = () => {
        go.showBackStep();
      };
      next.onclick = () => {
        go.showNextStep();
      };
      undo.onclick = () => {
        go.undoMove();
        updateScore();
      };
      pass.onclick = () => {
        go.passMove();
      };

      // Set game functions

      const playerBox = document.querySelectorAll(".playerBox");
      const black = playerBox[0].getElementsByTagName("p");
      const white = playerBox[1].getElementsByTagName("p");

      go.board.layers.scoreLayer.addEventListener("click", updateScore);
      pass.addEventListener("click", updateScore);

      function updateScore() {
        if (go.logic.end) {
          black[2].textContent = "Score: " + go.scores[go.players[0].code];
          white[3].textContent = "Score: " + go.scores[go.players[1].code];
        } else {
          black[2].textContent = '';
          white[3].textContent = '';
        }
      }

      black[1].textContent = "Player: " + go.players[0].name;
      white[1].textContent = "Player: " + go.players[1].name;
      white[2].textContent = "Komi: " + go.komi;

      if (go.logic.end) {
        updateScore();
      }
    };

    function saveGame() {
      go.saveGame();
    }

    function changeShared() {
      go.changeShared();
    }

    function deleteGame() {
      go.deleteGame();
    }
  </script>
</body>

</html>