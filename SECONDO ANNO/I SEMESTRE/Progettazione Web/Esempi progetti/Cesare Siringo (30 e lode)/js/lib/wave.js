"use strict";

import { Queue } from "./queue.js";
import { Grid, DIRECTIONS } from "./tiles.js";
import { createColor, getColorStyle, weighedColorSum } from "../render/color.js";

export class Wave extends Grid {
    constructor(rows, cols, tileset) {
        super(tileset.wrap_rows ? rows : rows + 1, tileset.wrap_cols ? cols : cols + 1, (i, j) => {
            if (i === rows || j === cols) return {
                possibilities: [null],
                entropy: 0
            };

            const arr = [];
            for (let i = 0; i < tileset.size; i++) {
                arr.push(i);
            }

            const entropy = Wave.entropy(tileset, arr);

            return {
                possibilities: arr,
                entropy: entropy
            };
        });

        this.tileset = tileset;
        this.initial_entropy = this.total_entropy();
    }

    init() {
        console.log("initializing wave");

        const borders = [];

        if(!this.tileset.wrap_rows) {
            for (let i = 0; i < this.cols; i++) {
                borders.push([this.rows - 1, i]);
            }
        }
        if(!this.tileset.wrap_cols) {
            for (let i = 0; i < this.rows; i++) {
                borders.push([i, this.cols - 1]);
            }
        }

        if (!this.propagate(borders)) return false;

        this.initial_entropy = this.total_entropy();
        return true;
    }

    // Calcola la Shannon entropy delle possibilità di una tile
    static entropy(tileset, possibilities) {
        const weights_sum = possibilities.map(t => tileset.get_weight(t)).reduce((a, e) => a+e);

        const entropy = -possibilities.map(t => {
            const p = tileset.get_weight(t) / weights_sum;
            return p * Math.log2(p);
        }).reduce((a, e) => a + e);

        return entropy;
    }

    // Sceglie una tile in base alla Shannon entropy
    choose() {
        let arr = [];
        let ent = +Infinity;

        for (let i = 0; i < this.rows; i++) {
            for (let j = 0; j < this.cols; j++) {
                const thisent = this.grid[i][j].entropy;
                if (thisent === 0) continue;

                if(thisent < ent) {
                    ent = thisent;
                    arr = [[i, j]];
                } else if(thisent === ent) {
                    arr.push([i, j]);
                }
            }
        }

        if (arr.length === 0) return null;

        return arr[Math.floor(Math.random() * arr.length)];
    }

    // Osserva (e collassa) una tile
    observe(row, col) {
        const tile = this.grid[row][col];

        const weights_sum = tile.possibilities.map(t => this.tileset.get_weight(t)).reduce((a, e) => a+e);
        const choice = Math.floor(Math.random() * weights_sum);

        let acc = 0;
        let i = 0;
        for (; i < tile.possibilities.length; i++) {
            acc += this.tileset.get_weight(tile.possibilities[i]);
            if (acc > choice) break;
        }

        tile.possibilities = [tile.possibilities[i]];
        tile.entropy = 0;

        this.update_cell(row, col);
    }

    // Funzione di propagazione. Parte da una prima queue di tiles da aggiornare ed esegue un BFS sui vicini escludendone le incompatibilità
    propagate(rowcols) {
        // Coda necessaria per il BFS
        const queue = new Queue(rowcols);

        while(!queue.isEmpty()) {
            const tile_coords = queue.dequeue();
            const tile_possibilities = this.grid[tile_coords[0]][tile_coords[1]].possibilities;

            // Per i 4 vicini
            for (let i = 0; i < 4; i++) {
                const neigh_row = this.wrap_row(tile_coords[0] + DIRECTIONS[i][0]);
                const neigh_col = this.wrap_col(tile_coords[1] + DIRECTIONS[i][1]);
                const neigh_tile = this.grid[neigh_row][neigh_col];

                let changed = false;

                // Filtra le possibilità del vicino
                neigh_tile.possibilities = neigh_tile.possibilities.filter((t) => {


                    // Cerca almeno una possibilità della propria tile compatibile con quella del vicino attualmente in esame
                    if(this.tileset.are_tiles_compatible(tile_possibilities, i, t)) {
                        return true;
                    }

                    // Se arrivo qui la possibilità del vicino esaminata non è compatibile
                    changed = true;
                    return false;
                })

                // Se ho escluso qualcosa controllo una possibile contradizione, poi richiedo la propagazione del cambiamento
                if(changed) {
                    this.update_cell(neigh_row, neigh_col);

                    if(neigh_tile.possibilities.length === 0) {
                        console.log("contradiction with", [neigh_row, neigh_col]);
                        return false;
                    }
                    // Ricalcolo l'entropia della tile vicina
                    neigh_tile.entropy = Wave.entropy(this.tileset, neigh_tile.possibilities);
                    queue.enqueue([neigh_row, neigh_col]);
                }
            }
        }

        return true;
    }

    total_entropy() {
        let entropy = 0;

        for (let i = 0; i < this.rows; i++) {
            for (let j = 0; j < this.cols; j++) {
                entropy += this.grid[i][j].entropy;
            }
        }

        return entropy;
    }

    update_cell(_row, _col) { }
}

export class WaveCanvas extends Wave {
    static CONTRADICTION_COLOR = createColor(255, 0, 255);

    constructor(rows, cols, tileset, canvas, palette) {
        super(rows, cols, tileset);
        this.palette = palette;
        this.canvas = canvas;
        this.ctx = canvas.getContext("2d");
        this.ctx.imageSmoothingEnabled = false;
    }

    clear() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }

    update_cell(row, col) {
        if (!this.canvas) return;

        const tile = this.grid[row][col].possibilities;

        if (tile.length === 0) {
            this.ctx.fillStyle = getColorStyle(WaveCanvas.CONTRADICTION_COLOR);
        } else {
            const wc = tile.map((t) => {
                return [this.tileset.get_weight(t), this.palette[this.tileset.tiles[t].center]];
            });

            const color = weighedColorSum(wc);
            this.ctx.fillStyle = getColorStyle(color);
        }

        const rows = this.tileset.wrap_rows ? this.rows : this.rows - 1;
        const cols = this.tileset.wrap_cols ? this.cols : this.cols - 1;

        const tile_size = Math.floor(Math.min(
            this.canvas.width / cols,
            this.canvas.height / rows
        ));

        const width_bias = Math.floor((this.canvas.width - tile_size * cols) / 2);
        const height_bias = Math.floor((this.canvas.height - tile_size * rows) / 2);

        this.ctx.fillRect(width_bias + col * tile_size, height_bias + row * tile_size, tile_size, tile_size);
    }

    render() {
        this.clear();

        const rows = this.tileset.wrap_rows ? this.rows : this.rows - 1;
        const cols = this.tileset.wrap_cols ? this.cols : this.cols - 1;

        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                this.update_cell(i, j);
            }
        }
    }
}