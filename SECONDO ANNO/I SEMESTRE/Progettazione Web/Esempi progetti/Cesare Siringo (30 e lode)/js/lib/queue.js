"use strict";

export class Queue {
    constructor(init) {
        if (init == undefined) init = [];
        this.buf = init;
    }

    enqueue(elem) {
        this.buf.push(elem);
    }

    dequeue() {
        return this.buf.shift();
    }

    get size() {
        return this.buf.length;
    }

    isEmpty() {
        return this.size === 0;
    }
}