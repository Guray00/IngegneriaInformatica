
// Go game board class, displays the board on canvas 
// only for user interface, no logic inside

// export class Board {

class Board {
    constructor(boardBox, boardSize = 13) {
        try {
            this.boardBox = boardBox;
            this.size = boardSize;
            this.canvasResolution = 1000;

            if (!this.boardBox) {
                throw Board.name + ': parent is null';
            }
            if (this.size < 2 || this.size > 25) {
                throw Board.name + ' board size not valid, only in [2,25]';
            }

            this.#createLayers();
            this.#buildBoard();

        } catch (e) {
            console.log(e);
        }
    }

    // change size
    rebuild(boardSize = this.size) {
        try {
            if (boardSize < 2 || boardSize > 25) {
                throw Board.name + ' board size not valid, [2,25]';
            }

            this.size = boardSize;
            const board = this.board;

            for (const context of Object.values(this.contexts)) {
                context.beginPath();
                context.clearRect(0, 0, board.width, board.height);
                context.closePath();
            }
            this.#buildBoard();
        } catch (error) {
            console.log(error);
        }
    }

    #createLayers() {
        const boardLayer = document.createElement('canvas');
        const stoneLayer = document.createElement('canvas');
        const scoreLayer = document.createElement('canvas');

        const layers = [boardLayer, scoreLayer, stoneLayer];
        const contexts = layers.map(layer => layer.getContext('2d'));

        let zIndex = 1;
        layers.forEach(layer => {
            this.boardBox.appendChild(layer);
            layer.style.position = 'absolute';
            layer.style.top = 0;
            layer.style.left = 0;
            layer.style.backgroundColor = 'transparent';
            layer.style.zIndex = zIndex++;
            layer.width = layer.height = this.canvasResolution;
        });
        this.boardBox.style.position = 'relative';
        boardLayer.style.position = 'relative';

        this.layers = {
            boardLayer: boardLayer,
            scoreLayer: scoreLayer,
            stoneLayer: stoneLayer
        };
        this.contexts = {
            boardContext: contexts[0],
            scoreContext: contexts[1],
            stoneContext: contexts[2],
        };
    }

    #buildBoard() {
        const board = this.layers.boardLayer;
        const size = this.size;

        const padding = (board.width / (size + 2)) * 1.5;
        const cell = {
            width: (board.width - padding * 2) / (size - 1),
            height: (board.height - padding * 2) / (size - 1)
        }

        // const padding = board.width / (size + 2) * 1.3;
        // const cell = {
        //     width: (board.width - padding * 2) / (size - 1),
        //     height: (board.width - padding * 2) / (size - 1),
        // }

        this.board = board;
        this.padding = padding;
        this.cell = cell;

        this.#drawGrid();
        this.#drawCoordinates();
        this.#drawHoshi();
    }

    #drawGrid() {
        const { board, cell, padding, size } = this;
        const context = this.contexts.boardContext;

        context.strokeStyle = 'black';
        context.lineWidth = 1; //this.canvasResolution/1000;
        for (let i = 0; i < size; i++) {

            context.moveTo(padding + i * cell.width, padding);
            context.lineTo(padding + i * cell.width, board.width - padding);
            context.stroke();

            context.moveTo(padding, padding + i * cell.height);
            context.lineTo(board.height - padding, padding + i * cell.height);
            context.stroke();
        }

    }

    #drawCoordinates() {
        const { board, cell, padding, size } = this;
        const context = this.contexts.boardContext;

        // Draw coordinates on borders
        const fontsize = cell.width / 2;
        const textSpacing = cell.width * 0.4;
        const adjustFormat = cell.width / 4;

        context.fillStyle = 'black';
        context.font = fontsize + 'px Arial';
        context.textAlign = 'center';

        for (let i = 0, letter = 0; i < size; i++, letter++) {

            let position_x = padding + i * cell.width;
            let position_y = board.height - (padding + i * cell.height) + fontsize / 3;

            if (letter == 8) letter++; // 'I' is historically not used
            let char = String.fromCharCode(65 + letter);

            context.fillText(i + 1, textSpacing + adjustFormat, position_y);
            context.fillText(i + 1, board.width - fontsize - textSpacing + adjustFormat, position_y)

            context.fillText(char, position_x, textSpacing + fontsize * 0.9);
            context.fillText(char, position_x, board.width - textSpacing - fontsize / 3);

        }

    }

    #drawHoshi() {
        const { cell, padding, size } = this;
        const context = this.contexts.boardContext;

        const hoshiCases = [
            [
                [3, 3], [3, 9], [3, 15],
                [9, 3], [9, 9], [9, 15],
                [15, 3], [15, 9], [15, 15],
            ], [
                [3, 3], [3, 9],
                [9, 3], [9, 9],
                [6, 6]
            ], [
                [2, 2], [2, 6],
                [6, 2], [6, 6],
                [4, 4]
            ]
        ]

        let hoshiPoints;
        switch (size) {
            case 19: hoshiPoints = hoshiCases[0]; break;
            case 13: hoshiPoints = hoshiCases[1]; break;
            case 9: hoshiPoints = hoshiCases[2]; break;
            default: hoshiPoints = null;
        }

        if (!hoshiPoints) {
            if (size % 2 == 1) {
                let middle = (size - 1) / 2;
                hoshiPoints = [[middle, middle]];
            } else {
                return;
            }
        }

        context.fillStyle = 'black';
        for (let point of hoshiPoints) {
            context.beginPath();
            context.arc(
                padding + point[0] * cell.width,
                padding + point[1] * cell.height,
                cell.width * 0.1, 0, 2 * Math.PI
            )
            context.closePath();
            context.fill();

        }


    }

    getGridCoordinates(event) {
        const { cell, padding, size } = this;
        const board = this.layers.stoneLayer;

        let [x, y] = [event.offsetX, event.offsetY];
        const rect = board.getBoundingClientRect();

        // Proportionate screen coordinates to canvas coordinates
        // canvas_x : screen_x = board_width : rect_width
        x = board.width / rect.width * x;
        y = board.height / rect.height * y;

        // get grid coordinates
        x = Math.round((x - padding) / cell.width);
        y = Math.round((y - padding) / cell.height);

        // console.log(`mouse x: ${x} y: ${y}`);
        if (!isValidCoordinates(x, y, size)) {
            return [];
        }
        return [x, y];

    }

    drawScorePoint(x, y, color) {

        const { cell, padding, size } = this;
        const context = this.contexts.scoreContext;

        try {
            if (!isValidCoordinates(x, y, size)) {
                return;
            }
            
            let length = cell.width * 0.3;

            context.clearRect(
                padding + x * cell.width - length,
                padding + y * cell.height - length,
                length * 2, length * 2
            )

            context.fillStyle = color;
            context.beginPath();
            context.rect(
                padding + x * cell.width - length / 2,
                padding + y * cell.height - length / 2,
                length, length
            )
            context.closePath();
            context.fill();

        } catch (error) {
            console.log(error);
        }
    }

    drawStone(x, y, color) {
        const { cell, padding, size } = this;
        const context = this.contexts.stoneContext;

        try {
            if (!isValidCoordinates(x, y, size)) {
                return;
            }

            let stoneRadius = cell.width * 0.47;
            context.fillStyle = color;
            context.beginPath();
            context.arc(
                padding + x * cell.width,
                padding + y * cell.height,
                stoneRadius, 0, 2 * Math.PI
            )
            context.closePath();
            context.fill();

        } catch (error) {
            console.log(error);
        }
    }

    clearStone(x, y) {
        const { cell, padding, size } = this;
        const context = this.contexts.stoneContext;

        if (!isValidCoordinates(x, y, size)) {
            return;
        }

        let stoneRadius = cell.width * 0.5;
        let length = cell.width;
        let startX = padding + x * cell.width - stoneRadius;
        let startY = padding + y * cell.width - stoneRadius;
        context.clearRect(startX, startY, length, length);

    }

    resetStoneLayer() {
        const board = this.layers.stoneLayer;
        const context = this.contexts.stoneContext;

        context.beginPath();
        context.clearRect(0, 0, board.width, board.height);
        context.closePath();
    }
}

function isValidCoordinates(x, y, size) {
    if (x == null || y == null) {
        return false;
    }
    if (x < 0 || y < 0 || x >= size || y >= size) {
        return false;
    }
    return true;
}
