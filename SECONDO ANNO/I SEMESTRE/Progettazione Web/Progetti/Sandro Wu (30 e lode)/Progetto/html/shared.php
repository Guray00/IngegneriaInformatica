<!DOCTYPE html>

<!-- Firefox 92.0.1 e Chrome 94.0.4606.61. -->

<html lang="en">
  <head>
    <title>Simple Go Game</title>

    <link rel="stylesheet" href="../css/main.css" />
    <link rel="stylesheet" href="../css/topNavigation.css" />
    <link rel="stylesheet" href="../css/leftNavigation.css" />

    <style>
      main {
        display: flex;
        flex-direction: column;
        
      }

      main section {
        display: flex;
        justify-content: space-around;
      }

      main > div {
        width: fit-content;
      }

      .game {
        background-color: rgb(220, 179, 92);
        background-image: url("../image-icon/kaya.jpg");
        width: fit-content;
        height: fit-content;
        border-radius: 20px;
      }

      .game canvas {
        /* width: min(40vw, 400px); */
        width: 100%;
      }

      .gamebox {
        width: 400px;
      }

      .gamebox > span {
        display: flex;
        justify-content: space-around;
        gap: 10px;

        font-size: small;
        font-style: italic;
      }

      main {
        display: flex;
        flex-direction: row;

        flex-wrap: wrap;
        justify-content: space-around;
        row-gap: 30px;
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
      <script>
        const main = document.getElementsByTagName("main")[0];
        let games = [];

        fetch("../php/getshared.php", {
          method: "post",
        })
          .then((response) => response.json())
          .then((data) => {
            console.log(data);
            if (data.games) loadGames(data.games);
            else console.log(data.error);
          })
          .catch((error) => console.log(error));

        function loadGames(ajaxGames) {
          console.log(ajaxGames.length);

          const main = document.getElementsByTagName("main")[0];

          if (ajaxGames.length == 0) {
            let p = document.createElement("p");
            p.textContent = "There is no game shared :(";
            main.appendChild(p);
          } else {
            let i = 0;
            ajaxGames.forEach((game) => {
              let box = document.createElement("div");
              box.classList += "gamebox";
              main.appendChild(box);

              let span = document.createElement("span");
              box.appendChild(span);

              [
                "user: " + game["Username"],
                game["CreatedTime"],
              ].forEach((str) => {
                let p = document.createElement("span");
                p.textContent = str;
                span.appendChild(p);
              });

              let gamediv = document.createElement("div");
              gamediv.classList += "game";
              box.appendChild(gamediv);

              let go = new GoGame(gamediv, game["BoardSize"]);
              go.id = game["ID"];

              go.loadFromDB(go.id);
              go.setReadOnly();

              gamediv.onclick = () => openGamePage(go);

              games[i++] = go;
            });
          }
        }

        function openGamePage(go) {
          console.log(go);
          const moves = go.logic.moveHistory.map((move) => move.cell);

          // no sessionStorage.setItem("gameid", go.id);
          sessionStorage.setItem("gameSize", go.logic.size);
          sessionStorage.setItem("gameMoves", JSON.stringify(moves));
          console.log("Saved in session storage");
          window.location.href = "../html/game.php";
        }
      </script>
    </main>
  </body>
</html>
