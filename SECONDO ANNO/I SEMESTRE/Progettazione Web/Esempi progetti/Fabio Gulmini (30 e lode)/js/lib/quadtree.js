// This file contains the implementation of the algorithm to find neighbors of a cell in a quadtree.
// The algorithm is described in this paper: https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=b2f67e125189d6ab3d036aa1a4c3e0870ddeccee

// FSM encodings
const TOP_LEFT = 0;
const TOP_RIGHT = 1;
const BOTTOM_LEFT = 2;
const BOTTOM_RIGHT = 3;

const R = 0;
const L = 1;
const D = 2;
const U = 3;
const RU = 4;
const RD = 5;
const LD = 6;
const LU = 7;
const HALT = 8;

// FSM table based on the provided directions and transitions
const fsmTable = Object.freeze({
  [TOP_LEFT]: Object.freeze({
    [R]: [1, HALT],
    [L]: [1, L],
    [D]: [2, HALT],
    [U]: [2, U],
    [RU]: [3, U],
    [RD]: [3, HALT],
    [LD]: [3, L],
    [LU]: [3, LU],
  }),
  [TOP_RIGHT]: Object.freeze({
    [R]: [0, R],
    [L]: [0, HALT],
    [D]: [3, HALT],
    [U]: [3, U],
    [RU]: [2, RU],
    [RD]: [2, R],
    [LD]: [2, HALT],
    [LU]: [2, U],
  }),
  [BOTTOM_LEFT]: Object.freeze({
    [R]: [3, HALT],
    [L]: [3, L],
    [D]: [0, D],
    [U]: [0, HALT],
    [RU]: [1, HALT],
    [RD]: [1, D],
    [LD]: [1, LD],
    [LU]: [1, L],
  }),
  [BOTTOM_RIGHT]: Object.freeze({
    [R]: [2, R],
    [L]: [2, HALT],
    [D]: [1, D],
    [U]: [1, HALT],
    [RU]: [0, R],
    [RD]: [0, RD],
    [LD]: [0, D],
    [LU]: [0, HALT],
  }),
});

// Function to get the quadrant at a specific level (0 to 31) in the 32-bit integer
const getQuadrantAtLevel = (locCode, level) => (locCode >> (2 * level)) & 0x03;

// Function to set the quadrant at a specific level (0 to 31) in the 32-bit integer
const setQuadrantAtLevel = (locCode, level, quadrant) =>
  (locCode & ~(0x03 << (2 * level))) | (quadrant << (2 * level));

// Function to navigate based on FSM table (now using bitwise operations)
const getNeighbor = (locCode, direction) => {
  for (let level = 0; level < 16; level++) {
    const quadrant = getQuadrantAtLevel(locCode, level);

    // Fetch new direction and set quadrant of the neighbor
    const [nextQuadrant, newDirection] = fsmTable[quadrant][direction];

    // Update the location code with the new quadrant at the current level
    locCode = setQuadrantAtLevel(locCode, level, nextQuadrant);

    if (newDirection === HALT) {
      return locCode;
    }

    direction = newDirection;
  }

  return locCode;
};

// Function to translate (x, y) coordinate into a locCode for a quadtree
const coordinateToLocCode = (x, y, depth = 16) => {
  let locCode = 0;

  for (let level = 0; level < depth; level++) {
    const gridSize = 1 << (depth - level);
    const halfGrid = gridSize / 2;

    // Determine which quadrant the point is in at this level
    let quadrant = 0;
    if (x >= halfGrid) {
      // cell is in right half
      quadrant |= 1;
      x -= halfGrid;
    }
    if (y >= halfGrid) {
      // cell is in bottom half
      quadrant |= 2;
      y -= halfGrid;
    }

    // Shift the quadrant into the correct position in the locCode
    locCode = (locCode << 2) | quadrant;
  }

  return locCode;
};

// Function to translate a locCode back into (x, y) coordinates
const locCodeToCoordinate = (cell, depth = 16) => {
  let x = 0;
  let y = 0;

  for (let level = 0; level < depth; level++) {
    const quadrant = getQuadrantAtLevel(cell, depth - level - 1);
    const gridSize = 1 << (depth - level);
    const halfGrid = gridSize / 2;

    if (quadrant & 1) {
      x += halfGrid; // cell is in right half
    }
    if (quadrant & 2) {
      y += halfGrid; // cell is in bottom half
    }
  }

  return [x, y];
};
