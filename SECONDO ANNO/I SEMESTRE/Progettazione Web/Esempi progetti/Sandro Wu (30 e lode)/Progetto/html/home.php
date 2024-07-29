<!DOCTYPE html>

<!-- Firefox 92.0.1 e Chrome 94.0.4606.61. -->

<html>

<head>
  <title>Simple Go Game</title>

  <link rel="stylesheet" href="../css/main.css" />
  <link rel="stylesheet" href="../css/topNavigation.css" />
  <link rel="stylesheet" href="../css/leftNavigation.css" />

  <style>
    /*   #FAFDF3  */
    main {
      display: flex;
      flex-direction: row;
    }

    main section {
      display: flex;
      justify-content: space-around;
    }

    main > div {
      width: 50%;
    }

    #gameBox {
      background-color: rgb(220, 179, 92);
      background-image: url("../image-icon/kaya.jpg");
      width: fit-content;
      height: fit-content;
      border-radius: 20px;
    }

    #gameBox{
      width: 95%;
    }
    #gameBox canvas {
      width: 100%;
    }

    main > div > section{
      display: flex;
    }

    main > div:nth-child(2){
      display: flex;
      align-items: center;
      justify-content: center;
    }

    fieldset{
      border-radius: 20px;
      box-shadow: 2px 2px 5px  lightgray;
    }
    
    form p{
      display: flex;
      justify-content: flex-end;
      gap: 10px;

      margin: 20px 10px;

      font-size: large;
    }
    
    form input {
      font-size: large;
      text-align: center;
      width: 50%;

      border: 1px solid rgb(0, 0, 0, 0.3);
      border-radius: 5px;
    }

    .buttons{
      display: flex;
      flex-direction: column;
      align-items: center;

    }
    .buttons button{
      padding: 8px 0;
      font-size: 1.1em;
      font-weight: 600;

      width: 70%;
      white-space: nowrap;

      border: none;
      border-radius: 10px;

      background-color: #2b89e1;
      color: white;

    }

    [hidden]{
      display: none;
    }


  </style>

  <script src="../js/goBoardCanvas.js"></script>
  <script src="../js/goGameLogic.js"></script>
  <script src="../js/goGame.js"></script>
</head>

<body>
  <?php if (session_status() === PHP_SESSION_NONE) {
    session_start();
  } ?>
  <?php include '../php/topNavigation.inc.php' ?>
  <?php include '../php/leftNavigation.inc.php' ?>

  <main>
    <div>
      <div id="gameBox"></div>
    </div>

    <div>

      <section>

        <form id="setgame">
          <fieldset>
            <legend>Set Game</legend>
            <p>
              <label for="b_name">Black Player </label>
              <input type="text" name="b_name" value="Black" />
            </p>
            <p>
              <label for="w_name">White Player</label>
              <input type="text" name="w_name" value="White" />
            </p>
            <p>
              <label for="komi">Komi</label>
              <input type="number" name="komi" value="6.5" min='0' max='10' step="0.5" />
            </p>
            <p>
              <label for="size"> Goban Size</label>
              <input name="size" type="number" list="sizelist" value="9" min="2" max="25" />
            </p>

            <datalist id="sizelist">
              <option value="9"> </option>
              <option value="13"></option>
              <option value="19"></option>
            </datalist>

            <p class="setgame error" hidden>Something went wrong...</p>

            <p class='buttons'>
              <button type="submit">Set New Demo</button>
              <button type="button" onclick="continueGame()"> Continue Demo </button>
              <button type="button" onclick="newGame()"> Open New Game </button>
            </p>
          </fieldset>
        </form>

      </section>

    </div>
  </main>

  <script>
    let boardSize = 13;
    let gameBox = document.getElementById("gameBox");
    let go = new GoGame(gameBox, boardSize);

    document.body.onload = () => {
      go.loadFromSessionStorage();
      go.id = null;
    };

    function continueGame() {
      go.saveInSessionStorage();
      window.location.href = "../html/game.php";
    }

    const form = document.getElementById('setgame');
    form.onsubmit = newDemo;

    function newDemo(event) {
      if (event)
        event.preventDefault();

      console.log('set game');

      const defaults = ['black', 'white', '6.5', '13', ''];
      const inputs = Array.from(
        form.getElementsByTagName('input')).map(
        (input, i) => input.value ? input.value : defaults[i]
      );

      let [black, white, komi, size, ] = inputs;

      const players = {
        black: black,
        white: white,
        komi: Number.parseFloat(komi)
      }

      go.loadGame([], Number.parseInt(size));
      go.setPlayers(players);

      go.saveInSessionStorage();
    }

    function newGame() {
      newDemo();
      window.location.href = '../html/game.php';
    }
  </script>

</body>

</html>