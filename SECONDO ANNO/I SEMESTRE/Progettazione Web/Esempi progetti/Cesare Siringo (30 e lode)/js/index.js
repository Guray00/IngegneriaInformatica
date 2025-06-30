"use strict";

import { Grid } from "./lib/tiles.js";
import { createColor } from "./render/color.js";
import { ColorGrid } from "./render/colorGrid.js";
import { WaveView } from "./views/waveView.js";
import { GridView } from "./views/gridView.js";
import { UserView } from "./views/userView.js";
import { Save } from "./lib/save.js";
import { ApiContext } from "./lib/apiContext.js";

const PALETTE = [
    createColor(0, 0, 0),         // Nero
    createColor(47, 50, 67),      // Grigio scuro
    createColor(123, 145, 153),   // Grigio bluastro
    createColor(195, 221, 218),   // Azzurro chiaro

    createColor(255, 255, 255),   // Bianco
    createColor(232, 24, 78),     // Fucsia intenso
    createColor(248, 156, 181),   // Rosa
    createColor(153, 51, 0),      // Marrone

    createColor(255, 153, 51),    // Arancione
    createColor(243, 210, 0),     // Giallo
    createColor(223, 255, 153),   // Verde chiaro
    createColor(0, 204, 0),       // Verde

    createColor(102, 255, 204),   // Turchese
    createColor(102, 153, 255),   // Azzurro
    createColor(76, 0, 255),      // Blu
    createColor(204, 0, 255),     // Viola
]

const ARR = [
    [1,1,1,1],
    [1,0,0,0],
    [1,0,5,0],
    [1,0,0,0]
];
const GRID = new Grid(4, 4, (i, j) => ARR[i][j]);
let INITIAL_SAVE = new Save("Untitled", GRID, 2, true, true, PALETTE);

export let waveView = undefined;
export let gridView = undefined;
export let userView = undefined;
export let apiContext = undefined;

document.addEventListener("DOMContentLoaded", init);
function init() {
    const canvas = document.getElementById("wave-canvas");
    const colorGrid = new ColorGrid(document.getElementById("color-grid"), PALETTE);

    const saveNameInput = document.getElementById("save-name-input");
    const saveButton = document.getElementById("save-button");

    const toWaveButton = document.getElementById("to-wave-button");
    const gridCanvas = document.getElementById("grid-canvas");

    canvas.width = Math.floor(window.innerWidth * 0.47);
    canvas.height = Math.floor(window.innerHeight * 0.96);

    saveNameInput.value = INITIAL_SAVE.name;

    // Initialize WaveView
    waveView = new WaveView(
        INITIAL_SAVE,
        canvas,
        document.getElementById("wave-controls"),
        gridCanvas,
        document.getElementById("play-button"),
        document.getElementById("pause-button"),
        document.getElementById("step-button"),
        document.getElementById("stop-button"),
        document.getElementById("speed-slider"),
        document.getElementById("num-cols"),
        document.getElementById("num-rows"),
        document.getElementById("entropy-display"),
        document.getElementById("entropy-progress"),
        document.getElementById("wave-state-message")
    );

    // Initialize GridView
    gridView = new GridView(
        INITIAL_SAVE,
        canvas,
        saveNameInput,
        document.getElementById("grid-controls"),
        colorGrid,
        document.getElementById("grid-num-rows"),
        document.getElementById("grid-num-cols"),
        document.getElementById("tile-length"),
        document.getElementById("wrap-rows"),
        document.getElementById("wrap-cols")
    );

    // Initialize API context
    apiContext = new ApiContext();

    // Initialize UserView
    userView = new UserView(
        apiContext,
        save => {
            saveNameInput.value = save.name;
            gridView.loadSave(save);

            if(gridView.hidden) {
                waveView.loadSave(save);
                waveView.wave.render();
            } else {
                gridView.gridCanvas.render();
            }
        },
        document.getElementById("signup-form"),
        document.getElementById("login-form"),
        document.getElementById("user-profile"),
        document.getElementById("show-login-button"),
        document.getElementById("show-signup-button")
    );

    saveButton.addEventListener("click", async () => {
        if(!saveNameInput.checkValidity()) {
            alert("Invalid save name. Please use 1-50 characters: letters, numbers, spaces, and !#$%&*^_-~ only.");
            return;
        }
        const save = gridView.getSave();
        console.log("saving", JSON.stringify(save.toJSON()));
        const success = await apiContext.save(save.name, JSON.stringify(save.toJSON()));
        if(success) userView.renderProfile();
    });

    gridCanvas.addEventListener("click", () => {
        waveView.endGame();

        waveView.hide();
        gridView.show();
    });

    toWaveButton.addEventListener("click", () => {
        waveView.loadSave(gridView.getSave());

        gridView.hide();
        waveView.show();
    });

    waveView.show();
}