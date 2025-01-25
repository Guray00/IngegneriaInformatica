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
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
    }

    h3 {
      font-weight: bold;
      font-size: 2em;
      margin: 50px;
    }

    h3 span {
      box-shadow: 1px 1px 30px #e9f2dc;
      border-radius: 20px;
      padding: 15px 30px;
    }

    h4 {
      font-style: italic;
      font-size: 1.5em;
    }

    #statistic {
      font-size: 1.2em;
      font-weight: 600;
    }

    table,
    th,
    td {
      border: 0.5px solid black;
      border-collapse: collapse;
      text-align: center;
    }

    table {
      margin: 60px 0px;
      box-shadow: 0px 0px 100px 20px #ffdf4180;
    }

    td,
    th {
      padding: 10px 20px;
      white-space: nowrap;
      font-size: large;
    }

    tr:hover {
      cursor: pointer;
    }
  </style>
</head>

<body>
  <?php if (session_status() === PHP_SESSION_NONE) session_start(); ?>
  <?php include '../php/topNavigation.inc.php' ?>
  <?php include '../php/leftNavigation.inc.php' ?>

  <main>
    <div>
      <h3>
        <span>
          <?php echo $_SESSION['username'] ?>
        </span>
      </h3>

      <h4>My Games</h4>
      <section id="statistic"></section>
      <h4 id="total">Total : 0</h4>
    </div>

    <div>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Shared</th>
            <th>Size</th>
            <th>Black</th>
            <th>White</th>
            <th>Created Time</th>
          </tr>
        </thead>

        <tbody></tbody>
      </table>
    </div>
  </main>

  <script>
    let g = [];

    fetch("../php/getprofile.php")
      .then((resp) => resp.json())
      // .then(data => console.log(data))
      .then((data) => {
        table(data.games);
        g = data;
      });

    function info(data) {}

    function table(games) {
      console.log(games);

      const thead = document.getElementsByTagName("thead")[0];
      const tbody = document.getElementsByTagName("tbody")[0];
      const total = document.getElementById("total");
      const statistic = document.getElementById("statistic");

      total.textContent = "Total: " + games.length;

      let sizes = {};

      games.forEach((element) => {
        const tr = document.createElement("tr");

        for (let [key, value] of Object.entries(element)) {
          let td = document.createElement("td");
          tr.appendChild(td);

          switch (key) {
            case "Shared":
              value = value ? "V Shared" : "X Private";
              break;
            case "BoardSize":
              sizes[value] = sizes[value] ? sizes[value] + 1 : 1;
              break;
            case "Black":
            case "White":
              value = value == null ? "-" : value;
              break;
          }

          td.textContent = value;

          if (key == "ID") {
            td.innerHTML = `<a href='./game.php?gameid=${value}'> ${value} </a>`;
            tr.onclick = () => {
              window.location.href = `./game.php?gameid=${value}`
            }
          }
          tr.onmouseover = () => {
            tr.style.background = '#F0F0F0'
          }
          tr.onmouseout = () => {
            tr.style.background = ''
          }
        }

        tbody.appendChild(tr);

      });

      // console.log(sizes);

      for (let [k, v] of Object.entries(sizes)) {
        // console.log(k, v);

        let p = document.createElement("p");
        p.textContent = ` ${k}x${k}: ${v} `;
        statistic.appendChild(p);
      }
    }
  </script>
</body>

</html>