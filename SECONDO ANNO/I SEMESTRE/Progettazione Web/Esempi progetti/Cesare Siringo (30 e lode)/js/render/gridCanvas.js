import { getColorStyle } from "./color.js";

export class GridCanvas {
    constructor(grid, canvas, palette) {
        this.grid = undefined;
        this.canvas = canvas;
        this.ctx = canvas.getContext("2d");
        this.ctx.imageSmoothingEnabled = false;
        this.palette = palette;

        this.setGrid(grid);
    }

    setGrid(grid) {
        this.grid = grid;
        this.tile_size = Math.floor(Math.min(
            this.canvas.width / this.grid.cols,
            this.canvas.height / this.grid.rows
        ));
        this.width_bias = Math.floor((this.canvas.width - this.tile_size * this.grid.cols) / 2);
        this.height_bias = Math.floor((this.canvas.height - this.tile_size * this.grid.rows) / 2);
    }

    drawGrid() {
        this.ctx.strokeStyle = "gray";
        this.ctx.lineWidth = this.baseLineWidth / this.tile_size;

        // Draw grid lines (horizontal)
        for (let i = 0; i <= this.grid.rows; i++) {
            const y = this.height_bias + i * this.tile_size;
            this.ctx.beginPath();
            this.ctx.moveTo(this.width_bias, y);
            this.ctx.lineTo(this.canvas.width - this.width_bias, y);
            this.ctx.stroke();
        }

        // Draw grid lines (vertical)
        for (let j = 0; j <= this.grid.cols; j++) {
            const x = this.width_bias + j * this.tile_size;
            this.ctx.beginPath();
            this.ctx.moveTo(x, this.height_bias);
            this.ctx.lineTo(x, this.canvas.height - this.height_bias);
            this.ctx.stroke();
        }
    }

    render() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        for (let i = 0; i < this.grid.rows; i++) {
            for (let j = 0; j < this.grid.cols; j++) {
                const color = this.palette[this.grid.grid[i][j]];

                this.ctx.fillStyle = getColorStyle(color);
                this.ctx.fillRect(
                    this.width_bias + j * this.tile_size,
                    this.height_bias + i * this.tile_size,
                    this.tile_size,
                    this.tile_size
                );
            }
        }

        this.drawGrid()
    }
}

export class EditableGridCanvas extends GridCanvas {
    constructor(grid, canvas, colorGrid) {
        super(grid, canvas, colorGrid.colors);

        this.colorGrid = colorGrid;
    }

    handleClickEvent(e) {
        const col = Math.floor((e.offsetX - this.width_bias) / this.tile_size);
        const row = Math.floor((e.offsetY - this.height_bias) / this.tile_size);
        if (col < 0 || col >= this.grid.cols || row < 0 || row >= this.grid.rows) {
            return; // Click outside the grid
        }
        if (this.colorGrid.selectedColor === null) {
            return; // No color selected
        }
        this.updateCell(row, col, this.colorGrid.selectedColor);
    }

    updateCell(row, col, colorIndex) {
        this.grid.grid[row][col] = colorIndex;
        this.render();
    }
}