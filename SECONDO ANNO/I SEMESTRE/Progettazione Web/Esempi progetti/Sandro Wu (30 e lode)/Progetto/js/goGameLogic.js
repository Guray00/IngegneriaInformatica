
// Go Game Logic class
// only logics, no user interface


function boardState(step, board, move, type) {
    this.step = step;
    this.board = board;
    this.move = move;
    this.type = type; // types: normal, setup ...(?)
}

class GoLogic {

    #void_cell = '.'; // 0
    #visited_cell = 'v';

    constructor(size = 13) {
        this.size = size;
        this.currentStep = 0;
        this.boardHistory = [];
        this.moveHistory = [];

        this.#visited_cell = 'visited';

        try {
            if (size < 2 || size > 25) {
                throw 'Not valid size';
            }

            this.board = Array(size).fill(
                Array(size).fill(this.#void_cell)
            );

            this.storeBoardState(this.currentStep, this.board, null, 'voidBoard');

        } catch (e) {
            console.log(e);
        }
    }

    rebuild(size) {
        this.size = size;
        this.reset();
    }

    reset() {
        this.currentStep = 0;
        this.moveHistory = [];
        this.boardHistory = [];
        this.board = Array(this.size).fill(
            Array(this.size).fill(this.#void_cell)
        );
        this.storeBoardState(this.currentStep, this.board, null, 'voidBoard');

    }

    storeBoardState(step, board, move, type = 'play') {
        let boardCopy = board.map(row => row.slice());
        this.boardHistory.push(new boardState(step, boardCopy, move, type));
    }

    // console log the board
    log(board, tab = false) {
        board = board ? board : this.board;
        let table = '';

        for (let i = 0; i < this.size; i++) {
            let row = '';
            for (let j = 0; j < this.size; j++) {
                row += board[i][j] + ' ';
            }
            table += row + '\n';
        }
        tab ? console.table(board) : console.log(table);
    }

    // check coordinates
    isValid([x, y]) {
        if (x == null || y == null) {
            throw 'isValid: null coordinate ';
        }
        else if (x < 0 || y < 0 || x >= this.size || y >= this.size) {
            throw 'isValid: coordinates out of the board';
            // return false;
        } else {
            return true;
        }
    }

    // set a cell on the board
    #setCell([x, y], player) {
        try {
            this.isValid([x, y])
            this.board[y][x] = player;

        } catch (error) {
            console.log(error);
        }
    }

    // place the stone if not occupied
    addStone([x, y], player) {
        try {
            this.isValid([x, y]);

            if (this.board[y][x] != this.#void_cell)
                throw 'go.addStone: cell already occupied';
            else {
                this.board[y][x] = player;
                return true;
            }

        } catch (error) {
            // console.log(error);
            return false;
        }
    }

    removeStone(cell) {
        if (cell == 'pass') return;
        this.#setCell(cell, this.#void_cell);
    }

    // get the entire group of a cell - format: [[x,y], [x,y], ...]
    getGroup([x, y]) {

        const size = this.size;
        const visited = this.#visited_cell;

        // (Nested function)
        // recursive function to search the group on valid adiacent cell
        function searchGroup([x, y], player, board) {

            if (board[y][x] != player || board[y][x] == visited) {
                return [];
            }

            board[y][x] = visited;
            let group = [[x, y]];
            let directions = adiacents([x, y], size);

            for (let dir of directions) {
                let subgroup = searchGroup(dir, player, board);
                group = group.concat(subgroup);
                // console.log(`x: ${x} y: ${y}  group: ${gruppo}`);
            }
            return group;
        }

        let boardCopy = this.board.map(row => row.slice());

        let player = this.board[y][x];
        let group = searchGroup([x, y], player, boardCopy);

        // this.log(boardCopy);
        // this.log();

        return group;
    }

    removeGroup(group) {
        for (let cell of group) {
            this.#setCell(cell, this.#void_cell);
        }
    }

    // get liberties (void cells) around a group
    getLiberties(group) {

        let liberties = new Set();
        for (let cell of group) {
            let directions = adiacents(cell, this.size);
            for (let dir of directions) {
                let [x, y] = dir;
                if (this.board[y][x] == this.#void_cell) {
                    liberties.add(dir.toString());
                }
            }
        }

        liberties = Array.from(liberties);
        liberties = liberties.map(str => str.split(','));

        // console.log('libertà: ', liberties);
        return liberties;
    }

    isSuicide([x, y], player) {
        // if capture at least 1 stones, then it is not suicide
        if (this.checkCapture([x, y], player))
            return false;


        let boardBackup = this.board.map(row => row.slice());

        let liberties = 0;
        if (this.addStone([x, y], player)) {

            // get the group of the move and get the liberties
            let group = this.getGroup([x, y]);
            liberties = this.getLiberties(group).length;
        }

        this.board = boardBackup;
        if (liberties == 0) {
            throw 'Suicide move';
        }
        return false;
    }

    isKO([x, y], player) {
        // under 2 moves, KO is not possible
        if (this.currentStep < 2)
            return false;

        let boardBackup = this.board.map(row => row.slice());

        if (this.addStone([x, y], player)) {

            this.doCapture([x, y], player);

            let currentBoard = this.board.map(row => row.toString()).join();
            let previousBoard = this.boardHistory[this.currentStep - 1].board.map(row => row.toString()).join();

            let ko = false;

            // for (let i = 1; i < 5; i++) {
            //     let step = Math.max(this.currentStep - i, 0);
            //     let previousBoard = this.boardHistory[step].board.map(row => row.toString()).join();

            //     if (previousBoard == currentBoard) {
            //         ko = true;
            //         console.log('previous step: '+i);
            //         break;
            //     }
            // }

            ko = currentBoard == previousBoard;
            this.board = boardBackup;

            if (ko) {
                throw 'KO situation';
                // return true;
            } else {
                return false;
            }
        }
    }

    // play a move with all the checks
    playMove([x, y], player) {
        const result = {
            success: false,
            capturedStones: null,
            error: null
        }

        try {
            this.isValid([x, y]);

            if (!this.isVoidCell([x, y])) {
                throw 'cell occupied';
            }

            if (!this.isSuicide([x, y], player) && !this.isKO([x, y], player)) {

                this.addStone([x, y], player);
                result.capturedStones = this.doCapture([x, y], player);
                result.success = true;

                this.currentStep++;
                // console.log(this.currentStep);
                this.storeBoardState(this.currentStep, this.board, [x, y]);
                this.moveHistory.push({
                    cell: [x, y],
                    player: player
                });

            }
            return result;

        } catch (e) {
            console.log(e);
            result.error = e;
            return result;
        }
    }

    // check if a move would capture stones, return the hypothetical number of captured
    checkCapture([x, y], player) {
        let boardBackup = this.board.map(row => row.slice());

        this.addStone([x, y], player);
        let totalCaptured = this.doCapture([x, y], player).length;

        this.board = boardBackup;
        return totalCaptured;

    }

    // 
    doCapture([x, y], player) {

        if (this.board[y][x] != player) {
            // this.log();
            // console.log(x, y, player);
            throw "doCapture: input cell is not player's";
        }
        let capturedStones = [];

        let directions = adiacents([x, y], this.size);
        for (let dir of directions) {

            let stone = this.board[dir[1]][dir[0]];
            if (stone != player && stone != this.#void_cell) {

                let group = this.getGroup(dir);
                let liberties = this.getLiberties(group);

                if (liberties.length == 0) {
                    capturedStones = capturedStones.concat(group);
                    this.removeGroup(group);
                }
            }

        }
        return capturedStones;

    }

    isVoidCell([x, y]) {
        if (x == null || y == null) return false;
        return this.board[y][x] == this.#void_cell;
    }

    getVoidCell() {
        return this.#void_cell;
    }

    pass(player) {
        try {
            this.currentStep++;
            this.storeBoardState(this.currentStep, this.board, null, 'pass');
            this.moveHistory.push({
                cell: 'pass',
                player: player
            });

            // Double pass => End Game
            if(this.currentStep > 1){
                const last = this.boardHistory.slice(-2)[0];
                if(last.type == 'pass'){
                    this.end = true;
                }
            }

        } catch (e) {
            console.log(e);
        }
    }

    estimateTerritory(board) {
        
        // get a copy
        let copyboard = board.map(row => row.slice());

        const unknow = 'unknow';

        copyboard.forEach((row, j) => {
            row.forEach((cell, i) => {

                if (cell == this.#void_cell) {
                    // console.log('cell:', cell, i, j);
                    const group = this.getGroup([i, j]);

                    // look if territory is delimited by a single one player
                    let delimiter = new Set();
                    for (let cell of group) {
                        let directions = adiacents(cell, this.size);
                        for (let dir of directions) {
                            let [x, y] = dir;
                            if (this.board[y][x] != this.#void_cell) {
                                delimiter.add(this.board[y][x]);
                            }
                        }
                    }
                    let code;
                    if (delimiter.size == 1) {
                        // get the value of player from delimiter
                        [code] = delimiter;
                    } else {
                        code = unknow;
                    }

                    for (const [x, y] of group) {
                        copyboard[y][x] = code;
                    }

                    // console.log(delimiter);
                    // this.log(board);
                }

            })
        })

        // this.log(copyboard);
        // console.log(copyboard);

        return {
            unknow: unknow,
            board: copyboard,
        };

    }

}

// returns not null, adiacent cells
function adiacents([x, y], size) {
    // const directions = {
    //     nord: [x - 1, y], 
    //     sud:  [x + 1, y], 
    //     est:  [x, y - 1], 
    //     ovest:[x, y + 1]
    // };
    const directions = [
        [x - 1, y],
        [x + 1, y],
        [x, y - 1],
        [x, y + 1]
    ];

    for (let dir in directions) {
        for (let coordinate of directions[dir]) {
            if (coordinate < 0 || coordinate >= size) {
                directions[dir] = null;
            }
        }
    }

    // filter null elements
    return directions.filter(Boolean);
}

