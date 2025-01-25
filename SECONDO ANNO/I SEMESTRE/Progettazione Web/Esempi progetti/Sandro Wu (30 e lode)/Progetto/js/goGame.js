
// Go Game Class
// it combines game logic and game canvas classes

class Player {
    constructor(name, color, playerCode) {
        this.name = name;
        this.color = color;     // canvas
        this.code = playerCode; // logic
    }
}


class GoGame {
    constructor(gameBox, boardSize) {
        this.board = new Board(gameBox, boardSize);
        this.logic = new GoLogic(boardSize);

        this.shownStep = 0;

        this.initPlayers();
        this.setOnClick();
        this.showHypotheticalStone();
    }

    setPlayers(players) {
        this.players = [
            new Player(players.black, 'black', 'b'),
            new Player(players.white, 'white', 'w')
        ]
        this.komi = players.komi;
    }

    initPlayers() {
        const players = {
            black: 'black',
            white: 'white',
            komi: 6.5
        }

        this.setPlayers(players);

        this.playersByCode = [];
        this.codes = [];
        this.scores = [];
        this.players.forEach(player => {
            this.playersByCode[player.code] = player;
            this.codes.push(player.code);
            this.scores[player.code] = 0;
        });

        this.turnPlayer = this.players[0];
        this.turnIndex = 0;
    }

    setReadOnly() {
        this.board.layers.stoneLayer.onclick = null;
        this.showHypotheticalStone(false);
    }

    setOnClick() {

        this.shownLastBoardState = true;

        this.board.layers.stoneLayer.onclick = event => {

            if (!this.shownLastBoardState) {
                this.showBoardStateAt(this.logic.currentStep);
                this.shownLastBoardState = true;

            } else {

                let [x, y] = this.board.getGridCoordinates(event, this);
                this.playMove(x, y);
            }
        }
    }

    playMove(x, y) {
        let result = this.logic.playMove([x, y], this.turnPlayer.code);
        // console.log(result);

        if (result.success) {
            // Update canvas
            this.board.drawStone(x, y, this.turnPlayer.color);
            result.capturedStones.forEach(cell => {
                this.board.clearStone(cell[0], cell[1]); // cell = [x,y]
            });

            // this.turnPlayer.capturedStones += result.capturedStones.length;

            // Update to next player
            this.turnIndex = (this.turnIndex + 1) % this.players.length;
            this.turnPlayer = this.players[this.turnIndex];

            // prevent clear by showHypotheticalStone
            this.lastMousePointX = this.lastMousePointY = null;

            // update shown step to last step
            this.shownStep = this.logic.currentStep;
        }
    }

    passMove() {
        console.log(this.turnPlayer.name + ' passed');

        this.logic.pass(this.turnPlayer.code);

        // Update to next player
        this.turnIndex = (this.turnIndex + 1) % this.players.length;
        this.turnPlayer = this.players[this.turnIndex];

        // update shown step to last step
        this.shownStep = this.logic.currentStep;

        if (this.logic.end) {
            this.setReadOnly();
            this.setScoreLayer();
            this.countScore();

            console.log('End Game: set scoring');
        }
    }

    undoMove() {
        if (this.logic.currentStep > 0) {

            if (this.logic.end) {
                this.logic.end = false;
                this.board.layers.scoreLayer.style.zIndex = -1;
                this.scoreBoard = null;

                this.setOnClick();
                this.showHypotheticalStone();

            }
            console.log("Undo: move " + this.logic.currentStep);

            // Update logic
            this.logic.currentStep--;
            this.logic.boardHistory.pop();
            const lastmove = this.logic.moveHistory.pop();
            if (lastmove.cell != null) {
                this.logic.removeStone(lastmove.cell);
            }
            this.logic.board = this.logic.boardHistory[this.logic.currentStep].board.map(row => row.slice());

            // Update canvas
            this.showBoardStateAt(this.logic.currentStep);

            // Update to previous player
            this.turnIndex = (this.turnIndex + this.players.length - 1) % this.players.length;
            this.turnPlayer = this.players[this.turnIndex];

            // update shown step to last step
            this.shownStep = this.logic.currentStep;

        } else {
            console.log("Nothing to undo");
        }


    }

    setScoreLayer() {

        const territory = this.logic.estimateTerritory(this.logic.board);
        const { unknow, board } = territory;

        this.unknowScorePoint = unknow;
        this.scoreBoard = board.map(x => x.slice());

        this.codes.push(unknow);
        this.codes = Array.from(new Set(this.codes));

        this.drawEstimated(board);

        this.board.layers.scoreLayer.style.zIndex = 10;
        this.board.layers.scoreLayer.onclick = event => {
            try {
                let [x, y] = this.board.getGridCoordinates(event, this);
                this.logic.isValid([x, y]);

                let code = this.scoreBoard[y][x];
                let next = (this.codes.indexOf(code) + 1) % this.codes.length;
                this.scoreBoard[y][x] = this.codes[next];

                this.drawEstimated(this.scoreBoard);
                this.countScore();
            } catch (e) {
                console.log(e);
            }
            // this.logic.log(this.scoreBoard);
        }

    }

    drawEstimated(board) {
        try {
            board.forEach((row, y) => {
                row.forEach((cell, x) => {
                    const code = cell;
                    if (code != this.unknowScorePoint) {
                        const color = this.playersByCode[code].color;
                        this.board.drawScorePoint(x, y, color);
                    } else {
                        this.board.drawScorePoint(x, y, 'red');
                    }

                })
            })

        } catch (e) {
            console.log(e);
        }
    }

    countScore() {
        if (!this.logic.end) {
            console.log('Game not finished');
            return;
        }

        let scores = [];
        this.codes.forEach(x => scores[x] = 0);

        this.scoreBoard.forEach((row, y) => {
            row.forEach((cell, x) => {
                scores[cell] = scores[cell] ? scores[cell] + 1 : 1;
            })
        })

        this.scores = scores;

        return scores;
    }


    showHypotheticalStone(show = true) {
        if (!show) {
            this.board.layers.stoneLayer.onmousemove = null;
            this.board.layers.stoneLayer.onmouseout = null;
            return;

        } else {

            this.board.layers.stoneLayer.onmouseout = () => {
                this.board.clearStone(this.lastMousePointX, this.lastMousePointY);
            }

            this.board.layers.stoneLayer.onmousemove = event => {

                const [x, y] = this.board.getGridCoordinates(event, this);

                if (!this.logic.isVoidCell([x, y])) {
                    this.board.clearStone(this.lastMousePointX, this.lastMousePointY);
                    this.lastMousePointX = this.lastMousePointY = null;

                    return;
                }

                const opacity = 0.2;
                const color = this.turnPlayer.color;

                if (this.lastMousePointX != x || this.lastMousePointY != y) {
                    // Clear last hipothetical stone
                    this.board.clearStone(this.lastMousePointX, this.lastMousePointY);

                    // Set the new one
                    this.board.contexts.stoneContext.globalAlpha = opacity;
                    this.board.drawStone(x, y, color);
                    this.board.contexts.stoneContext.globalAlpha = '1';
                }

                this.lastMousePointX = x;
                this.lastMousePointY = y;
            }
        }


    }

    showBoardStateAt(step) {

        if (step < 0 || step > this.logic.currentStep) {
            console.log("Not valid step: " + step);
            return;
        }

        this.shownLastBoardState = (step == this.logic.currentStep);


        this.board.resetStoneLayer();
        let board = this.logic.boardHistory[step].board;
        let type = this.logic.boardHistory[step].type;

        console.log("Board at step: " + step + " Move type: " + type);

        board.forEach((row, y) =>
            row.forEach((cell, x) => {

                if (cell != this.logic.getVoidCell()) {

                    let color = this.playersByCode[cell].color;
                    if (!color) {
                        console.log('Error: not valid code from cell');
                        return;
                    }
                    this.board.drawStone(x, y, color);
                }
            })
        )


    }

    showBackStep() {
        this.shownStep = Math.max(this.shownStep - 1, 0);
        this.showBoardStateAt(this.shownStep);

        return this.shownStep == 0;
    }

    showNextStep() {
        this.shownStep = Math.min(this.shownStep + 1, this.logic.currentStep);
        this.showBoardStateAt(this.shownStep);

        return this.shownStep == this.logic.currentStep;

    }

    loadGame(moves, size) {
        this.logic.rebuild(size);
        this.board.rebuild(size);
        this.initPlayers();

        for (const move of moves) {
            if (move == 'pass') {
                this.passMove();
            } else {
                const [x, y] = move;
                this.playMove(x, y);
            }
        }

    }

    loadFromSessionStorage() {
        const info = [
            "gameid",
            "gameSize",
            "gameKomi",
            "gameMoves",
            "gamePlayers"
        ]
        const data = info.map(key => JSON.parse(sessionStorage.getItem(key)))

        const [gameid, size, komi, moves, players] = data;

        if (size && moves) {
            this.loadGame(moves, size);

            this.id = gameid;
            this.komi = komi ? komi : 6.5;

            if (players) {
                this.players.forEach((p, i) => {
                    p.name = players[i] ? players[i] : p.name;
                })
            }

            console.log("Game loaded from session storage");
        } else {
            console.log("No game data in Session Storage")
        }
    }

    saveInSessionStorage() {

        const moves = this.logic.moveHistory.map(move => move.cell);

        sessionStorage.setItem("gameid", this.id ? this.id : 'null');
        sessionStorage.setItem("gameSize", this.logic.size);
        sessionStorage.setItem("gameKomi", this.komi);
        sessionStorage.setItem("gameMoves", JSON.stringify(moves));
        sessionStorage.setItem("gamePlayers", JSON.stringify(this.players.map(p => p.name)));

        console.log("Saved in session storage");
    }

    loadFromDB(gameid) {
        let x = new XMLHttpRequest();
        let data = new FormData();

        data.append("gameid", gameid);
        x.open('POST', '../php/getgame.php');

        x.onload = () => {
            // console.log(x.response);
            const response = JSON.parse(x.response);
            // console.log(response);
            // console.log(x.status); 

            if (response['error']) {
                console.log('Game:', response['gameid'], response['error']);
            } else {
                let { moves, size, gameid, komi, black, white } = response;

                size = Number.parseInt(size);
                gameid = Number.parseInt(gameid);

                moves = moves.map(move => JSON.parse(move));
                this.id = gameid;
                this.komi = komi;
                const players = {
                    black: black,
                    white: white,
                    komi: Number.parseFloat(komi)
                }

                this.setPlayers(players);
                this.loadGame(moves, size);
            }
        }

        x.send(data);
    }

    saveGame() {
        let players = this.players.map(p => p.name);
        let moves = this.logic.moveHistory.map(move => [
            JSON.stringify(move.cell ? move.cell : 'pass'),
            move.player
        ]);

        moves = JSON.stringify(moves);
        players = JSON.stringify(players);

        let data = new FormData();

        data.append("gameid", this.id ? this.id : "false");
        data.append("size", this.logic.size);
        data.append("komi", this.komi);
        data.append("moves", moves);
        data.append("players", players);

        let x = new XMLHttpRequest();
        x.open('POST', '../php/savegame.php');

        x.onload = () => {
            // console.log(x.response);
            // console.log(x.status);
            const response = JSON.parse(x.response);
            console.log(response);

            if (response.success) {
                this.id = response.gameid ? response.gameid : this.id;
                alert(`Game [${this.id}] saved!`);
            } else {
                alert('Game not saved... Something went wrong!');
            }
        }

        x.send(data);

    }

    changeShared() {
        if (!this.id) {
            console.log('No game selected');
            alert('No game selected');
            return;
        }

        let data = new FormData();
        data.append('gameid', this.id);

        fetch('../php/setshared.php', {
            method: 'post',
            body: data
        })
            .then(response => response.json())
            .then(data => {
                if (data['error']) {
                    console.log(data['error']);
                } else {
                    this.shared = Boolean(data['shared']);
                    console.log('Shared: ', this.shared);

                    let state = this.shared ? 'shared' : 'private';
                    alert(`Your game is now ${state}!`)
                }
            })
    }

    deleteGame() {
        if (!this.id) {
            console.log('No game selected');
            alert('No game selected');
            return;
        }

        let confirm_str = `Are you sure you want to delete this game? \nGame [${this.id}]`;
        if (confirm(confirm_str)) {

            let data = new FormData();
            data.append('gameid', this.id);

            fetch('../php/deletegame.php', {
                method: 'post',
                body: data
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        this.id = null;
                        sessionStorage.clear();
                        alert('Game deleted');
                        // window.location.reload();
                        window.location.href = './home.php'
                    } else {
                        console.log(data);
                        alert('Game not deleted, something went wrong...')
                    }
                })
                .catch(error => console.log(error))
        }
    }

}



