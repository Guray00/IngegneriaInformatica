class Compressor {
  constructor(board) {
    this.board = board.sort((a, b) => (a >>> 0) - (b >>> 0));
    this.buffer = new Uint8Array(1024);
    this.bufferLen = 0;
    this.process();
  }

  writeToBuffer(value) {
    this.buffer[Math.floor(this.bufferLen / 8)] |= value << this.bufferLen % 8;
    this.bufferLen++;
  }

  hasLeaves(p, maskSize) {
    return this.board.some((cell) => {
      const mask = -1 << (32 - maskSize);
      const maskedCell = cell & mask;
      return maskedCell === p;
    });
  }

  f(p, depth) {
    if (depth === 32) {
      return;
    }

    const hasLeft = this.hasLeaves(p, depth + 1);
    const hasRight = this.hasLeaves((p >>> 0) ^ (1 << (31 - depth)), depth + 1);

    if (!hasLeft && !hasRight) {
      return;
    }

    this.writeToBuffer(hasLeft ? 1 : 0);
    this.writeToBuffer(hasRight ? 1 : 0);

    if (hasLeft) {
      this.f(p, depth + 1);
    }

    if (hasRight) {
      this.f((p >>> 0) ^ (1 << (31 - depth)), depth + 1);
    }
  }

  process() {
    this.f(0, 0);
  }

  getBuffer() {
    return btoa(
      String.fromCharCode.apply(
        null,
        this.buffer.filter((x) => x !== 0),
      ),
    );
  }
}

class Decompressor {
  constructor(buffer) {
    this.buffer = atob(buffer)
      .split("")
      .map((c) => c.charCodeAt(0));
    this.bufferLen = 0;
    this.cellList = [];

    this.process();
  }

  readFromBuffer() {
    const byteIndex = Math.floor(this.bufferLen / 8);
    const bitIndex = this.bufferLen % 8;
    const bit = (this.buffer[byteIndex] >> bitIndex) & 1;
    this.bufferLen++;
    return bit;
  }

  process() {
    this.f(0, 0);
  }

  f(p, depth) {
    if (depth === 32) {
      this.cellList.push(p);
      return;
    }

    const left = this.readFromBuffer();
    const right = this.readFromBuffer();

    if (left) {
      this.f(p, depth + 1);
    }

    if (right) {
      this.f(p ^ (1 << (31 - depth)), depth + 1);
    }
  }

  getCellList() {
    return this.cellList;
  }
}
