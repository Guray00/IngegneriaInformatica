const MAP_SIZE = 1 << 16;
const OFFSET_FACTOR = 64;
const MAX_LINES = 1 << 10;

class GameCanvas {
  constructor(canvasId, options) {
    this.canvas = document.getElementById(canvasId);
    this.ctx = this.canvas.getContext("2d");

    this.cellList = new Set(options?.cellList ?? []);
    this.gridSize = options?.gridSize ?? 64;
    this.offsetX = 0;
    this.offsetY = 0;
    this.baseLineWidth = options?.baseLineWidth ?? 32;

    this.drawGrid();
  }

  drawGrid() {
    const cellSize = this.canvas.width / this.gridSize;

    this.ctx.strokeStyle = "gray";
    this.ctx.lineWidth = this.baseLineWidth / this.gridSize;

    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    // Fill the grid with background color
    this.ctx.fillStyle = "#1a1a2e";
    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

    this.ctx.strokeStyle = "#46455c";
    // Draw grid lines (horizontal)
    if (this.gridSize <= MAX_LINES) {
      for (let row = 0; row <= this.gridSize; row++) {
        const y = row * cellSize;
        this.ctx.beginPath();
        this.ctx.moveTo(0, y);
        this.ctx.lineTo(this.canvas.width, y);
        this.ctx.stroke();
      }

      // Draw grid lines (vertical)
      for (let col = 0; col <= this.gridSize; col++) {
        const x = col * cellSize;
        this.ctx.beginPath();
        this.ctx.moveTo(x, 0);
        this.ctx.lineTo(x, this.canvas.height);
        this.ctx.stroke();
      }
    }

    // Draw alive cells
    for (const cell of this.cellList) {
      const [col, row] = locCodeToCoordinate(cell);

      this.ctx.fillStyle = "#f0edff"; // Alive cell
      this.ctx.fillRect(
        ((col + this.offsetX + MAP_SIZE) % MAP_SIZE) * cellSize,
        ((row + this.offsetY + MAP_SIZE) % MAP_SIZE) * cellSize,
        cellSize,
        cellSize,
      );
      this.ctx.strokeRect(
        ((col + this.offsetX + MAP_SIZE) % MAP_SIZE) * cellSize,
        ((row + this.offsetY + MAP_SIZE) % MAP_SIZE) * cellSize,
        cellSize,
        cellSize,
      );
    }
  }
}

class PlayableGameCanvas extends GameCanvas {
  constructor(canvasId, options, elements) {
    super(canvasId, options);

    this.startStopButton = document.getElementById(elements.startStopButtonId);
    this.speedSlider = document.getElementById(elements.speedSliderId);

    this.running = false;
    this.interval = null;
    this.timeout = 100;

    // Keydown event for moving the grid
    document.addEventListener("keydown", (e) => this.handleKeydown(e));

    // Canvas click event for toggling cells
    this.canvas.addEventListener("click", (e) => this.handleCanvasClick(e));
  }

  handleCanvasClick(e) {
    const cellSize = this.canvas.width / this.gridSize;
    const x = Math.floor(e.offsetX / cellSize) - this.offsetX;
    const y = Math.floor(e.offsetY / cellSize) - this.offsetY;

    const cell = coordinateToLocCode(
      (x + MAP_SIZE) % MAP_SIZE,
      (y + MAP_SIZE) % MAP_SIZE,
    );

    if (this.cellList.has(cell)) {
      this.cellList.delete(cell);
    } else {
      this.cellList.add(cell);
    }

    this.drawGrid();
  }

  handleKeydown(e) {
    const key = e.key;
    if (key === "ArrowLeft") this.moveBoard("left");
    if (key === "ArrowRight") this.moveBoard("right");
    if (key === "ArrowUp") this.moveBoard("up");
    if (key === "ArrowDown") this.moveBoard("down");
  }

  updateCellList() {
    const newCellList = new Set([]);
    const neighborList = {};

    for (const cell of this.cellList) {
      const neighbors = Array.from(new Array(8)).map((_, i) =>
        getNeighbor(cell, i),
      );
      let neighborCount = neighbors.reduce(
        (acc, neighbor) => acc + this.cellList.has(neighbor),
        0,
      );

      // if a cell has 2 or 3 neighbors, it survives, otherwise it dies
      if (neighborCount === 2 || neighborCount === 3) {
        newCellList.add(cell);
      }

      neighbors.forEach((neighbor) => {
        neighborList[neighbor] = neighborList[neighbor] + 1 || 1;
      });
    }

    // if a cell has 3 neighbors, it becomes alive
    for (const cell in neighborList) {
      if (neighborList[cell] === 3) {
        newCellList.add(Number(cell));
      }
    }
    this.cellList = newCellList;
    this.drawGrid();
  }

  startStopGame() {
    this.running ? this.stopGame() : this.startGame();
  }

  startGame() {
    this.running = true;
    this.startStopButton.querySelector("span").innerText = "pause";
    this.interval = setInterval(() => this.updateCellList(), this.timeout);
  }

  stopGame() {
    this.running = false;
    this.startStopButton.querySelector("span").innerText = "play_arrow";
    clearInterval(this.interval);
  }

  clearBoard() {
    this.stopGame();
    this.cellList = new Set([]);
    this.drawGrid();
  }

  zoomOut() {
    this.offsetX += this.gridSize / 2;
    this.offsetY += this.gridSize / 2;
    this.gridSize *= 2;

    this.drawGrid();
  }

  zoomIn() {
    this.offsetX -= this.gridSize / 4;
    this.offsetY -= this.gridSize / 4;
    this.gridSize /= 2;

    this.drawGrid();
  }

  moveBoard(direction) {
    switch (direction) {
      case "up":
        this.offsetY += Math.max(this.gridSize / OFFSET_FACTOR, 1);
        break;
      case "down":
        this.offsetY -= Math.max(this.gridSize / OFFSET_FACTOR, 1);
        break;
      case "left":
        this.offsetX += Math.max(this.gridSize / OFFSET_FACTOR, 1);
        break;
      case "right":
        this.offsetX -= Math.max(this.gridSize / OFFSET_FACTOR, 1);
        break;
    }

    this.drawGrid();
  }

  updateSpeed() {
    const speed = Number(this.speedSlider.value);
    const isMaxSpeed = speed === 25;

    this.timeout = isMaxSpeed ? 0 : Math.round(1000 / speed);
    document.getElementById("speedValue").innerText = isMaxSpeed
      ? "Max"
      : speed;

    if (this.running) {
      clearInterval(this.interval);
      this.interval = setInterval(() => this.updateCellList(), this.timeout);
    }

    this.drawGrid();
  }

  load(repr) {
    this.stopGame();
    this.cellList = new Set(new Decompressor(repr).getCellList());
    this.drawGrid();
  }
}
