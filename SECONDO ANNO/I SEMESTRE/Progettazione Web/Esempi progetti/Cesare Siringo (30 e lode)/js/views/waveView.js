import { WaveCanvas } from "../lib/wave.js";
import { GridCanvas } from "../render/gridCanvas.js";

function calculateDelay(sliderValue) {
    return Math.round(1000 * Math.exp(-sliderValue / 200));
}

export class WaveView {
    constructor(initialSave, canvas, waveControls, gridCanvasElement, playButton, pauseButton, stepButton, stopButton, speedSlider, numColsInput, numRowsInput, entropyDisplay, entropyProgress, waveStateMessage) {
        this.canvas = canvas;
        this.waveControls = waveControls;
        this.gridCanvasElement = gridCanvasElement;
        this.playButton = playButton;
        this.pauseButton = pauseButton;
        this.stepButton = stepButton;
        this.stopButton = stopButton;
        this.speedSlider = speedSlider;
        this.speedSlider.value = 500; // Default speed
        this.interval = calculateDelay(500); // Initialize interval
        this.numColsInput = numColsInput;
        this.numRowsInput = numRowsInput;
        this.entropyDisplay = entropyDisplay;
        this.entropyProgress = entropyProgress;
        this.waveStateMessage = waveStateMessage;

        this.started = false;
        this.playing = null;

        this.wave = undefined;
        this.tileset = undefined;
        this.palette = undefined;
        // Flag to indicate if the wave was just loaded, it will be used to prevent unnecessary re-initialization
        this.justLoaded = false;
        this.loadSave(initialSave);

        //add event listeners
        this.playButton.addEventListener("click", () => {
            if (this.playing) return;

            if (!this.started) {
                this.started = true;

                if (!this.justLoaded) this.initWave();
                this.justLoaded = false;

                this.wave.render();
                this.updateView();
            }

            this.playGame();
        });

        this.pauseButton.addEventListener("click", () => {
            if (!this.playing) return;

            this.pauseGame();
        });

        this.stepButton.addEventListener("click", () => {
            if (this.playing || !this.started) return;

            if (!this.renderStep()) {
                this.endGame();
            }
        });

        this.stopButton.addEventListener("click", () => {
            if (!this.started) return;

            this.endGame();
        });

        this.speedSlider.addEventListener("input", (e) => {
            this.interval = calculateDelay(parseInt(e.target.value));
            if (this.playing) {
                clearInterval(this.playing);
                this.playing = setInterval(() => { this.render() }, this.interval);
            }
        });
    }

    initWave() {
        this.wave = new WaveCanvas(
            parseInt(this.numRowsInput.value),
            parseInt(this.numColsInput.value),
            this.tileset,
            this.canvas,
            this.palette
        );
        if(this.wave.init()) {
            this.waveStateMessage.innerHTML = "";
        } else {
            this.waveStateMessage.innerHTML = "Failed to initialize wave. Please check your tileset and grid size.";
        }
    }

    loadSave(save) {
        this.endGame();
        this.tileset = save.getTileset();
        this.palette = save.palette;
        const gridCanvas = new GridCanvas(
            save.grid,
            this.gridCanvasElement,
            this.palette
        );
        gridCanvas.render();
        this.initWave();
        this.updateView();
        this.justLoaded = true;
    }

    setTileset(tileset, palette) {
        this.tileset = tileset;
        this.palette = palette;
    }

    updateView() {
        let entropy = this.wave.total_entropy();
        this.entropyDisplay.textContent = `Entropy: ${entropy.toFixed(2)} / ${this.wave.initial_entropy.toFixed(2)} bits`;
        this.entropyProgress.value = this.wave.initial_entropy > 0 ? 1 - (entropy / this.wave.initial_entropy) : 1;
    }

    renderStep() {
        let choice = this.wave.choose();
        if (!choice) {
            this.waveStateMessage.innerHTML = "Wave is fully collapsed. Generation complete!";
            return false;
        }

        this.wave.observe(...choice);

        const success = this.wave.propagate([choice]);

        this.updateView();

        if (!success) {
            this.waveStateMessage.innerHTML = "Ran into a contradiction, the wave cannot be collapsed further.";
            return false;
        }

        return true;
    }

    render() {
        if(!this.renderStep()) {
            this.endGame();
        }
    }

    playGame() {
        this.playing = setInterval(() => this.render(), this.interval);

        this.numRowsInput.disabled = true;
        this.numColsInput.disabled = true;
        this.playButton.disabled = true;
        this.pauseButton.disabled = false;
        this.stepButton.disabled = true;
        this.stopButton.disabled = false;
    }

    pauseGame() {
        clearInterval(this.playing);
        this.playing = null;

        this.playButton.disabled = false;
        this.pauseButton.disabled = true;
        this.stepButton.disabled = false;
    }

    endGame() {
        this.pauseGame();
        this.started = false;

        this.numRowsInput.disabled = false;
        this.numColsInput.disabled = false;
        this.stepButton.disabled = true;
        this.stopButton.disabled = true;
    }

    show() {
        this.waveControls.hidden = false;
        this.wave.render();
    }

    hide() {
        this.waveControls.hidden = true;
        this.endGame();
    }
}