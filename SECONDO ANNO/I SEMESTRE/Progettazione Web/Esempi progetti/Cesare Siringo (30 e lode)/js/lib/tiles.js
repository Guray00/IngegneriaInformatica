"use strict";

export class Grid {
    constructor(rows, cols, gen) {
        if(!gen) {
            gen = (_i, _j) => null
        }

        this.rows = rows;
        this.cols = cols;
        this.grid = [];

        for (let i = 0; i < rows; i++) {
            let row = [];

            for (let j = 0; j < cols; j++) {
                row.push(gen(i, j));
            }

            this.grid.push(row);
        }
    }

    wrap_row(row) {
        return (row + this.rows) % this.rows;
    }

    wrap_col(col) {
        return (col + this.cols) % this.cols;
    }

    get_tile(base_row, base_col, rows, cols, wrap_rows, wrap_cols) {
        const grid = new Tile(rows, cols, (i, j) => {
            const row = base_row + i;
            const col = base_col + j;

            const wrap_res = this.grid[this.wrap_row(row)][this.wrap_col(col)];
            if (!wrap_rows && (row < 0 || row >= this.rows)
            ||  !wrap_cols && (col < 0 || col >= this.cols)) {
                return null;
            }
            return wrap_res;
        })

        return grid;
    }

    get_tiles(rows, cols, wrap_rows, wrap_cols) {
        return new Grid(this.rows, this.cols, (i, j) => {
            return this.get_tile(i - Math.floor(rows / 2), j - Math.floor(cols / 2), rows, cols, wrap_rows, wrap_cols);
        });
    }
}

export const DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]];
export const INVERSE_DIRECTIONS = [1, 0, 3, 2];
export const UP = 0;
export const DOWN = 1;
export const LEFT = 2;
export const RIGHT = 3;

class Tile extends Grid {
    constructor(rows, cols, gen) {
        super(rows, cols, gen);

        this.weight = 1;
        this.compatible = [[], [], [], []];
        this.center = this.grid[Math.floor(rows / 2)][Math.floor(cols / 2)];
    }
}

function compare_tiles(tile_a, tile_b, row_offset, col_offset) {
    for (let i = 0; i < tile_a.rows - row_offset; i++) {
        for (let j = 0; j < tile_a.cols - col_offset; j++) {
            if (tile_a.grid[i + row_offset][j + col_offset] !== tile_b.grid[i][j])
                return false;
        }
    }

    return true;
}

function extract_tiles_from_grid(tile_grid) {
    const tiles = [];
    const borders = [[null], [null], [null], [null]];

    for (let i = 0; i < tile_grid.rows; i++) {
        for (let j = 0; j < tile_grid.cols; j++) {
            const tile = tile_grid.grid[i][j];

            let tile_id = tiles.findIndex((t) => compare_tiles(t, tile, 0, 0));
            if(tile_id < 0) {
                tile_id = tiles.length;
                tiles.push(tile);
            } else {
                tiles[tile_id].weight++;
            }

            if(i === 0 && !borders[DOWN].includes(tile_id)) borders[DOWN].push(tile_id);
            if (i + 1 === tile_grid.rows && !borders[UP].includes(tile_id)) borders[UP].push(tile_id);
            if(j === 0 && !borders[RIGHT].includes(tile_id)) borders[RIGHT].push(tile_id);
            if (j + 1 === tile_grid.cols && !borders[LEFT].includes(tile_id)) borders[LEFT].push(tile_id);
        }
    }

    return [tiles, borders];
}

export class Tileset {
    constructor(grid, rows, cols, wrap_rows, wrap_cols) {
        const tile_grid = grid.get_tiles(rows, cols, wrap_rows, wrap_cols);
        const tiles_borders = extract_tiles_from_grid(tile_grid);

        this.tiles = tiles_borders[0];
        this.border = tiles_borders[1];
        this.wrap_rows = wrap_rows;
        this.wrap_cols = wrap_cols;

        this.build_adjacency_lists();
    }

    build_adjacency_lists() {
        for (let i = 0; i < this.tiles.length; i++) {
            if (this.border[UP].includes(i)) this.tiles[i].compatible[DOWN].push(null);
            if (this.border[DOWN].includes(i)) this.tiles[i].compatible[UP].push(null);
            if (this.border[LEFT].includes(i)) this.tiles[i].compatible[RIGHT].push(null);
            if (this.border[RIGHT].includes(i)) this.tiles[i].compatible[LEFT].push(null);

            for (let j = 0; j < this.tiles.length; j++) {
                if(compare_tiles(this.tiles[i], this.tiles[j], 0, 1)) {
                    this.tiles[i].compatible[RIGHT].push(j);
                    this.tiles[j].compatible[LEFT].push(i);
                }

                if(compare_tiles(this.tiles[i], this.tiles[j], 1, 0)) {
                    this.tiles[i].compatible[DOWN].push(j);
                    this.tiles[j].compatible[UP].push(i);
                }
            }
        }
    }

    are_tiles_compatible(srcs, dir, tgt) {
        const new_dir = INVERSE_DIRECTIONS[dir];
        const compatibilities = (tgt === null) ? this.border[new_dir] : this.tiles[tgt].compatible[new_dir];

        for (let i = 0; i < srcs.length; i++) {
            if (compatibilities.includes(srcs[i])) return true;
        }

        return false;
    }

    get_weight(idx) {
        return (idx === null) ? 0 : this.tiles[idx].weight;
    }

    get size() {
        return this.tiles.length;
    }
}