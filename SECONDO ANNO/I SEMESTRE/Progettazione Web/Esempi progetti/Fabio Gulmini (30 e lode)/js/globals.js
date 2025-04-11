const userDashboard = new UserDashboard();

const authContext = new AuthContext();

const apiContext = new ApiContext();

const gameCanvas = new PlayableGameCanvas(
  "gameCanvas",
  {
    cellList: [],
    baseLineWidth: 32,
    gridSize: 32,
  },
  {
    startStopButtonId: "startStopButton",
    speedSliderId: "speedSlider",
  },
);
