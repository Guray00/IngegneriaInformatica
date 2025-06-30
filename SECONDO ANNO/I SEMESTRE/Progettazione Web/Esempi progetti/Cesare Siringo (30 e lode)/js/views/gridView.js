import { Grid } from "../lib/tiles.js";
import { EditableGridCanvas } from "../render/gridCanvas.js";
import { Save } from "../lib/save.js";

export class GridView {
    constructor(save, canvas, saveNameInput, gridControls, colorGrid, gridNumRowsInput, gridNumColsInput, tileLengthInput, wrapRowsCheckbox, wrapColsCheckbox
    ) {
        this.canvas = canvas;
        this.saveNameInput = saveNameInput;
        this.gridControls = gridControls;
        this.colorGrid = colorGrid;
        this.gridNumRowsInput = gridNumRowsInput;
        this.gridNumColsInput = gridNumColsInput;
        this.tileLengthInput = tileLengthInput;
        this.wrapRowsCheckbox = wrapRowsCheckbox;
        this.wrapColsCheckbox = wrapColsCheckbox;

        this.grid = undefined;
        this.loadSave(save);

        canvas.addEventListener('mousedown', (e) => {
            if(this.hidden) return;

            this.dragging = true;
            this.gridCanvas.handleClickEvent(e);
        });
        canvas.addEventListener('mousemove', (e) => {
            if(this.hidden) return;
            if (!this.dragging) return;

            this.gridCanvas.handleClickEvent(e);
        });
        canvas.addEventListener('mouseup', () => {
            if (this.hidden) return;

            this.dragging = false;
        });
        canvas.addEventListener("mouseleave", () => {
            if (this.hidden) return;

            this.dragging = false;
        })

        this.gridNumRowsInput.addEventListener("change", () => { this.resizeEvent() });
        this.gridNumColsInput.addEventListener("change", () => { this.resizeEvent() });

        this.hidden = true;
    }

    resizeEvent() {
        this.grid = new Grid(
            parseInt(this.gridNumRowsInput.value),
            parseInt(this.gridNumColsInput.value),
            (i, j) => 0
        );
        this.gridCanvas = new EditableGridCanvas(
            this.grid,
            this.canvas,
            this.colorGrid
        );
        this.gridCanvas.render();
    }

    show() {
        this.hidden = false;
        this.gridControls.hidden = false;
        this.gridCanvas.render();
    }

    hide() {
        this.hidden = true;
        this.gridControls.hidden = true;
    }

    loadSave(save) {
        console.log("Loading save", save);
        let newGrid = new Grid(
            save.grid.rows,
            save.grid.cols,
            (i, j) => save.grid.grid[i][j]
        )
        this.grid = newGrid;
        this.gridNumRowsInput.value = this.grid.rows;
        this.gridNumColsInput.value = this.grid.cols;
        this.tileLengthInput.value = save.tileLength;
        this.wrapRowsCheckbox.checked = save.wrapRows;
        this.wrapColsCheckbox.checked = save.wrapCols;

        this.gridCanvas = new EditableGridCanvas(
            this.grid,
            this.canvas,
            this.colorGrid
        );
        // this.colorGrid.setColors(save.palette);
    }

    getSave() {
        return new Save(
            this.saveNameInput.value,
            this.grid,
            parseInt(this.tileLengthInput.value),
            this.wrapRowsCheckbox.checked,
            this.wrapColsCheckbox.checked,
            this.colorGrid.colors
        )
    }
}